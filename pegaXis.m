clear all
close all


img = openImage('teste2.jpg');
img2 = openImage('teste3.jpg');
img = getBoard(img);
img2 = getBoard(img2);

board = zeros(3, 3);
player = 'x';

diff = img-img2;
diff = im2bw(diff, 0.4);

%free_space = find(~board);
img_border = edge(diff,'canny', 0.5);
img_border = imclearborder(img_border);
figure, imshow(img_border)
%hough lines
[H,theta,rho] = hough(img_border);
P = houghpeaks(H,5);
lines = houghlines(img_border,theta,rho,P);
%checa se tem interseccao
xy = [lines(1).point1; lines(1).point2];
uv = [lines(2).point1; lines(2).point2];
[w,v] = polyxpoly(xy(:,1),xy(:,2),uv(:,1),uv(:,2));
center = [w,v];


%localização
x = center(1);
y = center(2);
size = size(img2);
cell_x = size(1)/3;
cell_y = size(2)/3;

if (x>cell_x)
    if (x>(cell_x*2))
        board_x = 3;
    else
        board_x = 2;
    end
else
    board_x = 1;
end

if (y>cell_y)
    if (y>(cell_y*2))
        board_y = 3;
    else
        board_y = 2;
    end
else
    board_y = 1;
end

board(board_y,board_x) = 1;

figure, imshow(img2)
hold on
plot(center(1), center(2),'x','LineWidth',2,'Color','green');
hold off

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