close all
clear all
clc

% cam = webcam;
% preview(cam);
% snapshot(cam);

img = imread('teste1.jpg');
img = rgb2gray(img);

borders = edge(img,'canny', 0.5);
imshow(borders);


[H,theta,rho] = hough(borders);
peaks = houghpeaks(H,4);
lines = houghlines(img,theta,rho,peaks,'FillGap',100,'MinLength',50);

figure(1), imshow(imadjust(rescale(H)),'XData',theta,'YData',rho, 'InitialMagnification','fit');
title('Transformada de Hough no tabuleiro do jogo da velha');
xlabel('\theta'), ylabel('\rho');

axis on, axis normal, hold on

x = theta(peaks(:,2));
y = rho(peaks(:,1));
plot(x,y,'s','color','red');

hold off

figure(2), imshow(img);
hold on

for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',5,'Color','red');
   plot(xy(2,1),xy(2,2),'x','LineWidth',5,'Color','red');
end

hold off



