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

    # Add subdirectory for tests
    add_subdirectory(${CMAKE_SOURCE_DIR}/tests)

    # Add code coverage option
    option(ENABLE_COVERAGE "Enable coverage reporting" OFF)
    if(ENABLE_COVERAGE)
        if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
            target_compile_options(${PROJECT_NAME}_lib PRIVATE --coverage)
            target_link_options(${PROJECT_NAME}_lib PRIVATE --coverage)
            foreach(TEST_TARGET memory_issues_ut thread_issues_ut)
                target_compile_options(${TEST_TARGET} PRIVATE --coverage)
                target_link_options(${TEST_TARGET} PRIVATE --coverage)
            endforeach()

            # Add a custom target to generate coverage reports
            add_custom_target(coverage
                COMMAND lcov --capture --directory . --output-file coverage.info
                COMMAND lcov --remove coverage.info '/usr/*' '*/googletest-src/*' --output-file coverage.info
                COMMAND genhtml coverage.info --output-directory coverage_html
                WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
                COMMENT "Generating HTML coverage report"
            )
        endif()
    endif()
endif()