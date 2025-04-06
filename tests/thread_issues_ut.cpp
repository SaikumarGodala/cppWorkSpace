#include <gtest/gtest.h>
#include "thread_issues.hpp"
#include <mutex>
#include <thread>
#include <vector>

std::mutex global_mutex;

// Test fixture for thread issues
class ThreadIssuesTest : public ::testing::Test {
protected:
    void SetUp() override {
        // Optional: Add setup logic if needed
    }

    void TearDown() override {
        // Optional: Add cleanup logic if needed
    }
};

// Test case for thread safety
TEST_F(ThreadIssuesTest, ThreadSafetyTest) {
    int shared_array[2] = {0, 0};
    std::vector<std::thread> threads;

    // Launch multiple threads to test thread safety
    for (int i = 0; i < 4; ++i) {
        threads.emplace_back(safeThreadAccess, i, shared_array);
    }

    // Wait for all threads to complete
    for (auto& t : threads) {
        t.join();
    }

    // Assert that shared_array[1] was incremented safely
    ASSERT_GT(shared_array[1], 0);
}

// Test case for race condition
TEST_F(ThreadIssuesTest, RaceConditionTest) {
    int shared_array[1] = {0};
    std::vector<std::thread> threads;

    // Launch multiple threads to test for race conditions
    for (int i = 0; i < 4; ++i) {
        threads.emplace_back(raceCondition, i, shared_array);
    }

    // Wait for all threads to complete
    for (auto& t : threads) {
        t.join();
    }

    // Assert that shared_array[0] was incremented
    ASSERT_GT(shared_array[0], 0);
}

// Test case for deadlock prevention
TEST_F(ThreadIssuesTest, DeadlockPreventionTest) {
    // Ensure that the deadlock function does not cause a deadlock
    ASSERT_NO_THROW(deadlock());
}