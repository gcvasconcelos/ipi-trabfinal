close all 
clear all
clc

img_mod = imread('teste2.jpg');
img_mod1 = rgb2gray(img_mod);

img_mod = imread('teste3.jpg');
img_mod2 = rgb2gray(img_mod);

%detecta pontos
Points1 = detectSURFFeatures(img_mod1);
Points2 = detectSURFFeatures(img_mod2);

%coners
corners = detectHarrisFeatures(img_mod1);

%mostra
figure, imshow(img_mod1);
hold on
%plot(selectStrongest(Points1, 100));
plot(corners.selectStrongest(50));
hold off

figure, imshow(img_mod2);
hold on
plot(selectStrongest(Points2, 100));
hold off



%extract features
[Features1, Points1] = extractFeatures(img_mod1, Points1);
[Features2, Points2] = extractFeatures(img_mod2, Points2);

%achar semelhancas
%boxPairs = matchFeatures(Features, sceneFeatures);
indexPairs = matchFeatures(Features1,Features2);

%localização dos pontos em comum
matchedPoints1 = Points1(indexPairs(:,1),:);
matchedPoints2 = Points2(indexPairs(:,2),:);

figure; showMatchedFeatures(img_mod1,img_mod2,matchedPoints1,matchedPoints2);


%contorno da imagem
boxPolygon = [1, 1;...                           % top-left
        size(img_mod, 2), 1;...                 % top-right
        size(img_mod, 2), size(img_mod, 1);... % bottom-right
        1, size(img_mod, 1);...                 % bottom-left
        1, 1];                   % top-left again to close the polygon
    
%newBoxPolygon = transformPointsForward(tform, boxPolygon);

hold on;
%line(newBoxPolygon(:, 1), newBoxPolygon(:, 2), 'Color', 'y');
for k = 1:length(boxPolygon)
   xy = boxPolygon(k,:);
   plot(xy(1),xy(2),'x','LineWidth',2,'Color','blue');
end