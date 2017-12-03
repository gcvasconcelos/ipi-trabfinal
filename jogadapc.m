clear 
clc

board = zeros(3,3);
board(8) = 1;

free_spaces = find(board==0);
i = randi(length(free_spaces));
play = free_spaces(i);

board(play) = 2;
board