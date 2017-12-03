clear
clc

img = openImage('circulo3.jpg');
img2 = openImage('circulo4.jpg');
img = getBoard(img);
img2 = getBoard(img2);

diff = img-img2;
diff = im2bw(diff, 0.4);
center = floor(imfindcircles(diff,[6 18]));
center = center(1,:);

x = center(1);
y = center(2);
size = size(img2);
cell_x = size(1)/3;
cell_y = size(2)/3;

board = zeros(3, 3);

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
scatter(center(1), center(2));
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