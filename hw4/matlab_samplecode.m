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
fs=250;   %sample rate
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
final=(abs(fft(disbuff)));
figure(2)

plot((0:999)*fs/1000,final)
xlim([-6,510])
toc
% close the serial port
fclose(s1); 















