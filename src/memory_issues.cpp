#include "memory_issues.hpp"
#include <iostream>
#include <vector>
#include <memory>
#include <array>

void memoryLeak() {
    auto leak = std::make_unique<int[]>(100); // Use smart pointers to avoid manual memory management
    leak[0] = 42;
}

void useAfterFree() {
    auto ptr = std::make_unique<int>(10); // Use smart pointers to avoid dangling pointers
    std::cout << "Value: " << *ptr << "\n";
    // No need to manually delete; smart pointer handles it
}

void doubleFree() {
    auto ptr = std::make_unique<int>(5); // Smart pointers prevent double free
    // No manual delete needed
}

void uninitializedAccess() {
    std::array<int, 5> arr{}; // Use std::array for safer stack-based arrays
    std::cout << "Value: " << arr[3] << "\n"; // Default-initialized to 0
}

void invalidReadWrite() {
    auto arr = std::make_unique<int[]>(11); // Use smart pointers for dynamic arrays
    arr[10] = 100;
    std::cout << arr[10] << "\n";
}


