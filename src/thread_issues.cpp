#include "thread_issues.hpp"
#include <array>
#include <chrono>
#include <iostream>
#include <mutex>
#include <thread>

namespace {
constexpr int ITERATION_COUNT = 1000;
constexpr auto SLEEP_DURATION = std::chrono::milliseconds(100);
}  // namespace

void raceCondition([[maybe_unused]] int threadIdentifier, int* shared_array) {
    for (int iteration = 0; iteration < ITERATION_COUNT; ++iteration) {
        // const std::lock_guard<std::mutex> lock(global_mutex);
        *shared_array += 1;  // Avoid array indexing
    }
}

void safeThreadAccess(int threadIdentifier, int* shared_array) {
    for (int iteration = 0; iteration < ITERATION_COUNT; ++iteration) {
        // const std::lock_guard<std::mutex> lock(global_mutex);
        *(shared_array + 1) = *(shared_array + 1) + 1;  // Avoid array indexing
    }
    std::cout << "Thread ID: " << threadIdentifier << " completed safe access.\n";
}

void deadlock() {
    std::mutex firstMutex;
    std::mutex secondMutex;

    std::thread thread1([&]() {
        const std::scoped_lock lock(firstMutex, secondMutex);
        std::this_thread::sleep_for(SLEEP_DURATION);
    });

    std::thread thread2([&]() {
        const std::scoped_lock lock(firstMutex, secondMutex);
        std::this_thread::sleep_for(SLEEP_DURATION);
    });

    thread1.join();
    thread2.join();
}