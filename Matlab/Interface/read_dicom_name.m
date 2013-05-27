function [Y,info]=read_dicom_name(FileName,PathName)

% voir read_dicom
% lit à partir des noms de fichiers cell 1*n dans le dossier pathPath


nfiles=length(FileName);

if nfiles>0

% initialisation de l'image 3D
% si on a n images de taille l*h on a un tableau lxhx1xn

namefile=strcat(PathName,FileName{1,1});
in = dicominfo(namefile);

width=in.Width;
height=in.Height;

Y=int16(zeros(width,height,1,nfiles));
info=[];

% boucle principale
for i=1:nfiles
    namefile=strcat(PathName,FileName{1,i});
    disp(FileName{1,i});
    in = dicominfo(namefile);
    info=[info,in];
    Y(:,:,1,i) = dicomread(in);
end


end
end
