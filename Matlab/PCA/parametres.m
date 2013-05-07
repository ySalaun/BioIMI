function [ c, X, R ] = parametres( E )
%Compute all the arguments of the ellipsoïde :
%   - R^3 vector c:     center of the ellipsoid
%   - M_{3x3} matrix X: the lines are directions of the ellipsoid
%   - R^3 vector R:     rays of the ellipsoid

%Compute the voxel in the nodule
M=Is_in ( E );
m=size(M);

% Compute the parameters c and X
[Vect, Val, Mean]= pca ( M, 3 )

Val= sqrt(Val)

c=Mean;

X=Vect';

% Compute R using Val
max3 = 0;
for i=1:m
    % voxel coordinates
    voxel = M(i,:);
    % compute if the voxel is inside the ellipsoïde
    d3 = sum( ((voxel-c).*X(3,:)) );
    if (d3>max3)
        max3 = d3;
    end
end

R(1) = max3*Val(1)/Val(3);
R(2) = max3*Val(2)/Val(3);
R(3) = max3;

end

