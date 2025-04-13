cmake_minimum_required(VERSION 3.10)
project(tests)

# Dynamically add test executables
set(TEST_SOURCES
    memory_issues_ut.cpp
    thread_issues_ut.cpp
)

foreach(TEST_SOURCE ${TEST_SOURCES})
    get_filename_component(TEST_NAME ${TEST_SOURCE} NAME_WE)
    add_executable(${TEST_NAME} ${TEST_SOURCE})
    target_link_libraries(${TEST_NAME} PRIVATE TestProject_lib gtest gtest_main pthread)
    add_test(NAME ${TEST_NAME} COMMAND ${TEST_NAME})
endforeach()