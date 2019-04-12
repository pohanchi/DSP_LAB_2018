# -*- coding: utf-8 -*-
"""
Created on Thur Nov 1 2018

@author: Winston
"""

import numpy as np
import math
from scipy.fftpack import dct 
import matplotlib.pyplot as plt
import soundfile as sf
from scipy.fftpack import fft, ifft

def pre_emphasis(signal,coefficient=0.95):
    return np.append(signal[0],signal[1:]-coefficient*signal[:-1])

def mel2hz(mel):
    '''
    mel scale to Hz scale
    '''
        ###################
        #Your code
        ##################
    hz = 700 * (10 **(mel / 2595 )-1)
        
    return  hz
def hz2mel(hz):
    '''
    hz scale to mel scale
    '''
        ###################
        #Your code
        ##################
    mel = 2595 * np.log10(1+ hz/700)
    return  mel

def get_filter_banks(filters_num,NFFT,samplerate,low_freq=0,high_freq=None):
    ''' Mel Bank
    filers_num: filter numbers
    NFFT:points of your FFT
    samplerate:sample rate
    low_freq: the lowest frequency that mel frequency include
    high_freq:the Highest frequency that mel frequency include
    '''
    #turn the hz scale into mel scale
    low_mel=hz2mel(low_freq)
    high_mel=hz2mel(high_freq)
    
    #in the mel scale, you should put the position of your filter number 
    mel_points=np.linspace(low_mel,high_mel,filters_num+2)
    #get back the hzscale of your filter position
    hz_points=mel2hz(mel_points)
    #Mel triangle bank design
    bin=np.floor((NFFT+1)*hz_points/samplerate)
    fbank=np.zeros([filters_num,int(NFFT/2+1)])
    ###################
    #Your code
    ##################
    for i in range(1, filters_num+1):
        f_minus = int(bin[i-1])
        f_m = int(bin[i])
        f_add = int(bin[(i+1)])
        for j in range(f_minus,f_m):
            fbank[i-1,j] =(j-bin[i-1])/(bin[i]-bin[i-1])
        for j in range(f_m , f_add):
            fbank[i-1,j] = (bin[i+1] - j)/(bin[i+1]-bin[i])  

    return fbank

if __name__ == '__main__':

    signal,fs = sf.read('./SteveJobs.wav')

    fs=fs                               #SampleRate
    print(fs)
    signal_length=len(signal)           #Signal length
    win_length=  0.025                  #Window_size(sec)
    win_step=  0.0125                      #Window_hop(sec)
    frame_length=int(win_length*fs)     #Frame length(samples)
    frame_step=int(win_step*fs)         #Step length(samples)
    
    emphasis_coeff= 0.97               #pre-emphasis para
    filters_num=  10                    #Filter number
    '''
    NFFT:points of your FFT
    low_freq: the lowest frequency that mel frequency include
    high_freq:the Highest frequency that mel frequency include
    '''
    NFFT= 256
    low_freq=0
    high_freq=int(fs/2)

    # plt.figure(1)
    # plt.plot(signal)
    signal=pre_emphasis(signal)
    # plt.figure(2)
    # plt.plot(signal)

    frames_num=1+int(math.ceil((1.0*signal_length-frame_length)/frame_step))

    #padding    
    pad_length=int((frames_num-1)*frame_step+frame_length)  
    zeros=np.zeros((pad_length-signal_length,))          
    pad_signal=np.concatenate((signal,zeros))   

            
    #split into frames
    indices=np.tile(np.arange(0,frame_length),(frames_num,1))+np.tile(np.arange(0,frames_num*frame_step,frame_step),(frame_length,1)).T  
    indices=np.array(indices,dtype=np.int32) 
    frames=pad_signal[indices] 
    frames *= np.hamming(frame_length)


    complex_spectrum=np.fft.rfft(frames,NFFT)
    absolute_complex_spectrum=np.abs(complex_spectrum)
    fb=get_filter_banks(filters_num,NFFT,fs,low_freq,high_freq)  


    ##########################
    ##########################
    #Your code
    xaxis = np.arange(0,len(fb[0])) * (1.0*fs/len(fb))
    #plt.ion()
    plt.figure(3)  
    
    for i in range(len(fb)):
        plt.plot(xaxis,fb[i]) 

    powerframe = ((1.0 / NFFT) * ((absolute_complex_spectrum) ** 2)) 
    ##########################
    ##########################
    fb = np.dot(powerframe,fb.T)
    fb = np.where(fb ==0 , np.finfo(float).eps,fb)

    feat = 20 * np.log10(fb)

    feat=dct(feat, norm='ortho')[:,:filters_num]

    ##########################
    ##########################
    #Your code
    ##########################
    ##########################
    plt.figure(4)
    for i in feat:
        plt.plot(i)
    #plt.ioff()
    plt.show()







