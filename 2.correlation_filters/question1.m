function [] = question1()
%{
jskyzero 2017/10/22

try to do image filter use correlation

REFERENCE:
Correlation and Convolution Class Notes for CMSC 426, Fall 2005 David Jacobs
%}

% read image
car_img = imread('car.png');
wheel_img = imread('wheel.png');

% print ans
  function print_match(img,str)
     fprintf([str,'\n']);
     [i,j] = find(img>=max(max(img)));
     disp([i,j])
  end

% use the common correlation filter
common_filter_img = imfilter(car_img, ...
  double(wheel_img) / sumsqr(wheel_img) * 255 / numel(wheel_img));

%self defined filter
source_img = im2double(car_img);
[source_x, source_y] = size(source_img);
mask_img = im2double(wheel_img);
[mask_x, mask_y] = size(mask_img);
mask = reshape(mask_img, [mask_x * mask_y, 1]);
source_pad = padarray(source_img, [floor(mask_x/2) floor(mask_y/2)]);
source = im2col(source_pad, [mask_x mask_y], 'sliding');


% diff points
diff_percent = @(a,b) (a == b) / numel(a);
diff_filter = sum(bsxfun(diff_percent, source, mask), 1);
diff_point_img = col2im(diff_filter, [mask_x mask_y], size(source_pad), 'sliding');

% use the sum of square error
sum_sqr = @(a, b)  (1 - (a - b).^2)./numel(a) ;
diff_filter = sum(bsxfun(sum_sqr, source, mask), 1);
square_error_img = col2im(diff_filter, [mask_x mask_y], size(source_pad), 'sliding');


% print output

hold on;
subplot(3,1,1);
imshow(common_filter_img);
title('common filter');
print_match(common_filter_img, 'common_filter');
subplot(3,1,2);
imshow(histeq(diff_point_img));
title('diff point filter');
print_match(diff_point_img, 'diff point');
subplot(3,1,3);
imshow(histeq(square_error_img));
title('square error filter');
print_match(square_error_img, 'diff point');

end