#include "memory_issues.hpp"
#include "thread_issues.hpp"
#include <iostream>
#include <vector>
#include <thread>
#include <mutex>
#include <memory>
#include <algorithm>
#include <unordered_map>
#include <array>
#include <string>

// Define the global mutex here (remove extern)
std::mutex global_mutex;  // Global definition

std::vector<int> processAndSort(std::vector<int>& nums);
std::vector<std::vector<std::string>> groupAnagrams(const std::vector<std::string>& words);
int firstUniqueChar(const std::string& s);
int makeKPeriodic(const std::string& word, int k);

int main() {
    constexpr std::size_t ARRAY_SIZE = 2;
    auto shared_array = std::array<int, ARRAY_SIZE>{0, 0};

    memoryLeak();
    useAfterFree();
    doubleFree();
    uninitializedAccess();
    invalidReadWrite();
    deadlock();

    return 0;
}

std::vector<int> processAndSort(std::vector<int>& nums)
{
    std::sort(nums.begin(), nums.end(), std::greater<int>());
    auto duplicates = std::unique(nums.begin(), nums.end());
    nums.erase(duplicates, nums.end());

    for(auto i : nums)
    {
        std::cout << i << " ";
    }

    return nums;
}

std::vector<std::vector<std::string>> groupAnagrams(const std::vector<std::string>& words)
{
    std::vector<std::vector<std::string>> anagrams;
    std::unordered_map<std::string, std::vector<std::string>> anagram_map;

    for(const auto& word : words)
    {
        std::vector<int> freq(26, 0);
        for(char c : word)
        {
            freq[c - 'a']++;
        }

        std::string freq_key;
        for(int count : freq)
        {
            freq_key += std::to_string(count) + "#";
        }

        anagram_map[freq_key].push_back(word);
    }

    for(const auto& pair : anagram_map)
    {
        anagrams.push_back(pair.second);
    }

    return anagrams;
}


int firstUniqueChar(const std::string& s)
{
    
    std::unordered_map<char,std::pair<int,int>> u_map;
    for(int i = 0; i < s.length(); i++)
    {
        auto it =u_map.find(s[i]);
        if(it == u_map.end())
        {
            u_map[s[i]] = {i,0};
        }
        else
        {
            it->second.second++;
        }
    }

    int min =s.length();

    for(auto pair: u_map)
    {
        if(pair.second.second == 0 && pair.second.first < min)
        {
            min = pair.second.first;
        }
    }

    if(min == s.length())
    {
        return -1;
    }
    else
    {
        return min;
    }
}

int makeKPeriodic(const std::string& word, int k) {
    const int n = word.length();
    if (k == n) return 0; // Already periodic
    
    // Count frequency of each k-length substring
    std::unordered_map<std::string, int> freq;
    int maxFreq = 0;
    
    // Get all k-length substrings at indices divisible by k
    for (int i = 0; i < n; i += k) {
        std::string chunk = word.substr(i, k);
        freq[chunk]++;
        maxFreq = std::max(maxFreq, freq[chunk]);
    }
    
    // Number of chunks that need to be swapped
    const int numChunks = n / k;
    
    // Minimum swaps needed = total chunks - most frequent chunk
    return numChunks - maxFreq;
}