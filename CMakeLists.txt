cmake_minimum_required(VERSION 3.16)

# Project name and version
project(TestProject VERSION 1.0 LANGUAGES CXX)

# Include modularized CMake scripts
include(cmake/FindGit.cmake)
include(cmake/CompilerOptions.cmake)
include(cmake/Sanitizers.cmake)
include(cmake/ClangTidy.cmake)
include(cmake/Testing.cmake)
include(CMakeDependentOption)
# include(cmake/InstallRules.cmake)

# Configure version header
configure_file(
    ${CMAKE_SOURCE_DIR}/cmake/version.hpp.in
    ${CMAKE_BINARY_DIR}/generated/version.hpp
    @ONLY
)

# Set C++ standard
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Enable debug and release builds
set(CMAKE_BUILD_TYPE Debug CACHE STRING "Build type (Debug, Release, or Test)")
set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS Debug Release Test)

# Add source files
set(SOURCES
    src/memory_issues.cpp
    src/thread_issues.cpp
)

# Ensure SOURCES is not empty
if (SOURCES)
    add_library(${PROJECT_NAME}_lib ${SOURCES})
    target_include_directories(${PROJECT_NAME}_lib PUBLIC 
        ${CMAKE_SOURCE_DIR}/include
        ${CMAKE_BINARY_DIR}/generated
    )
    target_link_libraries(${PROJECT_NAME}_lib PRIVATE Boost::boost)

    # Apply compiler options to the library
    apply_compiler_options(${PROJECT_NAME}_lib)

    if (NOT CMAKE_BUILD_TYPE STREQUAL "Test")
        add_executable(${PROJECT_NAME} src/main.cpp)
        target_link_libraries(${PROJECT_NAME} PRIVATE ${PROJECT_NAME}_lib Boost::boost)

        # Apply compiler options to the executable
        apply_compiler_options(${PROJECT_NAME})
    endif()
else()
    message(FATAL_ERROR "No source files found in the 'src' directory.")
endif()

# Optional packages with dependencies
cmake_dependent_option(
    USE_CLANG_TIDY "Enable clang-tidy integration" ON
    "CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR" OFF
)

# Set output directories
set_target_properties(${PROJECT_NAME}_lib PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib
    LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib
)

if (TARGET ${PROJECT_NAME})
    set_target_properties(${PROJECT_NAME} PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
    )
endif()

# Debug and Release specific flags
target_compile_definitions(${PROJECT_NAME}_lib PRIVATE 
    $<$<CONFIG:Debug>:DEBUG_BUILD>
    $<$<CONFIG:Release>:NDEBUG>
)

if (TARGET ${PROJECT_NAME})
    target_compile_definitions(${PROJECT_NAME} PRIVATE 
        $<$<CONFIG:Debug>:DEBUG_BUILD>
        $<$<CONFIG:Release>:NDEBUG>
    )
endif()

# Option to enable or disable building tests
option(BUILD_TESTS "Build tests" ON)

if (BUILD_TESTS)
    # Enable testing
    enable_testing()

    # Add subdirectory for tests
    if(EXISTS ${CMAKE_SOURCE_DIR}/tests/CMakeLists.txt)
        add_subdirectory(tests)
    endif()
endif()

# Find Conan-provided packages
find_package(Boost REQUIRED)

# Add near the end of the file
include(GNUInstallDirs)

# Install library
install(
    TARGETS ${PROJECT_NAME}_lib
    EXPORT ${PROJECT_NAME}Targets
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

# Install headers
install(
    DIRECTORY ${CMAKE_SOURCE_DIR}/include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    FILES_MATCHING PATTERN "*.hpp"
)

# Install generated version header
install(
    FILES ${CMAKE_BINARY_DIR}/generated/version.hpp
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}
)

