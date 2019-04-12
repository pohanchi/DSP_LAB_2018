import re
import os

c=[]
temp = []
buf = []
mydsp = []
fs = 360
errors = 10.0/360.0
f = open('result/report/'+'result_2.txt','a')
"""f.write('\t\t\t\t\t    TP\t')
f.write('\tFN \t')
f.write('\tFP \t')
f.write('\tPrecision \t')"""
f.write('\n')


directory='MIT_database/easy/'
file_name = '117'
myfile_directory ='../../predict/'
name='117_1'

f1 = open(directory+file_name+'.txt')
w=f1.readlines()
f1.seek(0)
for i in range(len(w)):
    line=f1.readline()
    temp += [line[-10:]]

for i in temp:
    sub=re.sub('[" " ]', '',i)
    c +=[sub]
f1.close()
mydata = open(directory+myfile_directory+name+'.txt')

dup = '0'
q=mydata.readlines()
mydata.seek(0)
for i in range(len(q)):
    a = mydata.readline()
    if i == 0:
        pass
    elif dup == a:
        print('dup')
    else:
        buf += [a]
    dup = a

for i in buf:
    bb = re.sub('["\n" ]','',i)
    mydsp += [bb]

correct = 0
total = 0
c_idx = 0
m_idx = 0 
FN = 0
FP = 0
print(len(mydsp))
while m_idx < len(mydsp) and c_idx < len(c):
    
    if not c[c_idx][1] == ':':
        minute = str(c[c_idx][0] + c[c_idx][1])
        buf =str(c[c_idx][3]+c[c_idx][4]+c[c_idx][5]+c[c_idx][6]+c[c_idx][7]+c[c_idx][8])
        time = float(minute)*60+float(buf)
        mytime = float(mydsp[m_idx])*0.00277778
        if(time+errors) >= mytime and mytime >=  (time-errors):
            m_idx += 1
            c_idx += 1
            correct += 1
        elif time > mytime:
            print('channel 1',time,mytime,(c_idx,m_idx))
            FP +=1
            m_idx +=1
        elif mytime > time:
            print('channel 2',time,mytime,(c_idx,m_idx))
            FN +=1
            c_idx +=1
    else:
        buf =str(c[c_idx][2]+c[c_idx][3]+c[c_idx][4]+c[c_idx][5]+c[c_idx][6]+c[c_idx][7])
        time = float(c[c_idx][0])*60+float(buf)
        mytime = int(mydsp[m_idx])*0.00277778
        if(time+errors) >= mytime and mytime >=  (time-errors):
            m_idx += 1
            c_idx += 1
            correct += 1
        elif time > mytime:
            print('channel 3',time,mytime,(c_idx,m_idx))
            FP += 1
            m_idx +=1
        elif mytime > time:
            print('channel 4',time,mytime,(c_idx,m_idx))
            FN += 1
            c_idx +=1
mydata.close()

print('--------------------------')

f.write(file_name+'.m_'+"first_row:\t")
f.write('\t'+str(correct)+'\t')
f.write('\t'+str(FN)+'\t')
f.write('\t'+str(FP)+'\t')
f.write('\t'+str(round((correct/len(mydsp))*100,2))+'%'+'\t')