
load("data.mat");
fs=500;

figure('name','origin');
plot(disbuff);


n=8;
one_filter = ones(n,1);
figure('name','freq_ones');
freqz(one_filter/n,1);
output=conv(disbuff,one_filter);

figure('name','low_pass_filter ');
plot(n-1:(length(disbuff)-(n-1)),output(n-1:(length(disbuff)-(n-1))));
disbuff = disbuff(7:length(disbuff)-7);
h1 = [1 -1];
figure('name','freq_low_pass_filter ');
freqz(h1,1);
new_vector2 =conv(output,h1);
figure('name','low_pass_filter & high pass filter');
new_vector2 = new_vector2(2:(length(new_vector2)-1));
new_vector2(new_vector2<0)=0;
plot(new_vector2);
figure('name','low_pass_filter & high pass filter___normal');
normal = ((new_vector2(:)-min(new_vector2(:)))./ (max(new_vector2(:))-min(new_vector2(:))));
temp = normal;
plot(temp);
new = temp .^ 2;
figure('name','low_pass_filter & high pass filter___');
plot(new);
figure('name','low_pass_filter & high pass filter_draw');

[y,x]=findpeaks(new);
%plot((1:length(new)),new);
a=find(y>0.705);
plot(1:987,disbuff);
hold on
plot(x(a),disbuff(x(a)+1),'o','Markersize',10);
hold off    
        
        

%{
for i=1:1000
    new_vector2(i) =sum(pad_vector(i:i+1).* h1);
end
%}
%{
fft_y3 = abs(fft(new_vectorif length(rpeakvector)<2:2));

figure('name','low_pass_filter & high pass filter_fs');
plot((n:(1000))*fs/1000,fft_y3(n:(1000)));
%}
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