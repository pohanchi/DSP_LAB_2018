close all;
fclose('all');
fs = 300;

serialobj=instrfind;

if ~isempty(serialobj)
    delete(serialobj)
end
clc;clear all;close all;
s1 = serial('/dev/ttyACM0');

s1.BaudRate=115200; %define baud rate
disbuff=nan(1,1000);
i = 1;
fopen(s1);
clear data;

time=[1:1:1000];
figure
h_plot=plot(nan,nan);
hold on;
d_plot=plot(nan,nan,'ro');
hold off;
tic

%filter
mov1 = [1 1 1 1 1 1 1]/7;
dif = [1 -1];
mov2 = ones(1,24)/24;
%filter



while 1
    data = fscanf(s1);
    y(i) = str2double(data); 
    
    if i<=1000
        disbuff(i)=y(i);
    else
        disbuff=[disbuff(2:end) y(i)];
    end
    
    lout = conv(disbuff,mov1,'same');
    lout2 = conv(lout,mov1,'same');
    lout3 = conv(lout2,mov1,'same');
    hout = conv(lout3,dif,'same');
    houtsq = hout .^2;
    flt = conv(houtsq,mov2,'same');
    
    [qrspeaks,locs] = findpeaks(flt,time,'MinPeakHeight',600,'MinPeakDistance',150);
    
    
    if i > 1
        set(h_plot,'xdata',time,'ydata',flt);
        title('test');
        xlabel('Time');
        ylabel('Quantization value');
        set(d_plot,'xdata',locs,'ydata',lout3(locs));
        drawnow;
    end
    
    i = i + 1;
end
