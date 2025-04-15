#!/bin/bash

set -e  # Exit on error

# Add git revert helper functions
show_version_history() {
    echo "Last 5 commits:"
    git log -n 5 --pretty=format:"%h - %s (%cr)" --graph
    echo -e "\nTags:"
    git tag -n
}

revert_to_version() {
    local version=$1
    if [ -z "$version" ]; then
        echo "Error: Please provide a commit hash or tag"
        return 1
    fi
    
    # Check if there are uncommitted changes
    if ! git diff-index --quiet HEAD --; then
        echo "Warning: You have uncommitted changes. Stashing them..."
        git stash
    fi
    
    # Attempt to revert
    if git checkout "$version"; then
        echo "Successfully reverted to version: $version"
    else
        echo "Error: Could not revert to version: $version"
        git stash pop 2>/dev/null || true
        return 1
    fi
}

# Add version management options
if [ "$1" = "--show-versions" ]; then
    show_version_history
    exit 0
elif [ "$1" = "--revert" ]; then
    revert_to_version "$2"
    exit 0
fi

echo "Running pre-commit checks..."

# Check if we're in the project root
if [ ! -d "cmake" ] || [ ! -d "scripts" ]; then
    echo "Error: Please run this script from the project root directory"
    exit 1
fi

# Add git version checking
echo "Git version information:"
echo "----------------------"
echo "Current branch: $(git rev-parse --abbrev-ref HEAD)"
echo "Latest tag: $(git describe --tags --abbrev=0 2>/dev/null || echo 'No tags found')"
echo "Number of commits: $(git rev-list --count HEAD)"
echo "Latest commit hash: $(git rev-parse --short HEAD)"
echo "----------------------"

# Run CMake format check if cmake-format is available
if command -v cmake-format &> /dev/null; then
    echo "Checking CMake formatting..."
    find . -name "CMakeLists.txt" -o -name "*.cmake" | while read -r file; do
        cmake-format --check "$file"
    done
fi

# Run formatter if clang-format is available
if command -v clang-format &> /dev/null; then
    echo "Checking C++ code formatting..."
    find . -name "*.cpp" -o -name "*.hpp" | while read -r file; do
        clang-format --dry-run --Werror "$file"
    done
fi

# Run tests
echo "Running tests..."
./scripts/run_tests.sh

echo "All checks passed! You can now commit your changes:"
echo "git add <files>"
echo "git commit -m \"Your commit message\""
