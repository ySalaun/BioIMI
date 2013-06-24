function X=fill_contour(contours,siz)
% trace et rempli le contour le plus adapté (tq abs(z) ptt)
% lève un warning si il existe plusieurs nodules sur une même altitude
% renvoie une matrice binaire de taille siz (length siz = 3)

% contours{i}{j} : matrice n*3 correspondant aux points d'un contour
% siz = [lx ly lz] : taille de l'output (doit contenir les contours

% X matrice de taille siz binaire, 1 à l'intérieur

X=zeros(siz(1),siz(2),siz(4));
idx=0; % index du nodule selectionné
n=0;

% cherche le bon nodule
% boucle sur les nodules
Ln=length(contours);
for in=1:Ln
    NoduleData=contours{in};   
    % boucle sur les différents contour d'un nodule
    Lc=length(NoduleData);
    for ic=1:Lc
        v=NoduleData{ic}; % coord x,y,z des points du contours en colonne
        if (abs(v(1,3))<0.51)
            n=n+1;
            idx=in;
        end;
    end
end

if (n==0)
    disp('pas de nodule')
    return;
end
if (n>1)
    disp(n, ' nodules')
    return;
end
NoduleData=contours{idx};

Lc=length(NoduleData);
for ic=1:Lc
    v=round(NoduleData{ic}); % coord x,y,z des points du contours en colonne
    z=1-1*v(1,3);
    X(:,:,z)=poly2mask(v(:,1),v(:,2),siz(1),siz(2));
end

disp('nodule trouve, croissance de region effectuee')
end