


A = imread('1.jpg');

%Generate a averaging filter
h_average = fspecial('average',3);

%generate a gaussian filter
h_gaussian = fspecial('gaussian', 3, 0.5);




 A_bin = imbinarize(A, 0.5);
merge = zeros(120);



A_bin_resize = imresize(A_bin,0.10) ;
[y, x] = size(A_bin_resize);
startX = round((120/2)-(x/2));
startY = round((120/2)-(y/2));
merge(startY: startY + y - 1, startX: + startX + x  - 1) = A_bin_resize;

% (87/2)-(y/2))
% ((87/2)-(x/2))
imshow(merge);

A_average = imfilter(merge, h_average);
A_gaussian = imfilter(merge, h_gaussian);
A_median = medfilt2(merge);
A_guided_filter = imguidedfilter(merge);


subplot(2,3,1), imshow(merge), title('Original');

subplot(2,3,2), imshow(A_average), title('average');
subplot(2,3,3), imshow(A_gaussian), title('gaussian');
subplot(2,3,4), imshow(A_median), title('median');
subplot(2,3,5), imshow(A_guided_filter), title('guide filter');




