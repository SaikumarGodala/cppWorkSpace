# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.22.1)

# We name the project and the target for the ExternalProject_Add() call
# to something that will highlight to the user what we are working on if
# something goes wrong and an error message is produced.

project(_project_options-populate NONE)



include(ExternalProject)
ExternalProject_Add(_project_options-populate
                     "UPDATE_DISCONNECTED" "False" "URL" "https://github.com/aminya/project_options/archive/refs/tags/v0.20.0.zip"
                    SOURCE_DIR          "/home/gskr/cppWorkSpace/build/_deps/_project_options-src"
                    BINARY_DIR          "/home/gskr/cppWorkSpace/build/_deps/_project_options-build"
                    CONFIGURE_COMMAND   ""
                    BUILD_COMMAND       ""
                    INSTALL_COMMAND     ""
                    TEST_COMMAND        ""
                    USES_TERMINAL_DOWNLOAD  YES
                    USES_TERMINAL_UPDATE    YES
)


