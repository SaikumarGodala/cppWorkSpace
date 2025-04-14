#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Function to build a specific preset
build_preset() {
    local preset=$1
    local configure_preset=${preset#build-}  # Remove 'build-' prefix for configure preset
    echo "Building with preset: $preset"
    cmake --preset "$configure_preset"  # Use configure preset name
    cmake --build --preset "$preset"    # Use build preset name
}

# Build Debug configuration
build_preset "build-debug"

# Build Release configuration
build_preset "build-release"

# Build Test configuration
build_preset "build-test"

echo "All builds completed successfully!"