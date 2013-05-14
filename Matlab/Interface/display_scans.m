function display_scans(Y,equali)
%affichage image 3D std

% on ramène le contrast sur [0,255]

Y=squeeze(Y);
sizY=size(Y);

%on ajuste en 2d
yy=double(reshape(Y,sizY(1),sizY(2)*sizY(3)));

m=min(min(yy));
M=max(max(yy));

disp(['min ',int2str(m),' max ',int2str(M)]);

if M>m
yy=(yy-m)/(M-m);
end

%imhist(yy,64);
%imshow(yy);
%Y=imadjust(Y);

if equali==1
yy=histeq(yy);
end

yy=uint8(255*yy);

% on affiche avec les outils de la toolbox Image Processing
% usage : implay(Images W*H*1*n,FPS)
Y=reshape(yy,sizY(1),sizY(2),1,sizY(3));
implay(Y,10);
%montage(Y);

end