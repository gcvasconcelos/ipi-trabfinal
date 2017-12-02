clear all
close all

%inicia variaveis jogo
board = zeros(3, 3);

img = imread('melhorx.jpg');
img = rgb2gray(img);

[h,w] = size(img);
%Quadrantes = [1 1; ]
% boardX = round([w*3/8,w*5/8])
% boardY = round([h*3/8,h*5/8])
% A = [boardX(1) h*1/8;boardX(1) h*7/8;boardX(2) h*7/8;boardX(2) h*1/8;w*1/8 boardY(1);w*7/8 boardY(1);w*1/8 boardY(2);w*7/8,boardY(2)];

A = [1 1; 1 w/3; 1 2*w/3;...
    h/3 1; h/3 w/3; h/3 2*w/3;...
    2*h/3 1; 2*h/3 w/3; 2*h/3 2*h/3];

% B1 = imcrop(img, [A(1,2) A(1,1) w/3 h/3]);
% B2 = imcrop(img, [A(2,2) A(2,1) w/3 h/3]);
% B3 = imcrop(img, [A(3,2) A(3,1) w/3 h/3]);
% imshow(B1)
% figure, imshow(B2)
% figure, imshow(B3)
    
% if player==1
%     playermark='X';
% elseif player==2
%     playerrmark='O';
% end

%player
player = 'o';


%le 1 frame
%detecta localizacao dos retangulos
%detecta posicao da jogada do player
%detecta simbolo utilizado
%while ninguem ganha ou acaba os espaços
%player = simbolo_identificado;
%joga em posicao aleatora
%end while

campo_livre = find(~board);
for i = 1:length(campo_livre)
    indice = campo_livre(i);
    quadrante =imcrop(img, [A(indice,2) A(indice,1) w/3 h/3]);
    LOC = encontra_jogada(quadrante, player);
    if ~isempty(LOC)
        break
    end
end    
board(i) = 1;
figure, imshow(img)
hold on
plot(LOC(1),LOC(2),'x','LineWidth',2,'Color','blue');
hold off

%jogada do computador
%pc = randperm(find(~board));
pc = find(~board);
pc = pc(1);%marca jogada do player

board(pc) = 2;%marca jogada do pc

x = (A(pc,2) + (A(pc,2)/2));
y = (A(pc,1) + w/6);

if player == 'x'
    hold on
    viscircles([x y],30,'EdgeColor','b');
    hold off
else
    hold on
    plot(LOC(1),LOC(2),'x','LineWidth',50,'Color','red');
    hold off
 end


function LOC = encontra_jogada(I, player)
    if player == 'x'
        T = imread('X_rots.jpg');
        T = rgb2gray(T);
        H = vision.TemplateMatcher;
        LOC = step(H,I,T);
    else
        [LOC, raddi] = imfindcircles(I, [15 30]);
    end
end



