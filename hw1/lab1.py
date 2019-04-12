import numpy as np 
import matplotlib.pyplot as plt 
import math 
import time
from  scipy import linalg
#fs = 500
f = 100
x = np.linspace(0,1,500) #sample rate 500
a = np.sin(2*np.pi*f*x)
plt.stem(x,a, 'r', )
#plt.plot(x,a,'black')
plt.show()
p=np.fft.fft(a)
"""m=linalg.dft(200)
p=m.dot(a)"""
#plt.plot(np.arange(len(p)),(p.imag),'green') #show real part
#plt.plot(np.arange(len(p)),(p.real),'blue')  #show imagine part
plt.plot(np.arange(len(p)),abs(p)/len(x),'red') #show absolute value
plt.show()
plt.close()

