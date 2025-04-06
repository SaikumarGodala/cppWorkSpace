#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Function to build a specific preset
build_preset() {
    local preset=$1
    echo "Building with preset: $preset"
    cmake --preset $preset
    cmake --build --preset build-$preset
}

# Build Debug configuration
build_preset debug

# Build Release configuration
build_preset release

# Build Test configuration
build_preset test

echo "All builds completed successfully!"