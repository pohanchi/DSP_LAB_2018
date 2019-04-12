load("ECG.mat");
figure(1);
fs=1800;
plot((0:1499),ECG(1:1500));
figure(2)
final=abs(fft(ECG(1:1500)));
plot((0:1499)*fs/1500,final);
xlim([-10,150]);