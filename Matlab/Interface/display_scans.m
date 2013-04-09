function display_scans(Y)
% on ramène le contrast sur [0,255]

m=min(min(min(Y)));
Y=(Y-m);


M=max(max(max(Y)));
M=M/255;
Y=Y/(M+1);
Y=uint8(Y);

% on affiche avec les outils de la toolbox Image Processing
% usage : implay(Images W*H*1*n,FPS)
implay(Y,10);
%montage(Y);

end