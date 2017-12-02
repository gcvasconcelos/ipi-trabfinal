close all
clc

% cam = webcam;
% preview(cam);
% snapshot(cam);

img = imread('melhorcaso.jpg');

img = rgb2gray(img);
BW = imbinarize(img);
bordas = edge(BW,'canny');

[H,theta,rho] = hough(bordas,'RhoResolution',0.5,'ThetaResolution',0.5);
peaks = houghpeaks(H,8);
linhas = houghlines(BW,theta,rho,peaks);

figure
imshow(imadjust(rescale(H)),'XData',theta,'YData',rho, 'InitialMagnification','fit');
title('Transformada de Hough no tabuleiro do jogo da velha');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
colormap(gca,hot);

peaks  = houghpeaks(H,8);
x = theta(peaks(:,2)); y = rho(peaks(:,1));
plot(x,y,'s','color','white');

lines = houghlines(BW,theta,rho,peaks,'FillGap',5,'MinLength',7);
figure, imshow(img), hold on;
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

hold off;

