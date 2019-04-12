function output = my_imfilter(image, filter)
% This function is intended to behave like the built in function imfilter()
% See 'help imfilter' or 'help conv2'. While terms like "filtering" and
% "convolution" might be used interchangeably, and they are indeed nearly
% the same thing, there is a difference:
% from 'help filter2'
%    2-D correlation is related to 2-D convolution by a 180 degree rotation
%    of the filter matrix.
% Your function should work for color images. Simply filter each color
% channel independently.
% Your function should work for filters of any width and height
% combination, as long as the width and height are odd (e.g. 1, 7, 9). This
% restriction makes it unambigious which pixel in the filter is the center
% pixel.
% Boundary handling can be tricky. The filter can't be centered on pixels
% at the image boundary without parts of the filter being out of bounds. If
% you look at 'help conv2' and 'help imfilter' you see that they have
% several options to deal with boundaries. You should simply recreate the
% default behavior of imfilter -- pad the input image with zeros, and
% return a filtered image which matches the input resolution. A better
% approach is to mirror the image content over the boundaries for padding.
% % Uncomment if you want to simply call imfilter so you can see the desired
% % behavior. When you write your actual solution, you can't use imfilter,
% % filter2, conv2, etc. Simply loop over all the pixels and do the actual
% % computation. It might be slow.
% output = imfilter(image, filter);

%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%
[height,width,channel]= size(image);
size_image = [height,width,channel];
output = zeros(size_image);
for i=1:channel
    output(:,:,i)=my_channel_function(image(:,:,i),filter);
end
%%%%%%%%%%%%%%%%
% Your code end
%%%%%%%%%%%%%%%%
function output = my_channel_function(channel,filter)
    [h,w] = size(filter);
    disp(size(filter));
    [h_channel,w_channel] = size(channel);
    output_temp = zeros(h_channel,w_channel);
    pad_channel = padarray(channel,[floor(h/2),floor(w/2)],'both');
    for i=1:h_channel
        for j=1:w_channel
          output_temp(i,j) = sum(sum(pad_channel(i:i+h-1,j:j+w-1) .* filter(:,:)));
        end
    end
    output = output_temp;