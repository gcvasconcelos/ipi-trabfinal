close all
clear all
%registra webcam e pega uma foto e possivel editar varias configuraçoes da webcam
%pkg load image-acquisition
%pkg load image

%obj = videoinput("v4l2", "/dev/video0");
%set(obj, "VideoFormat", "RGB3")
%set(obj, "VideoResolution", [1280 720])
%preview(obj) %ver imagem da camera live
%start(obj)
%img = getsnapshot(obj);
%stop(obj)

img = imread('melhorcaso.jpg');
figure, imshow(img);
%imwrite(img,'teste.png')
img = rgb2gray(img);

%preprocessamento retirar sombra fundo 
%img = imadjust(img);
%imadjust
%adapthisteq
%figure,imshow(img)

%binarizacao
%BW = imbinarize(img);
level = graythresh(img);
BW = im2bw(img,level);

%deteccao de bordas
bordas = edge(uint8(BW),'canny');
figure, imshow(bordas)

%deteccao de linhas
[H,theta,rho] = hough(bordas);
P = houghpeaks(H,8);
linhas = houghlines(BW,theta,rho,P);

hold on
for k = 1:length(linhas)
   xy = [linhas(k).point1; linhas(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
   % Plot beginnings and ends of lines
   %plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   %plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
end
hold off

