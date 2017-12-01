close all 
clear all
clc

obj = videoinput("v4l2", "/dev/video0");
set(obj, "VideoFormat", "RGB3")

% preview(obj);

%while 1
  input("Aperte qualquer tecla  para capturar o frame.");
  start(obj)
  img = getsnapshot(obj);
  stop(obj)
  %figure, imshow(img);
%end

img_mod = rgb2gray(img);

corners = detectHarrisFeatures(img_mod);
[features, valid_corners] = extractFeatures(img_mod, corners);

figure; imshow(img_mod); hold on

plot(valid_corners);