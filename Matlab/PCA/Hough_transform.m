function [ c, R, Vec] = Hough_transform( I, c_pca, R_pca, Vec_pca )
% Application of the hough transform to get the precise elements of the
% ellipsoïde : size of axis R and directions Vec
% I is the image of probabilities to be in the nodule
% c_pca is the center of the ellipsoïde determined by the pca
% R_pca is the R^3 vector of the size of the axis 
% Vec_pca is the matrix 3x3 which lines are the vector of the axis 

s=size(I);
Int1=max(1,ceil(c_pca(1)-1.5*R_pca(1))):min(s(1),ceil(c_pca(1)+1.5*R_pca(1)));
Int2=max(1,ceil(c_pca(2)-1.5*R_pca(2))):min(s(2),ceil(c_pca(2)+1.5*R_pca(2)));
Int3=max(1,ceil(c_pca(3)-1.5*R_pca(3))):min(s(3),ceil(c_pca(3)+1.5*R_pca(3)));

taille=size(Int1,2)*size(Int2,2)*size(Int3,2)

X=zeros(3,3);
R=zeros(1,3);

% Only 9 variables : center, axis 1, then two coordonates of axis 2 and the ray of axis 3
x0_var=0;%-2:1:2;
y0_var=0;%-2:1:2;
z0_var=0;%-2:1:2;
x1_var=0;%-1:1:1;
y1_var=0;%-1:1:1;
z1_var=0;%-1:1:1;
x2_var=0;%-1:1:1;
y2_var=0;%-1:1:1;
r3_var=-0.4:0.2:0.4;%-2:1:2;

efficiency=0;

for i=Int1
    for j=Int2
        for k=Int3
            % voxel coordinates
            voxel = [i j k];
            % compute the efficacity of the model
            d = 0;
            for l=1:3
                d = d + (sum( (voxel-c_pca).*Vec_pca(l,:) )/R_pca(l) )^2;
            end
            if (d<=1) % si le voxel est dans l'ellipse testée
                efficiency=efficiency+I(i,j,k)-1/2;
            end
        end
    end
end

