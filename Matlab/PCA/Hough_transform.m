function [ R, Vec, c ] = Hough_transform( I, c_pca, R_pca, Vec_pca )
% Application of the hough transform to get the precise elements of the
% ellipsoïde : size of axis R and directions Vec
% I is the image of probabilities to be in the nodule
% c_pca is the center of the ellipsoïde determined by the pca
% R_pca is the R^3 vector of the size of the axis 
% Vec_pca is the matrix 3x3 which lines are the vector of the axis 

s=size(I);
X=zeros(3,3);
% Only 9 variables : center, axis 1, then two coordonates of axis 2 and one of axis 3
centre_var=zeros(3);
axis1_var=zeros(3);
axis2_var=zeros(2);
axis3_var=0;

rayon1_var=-5:1:5;
cout=zeros(1,size(rayon1_var,2));

X(:,1)=Vec_pca(:,1)*R_pca(1);
X(:,2)=Vec_pca(:,2)*R_pca(2);
X(:,3)=Vec_pca(:,3)*R_pca(3);

for v=1:size(rayon1_var,2)
    R=R_pca;
    R(1)=R_pca(1)+rayon1_var(1,v);
    X(1,:)=Vec_pca(1,:);

for i=1:s(1)
    for j=1:s(2)
        for k=1:s(3)
            % voxel coordinates
            voxel = [i j k];
            % compute the efficacity of the model
            d = 0;
            for l=1:3
                d = d + (sum( (voxel-c_pca).*X(l,:) )/R(l) )^2;%d = d + (sum( (voxel-c).*X(l,:) ) /R(l))^2;
            end
            if (d<=1)
               cout(1,v)=cout(1,v)+I(i,j,k)-1/2;
            end
        end
    end
end

end

cout
[Max IdMax]= max(cout,[],2)

R(1)=(R_pca(1)+rayon1_var(IdMax));

Vec=Vec_pca;

end

