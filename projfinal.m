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

figure(1)
imshow(imadjust(rescale(H)),'XData',theta,'YData',rho, 'InitialMagnification','fit');
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

img_size = size(img);
lil_board_size  = [lines(2).point1(1)-lines(3).point1(1),lines(4).point1(2)-lines(1).point1(2)];
board_size = [3*lil_board_size(1), 3*lil_board_size(2)];
pad_size = floor((img_size - board_size)/2);

board_block = img(pad_size(1):img_size(1)-pad_size(1), pad_size(2):img_size(2)-pad_size(2));
board_block_size = size(board_block);

board_state = [0 0 0; 0 0 0; 0 0 0];

% play = imread('melhorx.jpg');
% play = rgb2gray(play);
x_template = imread('X_rots.jpg');
x_template = rgb2gray(x_template);
H = vision.TemplateMatcher;

LOC = step(H,board_block,x_template);
% [line, column] = size(board_block);
% LOC = step(H,play,x_template, [1 1 column line]);

figure, imshow(board_block);
hold on 
plot(LOC(1),LOC(2),'x','LineWidth',2,'Color','red');

%Encontra centro do circulo e raio
%seria melhor utilizadar um template? parte mais demorada
% [center, raddi] = imfindcircles(I, [15 30]);
% 
% viscircles(center,raddi,'EdgeColor','b');
% hold off

