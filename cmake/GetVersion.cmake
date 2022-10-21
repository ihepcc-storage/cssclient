#-------------------------------------------------------------------------------
# Get version
#-------------------------------------------------------------------------------
function(GetVersion MAJOR MINOR PATCH RELEASE)
  if(("${MAJOR}" STREQUAL "") OR
     ("${MINOR}" STREQUAL "") OR
     ("${PATCH}" STREQUAL ""))
    execute_process(
      COMMAND ${CMAKE_SOURCE_DIR}/genversion.sh ${CMAKE_SOURCE_DIR}
      OUTPUT_VARIABLE VERSION_INFO
      OUTPUT_STRIP_TRAILING_WHITESPACE)

    string(REPLACE "." ";" VERSION_LIST ${VERSION_INFO})
    list(GET VERSION_LIST 0 MAJOR)
    list(GET VERSION_LIST 1 MINOR)
    list(GET VERSION_LIST 2 PATCH)

    # The patch could also contain the RELEASE value if this is a snapshot
    string(FIND "${PATCH}" "-" POS)

    if (NOT "${POS}" EQUAL "-1")
      string(REPLACE "-" ";" PR_LIST ${PATCH})
      list(GET PR_LIST 0 PATCH)

      # Set RELEASE on if not already set
      if ("${RELEASE}" STREQUAL "")
        list(GET PR_LIST 1 RELEASE)
      endif()
    endif()
  endif()

  set(VERSION_MAJOR ${MAJOR} PARENT_SCOPE)
  set(VERSION_MINOR ${MINOR} PARENT_SCOPE)
  set(VERSION_PATCH ${PATCH} PARENT_SCOPE)
  set(VERSION "${MAJOR}.${MINOR}.${PATCH}" PARENT_SCOPE)

  if("${RELEASE}" STREQUAL "")
    set(RELEASE "1")
  endif()

  set(RELEASE ${RELEASE} PARENT_SCOPE)
endfunction()
