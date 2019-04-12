%{
clear all;
fclose('all');

serialobj=instrfind;
if ~isempty(serialobj)
    delete(serialobj)
end
clc;clear all;close all;
s1 = serial('/dev/ttyACM0');  %define serial port
s1.BaudRate=115200;     %define baud rate
 
disbuff=nan(1,1000);

fopen(s1);
clear data;
N_point = 1000;
fs=500;   %sample rate
time=[1:1:1000];
figure
h_plot=plot(nan,nan);
hold off 
tic
for i= 1:N_point 
    data=fscanf(s1);%read sensor
    %whos data;
    %disp(data);
    y(i) = str2double(data);

    if i<=1000
    disbuff(i)=y(i);
    
    else
    disbuff=[disbuff(2:end) y(i)];
    end

    if i>1
    set(h_plot,'xdata',time,'ydata',disbuff)
    save("data.mat","disbuff");
    title('test');
    xlabel('Time');
    ylabel('Quantization value');
    drawnow;
    figure(1);
    end
   
end
%}


load("data.mat");
fs=500;

figure('name','origin');
plot(disbuff);

ft_y=abs(fft(disbuff));
figure('name','original_frequency_domain');
plot((0:999)*fs/1000,ft_y);

%{
a = fir1(50,[0.20 0.28],'stop');
freqz(a);
y2 = filter(a,1,disbuff);
figure('name','past by FIR Filter');
plot((y2));

figure('name','pass by FIR Filter & fft');
ft_ya2=abs(fft(y2));
plot((0:999)*fs/1000,ft_y2);
%}
%{
l=fir1(20,0.1);
y2 = filter(l,1,y2);
figure(7);
plot(y2);
%}
%{
b = fir1(50,[0.4 0.56],'stop');
figure(100)
freqz(b)
y2 = filter(b,1,y2);
c = fir1(50,[0.68 0.76],'stop');
y2 = filter(c,1,y2);
d = fir1(50,[0.76 0.84],'stop');
y2 =filter(d,1,y2);
figure('name','past by all FIR Filter');
plot((y2));
figure('name','pass by all FIR Filter & fft');
ft_y2=abs(fft(y2));

plot((0:999)*fs/1000,ft_y2);
%}
%{
n=16;
moving_average = 1:n;
moving_average(moving_average>1)=1;
a=ones(16,1);
freqz(a/n,1);
pad_zero = 1:((n/2)-1);
pad_zero(pad_zero>1)=0;
new_vector=zeros(1,1000);
pad_vector = [pad_zero disbuff pad_zero 0];
disp(moving_average);
disp(pad_vector(2:(2+n-1)));
for i=1:1000
    new_vector(i)=(sum(pad_vector(i:(i+n-1)).* moving_average))/n;  
end
figure('name','low_pass_filter');
plot(new_vector);
fft_new=abs(fft(new_vector));
figure('name','low_pass_filter_fs');
plot((0:(999))*fs/(1000),fft_new);
y2=new_vector;
%}
%{
w0 = 60/(500/2);
bw = w0/10;
[b,a] = iirnotch(w0,bw);
freqz(b,a,50);
y2 = filter(b,a,disbuff);
figure('name','low_pass_filter ');
plot(y2);
ft_y2=abs(fft(y2));
figure('name','low_pass_filter fs');
plot((0:999)*fs/1000,ft_y2);
%}
h1 = [1 -1];
freqz(h1,1);
pad_vector = [0 y2 0];
new_vector2 =zeros(1,1000);
for i=1:1000
    new_vector2(i) =sum(pad_vector(i:i+1).* h1);
end
y3 =new_vector2;
figure('name','low_pass_filter & high pass filter');
plot(y2(n/2:(1000-n/2-1))-y3(n/2:(1000-n/2-1)));
fft_y3=abs(fft(y2(n/2:(1000-n/2-1))-y3(n/2:(1000-n/2-1))));
figure('name','low_pass_filter & high pass filter_fs');
plot((0:999-n)*fs/(1000-n),fft_y3);
%{
z2 = medfilt1(y2,100);
figure('name','pass by FIR and 200ms median filter');

plot(z2);

w2 = medfilt1(z2,300);
figure('name','pass by FIR and 200ms median filter and voltage shift and differential');
t2=y2-w2;
plot(t2+180);

figure('name','pass by FIR and 200ms median & 600ms median filter');

plot(w2);
ylim([-100,900]);
figure('name','pass by FIR and 200ms median and differential');
plot(y2-z2);

figure('name','pass by FIR and 200ms median and differential and shift and fft');
final=abs(fft(t2+180));
plot((0:999)*fs/1000,final);
%}