efficiency_max=efficiency; 
coeff_opt=[c_pca R_pca' Vec_pca(1,:) Vec_pca(2,:) Vec_pca(3,:)];

for v1=1:size(x0_var,2)
    for v2=1:size(y0_var,2)
        for v3=1:size(z0_var,2)
            for v4=1:size(x1_var,2)
                for v5=1:size(y1_var,2)
                    for v6=1:size(z1_var,2)
                        for v7=1:size(x2_var,2)
                            for v8=1:size(y2_var,2)
                                for v9=1:size(r3_var,2)
    
    efficiency = 0;
                              
    c=c_pca+[x0_var(v1) y0_var(v2) z0_var(v3)];
    
    % faire varier les vecteurs tout en gardant l'orthogonalité des axes
    
    X(1,:)=Vec_pca(1,:)*R_pca(1)+[x1_var(v4) y1_var(v5) z1_var(v6)];
     
    
    if (X(1,3)~=0)
        X(2,:)=Vec_pca(2,:)*R_pca(2)+[x2_var(v7) y2_var(v8) 0];
        X(2,3)=(X(1,1)*X(2,1)+X(1,2)*X(2,2))/(-X(1,3));
    elseif (X(1,2)~=0)
        X(2,:)=Vec_pca(2,:)*R_pca(2)+[x2_var(v7) 0 y2_var(v7)];
        X(2,2)=-X(1,1)*X(2,1)/X(1,2);
    elseif (X(1,1)~=0)
        X(2,1)=0;
        X(2,2:3)=Vec_pca(2,2:3)*R_pca(2)+[x2_var(v7) y2_var(v8)];
    else
        efficiency=-Inf; % supprimer le cas X1 vecteur nul
    end
    
     
    
    if (sum(X(2,:)==0)==3) % supprimer le cas X2 vecteur nul
        efficiency=-Inf;
    else
        X(3,:)=cross(X(1,:),X(2,:)); % produit vectoriel
        X(3,:)=[X(3,1)/sqrt(sum(X(3,1).*X(3,1)))  X(3,2)/sqrt(sum(X(3,2).*X(3,2)))  X(3,3)/sqrt(sum(X(3,3).*X(3,3)))];
        
        X(3,:)=X(3,:)*(R(3)+r3_var(v9));
        if (sum(X(3,:)==0)==3)
          efficiency=-Inf; % supprimer le cas X3 vecteur nul
        end
    end
     
%     A=[[X(2,2) X(2,3)];[X(1,2) X(1,3)]]
%     b=[-X(3,1)*X(2,1);-X(3,1)*X(1,1)]
%     sol =A\b
%     if ( sum(sol<=Inf )==2 && efficiency~=-Inf ) %supprimer les cas NaN et double Inf de non résolution
%         compte=compte+1;
%         if (sol(1)<Inf)
%             X(3,2)=sol(1);
%         end
%         if (sol(2)<Inf)
%             X(3,3)=sol(2);
%         end
%     else
%         efficiency=-Inf;
%         X
%     end
%     


%      if ((X(1,3)*X(2,2)-X(2,3)*X(1,2))~=0)
%          X(3,1)=Vec_pca(3,1)*R_pca(3)+x3_var(v9);
%          X(3,3)=X(3,1)*(X(2,1)*X(1,2)-X(1,1)*X(2,2))/(X(1,3)*X(2,2)-X(2,3)*X(1,2));
%          if (X(2,2)~=0)
%              X(3,2)=-(X(3,1)*X(2,1)+X(3,3)*X(2,3))/X(2,2);
%         else
%              if (X(3,1)*X(2,1)+X(3,3)*X(2,3)==0)
%              else
%                  efficiency=-Inf;
%              end
%         end
%      end
%      
%     end


%     if (X(2,2)~=0 && (X(1,3)*X(2,2)-X(2,3)*X(1,2))~=0)
%         
%         X(3,:)=Vec_pca(3,:)*R_pca(3)+[x3_var(v9) 0 0];
%         X(3,3)=X(3,1)*(X(2,1)*X(1,2)-X(1,1)*X(2,2))/(X(1,3)*X(2,2)-X(2,3)*X(1,2));
%         X(3,2)=-(X(3,1)*X(2,1)+X(3,3)*X(2,3))/X(2,2);
%     
%     elseif ( (X(1,3)*X(2,2)-X(2,3)*X(1,2))==0 && (X(2,1)*X(1,2)-X(1,1)*X(2,2))==0 && X(2,2)~=0 )
%         X(3,:)=Vec_pca(3,:)*R_pca(3)+[x3_var(v9) 0 x3_var(v9)];
%         X(3,2)= -(X(3,1)*X(2,1)+X(3,3)*X(2,3))/X(2,2);
%     elseif ( (X(1,3)*X(2,2)-X(2,3)*X(1,2))==0 && X(2,2)~=0 ) 
%         X(3,:)=Vec_pca(3,:)*R_pca(3)+[0 0 x3_var(v9)];
%         X(3,1)=0;
%         X(3,2)= -(X(3,1)*X(2,1)+X(3,3)*X(2,3))/X(2,2);
%     elseif  (X(2,2)==0 && X(2,3)~=0)
%         X(3,:)=Vec_pca(3,:)*R_pca(3)+[x3_var(v9) x3_var(v9) 0];
%         X(3,3)=-X(3,1)*X(2,1)/X(2,3);
%     end

    %test1 = sum(X(1,:).*X(2,:)) % vérifer l'orthogonalité
    %test2 = sum(X(1,:).*X(3,:))
    %test3 = sum(X(3,:).*X(2,:))
    
    if (efficiency~=-Inf)
    
    R(1)=sqrt( sum( X(1,:).*X(1,:) ) )
    R(2)=sqrt( sum( X(2,:).*X(2,:) ) )
    R(3)=sqrt( sum( X(3,:).*X(3,:) ) )
    
    X(1,:)=X(1,:)/R(1);
    X(2,:)=X(2,:)/R(2);
    X(3,:)=X(3,:)/R(3);

for i=Int1
    for j=Int2
        for k=Int3
            % voxel coordinates
            voxel = [i j k];
            % compute the efficacity of the model
            d = 0;
            for l=1:3
                d = d + (sum( (voxel-c).*X(l,:) )/R(l) )^2;
                if (sum(voxel==c_pca)==3)
                    testD1=sum( (voxel-c).*X(l,:) )
                    testD2=X(l,:)
                    testD3=voxel                   
                end
            end
            if (d<=1) % si le voxel est dans l'ellipse testée
                efficiency=efficiency+I(i,j,k)-1/2;
            end
        end
    end
end

if ( efficiency>efficiency_max )
        coord=[v1 v2 v3 v4 v5 v6 v7 v8 v9]
        efficiency_max=efficiency;
        coeff_opt = [ c R X(1,:) X(2,:) X(3,:) ]; 
end

    end % if efficiency~=-Inf
                                end
                            end 
                        end
                    end
                end
            end
        end
    end
end

test=efficiency_max
c = coeff_opt(1:3);
R = coeff_opt(4:6);
Vec = [coeff_opt(7:9);coeff_opt(10:12);coeff_opt(13:15)];
end

