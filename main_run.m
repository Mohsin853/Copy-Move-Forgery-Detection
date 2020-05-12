clc;
clear all;
close all;
warning off;
tic;
run ('support\vlfeat-0.9.17\toolbox\vl_setup');
fprintf('Reading Image\n');
[filename, pathname] = uigetfile('*.png', 'Select an image');
im1=imread(strcat(pathname,filename));
% I=imresize(im1,0.25);
I=im1;
% cropping image into two
[q, r]=size(I);
img1=imcrop(I,[1,1,q/2,r]);
subplot(121);
imshow(img1);
img2=imcrop(I,[q/2,1,q,r]);
subplot(122);
imshow(img2);
figure;
% cropping image into two
im256=imresize(I,[256 256]);
[q1, r1,z]=size(im256);
img11=imcrop(im256,[1,1,127,127]);
subplot(221);
imshow(img11);
img12=imcrop(im256,[1,128,127,127]);
subplot(223);
imshow(img12);
img21=imcrop(im256,[128,1,127,127]);
subplot(222);
imshow(img21);
img22=imcrop(im256,[128,128,127,127]);
subplot(224);
imshow(img22);
figure;
 % segmentation
 fprintf('Slicing ......\n');
I2=im2single(I);
segments=vl_slic(I2,40,0.1);

labels=segments;
img=I;

rows = size(img, 1);
    cols = size(img, 2);

    contourImg = img;
    for i = 1: rows
        for j = 1: cols
            label = labels(i, j);
            labelTop = 0;
            labelBottom = 0;
            labelLeft = 0;
            labelRight = 0;

            if i > 1
                labelTop = labels(i - 1, j);
            end;
            if j > 1
                labelLeft = labels(i, j - 1);
            end;
            if i < rows
                labelBottom = labels(i + 1, j);
            end;
            if j < cols
                labelRight = labels(i, j + 1);
            end;

            if labelTop ~= 0 && labelTop ~= label
                contourImg(i, j, 1) = 0;
                contourImg(i, j, 2) = 0;
                contourImg(i, j, 3) = 0;
            end;
            if labelLeft ~= 0 && labelLeft ~= label
                contourImg(i, j, 1) = 0;
                contourImg(i, j, 2) = 0;
                contourImg(i, j, 3) = 0;
            end;
            if labelBottom ~= 0 && labelBottom ~= label
                contourImg(i, j, 1) = 0;
                contourImg(i, j, 2) = 0;
                contourImg(i, j, 3) = 0;
            end;
            if labelRight ~= 0 && labelRight ~= label
                contourImg(i, j, 1) = 0;
                contourImg(i, j, 2) = 0;
                contourImg(i, j, 3) = 0;
            end;
        end;
    end;
imshow(contourImg);
figure,imshow(segments);
imshow(I);
hold on;
 % keypoint extraction
I1=single(rgb2gray(img1));
I2=single(rgb2gray(img2));
[fa,da]=vl_sift(I1);
[fb,db]=vl_sift(I2);
[matches,scores]=vl_ubcmatch(da,db,10);
matchtemp=matches;
[drop, perm] = sort(scores, 'descend') ;
matches = matches(:, perm) ;
scores  = scores(perm) ;



imagesc(cat(2, img1, img2)) ;
axis image off ;

[x,y]=size(matches);
if y==0
    disp('Original image');
end

% figure(2) ; clf ;
% imagesc(cat(2, img1, img2)) ;

xa = fa(1,matches(1,:)) ;
xb = fb(1,matches(2,:)) + size(img1,2) ;
ya = fa(2,matches(1,:)) ;
yb = fb(2,matches(2,:)) ;

hold on ;
 h = line([xa ; xb], [ya ; yb]) ;
 set(h,'linewidth', 1, 'color', 'b') ;
vl_plotframe(fa(:,matches(1,:))) ;
fb(1,:) = fb(1,:) + size(img1,2) ;
% hold off;
% figure ; clf ;
% imagesc(cat(2, img1, img2)) ;
% 
% % hold on;
% vl_plotframe(fa(:,matches(1,:))) ;
% % fb(1,:) = fb(1,:) + size(img1,2) ;
% vl_plotframe(fb(:,matches(2,:))) ;
% % axis image off ;

vl_plotframe(fb(:,matches(2,:))) ;
axis image off ;
toc;


