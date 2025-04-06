#!/bin/bash

# Base directories
for dir in include/TestProject src tests third_party cmake docs scripts; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
    else
        echo "Directory $dir already exists."
    fi
done

# Placeholder files
touch include/TestProject/Module1.hpp
touch include/TestProject/Module2.hpp
touch src/Module1.cpp
touch src/Module2.cpp
touch tests/TestModule1.cpp
touch tests/TestModule2.cpp
touch docs/README.md
touch scripts/build.sh
touch scripts/run_tests.sh

# Add README and LICENSE if not present
[ ! -f README.md ] && echo "# TestProject" > README.md
[ ! -f LICENSE ] && echo "MIT License" > LICENSE

# Make scripts executable
chmod +x scripts/*.sh

echo "Project structure created successfully!"