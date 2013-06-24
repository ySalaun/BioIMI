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

% sans interface graphique (pour l'interface GUI;)

% affichage graphiques
gui_on = 0;
display_on = 0;

if gui_on
    global Y_RT;
    global Y_GC;
    global Y_orig;
    global Y_proba; 
    GUI;
else
% ajoute les différents dossier du projet :
path_scan='CT - 20121226 - Studydescription/1/';
pathrt='RTSTRUCT - 20121226 - Studydescription/2/IM34463.dcm';

% dossier de lecture des images
% chargement des images de 480 à 500 (y a un nodule vers 495)
[X,info]=read_dicom(140:1:170,strcat(path_dcm,path_scan));
rt_info=dicominfo(strcat(path_dcm,pathrt));

% Selection of a nodule area
rect=[280 340 70 70];

% Main algorithm
[Y_orig,Y_RT,Y_proba,Y_proba_denoised,Y_GC]=main_function(X,rect,info,rt_info);

end
%% RESULTS

%affichage pour cet exemple en particulier de l'ellipse 
vtheta = 0:0.01:3.14*2;
Xcenter=ct(1) + R(2)*cos(vtheta);
Ycenter=ct(2) + R(3)*sin(vtheta);


if(display_on)
    hold on;
    colormap('gray');
    imagesc(imadjust(Y_orig(:,:,10)));
    plot(Ycenter, Xcenter);
    hold off; 
    
    % Draw images
    figure;
    imshow(imadjust(Y_orig(:,:,10)));
    figure;
    imshow(Y_RT(:,:,10));
    figure;
    imshow(Y_proba(:,:,10));

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

% error ratio between expert and this method
% the result is normalized with the expert nodule size
ratio = sum(sum(sum(diff==1)))/sum(sum(sum(Y_RT)))*100;
disp('The ratio between our result and expert one is : ',ration);
