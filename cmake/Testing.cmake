option(BUILD_TESTS "Build tests" ON)

if (BUILD_TESTS AND CMAKE_BUILD_TYPE STREQUAL "Test")
    enable_testing()

    include(FetchContent)
    FetchContent_Declare(
        googletest
        URL https://github.com/google/googletest/archive/refs/tags/release-1.12.1.tar.gz
    )
    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
    FetchContent_MakeAvailable(googletest)

    add_subdirectory(tests)

    option(ENABLE_COVERAGE "Enable coverage reporting" OFF)
    if(ENABLE_COVERAGE)
        if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
            target_compile_options(${PROJECT_NAME}_lib PRIVATE --coverage)
            target_link_options(${PROJECT_NAME}_lib PRIVATE --coverage)
            foreach(TEST_TARGET memory_issues_ut thread_issues_ut)
                target_compile_options(${TEST_TARGET} PRIVATE --coverage)
                target_link_options(${TEST_TARGET} PRIVATE --coverage)
            endforeach()
        endif()
    endif()
endif()