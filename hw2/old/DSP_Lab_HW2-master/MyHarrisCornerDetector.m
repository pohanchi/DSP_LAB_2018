% My Harris detector
% The code calculates
% the Harris Feature/Interest Points (FP or IP) 
% 
% When u execute the code, the test image file opened
% and u have to select by the mouse the region where u
% want to find the Harris points, 
% then the code will print out and display the feature
% points in the selected region.
% You can select the number of FPs by changing the variables 
% max_N & min_N


%%%
%corner : significant change in all direction for a sliding window
%%%


%%
% parameters
% corner response related
sigma=2;
n_x_sigma = 6;
alpha = 0.04;
% maximum suppression related
Thrshold=20;  % should be between 0 and 1000
r=6; 


%%
% filter kernels
dx = [-1 0 1; -1 0 1; -1 0 1]; % horizontal gradient filter 
dy = dx'; % vertical gradient filter
g = fspecial('gaussian',max(1,fix(2*n_x_sigma*sigma)), sigma); % Gaussien Filter: filter size 2*n_x_sigma*sigma


%% load 'Im.jpg'
frame = imread('statue.jpg');
I = double(frame);
figure(1);
imagesc(frame);
[xmax, ymax,ch] = size(I);
xmin = 1;
ymin = 1;


%%%%%%%%%%%%%%Intrest Points %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I_grey = grey_scale(I);
I_grey = I(:,:,1)*0.299 + I(:,:,2)*0.587 + I(:,:,3)*0.114;
R = I_grey;



%%%%1%%
% get image gradient
% [Your Code here] 
% calculate Ix
Ix_R = conv2(R, dx, 'same');


% calcualte Iy
Iy_R = conv2(R, dy, 'same');


%%%%%
% get all components of second moment matrix M = [[Ix2 Ixy];[Iyx Iy2]]; note Ix2 Ixy Iy2 are all Gaussian smoothed
% [Your Code here] 
% calculate Ix2
% calculate Iy2
% calculate Ixy
%%%%%
Ix2_R = Ix_R.*Ix_R;
Ix2 = imfilter(Ix2_R, g);
 

Iy2_R = Iy_R.*Iy_R;
Iy2 = imfilter(Iy2_R, g);


Ixy_R = Ix_R.*Iy_R;
Ixy = imfilter(Ixy_R, g);


%% visualize Ixy
figure(2);
imagesc(Ixy);

%%%%%%% Demo Check Point -------------------


%%%%%
% get corner response function R = det(M)-alpha*trace(M)^2 
% [Your Code here] 
% calculate R
%%%%%
for h = 1:ymax
    for w = 1:xmax
        M = [Ix2(w,h) Ixy(w,h); Ixy(w,h) Iy2(w,h)];
        R(w,h) = det(M)-alpha*trace(M)^2;     
    end
end

%% make max R value to be 1000
R=(1000/max(max(R)))*R; % be aware of if max(R) is 0 or not

%%%%%
%% using B = ordfilt2(A,order(sze^2),domain(ones(sze))) to complment a maxfilter
sze = 2*r+1; % domain width 
% [Your Code here] 
% calculate MX
%%%%%

Mx = ordfilt2(R, sze^2,ones(sze,sze));

%%%%%
% find local maximum.
% [Your Code here] 
% calculate RBinary
%%%%%

for h= 1:ymax
    for w=1:xmax
        if((R(w,h)>Thrshold) & Mx(w,h)==R(w,h)) RBinary(w,h) = 1;
        else  RBinary(w,h) = 0;
        end
    end 
end

%% get location of corner points not along image's edges
offe = r-1;
count=sum(sum(RBinary(offe:size(RBinary,1)-offe,offe:size(RBinary,2)-offe))); % How many interest points, avoid the image's edge   
R=R*0;
R(offe:size(RBinary,1)-offe,offe:size(RBinary,2)-offe)=RBinary(offe:size(RBinary,1)-offe,offe:size(RBinary,2)-offe);
[r1,c1] = find(R);
  

%% Display
figure(3)
imagesc(uint8(I));
hold on;
plot(c1,r1,'or');

return;
