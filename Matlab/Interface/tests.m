
% ajoute les différents dossier du projet
addpath(genpath('/home/raphal/Documents/2A/Projet_IMI/BioIMI/Matlab'));

path_dcm='/home/raphal/Documents/2A/Projet_IMI/DB/015 CC - 002672308/';
path_scan='CT - 20121205 - Studydescription/3/';
pathrt='RTSTRUCT - 20121205 - Studydescription/4/IM34463.dcm';

% dossier de lecture des images 
[X,info]=read_dicom(240:1:270,strcat(path_dcm,path_scan));

% paramètres des filtres de gabor (la taille du noyau et définie dans
% convolution_gabor
vpar=[5 1 1 1;20 1 2 1;1.5 0 1 0;1 1 0 0];
% application des filtres à l'image 3D X (l*h*1*p ou l*h*p) on peut donc
% sélectionner manuellement la zone qui nous intéresse X(1:10,:,:)
% on ne garde que les parties de la convolution totalement déterminées 
% -> taille réduite
Yg=convolution_gabor(X,vpar);

% classement par ACP
Z=classification_acp(Yg);

display_scans(Z,1);% le deuxieme parametre vaut 1 quand on egalise le contraste
display_scans(X,0);


% Comparaison
Y1=squeeze(X(:,:,1,1));
rt=dicominfo(strcat(path_dcm,pathrt));
figure;
hold on;
imagesc(Y1)
colormap('gray')
axis image
[ContourData,ImagePosition,PixelSpacing,SliceThickness]=add_RT(info(1),rt,240);
hold off;

% apparement ça ne marche pas, faut vérifier entre autre l'orientation des
% axes. Et je ne suis pas très sur de la définition de ImagePositionPatient
