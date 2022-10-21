# Require c++17
#-------------------------------------------------------------------------------
include(CheckCXXCompilerFlag)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CSSCLIENT_CXX_DEFINE "-DEOSCITRINE -DVERSION=\\\"${VERSION}\\\" -DRELEASE=\\\"${RELEASE}\\\"")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CSSCLIENT_CXX_DEFINE} ${CPP_VERSION} -Wall -Wno-error=parentheses")
check_cxx_compiler_flag(-std=c++17 HAVE_FLAG_STD_CXX17)
if(NOT HAVE_FLAG_STD_CXX17)
  message(FATAL_ERROR "A compiler with -std=c++17 support is required.")
endif()

#-------------------------------------------------------------------------------
# CPU architecture flags
#-------------------------------------------------------------------------------
include(CPUArchFlags)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CPU_ARCH_FLAGS}")
