function display_RT(contours)
% affiche les contours correspondants à z==0
% attention il faut que les infos ayant permis de générer contours
% correspondent

% boucle sur les nodules
Ln=length(contours);
for in=1:Ln
    NoduleData=contours{in};   
    % boucle sur les différents contour d'un nodule
    Lc=length(NoduleData);
    for ic=1:Lc
        v=NoduleData{ic}; % coord x,y,z des points du contours en colonne
        if (abs(v(1,3))<0.6)
            plot(v(:,1),v(:,2));
        end;
    end
end

end