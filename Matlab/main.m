% size of the 3D picture
n = 50;
s = [n n n];
% center of the ellipsoid
c = [n/2 n/2 n/2];
% axis directions
X1 = [2 3 0];
X2 = [0 2 6];
X3 = [0 0 4];
X = [X1/sqrt(sum(X1.*X1)) ; X2/sqrt(sum(X2.*X2)) ; X3/sqrt(sum(X3.*X3))];
% axis rays
R = [7 8 9 ];
% law inside and outside
m = [0.65 0.2];
sigma = [0.35 0.2];

% generate ellipsoid
ellipsoid = generate_ellipsoid(s, c, X, R, m, sigma);
% display a slice of the ellipsoid
surf(ellipsoid(:,:,20));