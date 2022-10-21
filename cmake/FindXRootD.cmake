# Try to find XROOTD
# Once done, this will define
#
# XROOTD_FOUND               - system has XRootD
# XROOTD_INCLUDE_DIRS        - XRootD include directories
# XROOTD_LIBRARIES           - libraries needed to use XRootD
# XROOTD_PRIVATE_INCLUDE_DIR - XRootD private include directory
#
# XROOTD_ROOT may be defined as a hint for where to look

find_path(XROOTD_INCLUDE_DIR
  NAMES XrdVersion.hh
  HINTS ${XROOTD_ROOT} $ENV{XROOTD_ROOT}
  PATH_SUFFIXES include/xrootd)

find_library(XROOTD_POSIX_LIBRARY
  NAMES XrdPosix
  HINTS ${XROOTD_ROOT} $ENV{XROOTD_ROOT}
  PATH_SUFFIXES ${CMAKE_INSTALL_LIBDIR})


include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(XRootD
  XROOTD_UTILS_LIBRARY
  XROOTD_POSIX_LIBRARY)

find_library(XROOTD_UTILS_LIBRARY
  NAMES XrdUtils
  HINTS ${XROOTD_ROOT} $ENV{XROOTD_ROOT}
  PATH_SUFFIXES ${CMAKE_INSTALL_LIBDIR})
if (XROOTD_FOUND)
  add_library(XROOTD::POSIX UNKNOWN IMPORTED)
  set_target_properties(XROOTD::POSIX PROPERTIES
    IMPORTED_LOCATION "${XROOTD_POSIX_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${XROOTD_INCLUDE_DIR}")

  add_library(XROOTD::UTILS UNKNOWN IMPORTED)
  set_target_properties(XROOTD::UTILS PROPERTIES
    IMPORTED_LOCATION "${XROOTD_UTILS_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${XROOTD_INCLUDE_DIR}")
endif()
