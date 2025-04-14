option(BUILD_TESTS "Build tests" ON)

if (BUILD_TESTS AND CMAKE_BUILD_TYPE MATCHES "Debug|Test")
    enable_testing()

    include(FetchContent)
    FetchContent_Declare(
        googletest
        URL https://github.com/google/googletest/archive/refs/tags/release-1.12.1.tar.gz
    )
    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
    FetchContent_MakeAvailable(googletest)

    # Add code coverage option
    option(ENABLE_COVERAGE "Enable coverage reporting" OFF)
    if(ENABLE_COVERAGE)
        if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
# Add coverage flags to the library
            target_compile_options(${PROJECT_NAME}_lib PRIVATE --coverage)
            target_link_options(${PROJECT_NAME}_lib PRIVATE --coverage)
            
            # Add coverage flags to test targets
            if(NOT TARGET coverage_config)
                add_library(coverage_config INTERFACE)
                target_compile_options(coverage_config INTERFACE --coverage)
                target_link_options(coverage_config INTERFACE --coverage)
            endif()

            # Create coverage target for report generation
            if(NOT TARGET coverage)
                find_program(LCOV lcov REQUIRED)
                find_program(GENHTML genhtml REQUIRED)
                
                add_custom_target(coverage
                    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/coverage
                    COMMAND ${LCOV} --directory . --zerocounters
                    COMMAND ctest --output-on-failure
                    COMMAND ${LCOV} --directory . --capture --output-file ${CMAKE_BINARY_DIR}/coverage.info
                    COMMAND ${LCOV} --remove ${CMAKE_BINARY_DIR}/coverage.info '/usr/*' '*/googletest/*' --output-file ${CMAKE_BINARY_DIR}/coverage.info
                    COMMAND ${GENHTML} ${CMAKE_BINARY_DIR}/coverage.info --output-directory ${CMAKE_BINARY_DIR}/coverage_html
                    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
                    COMMENT "Generating code coverage report..."
                )
            endif()
        endif()
    endif()
endif()