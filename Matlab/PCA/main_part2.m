s = [100 100 100];
c = [50 50 50];
X1 = [0 1 1];
X2 = [0 1 -1];
X3 = [1 0 0];
X = [X1/sqrt(sum(X1.*X1)) ; X2/sqrt(sum(X2.*X2)) ; X3/sqrt(sum(X3.*X3))];
R = [2 10 30];
m = [0.65 0.2];
sigma = [0.35 0.2];
E = generate_ellipsoid (s, c, X, R, m, sigma);
M = Is_in(E);
% scatter3(M(:,1),M(:,2),M(:,3));
[Vect, Val] = pca(M,3)
Val=sqrt(Val)