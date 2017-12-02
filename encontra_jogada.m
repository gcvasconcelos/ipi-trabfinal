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

%é possivel especificar o quadrante
%[linha, coluna] = size(I);
%LOC = step(H,I,T, [1 1 coluna linha]);

imshow(I);
hold on 
plot(LOC(1),LOC(2),'x','LineWidth',2,'Color','red');

%Encontra centro do circulo e raio
%seria melhor utilizadar um template? parte mais demorada
[center, raddi] = imfindcircles(I, [15 30]);

viscircles(center,raddi,'EdgeColor','b');
hold off