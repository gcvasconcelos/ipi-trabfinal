close all 
clc

% obj = videoinput("v4l2", "/dev/video0");
% set(obj, "VideoFormat", "RGB3")

% preview(obj);

%while 1
  % input("Aperte qualquer tecla  para capturar o frame.");
  % start(obj)
  % img = getsnapshot(obj);
  % stop(obj)
  %figure, imshow(img);
%end

img_mod = imread('melhorcaso.jpg');
figure, imshow(img_mod);

% img_mod = rgb2gray(img);

%binarizar localmente
level = graythresh(img_mod);
img_mod = im2bw(img_mod,level);

img_border = edge(uint8(img_mod),'canny');
img_border = imclearborder(img_border);
figure, imshow(img_border)

[H,theta,rho] = hough(img_border);
% imshow(imadjust(rescale(H)),'XData',T,'YData',R,...
%       'InitialMagnification','fit');
% title('Hough transform of gantrycrane.png');
% xlabel('\theta'), ylabel('\rho');
% axis on, axis normal;
P = houghpeaks(H,8);
linhas = houghlines(img_mod,theta,rho,P);

hold on
for k = 1:length(linhas)
   xy = [linhas(k).point1; linhas(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','blue');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
end
hold off

% corners = detectHarrisFeatures(img_mod);
% [features, valid_corners] = extractFeatures(img_mod, corners);
% figure; imshow(img_mod); hold on
% plot(valid_corners);
%dividir a imagem em blocos
%A = crop();
