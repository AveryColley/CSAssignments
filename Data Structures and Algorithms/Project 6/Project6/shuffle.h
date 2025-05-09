#pragma once 

#include <array>

using namespace std;

// might need to comment this if you already have a variable N
const unsigned int N = 20;

/// @brief creates an array with values 1 - N in random order
/// @return shuffled array
array<int, N - 1> makeShuffledArray();