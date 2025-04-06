#include <gtest/gtest.h>
#include "memory_issues.hpp"

// Define a test fixture for memory-related tests
class MemoryIssuesTest : public ::testing::Test {
protected:
    int* ptr;

    // Setup logic (called before each test)
    void SetUp() override {
        ptr = new int[10]; // Allocate memory
    }

    // Teardown logic (called after each test)
    void TearDown() override {
        delete[] ptr; // Clean up memory
    }
};

// Test case for memory allocation issues
TEST_F(MemoryIssuesTest, AllocationTest) {
    ASSERT_NE(ptr, nullptr); // Ensure memory was allocated
}

// Test case for memory leak
TEST_F(MemoryIssuesTest, MemoryLeakTest) {
    ASSERT_NO_THROW(memoryLeak()); // Ensure no exceptions are thrown
}

// Test case for use-after-free
TEST_F(MemoryIssuesTest, UseAfterFreeTest) {
    ASSERT_NO_THROW(useAfterFree()); // Ensure no exceptions are thrown
}

// Test case for double free
TEST_F(MemoryIssuesTest, DoubleFreeTest) {
    ASSERT_NO_THROW(doubleFree()); // Ensure no exceptions are thrown
}

// Test case for uninitialized access
TEST_F(MemoryIssuesTest, UninitializedAccessTest) {
    ASSERT_NO_THROW(uninitializedAccess()); // Ensure no exceptions are thrown
}

// Test case for invalid read/write
TEST_F(MemoryIssuesTest, InvalidReadWriteTest) {
    ASSERT_NO_THROW(invalidReadWrite()); // Ensure no exceptions are thrown
}


// Test case for safe memory management with smart pointers
TEST_F(MemoryIssuesTest, SafeMemoryManagementTest) {
    std::unique_ptr<int> tempPtr = std::make_unique<int>(42); // Allocate memory safely
    ASSERT_NE(tempPtr, nullptr); // Ensure memory was allocated

    // No need to manually delete; std::unique_ptr automatically handles cleanup
}
