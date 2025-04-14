#include "memory_issues.hpp"
#include <array>
#include <cstddef>  // for size_t
#include <iostream>
#include <memory>

namespace {
constexpr std::size_t ARRAY_SIZE = 100;
constexpr int INIT_VALUE = 42;
}  // namespace

void memoryLeak() {
    std::array<int, ARRAY_SIZE> leak{};
    leak[0] = INIT_VALUE;
}

void useAfterFree() {
    auto ptr = std::make_unique<int>(INIT_VALUE);
    std::cout << "Value: " << *ptr << "\n";
}

void doubleFree() {
    auto ptr = std::make_unique<int>(INIT_VALUE);
}

void uninitializedAccess() {
    std::array<int, ARRAY_SIZE> arr{};
    std::cout << "Value: " << arr[3] << "\n";
}

void invalidReadWrite() {
    std::array<int, ARRAY_SIZE> arr{};
    arr[4] = INIT_VALUE;
    std::cout << arr[4] << "\n";
}


