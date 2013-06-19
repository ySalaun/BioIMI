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
addpath(genpath('C:/Users/Yohann/Documents/GitHub/BioIMI/Matlab'));
path_dcm='C:/Users/Yohann/Documents/GitHub/BioIMI_Data/017 BA - 000112377//';

%% Raphael
% addpath(genpath('/home/raphal/Documents/2A/Projet_IMI/BioIMI/Matlab'));
% path_dcm='/home/raphal/Documents/2A/Projet_IMI/DB/017 BA - 000112377//';

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
Yg=convolution_gabor(X(280:340,350:409,:),vpar_gabor);

% classement par ACP
% Z est donc la matrice 3D de proba qui vous intéresse
Z=classification_acp(Yg);
TestSize=size(Z)

Masq=Masque(Z);

% debruitage
Zm=Z;
for p=1:size(Z,3)
    Zm(:,:,p)=Z(:,:,p).*Masq;
end

%imagesc(squeeze(Zm(:,30,:))); % permet de voir la tranche etudie par l'acp et HT

X1=squeeze(X(:,:,1,1));
Z1=squeeze(Z(:,31,:));

imagesc(Z1);

% affichage : le deuxieme parametre vaut 1 quand on egalise le contraste
if display_on
    display_scans(Z,1);
    display_scans(X,0);
    figure;
    imshow(Z1);
    figure;
    imshow(Masq);
end

% Comparaison
% apparement ça ne marche pas, faut vérifier entre autre l'orientation des
% axes. Et je ne suis pas très sur de la définition de ImagePositionPatient

rt=dicominfo(strcat(path_dcm,pathrt));
[contours]=add_RT(info,rt);

hold on
if display_on
    display_RT(X,contours);
end

%% Calcul des parametres, ATTENTION probleme si l'ellipsoide a un rayon de 1

[ct,Xt,Rt] = parametres(Zm, seuil) % Parametres approches par la PCA

[c, R, Vec] = Hough_transform(Z,ct,Rt,Xt,seuil) % Precision avec hough transform

%affichage pour cet exemple en particulier de l'ellipse 
colormap('gray');
vtheta = 0:0.01:3.14*2;
Xcenter=ct(1) + R(2)*cos(vtheta);
Ycenter=ct(2) + R(3)*sin(vtheta);
plot(Ycenter, Xcenter)

hold off

%% GRAPH CUT

% compile cpp file
mex GC/GC.cpp

% parameters for cropped picture
X1 = 280; X2 = 340;
Y1 = 350; Y2 = 410;
s = size(X);
Z1 = 0; Z2 = s(0);
I = X(X1+2:X2-2,Y1+2:Y2-2,Z1+2:Z2-2);

% draw PCA ellipsoid
PCA_ellipsoid = generate_ellipsoid(size(I), c, Vec, R, [1 0], [0 0]);
M = Is_in (PCA_ellipsoid, 0.5);
hold on;
scatter3(M(:,1),M(:,2),M(:,3));
hold off;

% draw proba ellipsoid
M = Is_in (Z, 0.5);
hold on;
scatter3(M(:,1),M(:,2),M(:,3));
hold off;

% draw denoised proba ellipsoid
M = Is_in (Zm, 0.3);
hold on;
scatter3(M(:,1),M(:,2),M(:,3));
hold off;

% draw test proba ellipsoid
Ztest = Zm/max(max(max(Zm))); min(2*(Zm>0.3).*Zm,1) + Zm;
M = Is_in (Ztest, 0.5);
hold on;
scatter3(M(:,1),M(:,2),M(:,3));
hold off;

% execute mex file
[label_map] = GC(double(I), double(Ztest), [c' Vec' R'], 0);

% display final ellipsoid
l0 = label(label_map, 0);
hold on;
scatter3(l0(:,1),l0(:,2),l0(:,3));
hold off;

