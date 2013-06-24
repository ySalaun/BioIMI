% ----- %
% MAIN  %
% ----- %

%% USER PATHS
% Marie
% addpath(genpath('C:\Users\Marie\Documents\GitHub\BioIMI\Matlab'));
% path_dcm='C:\Users\Marie\Documents\GitHub\017 BA - 000112377//';

% Yohann
addpath(genpath('C:/Users/Yohann/Documents/GitHub/BioIMI/Matlab'));
path_dcm='C:/Users/Yohann/Documents/GitHub/BioIMI_Data/017 BA - 000112377//';

% Raphael
% addpath(genpath('/home/raphal/Documents/2A/Projet_IMI/BioIMI/Matlab'));
% path_dcm='/home/raphal/Documents/2A/Projet_IMI/DB/017 BA - 000112377//';

%% PARAMETERS

% Algorithm parameters -> cf main_function

%% DISPLAY PART


% displaying modes
gui_on = 0;
display_on = 0;

if gui_on
    global Y_RT;
    global Y_GC;
    global Y_orig;
    global Y_proba;
    global Y_proba_denoised;
    global c;
    global Vec;
    global R;
    
    GUI;
else
    % add the corresponding path :
    path_scan='CT - 20121226 - Studydescription/1/';
    pathrt='RTSTRUCT - 20121226 - Studydescription/2/IM34463.dcm';
    
    % load images from 480 to 500 (there is a nodule around 495)
    [X,info]=read_dicom(140:1:170,strcat(path_dcm,path_scan));
    rt_info=dicominfo(strcat(path_dcm,pathrt));
    
    % Selection of a nodule area
    rect=[280 340 70 70];
    
    % Main algorithm
    [Y_orig,Y_RT,Y_proba,Y_proba_denoised,Y_GC,c,Vec,R]=main_function(X,rect,info,rt_info);
    
end
%% RESULTS

% ellipsoid
vtheta = 0:0.01:3.14*2;
Xcenter=c(1) + R(2)*cos(vtheta);
Ycenter=c(2) + R(3)*sin(vtheta);


if(display_on)
    hold on;
    colormap('gray');
    imagesc(imadjust(Y_orig(:,:,10)));
    plot(Ycenter, Xcenter);
    hold off; 
    
    % Draw images
    
    slice=10;
    figure;
    
    subplot(2,3,1);
    imshow(imadjust(Y_orig(:,:,slice)));
    title('Image originale');
    
    subplot(2,3,2);
    imshow(Y_proba(:,:,slice));
    title('Probabilites');
    
    subplot(2,3,3);
    imshow(Y_proba_denoised(:,:,slice));
    title('Filtrage grossier');
    
    subplot(2,3,4);
    imshow(Y_GC(:,:,slice));
    title('Segmentation finale');
    
    subplot(2,3,5);
    imshow(Y_RT(:,:,slice));
    title('Segmentation RT (expert)');
    
    subplot(2,3,6);
    imshow(Y_GC(:,:,slice)==Y_RT(:,:,slice));
    title('Erreur');
    
    
    % error ratio between expert and this method

    ratio=sum(sum(sum(Y_GC(:,:,slice)==Y_RT(:,:,slice))))/sum(sum(sum(Y_RT(:,:,slice))));
    disp('The ratio between our result and expert one is : ',ratio);
    
    
    
    % draw PCA ellipsoid
    siz=size(Y_orig);
    PCA_ellipsoid = generate_ellipsoid(siz, c, Vec, R, [1 0], [0 0]);
    M = Is_in (PCA_ellipsoid, 0.5);
    hold on;
    scatter3(M(:,1),M(:,2),M(:,3));
    hold off;

    % draw proba ellipsoid
    M = Is_in (Y_proba, 0.5);
    hold on;
    scatter3(M(:,1),M(:,2),M(:,3));
    hold off;

    % draw denoised proba ellipsoid
    M = Is_in (Y_proba_denoised, 0.3);
    hold on;
    scatter3(M(:,1),M(:,2),M(:,3));
    hold off;

    % draw enhanced proba ellipsoid
    M = Is_in (Y_proba_enhanced, 0.5);
    hold on;
    scatter3(M(:,1),M(:,2),M(:,3));
    hold off;
    
    % draw expert segmentation
    M = Is_in (Y_RT, 0.5);
    hold on;
    scatter3(M(:,1),M(:,2),M(:,3));
    hold off;

    % display final nodule
    M = Is_in (nodule, 0.5);
    hold on;
    scatter3(M(:,1),M(:,2),M(:,3));
    hold off;
    
    % draw difference between the two segmentations
    diff = diffMaps(nodule, 1, Y_RT, 0.5);
    M = Is_in (diff, 0.5);
    hold on;
    scatter3(M(:,1),M(:,2),M(:,3));
    hold off;
end

