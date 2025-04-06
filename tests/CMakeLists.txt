cmake_minimum_required(VERSION 3.10)
project(tests)

# Add test executables
add_executable(memory_issues_ut memory_issues_ut.cpp)
target_link_libraries(memory_issues_ut PRIVATE TestProject_lib gtest gtest_main pthread)

add_executable(thread_issues_ut thread_issues_ut.cpp)
target_link_libraries(thread_issues_ut PRIVATE TestProject_lib gtest gtest_main pthread)

# Register tests with CTest
add_test(NAME memory_issues_ut COMMAND memory_issues_ut)
add_test(NAME thread_issues_ut COMMAND thread_issues_ut)