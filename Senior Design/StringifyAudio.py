# Avery Colley
# functions for creating a string from a given .wav file
# function for determining the frequency of the beeps is based on code from https://stackoverflow.com/questions/54612204/trying-to-get-the-frequencies-of-a-wav-file-in-python

from scipy.fft import *
import numpy

# getFreq: returns the frequency of the given time interval in an audio array
# audioArray -- the audio array that contains all the beeps
# start -- start time to determine frequency, in ms
# end -- end time to determine frequency, in ms
# sampleRate -- sample rate of the audio array
def getFreq(audioArray, start, end, sampleRate):
   window = audioArray[int(start * sampleRate / 1000) : int(end * sampleRate / 1000) + 1]
   n = len(window)
   if(n <= 0):
      # return ending signal if we reach the end of the file
      return 22000
   yf = rfft(window)
   xf = rfftfreq(n, 1 / sampleRate)
   index = numpy.argmax(numpy.abs(yf))
   freq = xf[index]
   return freq

# addLetter: returns a letter based on the given frequency
# freq -- the frequency to determine the letter
# mulitplier -- determines how far apart each letter is, in Hz
def addLetter(freq, multiplier):
   # alphabet to use for the translation - base64
   letters = ['+', '/', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '=', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K',
              'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i',
              'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
   # starting/ending signal
   if(freq >= 19000):
      return True
   # frequency is within the range, so we check what letter it should be
   for x in letters:
      if(freq >= (((letters.index(x) + 2) * multiplier) - (multiplier / 2)) and freq < (((letters.index(x) + 2) * multiplier) + (multiplier / 2))):
         return x;

# makeString -- returns the string based on the translation from the given audio array
# duration -- duration of each encoded letter, in ms
# audioArray -- audio data from an audio file
# sampleRate -- sample rate of the audio file
# multiplier -- how far apart each letter is, in Hz
def makeString(duration, audioArray, sampleRate, multiplier):
   builtString = ""
   flag = False
   k = 0
   while True:
      if(flag):
         # we've reached the end of the starting signal
         i = k # start where starting signal ended
         while True:
            j = 0 # used for taking the average frequency within the range of the given duration
            rollingFreq = 0 # cumulative sum of the frequencies
            while j < duration:
               rollingFreq += getFreq(audioArray, i + j, i + j + (duration // 5), sampleRate)
               j += duration // 5
            # check to see if we've reached the ending signal
            if(addLetter((rollingFreq // 5), multiplier) == True):
               return builtString
            else:
               builtString += addLetter((rollingFreq // 5), multiplier)
               i += duration # we have not reached the ending signal, so we move to the next interval
      else:
         # check to see if we have reached the starting signal (19000Hz+)
         if(addLetter(getFreq(audioArray, k, k + 1, sampleRate), multiplier) == True):
            # if we have reached the starting signal, we continue until the end of the signal
            while(addLetter(getFreq(audioArray, k, k + 1, sampleRate), multiplier) == True):
               k += 1
            flag = True
         else:
            k += 1
            continue