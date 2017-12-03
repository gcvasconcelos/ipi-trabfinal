close all
clear all
clc

% cam = webcam;
% %preview(cam);
% img = snapshot(cam);
% 
% img = rgb2gray(img);
% img = imresize(img, [300, 300]);
% img = getBoard(img);
% imshow(img)
%pause


 img = openImage('teste2.jpg');
 img2 = openImage('teste3.jpg');
% 
img = getBoard(img);
img2 = getBoard(img2);


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

board = zeros(3, 3);

%desenvolvimento do jogo
player = 'x';

[h,w] = size(img);
A = [1 1; 1 w/3; 1 2*w/3;...
    h/3 1; h/3 w/3; h/3 2*w/3;...
    2*h/3 1; 2*h/3 w/3; 2*h/3 2*h/3];

board(8) = 1;

%detecta jogada do player
% free_space = find(~board);
% for i = 1:length(free_space)
%     indice = free_space(i);
%     %indice = 1;
%     frame_anterior = imcrop(img, [A(indice,1) A(indice,1) w/3 h/3]);
%     frame_atual = imcrop(img2, [A(indice,2) A(indice,1) w/3 h/3]);
%     diff = imabsdiff(frame_anterior,frame_atual);
%     if player == 'x'
% %         T = imread('X_rots.jpg');
% %         T = rgb2gray(T);
% %         H = vision.TemplateMatcher;
% %         I = imabsdiff(img,img2);
% %         LOC = step(H,I,T);
% %         break
% %     [h,w] = size(img_border);
% %     img_border = imcrop(img_border, [1+h/8 1+w/8 w/8 h/8]); 
%     img_border = edge(diff,'canny', 0.3);
%     img_border = imclearborder(img_border);
%    % img_border = bwmorph(img_border,'skel',Inf);
% %     img_border = getBoard(img_border);
%    % status = regionprops(img_border,'Centroid',...
%    % 'MajorAxisLength','MinorAxisLength');
% 
% 
%     figure, imshow(img_border)
%     [H,theta,rho] = hough(img_border);
%     P = houghpeaks(H,2);
%     lines = houghlines(frame_atual,theta,rho,P);
% %     for k = 1:length(lines)
%          xy = [lines(1).point1; lines(1).point2];
% %         for l = 1:length(lines)
%              uv = [lines(2).point1; lines(2).point2];
% %             if xy == uv 
% %                 continue
% %             end
%             [w,v] = polyxpoly(xy(:,1),xy(:,2),uv(:,1),uv(:,2));
% %         end
% %     end
%     LOC = [w,v];
%     else
%         [LOC, raddi] = imfindcircles(frame_anterior, [6 18]);
%     end
%     if ~isempty(LOC)
%         break
%     end
% end
% 
% %marca no board ajogada do player
% %board(i) = 1;   %marca a jogada do player como 1
% % figure, imshow(img)
% % hold on
% % plot(LOC(1),LOC(2),'x','LineWidth',2,'Color','blue');
% % hold off

imshow(img)
%computador faz jogada
pc = find(~board);
pc = pc(randperm(length(pc)));
pc = pc(1);

board(pc) = 2;%marca jogada do pc

row = (A(pc,2) + w/6);
col = (A(pc,1) + h/6);

if player == 'x'
    hold on
    viscircles([col row],20,'EdgeColor','b');
    hold off
else
 hold on
    x = 0:1;
    pos = 0:1;
    neg = 1-x;
    plot(x+col, pos+row,'LineWidth',50,'Color','red')
    plot(x+col, neg+row,'LineWidth',50,'Color','red')
 hold off
end

function img = openImage(name)
    img = imread(name);
    img = rgb2gray(img);
    img = imresize(img, [200, 200]);
end

function board = getBoard(img)
    corners = detectHarrisFeatures(img);
    x_c = floor(abs(corners.Location(:,2)));
    y_c = floor(abs(corners.Location(:,1)));
    board = img(min(x_c):max(x_c),min(y_c):max(y_c));
    board = imresize(board, [200, 200]);
end




