#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Base directories
for dir in include/TestProject src tests third_party cmake docs scripts; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        echo "Created directory: $dir"
    else
        echo "Directory $dir already exists."
    fi
done

# Placeholder files
for file in include/TestProject/Module1.hpp include/TestProject/Module2.hpp \
            src/Module1.cpp src/Module2.cpp \
            tests/TestModule1.cpp tests/TestModule2.cpp \
            docs/README.md scripts/build.sh scripts/run_tests.sh; do
    if [ ! -f "$file" ]; then
        touch "$file"
        echo "Created file: $file"
    else
        echo "File $file already exists."
    fi
done

# Add README and LICENSE if not present
[ ! -f README.md ] && echo "# TestProject" > README.md && echo "Created README.md"
[ ! -f LICENSE ] && echo "MIT License" > LICENSE && echo "Created LICENSE"

# Make scripts executable
chmod +x scripts/*.sh || echo "Failed to make scripts executable."

echo "Project structure created successfully!"