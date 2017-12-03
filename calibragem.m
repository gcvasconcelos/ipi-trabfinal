clear all
close all


cam = webcam;
preview(cam);
for i = 1:10
    
    pause;
    frame = getSnapshot(cam);
    %frame = imbinarize(frame);
    %coners
    corners = detectHarrisFeatures(frame);
    x_c = floor(abs(corners.Location(:,2)));
    y_c = floor(abs(corners.Location(:,1)));
    board = frame(min(x_c):max(x_c),min(y_c):max(y_c));
    board = imresize(board, [200, 200]);
    %mostra
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