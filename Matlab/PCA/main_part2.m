% Main who test the PCA and hough transform on ellipsoid generated

threshold =0.5;
s = [100 100 100];
c = [50 50 30];
X1 = [1 1 0];
X2 = [-1 1 0];
X3 = [0 0 1];
X = [X1/sqrt(sum(X1.*X1)) ; X2/sqrt(sum(X2.*X2)) ; X3/sqrt(sum(X3.*X3))];
R = [40 20 5];
m = [0.8 0.3];
sigma = [0.2 0.2001];
E = generate_ellipsoid (s, c, X, R, m, sigma);
M = Is_in (E, threshold);
size (M,1)

[ct,Xt,Rt] = parametres(E, threshold)

[c, R, Vec] = Hough_transform(E,ct,Rt,Xt,threshold)

%[x, y, z] = ellipsoid(c(1),c(2),c(3),R(1),R(2),R(3),30);
%hMesh=mesh(x,y,z);
%rotate(hMesh,[0 0 1],45);
%xlabel('x');
%ylabel('y');
%zlabel('z');
%axis equal;
hold on;
scatter3(M(:,1),M(:,2),M(:,3));
hold off;
