close all
clear all
clc

cam = webcam;
preview(cam);

board = zeros(3, 3);
%pega primeiro frame sem jogadas
frame = getSnapshot(cam);
frame = getBoard(frame);


result = won(board);
imshow(frame)
hold on
while result == -1
    lastframe = frame;
    pause;

    %pega primeira jogada
    frame = getSnapshot(cam);
    frame = getBoard(frame);

%     imshow(frame)
%     find(frame==1)

    diff = psnr(frame, lastframe);
    if (diff < 40)
        [check, board] = findCircle(lastframe, frame, board);
        if (check == 'x')
            board = findCross(lastframe, frame, board);
        end
        board = computerTurn(frame, board, check);
        result = won(board);
    end
end
hold off

checkWin(result);

% captura o frame atual da camera e formata para analise
function tmp = getSnapshot(cam)
    tmp = snapshot(cam);
    tmp = rgb2gray(tmp);
    tmp = imresize(tmp, [200, 200]);
end

% segmenta a imagem utilizando os pontos de Harrris
% retorna apenas a parte da imagem com o tabuleiro
function board = getBoard(img)
    corners = detectHarrisFeatures(img);
    % pega o menor valor a esquerda e acima e o maior valor a direita e
    % abaixo para considerar como as bordas da nova imagem
    x_c = floor(abs(corners.Location(:,2)));
    y_c = floor(abs(corners.Location(:,1)));
    board = img(min(x_c):max(x_c),min(y_c):max(y_c));
    board = imresize(board, [200, 200]);
end

% detecta qual jogada aconteceu entre cada estado do frame
% registra a jogada no board
function [bool, board] = findCircle(prevframe, frame, board)

    %diferenca entre frames
    diff = prevframe-frame;
    %diff = im2bw(diff, 0.4);
    diff = imbinarize(diff);

    center = floor(imfindcircles(diff,[6 18]));
    if (length(center) > 1)
        center = center(1,:);
    elseif (isempty(center))
        bool = 'x';
        return;
    end

    %localização
    x = center(1); y = center(2);
    board_size = size(frame);
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
    bool = 'o';
end

function board = findCross(prevframe, frame, board)

    %Faz diferença entre frame
    diff = prevframe-frame;
    %diff = im2bw(diff, 0.4);
    diff = imbinarize(diff);

    %encontra o X
    %segmentação
    img_border = edge(diff,'canny', 0.5);
    img_border = imclearborder(img_border);
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
    board_size = size(img2);
    cell_x = board_size(1)/3;
    cell_y = board_size(2)/3;

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
    %escreve no board
    board(board_y,board_x) = 1;
end

% jogada do PC
function board = computerTurn(frame, board, player)
    % frame = frame atual
    % board = board sendo, 0 as posicoes vazias
    % player = a opção de jogada do player
    % assim que o matlab lida com matrix
    % |1| |4|  |7|
    % |2| |5|  |8|
    % |3| |6|  |9|

    % devide o board em regioes
    [h,w] = size(frame);

    A = [1 1; 1 w/3; 1 2*w/3;...
        h/3 1; h/3 w/3; h/3 2*w/3;...
        2*h/3 1; 2*h/3 w/3; 2*h/3 2*h/3];

    % supondo que espaços vazio sao 0
    % procura pela primeira posicao vazia
    % acha posicao aleatoria vazia
    pc = find(board==0);
    pc = pc(randperm(length(pc)));
    pc = pc(1);

    % marca jogada do pc
    board(pc) = 2;

    row = (A(pc,2) + w/6);
    col = (A(pc,1) + h/6);

    if player == 'x'
        % plota O
        hold on
        viscircles([col row],20,'EdgeColor','red');
        hold off
        % hold on
        % t = 0:0.1:2*pi;
        % x = cos(t)/2+0.5;
        % y = sin(t)/2+0.5;
        % plot(x+col, y+row)
        % hold off
    else
        % plota X
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
% retorna a 1 se o 'Jogador' venceu
%           2 se o 'Computador' venceu
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
    % velha
    elseif ~ismember(board, 0)
        result = 0;
    % se eh apenas uma jogada comum
    else
        result = -1;
    end
end

% verifica quem venceu e printa na tela
function [] = checkWin(result)
    if (result == 0)
        warndlg('Ninguém ganhou!')
    elseif result == 1
        warndlg('O Jogador Ganhou')
    elseif result == 2
        warndlg('O Computador Ganhou')
    else
        warndlg('Ocorreu algum erro')
    end
end