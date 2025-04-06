cmake_minimum_required(VERSION 3.16)


# Project name and version
project(TestProject VERSION 1.0 LANGUAGES CXX)

# Find Git
find_package(Git QUIET)
if(GIT_FOUND)
    # Get the current working branch
    execute_process(
        COMMAND ${GIT_EXECUTABLE} rev-parse --abbrev-ref HEAD
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_BRANCH
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    # Get the latest commit hash
    execute_process(
        COMMAND ${GIT_EXECUTABLE} rev-parse --short HEAD
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_COMMIT_HASH
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
endif()

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
    # Add library for shared code
    add_library(${PROJECT_NAME}_lib ${SOURCES})
    target_include_directories(${PROJECT_NAME}_lib PUBLIC 
        include
        ${CMAKE_BINARY_DIR}/generated
    )
    target_link_libraries(${PROJECT_NAME}_lib PRIVATE 
        Boost::boost
    )

    # Add executable only for Debug and Release builds
    if (NOT CMAKE_BUILD_TYPE STREQUAL "Test")
        add_executable(${PROJECT_NAME} src/main.cpp)
        target_link_libraries(${PROJECT_NAME} PRIVATE 
            ${PROJECT_NAME}_lib
            Boost::boost
        )
    endif()
else()
    message(FATAL_ERROR "No source files found in the 'src' directory.")
endif()

# Enable warnings and additional flags
if (CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
    # Add compiler options for Debug and Release builds
    target_compile_options(${PROJECT_NAME}_lib PRIVATE
        $<$<CONFIG:Debug>:-g -O0 -Wall -Wextra -Wpedantic> # Debug: Enable debug symbols, disable optimizations
        $<$<CONFIG:Release>:-O3 -DNDEBUG -Wall -Wextra -Wpedantic> # Release: Enable optimizations, disable debug symbols
    )
    if (TARGET ${PROJECT_NAME})
        target_compile_options(${PROJECT_NAME} PRIVATE
            $<$<CONFIG:Debug>:-g -O0 -Wall -Wextra -Wpedantic>
            $<$<CONFIG:Release>:-O3 -DNDEBUG -Wall -Wextra -Wpedantic>
        )
    endif()
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    # Add compiler options for Debug and Release builds (MSVC)
    target_compile_options(${PROJECT_NAME}_lib PRIVATE
        $<$<CONFIG:Debug>:/Zi /Od /W4> # Debug: Enable debug symbols, disable optimizations
        $<$<CONFIG:Release>:/O2 /DNDEBUG /W4> # Release: Enable optimizations, disable debug symbols
    )
    if (TARGET ${PROJECT_NAME})
        target_compile_options(${PROJECT_NAME} PRIVATE
            $<$<CONFIG:Debug>:/Zi /Od /W4>
            $<$<CONFIG:Release>:/O2 /DNDEBUG /W4>
        )
    endif()
endif()

# Integrate clang-tidy
option(ENABLE_CLANG_TIDY "Enable clang-tidy checks" ON)
find_program(CLANG_TIDY clang-tidy)
if (ENABLE_CLANG_TIDY AND CLANG_TIDY)
    set(CMAKE_CXX_CLANG_TIDY clang-tidy;-checks=cppcoreguidelines-*,-modernize-use-trailing-return-type)
endif()

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

if (BUILD_TESTS AND CMAKE_BUILD_TYPE STREQUAL "Test")
    # Enable testing
    enable_testing()

    # Fetch Google Test
    include(FetchContent)
    FetchContent_Declare(
        googletest
        URL https://github.com/google/googletest/archive/refs/tags/release-1.12.1.tar.gz
    )
    # Prevent Google Test from overriding compiler/linker options
    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
    FetchContent_MakeAvailable(googletest)

    # Add subdirectory for tests
    add_subdirectory(tests)
endif()

# Find Conan-provided packages
find_package(Boost REQUIRED)

