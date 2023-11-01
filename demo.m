
% 
clear all;
clc;
close all;
for j=1:24
im = im2double(imread('C:\Users\zyx\Desktop\retinex\dataset\',strcat(num2str(j),'.png')));

aIm = rgb2gray(im);
gIm = RtGrayA(im);


imwrite(gIm,strcat('C:\Users\zyx\Desktop\retinex\dataset\',strcat(num2str(j),'_2.png')));
imwrite(aIm,strcat('C:\Users\zyx\Desktop\retinex\dataset\',strcat(num2str(j),'_1.png')));

end

