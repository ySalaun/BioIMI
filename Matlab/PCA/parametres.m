function [ c, X, R ] = parametres( E )
%Compute all the arguments of the ellipsoïde :
%   - R^3 vector c:     center of the ellipsoid
%   - M_{3x3} matrix X: the lines are directions of the ellipsoid
%   - R^3 vector R:     rays of the ellipsoid

%Compute the voxel in the nodule
M=Is_in ( E );
m=size(M,1);

% Compute the parameters c and X
[Vect, Val, Mean]= pca ( M, 3 );

Val= sqrt(Val);

c=Mean;

X=Vect';

% Compute the rays using : Volume=4/3*Pi*a*b*c= m 

R=zeros(3,1);

R(1,1)=nthroot(3.*m/(4*pi)*Val(1)/Val(3)*Val(1)/Val(2),3);
R(2,1)=R(1)*Val(2)/Val(1);
R(3,1)=R(1)*Val(3)/Val(1);

end

