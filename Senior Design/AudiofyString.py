# Avery Colley
# functions for creating an audio file given a string
# sound file creation code is based on code from https://www.daniweb.com/programming/software-development/code/263775/create-a-synthetic-sine-wave-wave-file

import numpy
from scipy.io import wavfile

# addSound: adds a beep with a given frequency and duration to an audio array
# frequency -- frequency of the beep to add, in Hz
# duration -- duration of the beed to add, in ms
# prevAudio -- the audio array to add the beep to the end to
# sr -- sample rate of the audio file
# twoPi -- 2*pi
def addSound(frequency, duration, prevAudio, sr, twoPi):
   samples = duration * (sr / 1000.0)
   for x in range (int(samples)):
      prevAudio.append(numpy.sin(twoPi * frequency * (x / sr)))
   return prevAudio

# makeAudioFile: creates a file with the given name name using an array for the audio
# audioArray -- array containing audio data
# fileName -- name of the file to create
# sr -- sample rate of the audio file
def makeAudioFile(audioArray, fileName, sr):
   audioArray = numpy.array(audioArray).astype(numpy.float32)
   wavfile.write(fileName, int(sr), numpy.array(audioArray))

# stringToAudio: fills out the given audioArray with frequencies determined by the given string
# audioArray -- array for creating a .wav file
# string -- string to convert into the .wav file: only takes in base64 characters
# durationPerLetter -- how long the beep for each letter should last, in ms
# sr -- sample rate of the audio file
# multiplier -- frequencies will start at 2*multiplier and each letter will be separated by multiplier Hz
# twoP -- 2*pi
def stringToAudio(audioArray, string, durationPerLetter, sr, multiplier, twoPi):
   # start signal
   addSound(19250, 1000, audioArray, sr, twoPi)
   # alphabet to use for the string conversion -- base64
   letters = ['+', '/', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '=', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K',
              'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i',
              'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
   for c in str(string):
      if(c in letters):
         addSound(((letters.index(c) + 2) * multiplier), durationPerLetter, audioArray, sr, twoPi)
      else:
         # ignore all characters not in the alphabet
         continue
   # end signal
   addSound(19250, 1000, audioArray, sr, twoPi)
   return audioArray