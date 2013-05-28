function [ContoursData,ImagePosition,PixelSpacing,SliceThickness]=add_RT(dcm_info,rt_info)
% récupère des informations sur les images afin d'appeler plot_contour par
%       exemple
% dcm_info,rt_info : informations sur les images (dicominfo)


ImagePosition=dcm_info.ImagePositionPatient;
SliceThickness=dcm_info.SliceThickness;
PixelSpacing=dcm_info.PixelSpacing;
if (PixelSpacing(1) ~= PixelSpacing(2))
    disp('Warning : échelle non orthonormée, cas non géré');
end
PixelSpacing=PixelSpacing(1);

% ajoute le polygone définie par ContourData sur la figure courante
% ContourData tableau de cell de [3*k x 1] vecteur colonne (x1,y1,z1,x2,y2,...) en mm
%       chaque vecteur contient un contour que l'on suppose horizontal
% z0 coupe à selectionner 
% ImagePosition coordonnée du pixel(0,0,0), on suppose l'orientation BIPED
% PixelSpacing distance entre 2 centres de pixels adjacents (mm)
% SliceThickness épaisseur des coupes (mm)


% boucle sur les nodules
ContoursData=rt_info.ROIContourSequence;
nodules=fieldnames(ContoursData);
Ln=length(nodules);
for in=1:Ln
    NoduleData=ContoursData.(nodules{in}).ContourSequence;
    
    % boucle sur les différents contour d'un nodule
    fields=fieldnames(NoduleData);
    Lc=length(fields);
    for ic=1:Lc
        CD=NoduleData.(fields{ic}).ContourData;
        z1=-1*(CD(3)-ImagePosition(3))/SliceThickness;% hauteur du contour en pixels  
        if (abs(z1)<2)
            disp(z1);
            % Création des vecteurs de coordonnées : x, y
            x=(CD(1:3:end)-ImagePosition(1))/PixelSpacing;
            y=(CD(2:3:end)-ImagePosition(2))/PixelSpacing;
            %z=(ContourData(3:3:end)-ImagePosition(3))/SliceThickness;
            %f=find(abs(z-z0)<1)
            plot(x,y);
        end;
    end
end

end