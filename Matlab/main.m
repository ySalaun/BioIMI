% ----- %
% main  %
% ----- %

%% PARAMETERS
lambda = 0.5;                               % smoothness coefficient

% sans interface graphique


% ajoute les différents dossier du projet :à adapter
% je vous conseille quand même d'utiliser ce patient pour l'instant
% avec les paramètres qui suivent vous aurez un beau nodule :)

%% Marie
addpath(genpath('C:\Users\Marie\Documents\GitHub\BioIMI\Matlab'));
path_dcm='C:\Users\Marie\Documents\GitHub\017 BA - 000112377//';


%% Yohann
% addpath(genpath('C:/Users/Yohann/Documents/GitHub/BioIMI/Matlab'));
% path_dcm='C:/Users/Yohann/Documents/GitHub/BioIMI_Data/017 BA - 000112377//';

%% Raphael
% addpath(genpath('/home/raphal/Documents/2A/Projet_IMI/BioIMI/Matlab'));
% path_dcm='/home/raphal/Documents/2A/Projet_IMI/DB/017 BA - 000112377//';

path_scan='CT - 20121226 - Studydescription/1/';
pathrt='RTSTRUCT - 20121226 - Studydescription/2/IM34463.dcm';

% dossier de lecture des images 
% chargement des images de 480 à 500 (y a un nodule vers 495)
% /!\ j'ai l'impression que les images sont numérotées à l'envers d'où :
[X,info]=read_dicom(140:1:170,strcat(path_dcm,path_scan));

% paramètres des filtres de gabor (la taille du noyau et définie dans
% convolution_gabor
vpar=[5 1 1 1;20 1 2 1;1.5 0 1 0;1 1 0 0];

% application des filtres à l'image 3D X (l*h*1*p ou l*h*p) on peut donc
% sélectionner manuellement la zone qui nous intéresse X(1:10,:,:)
% on ne garde que les parties de la convolution totalement déterminées 
% -> taille réduite
% la position du nodule est environ 382,313, prévoir un peu de marge
% /!\ inverser X et Y
Yg=convolution_gabor(X(280:340,350:410,:),vpar);

% classement par ACP
% Z est donc la matrice 3D de proba qui vous intéresse
Z=classification_acp(Yg);

% affichage : le deuxieme parametre vaut 1 quand on egalise le contraste
display_scans(Z,1);
display_scans(X,0);

% Comparaison
% apparement ça ne marche pas, faut vérifier entre autre l'orientation des
% axes. Et je ne suis pas très sur de la définition de ImagePositionPatient

Y1=squeeze(X(:,:,1,1));
rt=dicominfo(strcat(path_dcm,pathrt));
figure;
hold on;
imagesc(Y1);
colormap('gray');
axis image;
[ContourData,ImagePosition,PixelSpacing,SliceThickness]=add_RT(info,rt);
hold off;

% Calcul des parametres, ATTENTION probl�me si l'ellipsoide a un rayon de 1

[ct,Xt,Rt] = parametres(Z); % Parametres approches par la PCA
[c, R, Vec] = Hough_transform(Z,ct,Rt,Xt); % Pr�cision avec hough transform

%% GRAPH CUT

% compile cpp file
mex GC/GC.cpp

% execute mex file
I = X(280:340,350:410,:);                   % crop of picture
[label_map] = GC(I, Z, [c' Vec' R'], lambda);

l0 = label(label_map, 0);
hold on;
scatter3(l0(:,1),l0(:,2),l0(:,3));
hold off;

