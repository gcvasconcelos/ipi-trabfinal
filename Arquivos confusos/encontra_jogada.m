clear all
close all

T = imread('X_rots.jpg');
T = rgb2gray(T);
%figure, imshow(T);

I = imread('melhorx.jpg');
I = rgb2gray(I);

H = vision.TemplateMatcher;
%encontra template na imagem
LOC = step(H,I,T);

%� possivel especificar o quadrante
%[linha, coluna] = size(I);
%LOC = step(H,I,T, [1 1 coluna linha]);

figure, imshow(I);
hold on 
plot(LOC(1),LOC(2),'x','LineWidth',2,'Color','red');

%Encontra centro do circulo e raio
%seria melhor utilizadar um template? parte mais demorada
% [center, raddi] = imfindcircles(I, [15 30]);
% 
% viscircles(center,raddi,'EdgeColor','b');
% hold off

% borders = edge(img,'canny', 0.5);
% [H,theta,rho] = hough(borders);
% peaks = houghpeaks(H,5);
% lines = houghlines(img,theta,rho,peaks);
% 
% figure(1), imshow(imadjust(rescale(H)),'XData',theta,'YData',rho, 'InitialMagnification','fit');
% title('Transformada de Hough no tabuleiro do jogo da velha');
% xlabel('\theta'), ylabel('\rho');
% 
% axis on, axis normal, hold on
% 
% x = theta(peaks(:,2));
% y = rho(peaks(:,1));
% plot(x,y,'s','color','red');
% hold off
% 
% figure(2), imshow(img);
% hold on
% for k = 1:length(lines)
%    xy = [lines(k).point1; lines(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% 
%    plot(xy(1,1),xy(1,2),'x','LineWidth',5,'Color','red');
%    plot(xy(2,1),xy(2,2),'x','LineWidth',5,'Color','red');
% end
% 
% hold off
