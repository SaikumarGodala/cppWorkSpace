# Modern C++ Project Template (C++20, CMake, Conan, GoogleTest)

## Project Overview

This project is a **modern C++20 starter template** that uses CMake for building, Conan for dependency management, and GoogleTest for unit testing. It provides a ready-to-use setup with a focus on best practices in C++ development. Key features include:

- **C++20** standard enabled by default (requires a compiler supporting C++20, e.g. GCC 10+ or Clang 10+).
- **CMake** build system with a clean module-based structure.
- **Conan** integration for managing third-party libraries (e.g. GoogleTest).
- **GoogleTest** framework for writing and running unit tests.
- **Clang-Tidy** static analysis and (optionally) Clang-Format for code style, to maintain code quality.
- **Continuous Integration** via GitHub Actions to automate builds, tests, static analysis, and code coverage.

## Build and Run Instructions

### Prerequisites

- GCC or Clang with C++20 support
- CMake (>= 3.15)
- Conan (>= 2.x)
- Python 3

### Steps to Build

1. **Install dependencies with Conan**

```bash
conan install . --output-folder=build --build=missing
```

2. **Configure with CMake**

```bash
cmake -S . -B build -DCMAKE_TOOLCHAIN_FILE=build/conan_toolchain.cmake \
      -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_STANDARD=20
```

3. **Build the Project**

```bash
cmake --build build --parallel
```

4. **Run the Application**

```bash
./build/MyApp
```

## Testing Instructions

1. **Run tests with CTest**

```bash
cd build && ctest --output-on-failure
```

2. **Or via CMake target**

```bash
cmake --build build --target test
```

3. **Or run test binary directly**

```bash
./build/tests/runTests
```

## Code Formatting and Linting

- **Clang-Format**: Format code using provided `.clang-format` file.
- **Clang-Tidy**: Static analysis using `.clang-tidy` configuration.

To run Clang-Tidy manually:

```bash
clang-tidy -p build src/**/*.cpp
```

## License

Licensed under the **MIT License**. See `LICENSE` file.

## Contributing

- Ensure code builds and all tests pass.
- Run Clang-Format and Clang-Tidy.
- Submit PRs with clear descriptions.

---

## .gitignore

```txt
# CMake
CMakeCache.txt
CMakeFiles/
cmake_install.cmake
CMakeUserPresets.json
CTestTestfile.cmake

# Conan
conan.lock
conanbuildinfo.*
graph_info.json
.conan*

# Build directories
build/
cmake-build-*/

# IDE files
.idea/
.vscode/
.vs/
*.code-workspace
*.sln

# Logs and caches
*.log
.cache/
*.swp
*~

# Binaries
*.o
*.so
*.dll
*.exe
*.a
*.out

# OS files
.DS_Store
Thumbs.db
```

---

## GitHub Actions CI Workflow

Save the following as `.github/workflows/ci.yml`

```yaml
name: C++ CI

on:
  push:
    branches: [ main, master ]
  pull_request:
    branches: [ main, master ]

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        compiler: [gcc, clang]

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Install dependencies
        run: |
          sudo apt-get update -y
          if [ "${{ matrix.compiler }}" = "clang" ]; then
            sudo apt-get install -y clang
          else
            sudo apt-get install -y build-essential
          fi
          sudo apt-get install -y lcov

      - name: Install Python & Conan
        run: |
          python3 -m pip install --upgrade pip
          pip install conan

      - name: Cache Conan packages
        uses: actions/cache@v3
        with:
          path: ~/.conan2
          key: ${{ runner.os }}-conan2-${{ matrix.compiler }}-${{ hashFiles('conanfile.txt') }}
          restore-keys: ${{ runner.os }}-conan2-${{ matrix.compiler }}

      - name: Conan install
        run: |
          if [ "${{ matrix.compiler }}" = "clang" ]; then
            export CC=clang
            export CXX=clang++
          else
            export CC=gcc
            export CXX=g++
          fi
          conan install . --output-folder=build --build=missing

      - name: Configure with CMake
        run: cmake -S . -B build -DCMAKE_TOOLCHAIN_FILE=build/conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_STANDARD=20 -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

      - name: Build
        run: cmake --build build --parallel

      - name: Run Tests
        run: cd build && ctest --output-on-failure

      - name: Run Clang-Tidy
        run: |
          sudo apt-get install -y clang-tidy
          FILES=$(find src tests -name '*.cpp')
          clang-tidy -p build -warnings-as-errors=* $FILES

      - name: Generate coverage report
        run: |
          lcov --directory build --capture --output-file coverage.info
          lcov --remove coverage.info '/usr/*' '*/tests/*' --output-file coverage.info
          lcov --list coverage.info

      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
        with:
          file: coverage.info
          flags: ${{ matrix.compiler }}
          name: coverage-${{ matrix.compiler }}
          fail_ci_if_error: true
```

---

You're now ready with a fully modern C++ setup! 🚀

