clear all;
fclose('all');

serialobj=instrfind;
if ~isempty(serialobj)
    delete(serialobj)
end
clc;clear all;close all;
s1 = serial('COM4');  %define serial port
                      %應該要和 arduino 的 port 相同
s1.BaudRate=115200;     %define baud rate
 
disbuff=nan(1,2000);

fopen(s1);
clear data;
N_point = 2000;
fs=200;   %sample rate
time=[1:1:2000]; % 從 1 到 1000 間格 為 1
figure
h_plot=plot(nan,nan);
hold off 
tic
for i= 1:N_point 
    data=fscanf(s1);%read sensor
    y(i) = str2double(data); 

    if i<=2000
    disbuff(i)=y(i);
    
    else
    disbuff=[disbuff(2:end) y(i)];
    end

    if i>1
    set(h_plot,'xdata',time,'ydata',disbuff)
    title('test');
    xlabel('Time');
    ylabel('Quantization value');
    drawnow;
    end
   
end
fY = abs(fft(y));%這邊會將 y 裡面儲存的取樣資訊
                 %從 time domain 轉成 frequncy
                 %domain
figure(2)
plot(((0:N_point-1))*fs/N_point,fY);
xlim([0,400]);
toc
% close the serial port
fclose(s1); 















