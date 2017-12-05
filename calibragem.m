clear all
close all

%Arquivo utilizado para calibração da webcam
%Verificar se os harrisfeatures estao identificando de forma adequada
%o tabuleiro do jogo.

cam = webcam;
preview(cam);
for i = 1:10
    
    pause;
    frame = getSnapshot(cam);
    
    %coners
    corners = detectHarrisFeatures(frame);
    x_c = floor(abs(corners.Location(:,2)));
    y_c = floor(abs(corners.Location(:,1)));
    board = frame(min(x_c):max(x_c),min(y_c):max(y_c));
    board = imresize(board, [200, 200]);
    
    %mostra a imagem com os corner e a imagem apenas com o tabuleiro
    imshow(frame)
    hold on
    plot(corners.selectStrongest(50));
    hold off
    figure, imshow(board)
    
end

function tmp = getSnapshot(cam)
    tmp = snapshot(cam);
    tmp = rgb2gray(tmp);
    tmp = imresize(tmp, [200, 200]);
end