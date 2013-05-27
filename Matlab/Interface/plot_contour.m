function plot_contour(ContourData,z0,ImagePosition,PixelSpacing,SliceThickness)
% ajoute le polygone définie par ContourData sur la figure courante
% ContourData tableau de cell de [3*k x 1] vecteur colonne (x1,y1,z1,x2,y2,...) en mm
%       chaque vecteur contient un contour que l'on suppose horizontal
% z0 coupe à selectionner 
% ImagePosition coordonnée du pixel(0,0,0)
% PixelSpacing distance entre 2 centres de pixels adjacents (mm)
% SliceThickness épaisseur des coupes (mm)

fields=fieldnames(ContourData);
Lc=length(fields);

for ic=1:Lc
    CD=ContourData.(fields{ic}).ContourData;
    z1=(CD(3)-ImagePosition(3))/SliceThickness;% hauteur du contour en pixels
    if (abs(z1-z0)<1)
        % Création des vecteurs de coordonnées : x, y
        x=(ContourData(1:3:end)-ImagePosition(1))/PixelSpacing;
        y=(ContourData(2:3:end)-ImagePosition(2))/PixelSpacing;
        %z=(ContourData(3:3:end)-ImagePosition(3))/SliceThickness;
        %f=find(abs(z-z0)<1)
        pdepoly(x,y);
    end
end

end
