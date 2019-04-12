clear all;
fclose('all');

serialobj=instrfind;
if ~isempty(serialobj)
    delete(serialobj)
end
clc;clear all;close all;
s1 = serial('COM4');  %define serial port
                      %���ӭn�M arduino �� port �ۦP
s1.BaudRate=115200;     %define baud rate
 
disbuff=nan(1,2000);

fopen(s1);
clear data;
N_point = 2000;
fs=200;   %sample rate
time=[1:1:2000]; % �q 1 �� 1000 ���� �� 1
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
fY = abs(fft(y));%�o��|�N y �̭��x�s�����˸�T
                 %�q time domain �ন frequncy
                 %domain
figure(2)
plot(((0:N_point-1))*fs/N_point,fY);
xlim([0,400]);
toc
% close the serial port
fclose(s1); 















