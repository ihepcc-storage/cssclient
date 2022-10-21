cmake_minimum_required (VERSION 3.1)
project (cssclient)
SET(CMAKE_BUILD_TYPE "Debug")
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(FindDepLibs)
include(GetVersion)
GetVersion("${VERSION_MAJOR}" "${VERSION_MINOR}" "${VERSION_PATCH}" "${RELEASE}")
include(CompileFlags)

add_executable(cssclient cssclient.cc)
target_link_libraries(cssclient
  XROOTD::POSIX
  XROOTD::UTILS
)
install(TARGETS cssclient 
        RUNTIME DESTINATION bin
        )
