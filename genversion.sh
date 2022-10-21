#!/bin/bash

#-------------------------------------------------------------------------------
# This script generates the version information using the last git commit. If
# the last commit was also tagged, then the tag information is used to build
# the version information in the form of MAJOR, MINOR and PATCH values.
# If the last commit is not tagged then the version is built using the date of
# the last commit and its hash value. Therefore, we have the following
# convention:
# MAJOR = major value of the last tag in the current branch
# MINOR = YYYYMMDD of the last commit
# PATCH = hash 7 characters long of the last commit
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Generate the version string from the date and the hash
#-------------------------------------------------------------------------------
function getVersionFromLog()
{
  AWK=gawk
  EX="$(which gawk)"
  if test x"${EX}" == x -o ! -x "${EX}"; then
    AWK=awk
  fi

  TAG=$1

  # remove release from tag for commits and append log info instead
  if [[ $TAG == *"-"* ]]; then
    TAG=${TAG%-*}
  fi

  VERSION="$(echo $2 | $AWK -v tag="${TAG}" '{ gsub("-","",$1); gsub(":","",$2); print tag"-"$1$2"git"$4; }')"

  if test $? -ne 0; then
    echo "unknown";
    return 1
  fi

  echo $VERSION
}

#-------------------------------------------------------------------------------
# Print help
#-------------------------------------------------------------------------------
function printHelp()
{
  echo "Usage:"                             1>&2
  echo "${0} [--help] [SOURCEPATH]"         1>&2
  echo "  --help       prints this message" 1>&2
}

#-------------------------------------------------------------------------------
# Main
#-------------------------------------------------------------------------------

# Parse the parameters
PRINTHELP=0
SOURCEPATH=""

while [[ ${#} -ne 0 ]]; do
  if [[ "${1}" == "--help" ]]; then
    PRINTHELP=1
  else
    SOURCEPATH="${1}"
  fi
  shift
done

EX="$(which git)"

if [[ "${EX}" == "" ]] || [[ ! -x "${EX}" ]]; then
  echo "[!] Unable to find git in the path: setting the version tag to unknown" 1>&2
  exit 1
else
  # Sanity check
  CURRENTDIR="$PWD"

  if [[ ${SOURCEPATH} != "" ]]; then
    cd ${SOURCEPATH}
  fi

  git log -1 >/dev/null 2>&1

  if [[  ${?} -ne 0 ]]; then
    # Check if we have a spec file and try to extract the version. This happens
    # in the rpmbuild step. We don't have a git repo but the version was already
    # set in the eos.spec file.
    if [[ -e "eos.spec" ]]; then
       VERSION="$(grep "Version:" eos.spec | head -1 | awk '{print $2;}')"
    else
      echo "[!] Unable to get version from git or spec file." 1>&2
      exit 1
    fi
  else
    # Can we match the exact tag?
    LASTCOMMITONBRANCH=$(git log --first-parent --pretty=format:'%h' -n 1)
    git describe --tags --abbrev=0 --exact-match ${LASTCOMMITONBRANCH} >/dev/null 2>&1

    if [[ ${?} -eq 0 ]]; then
      TAG="$(git describe --tags --abbrev=0 --exact-match ${LASTCOMMITONBRANCH})"
      EXP="[0-9]+\.[0-9]+\.[0-9]+(-[a-z0-9]+)?$"

      # Check if tag respects the regular expression
      VERSION="$(echo "${TAG}" | grep -E "${EXP}")"

      if [[ ${?} -ne 0 ]]; then
        echo "[!] Git tag \"${TAG}\" does not match the regex"
        VERSION=""
        exit 1
      fi

    else
      # Get last tag to extract the major version number
      LAST_TAG="$(git describe --tags --abbrev=0 --candidates=50 ${LASTCOMMITONBRANCH})"

      if [[ ${?} -ne 0 ]]; then
        echo "[!] Can not find last tag to build the commit version"
        VERSION=""
        exit 1
      fi

      # Get last commit date and hash used to build the rest of the version
      LOGINFO="$(git log -1 --format='%ai %h')"

      if [[ ${?} -ne 0 ]]; then
        echo "[!] Can not get info about last commit"
        exit 1
      fi

      VERSION="$(getVersionFromLog "$LAST_TAG" "$LOGINFO")"
    fi
  fi

  cd $CURRENTDIR

  # The version has the following fomat: major.minor.patch
  echo $VERSION
fi
