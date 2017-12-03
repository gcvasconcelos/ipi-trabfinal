function Bool = FindX(prevframe, frame, board)
    %Faz diferença entre frame
    diff = prevframe-frame;
    diff = im2bw(diff, 0.4);
    
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
    
    Bool = 0;
    
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
    %escreve no board
    board(board_y,board_x) = 1;
    
    Bool = 1;
    
end