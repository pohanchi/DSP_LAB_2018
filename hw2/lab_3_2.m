load("data_plus_notch.mat");
fs=500;
a = fir1(2,[0.20,0.28],'stop');
y2 = filter(a,1,disbuff);
figure(1)
plot(y2);

final=abs(fft(y2));
figure(2);
plot((0:999)*fs/1000,final);