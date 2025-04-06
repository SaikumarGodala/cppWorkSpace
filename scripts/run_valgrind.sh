#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Path to the executable
EXECUTABLE="$(pwd)/build/debug/bin/TestProject"

# Check if Valgrind is installed
if ! command -v valgrind &> /dev/null; then
    echo "Error: Valgrind is not installed. Please install it and try again."
    exit 1
fi

# Check if the executable exists
if [ ! -f "$EXECUTABLE" ]; then
    echo "Error: Executable not found at $EXECUTABLE. Build the project first."
    exit 1
fi

echo "Running Valgrind to check for memory leaks..."
valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --verbose "$EXECUTABLE"

echo "Running Valgrind with Helgrind to check for threading issues (data races, deadlocks)..."
valgrind --tool=helgrind --track-lockorders=yes "$EXECUTABLE"

echo "Running Valgrind with Memcheck to check for uninitialized values and invalid memory accesses..."
valgrind --tool=memcheck --track-origins=yes "$EXECUTABLE"

echo "Valgrind checks completed successfully!"