load("data.mat");
fs=500;

figure('name','origin');
plot(disbuff);


%%%%%%%%%%%%%%%%%low_pass_filter%%%%%%%%%%%%%%%%%%%
n=8;
one_filter = ones(n,1);

output=conv(disbuff,one_filter/n,'same');

low_pass_data=output(n-1:(length(output)-(n-1)));

%%%%%%%%%%%%%%%%      end       %%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%%% high pass filter  %%%%%%%%%%%%%%%%%

h1 = [1 -1];
new_vector2 =conv(low_pass_data,h1,'same');
new_vector2=new_vector2(2:(length(new_vector2)-1));

%%%%%%%%%%%%%%%%      end      %%%%%%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%% if negative become zero %%%%%%%%%%%%

new_vector2(new_vector2<0)=0;

%%%%%%%%%%%%%%        end       %%%%%%%%%%%%%%%





%%%%%%%%%%%%%   normalize and square     %%%%%%%%%%%%%

normalize = new_vector2(:) ./ max(new_vector2);

second_order = normalize .^ 2;

%%%%%%%%%%%%%%       end   %%%%%%%%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%     show      %%%%%%%%%%%%%%%%%%%%%%%%

figure('name','low_pass_filter & high pass filter_normalize_dot');
plot(disbuff);
hold on;
index_final=[];

i=1;

%%%%%%%%%%%%    find peak    %%%%%%%%%%%%%%%%%
while i <=(length(second_order)-35)
    if second_order(i)>0.2
        [value ,index]=max(disbuff(i:i+35));
        index_final=[index_final index+i-1];
        i=i+35;
    end
    i=i+1;
end
%%%%%%%%%%%%%%     end      %%%%%%%%%%%%%%%%%%%%%%%%





%%%%%%%%%%%    draw peak on pciture %%%%%%%%%%%%%%%%%

plot(index_final,disbuff(index_final),'o','Markersize',10);
hold off;
        
%%%%%%%%%%%%%%%     end     %%%%%%%%%%%%%%%%
        
        

