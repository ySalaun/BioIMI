function [Y,info]=read_dicom(vk,path)

% Y=read_dicom(1:18) lit les images IM0001.dcm à IM0018.dcm dans dossier
% désigner par path
% si on a n images de taille l*h, Y est un tableau lxhx1xn
% pour afficher la kieme coupe : figure; imshow(Y(:,:,1,k)); imcontrast;
% pour tout afficher display_scans(Y);

% je vous laisse personnaliser la configuration du chemin d'accès aux images (ex ci dessous)
if nargin<2
    path=['/home/raphal/Documents/2A/Projet_IMI/DB/','0042 BS - 002469609/CT - 20111102 - Studydescription/1/'];
end


n=length(vk);

% convertit un entier en string de longueur 3
function st=int2str3(a)
    st=int2str(a);
    if a<100
        st=['0',st];
    end
    if a<10
        st=['0',st];
    end  
end

% initialisation de l'image 3D
% si on a n images de taille l*h on a un tableau lxhx1xn
namefile=['IM0',int2str3(vk(1)),'.dcm'];
in = dicominfo([path,namefile]);

width=in.Width;
height=in.Height;

Y=int16(zeros(width,height,1,n));
info=[];

% boucle principale
for i=1:n
    namefile=['IM0',int2str3(vk(i)),'.dcm']
    in = dicominfo([path,namefile]);
    info=[info,in];
    Y(:,:,1,i) = dicomread(in);
end


end
