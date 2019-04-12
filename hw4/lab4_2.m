%This is for MIT Database
load("Desktop/4up/DSP_LAB/hw4/MIT_database/easy/117m.mat");


disbuff =val(1,:);
time=[1:1:1000];

h_plot=plot(nan,nan);
hold on; 
d_plot=plot(nan,nan,'ro');


out   =  low_pass(disbuff);
output= high_pass(out);
norm  = normalize(output);
norm2 = norm .^ 2;

rpeak = findrpeak(norm2,disbuff);
set(h_plot,'xdata',((1:length(disbuff))-1),'ydata',disbuff);

title('test');
xlabel('Time');
ylabel('Quantization value');


if length(rpeak)>=1
    set(d_plot,'xdata',(rpeak-1),'ydata',disbuff(rpeak));
    %drawnow;
end
    
hold off;
disp(length(rpeak)); 

%output to file
fileID = fopen('Desktop/4up/DSP_LAB/hw4/predict/117_1.txt','w');
fprintf(fileID, '%d\n',(rpeak));





function output=low_pass(data)

    n=8;
    one_filter = ones(n,1);
    temp=conv(data,one_filter/n,'same');
    output=temp(n-1:(length(temp)-(n-1)));
end



function output=high_pass(data)

    h1 = [1 -1];
    output =conv(data,h1);
    output = output(2:(length(output)-1));
end



function norm  = normalize(data)

    data(data<0)=0;
    norm        =data(:) ./ max(data);
end



function rpeak = findrpeak(data,disbuff)
    temp=[1];
    i=1;
    while i<(length(disbuff)-90)
        if data(i)>0.1
            [value ,index]=max(disbuff(i:i+90));
            temp=[temp index+i-1];
            i=i+90;
        end
        i = i+1;
    end
    rpeak=temp;
end
