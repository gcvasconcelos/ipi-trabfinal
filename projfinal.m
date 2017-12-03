close all
clear all
clc

cam = webcam;
preview(cam);

frame = getSnapshot(cam);
for i=1:10
    lastframe = frame;
    frame = getSnapshot(cam);
    frame = getBoard(frame);
    imshow(img);
    pause;
end


% img = openImage('teste2.jpg');
% img2 = openImage('teste3.jpg');
% board = zeros(3, 3);
% 
% 
% img = getBoard(img);
% img2 = getBoard(img2);


function tmp = getSnapshot(cam)
    tmp = snapshot(cam);
    tmp = rgb2gray(tmp);
    tmp = imresize(tmp, [200, 200]);
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

function [] = computerTurn()
end

function [] = drawPlay()
end

function result = won(board, op)
    % horizontal
    if (board(1,1) == board(1,2) && board(1,1) == board(1,3) && board(1,1) ~= 0)
        result = board(1,1);
    elseif (board(2,1) == board(2,2) && board(2,1) == board(2,3) && board(2,1) ~= 0)
        result = board(2,1);
    elseif (board(3,1) == board(3,2) && board(3,1) == board(3,3) && board(3,1) ~= 0)
        result = board(3,1);
    % vertical
    elseif (board(1,1) == board(2,1) && board(1,1) == board(3,1) && board(3,1) ~= 0) 
        result = board(1,1);
    elseif (board(1,2) == board(2,2) && board(1,2) == board(3,2) && board(1,2) ~= 0) 
        result = board(1,2);
    elseif (board(1,3) == board(2,3) && board(1,3) == board(3,3) && board(1,3) ~= 0) 
        result = board(1,3);
    % diagonal
    elseif (board(1,1) == board(2,2) && board(1,1) == board(3,3) && board(1,1) ~= 0)
        result = board(1,1);
    elseif (board(1,3) == board(2,2) && board(1,3) == board(3,1) && board(2,2) ~= 0)
        result = board(1,3);
    else
        result = 0;
    end
end

