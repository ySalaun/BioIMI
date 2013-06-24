function [ c, R, Vec] = Hough_transform( I, c_pca, R_pca, Vec_pca, seuil )
% Application of the hough transform to get the precise elements of the
% ellipsoïde : center (line), size of axis R (line), and directions Vec
% (lines normalized)
% I is the image of probabilities to be in the nodule
% c_pca is the center of the ellipsoï¿½de determined by the pca
% R_pca is the R^3 vector of the size of the axis 
% Vec_pca is the matrix 3x3 which lines are the vector of the axis 

%% Only 9 variables : center, axis 1, then two coordonates of axis 2 and the ray of axis 3

% axe 3 non normé : 3 variables pour direction et taille
x3_var=0;%-2:1:2;  % varier de 2 -> rayon varie de 3.4
y3_var=0;%-2:1:2;
z3_var=0;%-2:1:2;
% axe 2
x2_var=0;%-2:1:2;
y2_var=0;%-2:1:2;
% rayon 1 % mieux vaut faire varier au maximum l'axe le plus grand
r1_var=5; % on peut mettre une grande valeur car la variation s'arrête quand elle devient inutile
% centre
x0_var=0;
y0_var=0;
z0_var=0;
[dX,dY,dZ] = meshgrid(0:x0_var,0:y0_var,0:z0_var);

s=size(I);
Int1=max(1,ceil(c_pca(1)-x0_var-R_pca(1)-r1_var)):min(s(1),ceil(c_pca(1)+x0_var+R_pca(1)+r1_var));
Int2=max(1,ceil(c_pca(2)-y0_var-R_pca(2)-r1_var)):min(s(2),ceil(c_pca(2)+y0_var+R_pca(2)+r1_var));
Int3=max(1,ceil(c_pca(3)-z0_var-R_pca(3)-r1_var)):min(s(3),ceil(c_pca(3)+z0_var+R_pca(3)+r1_var));

