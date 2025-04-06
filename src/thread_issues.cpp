#include "thread_issues.hpp"
#include <mutex>
#include <thread>
#include <iostream>
#include <chrono>

extern std::mutex global_mutex;

void raceCondition([[maybe_unused]] int id, int* shared_array) {
    for (int i = 0; i < 1000; ++i) {
        std::lock_guard lock(global_mutex); // Simplified with C++20 deduction guides
        shared_array[0]++;
    }
}

void safeThreadAccess(int id, int* shared_array) {
    for (int i = 0; i < 1000; ++i) {
        std::lock_guard lock(global_mutex); // Simplified with C++20 deduction guides
        shared_array[1]++;
    }
    std::cout << "Thread ID: " << id << " completed safe access.\n";
}

void deadlock() {
    std::mutex mutex1, mutex2;

    std::thread t1([&]() {
        std::scoped_lock lock(mutex1, mutex2); // Use scoped_lock to avoid deadlocks
        std::this_thread::sleep_for(std::chrono::milliseconds(100));
    });

    std::thread t2([&]() {
        std::scoped_lock lock(mutex1, mutex2); // Use scoped_lock to avoid deadlocks
        std::this_thread::sleep_for(std::chrono::milliseconds(100));
    });

    t1.join();
    t2.join();
}