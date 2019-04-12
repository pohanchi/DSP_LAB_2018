# -*- coding: utf-8 -*-
"""
@NTHUEE DSP LAB AUDIO PART #1 ENERGY-BASED VAD
@author: David
@ENERGY-BASED VAD.PY
"""


"""Import library"""
import matplotlib.pyplot as plt
import scipy.io.wavfile as wav
import numpy as np
import math


"""Input/output path setting"""
InputAudioFile= "input/S001-007_mic.wav"
OutputAudioPath='output/'
OutputFigurePath='outfigure/'

"""Volume Calculation"""
def CalEnergy(audioData, frameSize, overLap):
    """Signal Array length"""
    wlen = len(audioData)
    """Calculate Step Size"""
    step = frameSize - overLap
    frameNum = int(math.ceil(wlen*1.0/step))
    Energy = np.zeros((frameNum,1))
    for i in range(frameNum):
        curFrame = audioData[np.arange(i*step,min(i*step+frameSize,wlen))]
        curFrame = curFrame - np.median(curFrame) # zero-justified
        """To calculate Energy"""
        Energy[i] = sum((curFrame**2))
    return Energy

"""To Find consecutive index intervals."""
def consecutive(data, stepsize=1):

    return np.split(data, np.where(np.diff(data) != stepsize)[0]+1)



SampleRate, audioData= wav.read(InputAudioFile,'r')

"""Setting frame size and overlap Size."""
#laughter
frameSize = 2048
overLap = 1024

#number 1-9
#frameSize = 1024
#overLap = 512

#number 0-9
#frameSize = 1024
#overLap = 512

Audio_Energy = CalEnergy(audioData,frameSize,overLap)

"""
Threshold is very important to Energy-based VAD.
"""
threshold1 = max(Audio_Energy)*0.1
threshold2 = min(Audio_Energy)*5000.0
threshold3 = min(Audio_Energy)+max(Audio_Energy)*0.0005
threshold4 = np.sqrt(max(Audio_Energy))*450


"""Choose one threshold"""
threshold=threshold4
"""
To find value which is large than threshold.
"""

Filter_Arrary = np.where(Audio_Energy>threshold)[0]
Split_Array = consecutive(Filter_Arrary)

#==============================================================================
# Signal Amplitude
#==============================================================================
"""Plot audio signal on figure."""
time = np.arange(0,len(audioData)) * (1.0/SampleRate)
plt.subplot(211)
plt.plot(time,audioData,'black')
plt.ylabel('Amplitude')
plt.xlabel('Time(seconds)')
plt.title("Raw Singal")


"""Plot Start-End lines on figure."""
i=-1
for item in Split_Array:
    if len(item) > 10:
        start_line=item[0]*(len(audioData)*1.0/len(Audio_Energy)/SampleRate)
        plt.axvline(x=start_line,c='r')
        end_line=item[-1]*(len(audioData)*1.0/len(Audio_Energy)/SampleRate)
        plt.axvline(x=end_line)
        i=i+1
        """Writing audio signal into files"""
        Writepath=OutputAudioPath+'_'+str(i)+'.wav'
        frame = np.take(audioData,list(np.arange(start_line*SampleRate,end_line*SampleRate)))
        wav.write(Writepath,SampleRate,frame)
        
plt.legend(("End","Start"),loc=0)        

#==============================================================================
# Audio Energy
#==============================================================================
"""Plot threshold lines on figures"""
plt.subplot(212)
frame = np.arange(0,len(Audio_Energy)) * (len(audioData)*1.0/len(Audio_Energy)/SampleRate)
plt.plot(frame,Audio_Energy,'black')

threshold1_Array = np.empty(len(audioData))
threshold1_Array.fill(threshold1[0])

threshold2_Array = np.empty(len(audioData))
threshold2_Array.fill(threshold2[0])

threshold3_Array = np.empty(len(audioData))
threshold3_Array.fill(threshold3[0])

threshold4_Array = np.empty(len(audioData))
threshold4_Array.fill(threshold4[0])

plt.plot(time,threshold1_Array,'-r' ,label="threshold 1")
plt.plot(time,threshold2_Array,'-g',label="threshold 2")
plt.plot(time,threshold3_Array,'-y',label="threshold 3")
plt.plot(time,threshold4_Array,'-b',label="threshold 4")


plt.legend(loc=0)
plt.ylabel('Energy')
plt.xlabel('Time(seconds)')
plt.title("Signal Energy")
plt.savefig(OutputFigurePath+"figures_demo.png", dpi=300)
plt.show()





