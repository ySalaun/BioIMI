function [Y_orig,Y_RT,Y_proba,Y_proba_denoised,Y_gc,c,Vec,R]=main_function(X,rect,info,rt_info)

%% PARAMETERS

lambda = 0.5;        % smoothness coefficient
% gabor filters parameters
% sigma,a,b,c : "cos(ax+by+cz)exp(-x^2/sigma^2)"
vpar_gabor=[
        1 0 0 0;
        2 0 0 0;
        2 2 0 0;
        2 0 2 0; 
        2 0 0 2  ]; 
%vpar_gabor=[5 1 1 1;20 1 2 1; 1.5 0 1 0;1 1 0 0]; 
    
sgabor= 3; % size of gabor kernel 
seuil = 0.2; % threshold on image of probabilities

%% PREPROCESSING

% Selected image
Y_orig=squeeze(X(rect(1)+sgabor:rect(1)+rect(3)-1-sgabor,rect(2)+sgabor:rect(2)+rect(4)-1-sgabor,1+sgabor:end-sgabor));
siz=size(Y_orig);

% Proba Image
Yg=convolution_gabor(X(rect(1):rect(1)+rect(3)-1,rect(2):rect(2)+rect(4)-1,:),vpar_gabor);
Y_proba=classification_acp(Yg);

% Denoising
Masq=Masque(Y_proba);
Y_proba_denoised=Y_proba;
for p=1:siz(3)
    Y_proba_denoised(:,:,p)=Y_proba(:,:,p).*Masq;
end


%% ESTIMATION OF ELLIPSOID PARAMETERS

% Parameters estimation using PCA
[c,Vec,R] = parametres(Y_proba_denoised, seuil);

% Refinement by Hough transform
%[c, R, Vec] = Hough_transform(Z,c,R,Vec,seuil)


%% GRAPH CUT PART
% compile cpp file if needed
compile = 0;
if(compile)
    mex GC/GC.cpp
end

% enhance probability map
Y_proba_enhanced = Y_proba_denoised/max(max(max(Y_proba_denoised)));

% execute mex file, final ellipsoide
[label_map] = GC(double(Y_orig), double(Y_proba_enhanced), [c' Vec' R'], 0.5);
Y_gc = label(label_map, 0);


%% Segmentation using RT-ROI
contours=add_RT(info,rt_info);
Xin_contours=fill_contour(contours,size(X));
Y_RT=Xin_contours(rect(1)+sgabor:rect(1)+rect(3)-1-sgabor,rect(2)+sgabor:rect(2)+rect(4)-1-sgabor,1+sgabor:end-sgabor);

