// shuffle algorithm example
// stolen from:
// https://cplusplus.com/reference/algorithm/shuffle/

#include <algorithm> // std::shuffle
#include <array>     // std::array
#include <random>    // std::default_random_engine
#include <chrono>    // std::chrono::system_clock

using namespace std;

const unsigned int N = 20;

/// @brief creates an array with values 1 to (N - 1) in random order
/// @return shuffled array
array<unsigned int, N - 1> makeShuffledArray()
{
  // c++ standard library array class
  // the <int,N> tells the array what kind of things to hold (int) and how many (N=19)
  array<unsigned int, N - 1> arrayShuffle;

  // fill the array with values 1 - N
  for (unsigned int i = 0; i < ( N - 1 ); i++)
  {
    arrayShuffle[i] = i + 1;
  }

  // obtain a time-based seed, this is just a fancier way to do
  // random numbers than what we did in projects 1 and 2
  auto seed = static_cast<unsigned int>( std::chrono::system_clock::now().time_since_epoch().count() );

  // give the shuffle algorithm the beginning and end of the array as
  // well as the random generator with the seed. Works the same with vector.
  // After this the array/vector will be shuffled in-place
  shuffle(arrayShuffle.begin(), arrayShuffle.end(), default_random_engine(seed));

  return arrayShuffle;
}