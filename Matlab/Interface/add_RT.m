function [ContourData,ImagePosition,PixelSpacing,SliceThickness]=add_RT(dcm_info,rt_info,z0)
% récupère des informations sur les images afin d'appeler plot_contour par
%       exemple
% dcm_info,rt_info : informations sur les images (dicominfo)

ContourData=rt_info.ROIContourSequence.Item_1.ContourSequence;
ImagePosition=dcm_info.ImagePositionPatient;
PixelSpacing=dcm_info.PixelSpacing;
if (PixelSpacing(1) ~= PixelSpacing(2))
    disp('Warning : échelle non orthonormée, cas non géré');
end
PixelSpacing=PixelSpacing(1);
SliceThickness=dcm_info.SliceThickness;

% ajoute le polygone définie par ContourData sur la figure courante
% ContourData tableau de cell de [3*k x 1] vecteur colonne (x1,y1,z1,x2,y2,...) en mm
%       chaque vecteur contient un contour que l'on suppose horizontal
% z0 coupe à selectionner 
% ImagePosition coordonnée du pixel(0,0,0), on suppose l'orientation BIPED
% PixelSpacing distance entre 2 centres de pixels adjacents (mm)
% SliceThickness épaisseur des coupes (mm)

fields=fieldnames(ContourData);
Lc=length(fields);

for ic=1:Lc
    CD=ContourData.(fields{ic}).ContourData;
    z1=-1*(CD(3)-ImagePosition(3))/SliceThickness;% hauteur du contour en pixels
    %disp(z1);   
    if (abs(z1-z0)<1)
        disp(z1);
        % Création des vecteurs de coordonnées : x, y
        x=(CD(1:3:end)-ImagePosition(1))/PixelSpacing;
        y=(CD(2:3:end)-ImagePosition(2))/PixelSpacing;
        %z=(ContourData(3:3:end)-ImagePosition(3))/SliceThickness;
        %f=find(abs(z-z0)<1)
        plot(512-x,512-y);
    end
end

end