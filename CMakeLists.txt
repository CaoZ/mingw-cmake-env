cmake_minimum_required(VERSION 3.30.0)
project(mingw-env)
enable_language(C ASM CXX)

include(ExternalProject)
include(ProcessorCount)

ProcessorCount(CPU_COUNT)
if(CPU_COUNT EQUAL 0)
  set(CPU_COUNT 1)
endif()

if(NOT CMAKE_GENERATOR STREQUAL "Ninja")
  message(
  FATAL_ERROR "Generator “${CMAKE_GENERATOR}” is unsupported!\nInstall Ninja.")
endif()

set(CPUTUNE "x86-64-v3"
  CACHE STRING "Target 'march' to optimize for. Example: x86-64-v3 or native")

set(OPTIM "O3"
  CACHE STRING "Target optimization level. Example: O2 or O3")

set(MALLOC "/usr/lib/libmimalloc-insecure.so.2"
   CACHE STRING "set malloc implementation")

set(MAKEJOBS ${CPU_COUNT}
  CACHE STRING "Number of parallel processes to run for each package build")

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/install"
  CACHE PATH "Default install path" FORCE)
endif()
set(MINGW_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX}/x86_64-w64-mingw32)

configure_file( ${CMAKE_CURRENT_SOURCE_DIR}/packages/ccache.conf.in
                ${MINGW_INSTALL_PREFIX}/ccache/ccache.conf @ONLY)
set(CCACHE_CONF ${MINGW_INSTALL_PREFIX}/ccache/ccache.conf)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/packages/toolchain.cmake.in
               ${CMAKE_CURRENT_BINARY_DIR}/toolchain.cmake @ONLY)
set(TOOLCHAIN_FILE ${CMAKE_CURRENT_BINARY_DIR}/toolchain.cmake)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/packages/meson_cross.txt.in
               ${CMAKE_CURRENT_BINARY_DIR}/meson_cross.txt @ONLY)
set(MESON_CROSS ${CMAKE_CURRENT_BINARY_DIR}/meson_cross.txt)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/packages/exec.in
               ${CMAKE_CURRENT_BINARY_DIR}/exec @ONLY)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/packages/exec-nolto.in
               ${CMAKE_CURRENT_BINARY_DIR}/exec-nolto @ONLY)

set(EXEC ${CMAKE_CURRENT_BINARY_DIR}/exec)
set(MAKE ${EXEC} make -j${MAKEJOBS})
set(NINJA ${EXEC} ninja -j${MAKEJOBS})
set(EXEC-NLTO ${CMAKE_CURRENT_BINARY_DIR}/exec-nolto)
set(MAKE-NLTO ${EXEC-NLTO} make -j${MAKEJOBS})
set(NINJA-NLTO ${EXEC-NLTO} ninja -j${MAKEJOBS})

string(TIMESTAMP BUILDDATE "%Y%m%d" UTC)

add_subdirectory(packages)
