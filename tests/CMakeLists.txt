cmake_minimum_required(VERSION 3.10)
project(tests)

# Dynamically add test executables
set(TEST_SOURCES
    memory_issues_ut.cpp
    thread_issues_ut.cpp
)

foreach(TEST_SOURCE ${TEST_SOURCES})
    get_filename_component(TEST_NAME ${TEST_SOURCE} NAME_WE)
    if (NOT TARGET ${TEST_NAME})  # Ensure the target does not already exist
        add_executable(${TEST_NAME} ${TEST_SOURCE})
target_link_libraries(${TEST_NAME} 
            PRIVATE 
            TestProject_lib 
            gtest 
            gtest_main 
            pthread
        )
        if(ENABLE_COVERAGE)
        target_link_libraries(${TEST_NAME} PRIVATE coverage_config)
        endif()
        add_test(NAME ${TEST_NAME} COMMAND ${TEST_NAME})
    else()
        message(WARNING "Target ${TEST_NAME} already exists. Skipping.")
    endif()
endforeach()