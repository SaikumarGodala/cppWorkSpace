#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Define the build directory for the Test configuration
BUILD_DIR="./build/test"
BIN_DIR="$BUILD_DIR/tests"

# Check if the build directory exists
if [ ! -d "$BUILD_DIR" ]; then
    echo "Test build directory not found. Configuring the project for tests..."
    cmake -S . -B "$BUILD_DIR" -DCMAKE_BUILD_TYPE=Test -DBUILD_TESTS=ON
fi

# Build the project in the Test configuration
echo "Building the project in Test configuration..."
cmake --build "$BUILD_DIR"

# Run tests using ctest
echo "Running tests using ctest..."
ctest --test-dir "$BUILD_DIR" --output-on-failure

# Run individual test executables
echo "Running individual test executables..."
if [ -f "$BIN_DIR/memory_issues_ut" ]; then
    echo "Running memory_issues_ut..."
    "$BIN_DIR/memory_issues_ut"
else
    echo "memory_issues_ut executable not found!"
fi

if [ -f "$BIN_DIR/thread_issues_ut" ]; then
    echo "Running thread_issues_ut..."
    "$BIN_DIR/thread_issues_ut"
else
    echo "thread_issues_ut executable not found!"
fi

echo "All tests executed successfully!"