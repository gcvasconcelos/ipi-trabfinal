close all
clear all
clc

cam = webcam;
preview(cam);

board = zeros(3, 3);
frame = getSnapshot(cam);

while result == -1
    lastframe = frame;
    frame = getSnapshot(cam);
    frame = getBoard(frame);
    
    pause;
    diff = psnr(frame, lastframe);
    if (diff < 22)
        playerTurn(lastframe, frame, board);
        computerTurn(frame, board, 'o');
        result = won(board);
    end
end


% img = openImage('teste2.jpg');
% img2 = openImage('teste3.jpg');
% img = getBoard(img);
% img2 = getBoard(img2);

% captura o frame atual da camera e formata para analise
function tmp = getSnapshot(cam)
    tmp = snapshot(cam);
    tmp = rgb2gray(tmp);
    tmp = imresize(tmp, [200, 200]);
end

% abre imagem de testes e formata para analise
function img = openImage(name)
    img = imread(name);
    img = rgb2gray(img);
    img = imresize(img, [200, 200]);
end

% segmenta a imagem utilizando os pontos de Harrris
% retorna apenas a parte da imagem com o tabuleiro 
function board = getBoard(img)
    corners = detectHarrisFeatures(img);
    x_c = floor(abs(corners.Location(:,2)));
    y_c = floor(abs(corners.Location(:,1)));
    board = img(min(x_c):max(x_c),min(y_c):max(y_c));
    board = imresize(board, [200, 200]);
end

% detecta qual jogada aconteceu entre cada estado do frame
% registra a jogada no board
function [] = playerTurn(frame, nextframe, board)
    diff = frame-nextframe;
    diff = im2bw(diff, 0.4);
    center = floor(imfindcircles(diff,[6 18]));
    if (length(center) > 1)
        center = center(1,:);
    elseif (isempty(center))
        return;
    end
    
    x = center(1); y = center(2);
    board_size = size(nextframe);
    cell_x = board_size(1)/3; cell_y = board_size(2)/3;

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

    board(board_x,board_y) = 1;
end

% jogada do PC
function [] = computerTurn(frame, board, player)
    %frame = frame atual
    %board = board sendo, 0 as posicoes vazias
    %player = a opção de jogada do player
    %assim que o matlab lida com matrix
    % |1| |4|  |7|
    % |2| |5|  |8|
    % |3| |6|  |9|
    
    %devide o board em regioes
    [h,w] = size(frame);
    
    A = [1 1; 1 w/3; 1 2*w/3;...
    h/3 1; h/3 w/3; h/3 2*w/3;...
    2*h/3 1; 2*h/3 w/3; 2*h/3 2*h/3];

    %supondo que espaços vazio sao 0
    %procura pela primeira posicao vazia
    %acha posicao aleatoria vazia
    pc = find(~board);
    pc = pc(randperm(length(pc)));
    pc = pc(1);
    

    board(pc) = 2;%marca jogada do pc

    row = (A(pc,2) + w/6);
    col = (A(pc,1) + h/6);

    if player == 'x'
        hold on
        viscircles([x y],30,'EdgeColor','b');
        hold off
    else
     hold on
        x = 0:1;
        pos = 0:1;
        neg = 1-x;
        plot(x+col, pos+row,'LineWidth',60,'Color','red')
        plot(x+col, neg+row,'LineWidth',60,'Color','red')
     hold off
    end





end

% analisa o board e detecta se alguem venceu
% retorna a 1 se o 'O' venceu
%           2 se o 'X' venceu        
%           0 se deu velha
%          -1 se nada aconteceu
function result = won(board)
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
    elseif ~ismember(board, -1)
        result = 2;
    else
        result = -1;
    end
end

function checkWin(board)
    state = won(board);
    if (state == 0)
end
