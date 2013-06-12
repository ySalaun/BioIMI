function display_RT(X,contours)
% affiche la premiere tranche de X
% attention il faut que les infos ayant permis de générer contours
% correspondent
Y1=squeeze(X(:,:,1,1));
figure;
hold on;
imagesc(Y1);
colormap('gray');
axis image;

% boucle sur les nodules
Ln=length(contours);
for in=1:Ln
    NoduleData=contours{in};   
    % boucle sur les différents contour d'un nodule
    Lc=NoduleData;
    for ic=1:Lc
        [x y z]=NoduleData{ic};              
        if (abs(z(1))<2)
            disp(z(1));
            plot(x,y);
        end;
    end
end

hold off;

end