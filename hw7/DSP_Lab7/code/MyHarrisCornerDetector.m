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
Thrshold=5;  % should be between 0 and 1000
r=4; 


%%
% filter kernels
dx = [-1 0 1; -1 0 1; -1 0 1]; % horizontal gradient filter 
dy = dx'; % vertical gradient filter
g = fspecial('gaussian',max(1,fix(2*n_x_sigma*sigma)), sigma); % Gaussien Filter: filter size 2*n_x_sigma*sigma


%% load 'Im.jpg'
frame = imread('data/square.jpg');
I = double(frame);
figure(1);
imagesc(frame);
[xmax, ymax,ch] = size(I);
xmin = 1;
ymin = 1;


%%%%%%%%%%%%%%Intrest Points %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
grey = I(:,:,1)*0.299 + I(:,:,2)*0.587 + I(:,:,3)*0.114;
R = grey;

%%%%%%
% get image gradient
Ixr = conv2(R,dx,'same');
Iyr = conv2(R,dy,'same');
% [Your Code here] 
% calculate Ix
% calcualte Iy
%%%%%
% get all components of second moment matrix M = [[Ix2 Ixy];[Iyx Iy2]]; note Ix2 Ixy Iy2 are all Gaussian smoothed
% [Your Code here] 
Ix2r = Ixr .* Ixr;
I_x2r= imfilter(Ix2r, g);
Iy2r = Iyr .* Iyr;
I_y2r= imfilter(Iy2r, g);
Ixyr = Ixr .* Iyr;
I_xyr= imfilter(Ixyr, g);
Ixy = I_xyr;
% calculate Ix2  
% calculate Iy2
% calculate Ixy
%%%%%

%% visualize Ixy
figure(2);
imagesc(Ixy);

%%%%%%% Demo Check Point -------------------


%%%%%
% get corner response function R = det(M)-alpha*trace(M)^2 
% [Your Code here] 
for h = 1:ymax
    for w = 1:xmax
        M = [I_x2r(w,h) I_xyr(w,h); I_xyr(w,h) I_y2r(w,h)];
        R(w,h) = det(M)-alpha*trace(M)^2;     
    end
end
% calculate R
%%%%%
 
%% make max R value to be 1000
R=(1000/max(max(R)))*R; % be aware of if max(R) is 0 or not

%%%%%
%% using B = ordfilt2(A,order,domain) to complment a maxfilter
sze = 2*r+1; % domain width 
% [Your Code here] 
Mx = ordfilt2(R, sze^2,ones(sze,sze));
figure(5);
imagesc(uint8(Mx));
figure(6);
imagesc(uint8(R));
% calculate MX
%%%%%

%%%%%
% find local maximum.
% [Your Code here] 
% calculate RBinary
for h= 1:ymax
    for w=1:xmax
        if((R(w,h)>Thrshold) & Mx(w,h)==R(w,h)) 
            RBinary(w,h) = 1;
        else  RBinary(w,h) = 0;
        end
    end 
end
%%%%%


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
