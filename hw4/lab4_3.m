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
hold on; 
d_plot=plot(nan,nan,'ro');hold off;
tic

i=1;

while i<3000
    tic
    data=fscanf(s1);%read sensor
    y(i) = str2double(data);
    
    if i<=1000
        disbuff(i)=y(i);
    else
        disbuff=[disbuff(2:end) y(i)];
    end
    
    if i>1 & mod(i,30) == 0     %update every 30 point
        
        out   =  low_pass(disbuff);  %lowpass
        output= high_pass(out);         %high pass
        norm  = normalize(output);      %normalize
        norm2 = norm .^ 2;              %square
        rpeak = findrpeak(norm2,disbuff);   %rpeak index get
        heartbeatrate = hbr(rpeak);     %heart beat rate
        
        set(h_plot,'xdata',time,'ydata',disbuff)  %draw
        title(['Heart Beat rate is ',num2str(heartbeatrate),'Hz']);
        xlabel('Time');
        ylabel('Quantization value');
        
        if length(rpeak)>=1
            set(d_plot,'xdata',rpeak,'ydata',disbuff(rpeak));
            drawnow;
        end
        
    end
    i=i+1;
    disp(i);
end

function output=low_pass(data)      %low pass

    n=8;
    one_filter = ones(n,1);
    temp=conv(data,one_filter/n,'same');
    output=temp(n-1:(length(temp)-(n-1)));
    
end

function output=high_pass(data)     %high pass

    h1 = [1 -1];
    output =conv(data,h1);
    output = output(2:(length(output)-1));
end

function norm  = normalize(data)    %normalize

    data(data<0)=0;
    norm        =data(:) ./ max(data);
    
end

function rpeak = findrpeak(data,disbuff)    %find peak
    
    temp=[];
    i=1;
    
    while i <(length(data)-25) 
        
        if data(i)>0.5 
            [value ,index]=max(disbuff(i:i+25));%period=25
            temp=[temp index+i-1];
            i=i+25;
        end
        
        i=i+1;
        
    end
    
    rpeak=temp;
    
end

function output = hbr(rpeakvector) %heart beat rate
    
    interval = [-1 1];
    temp=[];
    
    for i = 2:(length(rpeakvector)-1)
        
        %disp((sum((rpeakvector(i:i+1) .* interval))/250.0))
        temp(i-1)= (1/(sum((rpeakvector(i:i+1) .* interval))/250.0));
        
    end    
    
    output = mean(temp);
    
end
        
        
        
        
        
        
        
        
        
    
    
    
    