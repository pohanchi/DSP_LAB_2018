import re

dictionary='MIT database/easy/'
file_name = '100.txt'
myfile_name ='/home/pohan/qwe.txt'
c=[]
f = open(dictionary+file_name)
temp = []
buf = []
mydsp = []
fs = 360
errors = 10.0/360.0

for i in range(2273):
    a=f.readline()
    temp += [a[-10:]]

for i in temp:
    b=re.sub('[" " ]', '',i)
    c +=[b]
"""want=re.sub('[!@#$ "A" "N" ]', '', f.read())
print(want)"""

mydata = open(myfile_name)
for i in range(2271):
    a = mydata.readline()
    if i == 0:
        pass
    else:
        buf += [a]
for i in buf:
    bb = re.sub('["\n" ]','',i)
    mydsp += [bb]

correct = 0
total = 0
'''
for i,j in zip(c,mydsp):
    if not i[1] == ':':
        pass
    else:    
        buf = str(i[2]+i[3]+i[4]+i[5]+i[6]+i[7])
        time = float(i[0])*60 + float(buf)
        mytime = float(j) * 0.003333
        if ((time + errors) >= mytime and mytime >= (time - errors)):
            correct += 1
        elif time > mytime:
            int(i) = int(i) - 1
        elif mytime > time:
            int(j) = int(j) - 1
print(correct)
'''
c_idx = 0
m_idx = 0 
print(len(mydsp))
while m_idx <= len(mydsp):
    print(m_idx)
    if not c[c_idx][1] == ':' and c_idx < len(c):
        minutes = c[c_idx][0]+c[c_idx][1]
        buf =str(c[c_idx][3]+c[c_idx][4]+c[c_idx][5]+c[c_idx][6]+c[c_idx][7]+c[c_idx][8])
        time = float(minutes)*60+float(buf)
        print('here=',mydsp[m_idx])
        mytime = int(mydsp[m_idx])*0.002777777
        if(time+errors) >= mytime and mytime >=  (time-errors):
            m_idx += 1
            c_idx += 1
            correct += 1
        elif time > mytime:
            m_idx +=1
        elif mytime > time:
            c_idx +=1     
    else:
        buf =str(c[c_idx][2]+c[c_idx][3]+c[c_idx][4]+c[c_idx][5]+c[c_idx][6]+c[c_idx][7])
        time = float(c[c_idx][0])*60+float(buf)
        mytime = float(mydsp[m_idx])*0.002777777
        if(time+errors) >= mytime and mytime >=  (time-errors):
            m_idx += 1
            c_idx += 1
            correct += 1
        elif time > mytime:
            m_idx +=1
        elif mytime > time:
            c_idx +=1
print('-----------------------------------------------------')
print(correct/(len(mydsp)-1))