IResized=I(Int1,Int2,Int3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Efficiency of pca
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

M = Matrix(Int1, Int2, Int3, c_pca, Vec_pca, R_pca);

volume=sum(sum (sum(M)));

efficiency=sum(sum(sum(M.*IResized)))-seuil*volume;

efficiency_max=efficiency; 
coeff_opt=[c_pca R_pca Vec_pca(1,:) Vec_pca(2,:) Vec_pca(3,:)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Other ellipsoides
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for v4=1:size(x3_var,2)
    for v5=1:size(y3_var,2)
        for v6=1:size(z3_var,2)
            for v7=1:size(x2_var,2)
                for v8=1:size(y2_var,2)
                    for r1=0:r1_var % variation croissante de r1 (stoppée si ça empire)
                  
    tic;
    % faire varier les vecteurs tout en gardant l'orthogonalitï¿½ des axes
    
    X(3,:)=Vec_pca(3,:)*R_pca(3)+[x3_var(v4) y3_var(v5) z3_var(v6)];
     
    
    if (X(3,3)~=0)
        X(2,:)=Vec_pca(2,:)*R_pca(2)+[x2_var(v7) y2_var(v8) 0];
        X(2,3)=(X(3,1)*X(2,1)+X(3,2)*X(2,2))/(-X(3,3));
    elseif (X(3,2)~=0)
        X(2,:)=Vec_pca(2,:)*R_pca(2)+[x2_var(v7) 0 y2_var(v7)];
        X(2,2)=-X(3,1)*X(2,1)/X(3,2);
    elseif (X(3,1)~=0)
        X(2,1)=0;
        X(2,2:3)=Vec_pca(2,2:3)*R_pca(2)+[x2_var(v7) y2_var(v8)];
    else
        efficiency=-Inf; % supprimer le cas x3 vecteur nul
    end
    
   
    if (sum(X(2,:)==0)==3) % supprimer le cas X2 vecteur nul
        efficiency=-Inf;
    else
        X(1,:)=cross(X(3,:),X(2,:)); % produit vectoriel
        X1n=sqrt(X(1,:)*X(1,:)');
        X(1,:)=X(1,:)/ X1n;
        X(1,:)=X(1,:)*(R_pca(1)+r1);
        if (sum(X(1,:)==0)==3)
          efficiency=-Inf; % supprimer le cas X1 vecteur nul
        end
    end
     
 
    if (efficiency~=-Inf)
    
    R(1)=sqrt( sum( X(1,:).*X(1,:) ) );
    R(2)=sqrt( sum( X(2,:).*X(2,:) ) );
    R(3)=sqrt( sum( X(3,:).*X(3,:) ) );
    
    X(1,:)=X(1,:)/R(1);
    X(2,:)=X(2,:)/R(2);
    X(3,:)=X(3,:)/R(3);
    
    c=c_pca;

M=Matrix(Int1, Int2, Int3, c, X, R);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loop on the center
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for v1p=1:(x0_var+1) % shifting of the center on x axis + 
    for v2p=1:(y0_var+1) % shifting of the center on y axis +
        for v3p=1:(z0_var+1) % shifting of the center on z axis +
        %+++
            c=c_pca+[v1p-1 v2p-1 v3p-1];
            M=circshift(M,[dY(v1p) dY(v2p) dY(v3p)]);
            [efficiency_max coeff_opt] = optimum (M,IResized,efficiency_max,coeff_opt,c,R,X,seuil);

        end % loop on z0 +

        for v3p=2:(z0_var+1) % shifting of the center on z axis -
        %++-
            c=c_pca+[v1p-1 v2p-1 -v3p+1];
            M=circshift(M,[dY(v1p) dY(v2p) -dY(v3p)]);
            [efficiency_max coeff_opt] = optimum (M,IResized,efficiency_max,coeff_opt,c,R,X,seuil);

        end % loop on z0 -
    end % loop on y0 +
    
    for v2p=2:(y0_var+1) % shifting of the center on y axis -
        for v3p=1:(z0_var+1) % shifting of the center on z axis +
        %+-+
            c=c_pca+[v1p-1 -v2p+1 v3p-1];
            M=circshift(M,[dY(v1p) -dY(v2p) dY(v3p)]);
            [efficiency_max coeff_opt] = optimum (M,IResized,efficiency_max,coeff_opt,c,R,X,seuil);

        end % loop on z0 +

        for v3m=2:(z0_var+1) % shifting of the center on z axis -
        %+--
            c=c_pca+[v1p-1 -v2p+1 -v3p+1];
            M=circshift(M,[dY(v1p) -dY(v2p) -dY(v3p)]);
            [efficiency_max coeff_opt] = optimum (M,IResized,efficiency_max,coeff_opt,c,R,X,seuil);
        
        end % loop on z0 -
    end % loop on y0 -    
end % loop on x0 +

for v1p=2:(x0_var+1) % shifting of the center on x axis -
    for v2p=1:(y0_var+1) % shifting of the center on y axis +
        for v3p=1:(z0_var+1) % shifting of the center on z axis +
        %-++   
            c=c_pca+[-v1p+1 v2p-1 v3p-1];
            M=circshift(M,[-dY(v1p) dY(v2p) dY(v3p)]);
            [efficiency_max coeff_opt] = optimum (M,IResized,efficiency_max,coeff_opt,c,R,X,seuil);

        end % loop on z0 +

        for v3m=2:(z0_var+1) % shifting of the center on z axis -
        %-+-
            c=c_pca+[-v1p+1 v2p-1 -v3p+1];
            M=circshift(M,[-dY(v1p) dY(v2p) -dY(v3p)]);
            [efficiency_max coeff_opt] = optimum (M,IResized,efficiency_max,coeff_opt,c,R,X,seuil);

        end % loop on z0 -
    end % loop on y0 +
    
    for v2p=2:(y0_var+1) % shifting of the center on y axis -
        for v3p=1:(z0_var+1) % shifting of the center on z axis +
        %--+
            c=c_pca+[-v1p+1 -v2p+1 v3p-1];
            M=circshift(M,[-dY(v1p) -dY(v2p) dY(v3p)]);
            [efficiency_max coeff_opt] = optimum (M,IResized,efficiency_max,coeff_opt,c,R,X,seuil);
        
        end % loop on z0 +

        for v3m=2:(z0_var+1) % shifting of the center on z axis -
        %---
            c=c_pca+[-v1p+1 -v2p+1 -v3p+1];
            M=circshift(M,[-dY(v1p) -dY(v2p) -dY(v3p)]);
            [efficiency_max coeff_opt] = optimum (M,IResized,efficiency_max,coeff_opt,c,R,X,seuil);
        end % loop on z0 -
    end % loop on y0 -    
end % loop on x0 -
    
    end
                    end
                    
                    for r1=-1:-1:-r1_var % variation décroissante de r1 (stoppée si ça empire)
    
    % faire varier les vecteurs tout en gardant l'orthogonalitï¿½ des axes
    
    X(3,:)=Vec_pca(3,:)*R_pca(3)+[x3_var(v4) y3_var(v5) z3_var(v6)];
     
    
    if (X(3,3)~=0)
        X(2,:)=Vec_pca(2,:)*R_pca(2)+[x2_var(v7) y2_var(v8) 0];
        X(2,3)=(X(3,1)*X(2,1)+X(3,2)*X(2,2))/(-X(3,3));
    elseif (X(3,2)~=0)
        X(2,:)=Vec_pca(2,:)*R_pca(2)+[x2_var(v7) 0 y2_var(v7)];
        X(2,2)=-X(3,1)*X(2,1)/X(3,2);
    elseif (X(3,1)~=0)
        X(2,1)=0;
        X(2,2:3)=Vec_pca(2,2:3)*R_pca(2)+[x2_var(v7) y2_var(v8)];
    else
        efficiency=-Inf; % supprimer le cas x3 vecteur nul
    end
    
   
    if (sum(X(2,:)==0)==3) % supprimer le cas X2 vecteur nul
        efficiency=-Inf;
    else
        X(1,:)=cross(X(3,:),X(2,:)); % produit vectoriel
        X1n=sqrt(X(1,:)*X(1,:)');
        X(1,:)=X(1,:)/ X1n;
        X(1,:)=X(1,:)*(R_pca(1)+r1);
        if (sum(X(1,:)==0)==3)
          efficiency=-Inf; % supprimer le cas X3 vecteur nul
        end
    end
     
 
    if (efficiency~=-Inf)
    
    R(1)=sqrt( sum( X(1,:).*X(1,:) ) );
    R(2)=sqrt( sum( X(2,:).*X(2,:) ) );
    R(3)=sqrt( sum( X(3,:).*X(3,:) ) );
    
    X(1,:)=X(1,:)/R(1);
    X(2,:)=X(2,:)/R(2);
    X(3,:)=X(3,:)/R(3);
    
    c=c_pca;

M=Matrix(Int1, Int2, Int3, c, X, R);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loop on the center
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for v1p=1:(x0_var+1) % shifting of the center on x axis + 
    for v2p=1:(y0_var+1) % shifting of the center on y axis +
        for v3p=1:(z0_var+1) % shifting of the center on z axis +
        %+++
            c=c_pca+[v1p-1 v2p-1 v3p-1];
            M=circshift(M,[dY(v1p) dY(v2p) dY(v3p)]);
            [efficiency_max coeff_opt] = optimum (M,IResized,efficiency_max,coeff_opt,c,R,X,seuil);

        end % loop on z0 +

        for v3p=2:(z0_var+1) % shifting of the center on z axis -
        %++-
            c=c_pca+[v1p-1 v2p-1 -v3p+1];
            M=circshift(M,[dY(v1p) dY(v2p) -dY(v3p)]);
            [efficiency_max coeff_opt] = optimum (M,IResized,efficiency_max,coeff_opt,c,R,X,seuil);

        end % loop on z0 -
    end % loop on y0 +
    
    for v2p=2:(y0_var+1) % shifting of the center on y axis -
        for v3p=1:(z0_var+1) % shifting of the center on z axis +
        %+-+
            c=c_pca+[v1p-1 -v2p+1 v3p-1];
            M=circshift(M,[dY(v1p) -dY(v2p) dY(v3p)]);
            [efficiency_max coeff_opt] = optimum (M,IResized,efficiency_max,coeff_opt,c,R,X,seuil);

        end % loop on z0 +

        for v3m=2:(z0_var+1) % shifting of the center on z axis -
        %+--
            c=c_pca+[v1p-1 -v2p+1 -v3p+1];
            M=circshift(M,[dY(v1p) -dY(v2p) -dY(v3p)]);
            [efficiency_max coeff_opt] = optimum (M,IResized,efficiency_max,coeff_opt,c,R,X,seuil);
        
        end % loop on z0 -
    end % loop on y0 -    
end % loop on x0 +

for v1p=2:(x0_var+1) % shifting of the center on x axis -
    for v2p=1:(y0_var+1) % shifting of the center on y axis +
        for v3p=1:(z0_var+1) % shifting of the center on z axis +
        %-++   
            c=c_pca+[-v1p+1 v2p-1 v3p-1];
            M=circshift(M,[-dY(v1p) dY(v2p) dY(v3p)]);
            [efficiency_max coeff_opt] = optimum (M,IResized,efficiency_max,coeff_opt,c,R,X,seuil);

        end % loop on z0 +

        for v3m=2:(z0_var+1) % shifting of the center on z axis -
        %-+-
            c=c_pca+[-v1p+1 v2p-1 -v3p+1];
            M=circshift(M,[-dY(v1p) dY(v2p) -dY(v3p)]);
            [efficiency_max coeff_opt] = optimum (M,IResized,efficiency_max,coeff_opt,c,R,X,seuil);

        end % loop on z0 -
    end % loop on y0 +
    
    for v2p=2:(y0_var+1) % shifting of the center on y axis -
        for v3p=1:(z0_var+1) % shifting of the center on z axis +
        %--+
            c=c_pca+[-v1p+1 -v2p+1 v3p-1];
            M=circshift(M,[-dY(v1p) -dY(v2p) dY(v3p)]);
            [efficiency_max coeff_opt] = optimum (M,IResized,efficiency_max,coeff_opt,c,R,X,seuil);
        
        end % loop on z0 +

        for v3m=2:(z0_var+1) % shifting of the center on z axis -
        %---
            c=c_pca+[-v1p+1 -v2p+1 -v3p+1];
            M=circshift(M,[-dY(v1p) -dY(v2p) -dY(v3p)]);
            [efficiency_max coeff_opt] = optimum (M,IResized,efficiency_max,coeff_opt,c,R,X,seuil);
    
        end % loop on z0 -
    end % loop on y0 -    
end % loop on x0 -

t=toc;

    end % endif efficiency~=-Inf
    
                    
                    end
                end
            end
        end
    end
end

c = coeff_opt(1:3);
R = coeff_opt(4:6);
Vec = [coeff_opt(7:9);coeff_opt(10:12);coeff_opt(13:15)];
end

