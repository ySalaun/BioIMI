% ----- %
% main  %
% ----- %

%% PARAMETERS
lambda = 0.5;                               % smoothness coefficient
vpar_gabor=[5 1 1 1; % paramètres des filtres de gabor
    20 1 2 1;    % a,b,c,sigma : "cos(ax+by+cz)exp(-x^2/sigma^2)"
    1.5 0 1 0;
    1 1 0 0];

seuil=0.2;


% sans interface graphique (pour l'interface gui;)

% affichage graphique
display_on = 0;

% ajoute les différents dossier du projet :à adapter
% je vous conseille quand même d'utiliser ce patient pour l'instant
% avec les paramètres qui suivent vous aurez un beau nodule :)

%% Marie
% addpath(genpath('C:\Users\Marie\Documents\GitHub\BioIMI\Matlab'));
% path_dcm='C:\Users\Marie\Documents\GitHub\017 BA - 000112377//';


%% Yohann
%addpath(genpath('C:/Users/Yohann/Documents/GitHub/BioIMI/Matlab'));
%path_dcm='C:/Users/Yohann/Documents/GitHub/BioIMI_Data/017 BA - 000112377//';

%% Raphael
addpath(genpath('/home/raphal/Documents/2A/Projet_IMI/BioIMI/Matlab'));
path_dcm='/home/raphal/Documents/2A/Projet_IMI/DB/017 BA - 000112377//';

path_scan='CT - 20121226 - Studydescription/1/';
pathrt='RTSTRUCT - 20121226 - Studydescription/2/IM34463.dcm';

% dossier de lecture des images
% chargement des images de 480 à 500 (y a un nodule vers 495)
% /!\ j'ai l'impression que les images sont numérotées à l'envers d'où :
[X,info]=read_dicom(140:1:170,strcat(path_dcm,path_scan));


% application des filtres à l'image 3D X (l*h*1*p ou l*h*p) on peut donc
% sélectionner manuellement la zone qui nous intéresse X(1:10,:,:)
% on ne garde que les parties de la convolution totalement déterminées
% -> taille réduite
% la position du nodule est environ 382,313, prévoir un peu de marge
% /!\ inverser X et Y
Yg=convolution_gabor(X(280:340,350:410,:),vpar_gabor);

% classement par ACP
% Z est donc la matrice 3D de proba qui vous intéresse
Z=classification_acp(Yg);

Masq=Masque(Z);

% debruitage
Zm=Z;
for p=1:size(Z,3)
    Zm(:,:,p)=Z(:,:,p).*Masq;
end

% Comparaison
% apparement ça ne marche pas, faut vérifier entre autre l'orientation des
% axes. Et je ne suis pas très sur de la définition de ImagePositionPatient

rt=dicominfo(strcat(path_dcm,pathrt));
[contours]=add_RT(info,rt);

Xin_contours=fill_contour(contours,size(X));


%% Resultats premiere partie
Y_orig=squeeze(X(280+3:340-3,350+3:410-3,1,4:end-3));
Y_RT=Xin_contours(280+3:340-3,350+3:410-3,4:end-3);
Y_proba=Z;
Y_proba_denoised=Zm;

imshow(imadjust(Y_orig(:,:,10)));
figure;
imshow(Y_RT(:,:,10));
figure;
imshow(Y_proba(:,:,10));

%% Calcul des parametres, ATTENTION probleme si l'ellipsoide a un rayon de 1

[ct,Xt,Rt] = parametres(Zm, seuil) % Parametres approches par la PCA
R=Rt;
c=ct;
Vec=Xt;

%[c, R, Vec] = Hough_transform(Z,ct,Rt,Xt,seuil) % Precision avec hough transform



%affichage pour cet exemple en particulier de l'ellipse 
vtheta = 0:0.01:3.14*2;
Xcenter=ct(1) + R(2)*cos(vtheta);
Ycenter=ct(2) + R(3)*sin(vtheta);

hold on;
colormap('gray');
imagesc(imadjust(Y_orig(:,:,10)));
plot(Ycenter, Xcenter);
hold off;

%% GRAPH CUT

% compile cpp file
mex GC/GC.cpp

% parameters for cropped picture
siz=size(Y_orig);
Zm=Y_proba_denoised;
Ztest = Zm/max(max(max(Zm))); % min(2*(Zm>0.3).*Zm,1) + Zm;

% execute mex file, final ellipsoide
[label_map] = GC(double(I), double(Ztest), [c' Vec' R'], 0.5);
l0 = label(label_map, 0);


%% DISPLAY RESULTS

% Draw images
imshow(imadjust(Y_orig(:,:,10)));
figure;
imshow(Y_RT(:,:,10));
figure;
imshow(Y_proba(:,:,10));


% draw PCA ellipsoid
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

% draw test proba ellipsoid
M = Is_in (Ztest, 0.5);
hold on;
scatter3(M(:,1),M(:,2),M(:,3));
hold off;

% display final ellipsoid
hold on;
scatter3(l0(:,1),l0(:,2),l0(:,3));
hold off;

