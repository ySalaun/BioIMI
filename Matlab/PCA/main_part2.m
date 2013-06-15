seuil =0.5;
s = [100 100 100];
c = [50 50 30];
X1 = [1 1 0];
X2 = [-1 1 0];
X3 = [0 0 1];
X = [X1/sqrt(sum(X1.*X1)) ; X2/sqrt(sum(X2.*X2)) ; X3/sqrt(sum(X3.*X3))];
R = [30 10 2];
m = [0.7 0.3];
sigma = [0.3 0.2001];
%m = [1 0];
%sigma = [0 0];
E = generate_ellipsoid (s, c, X, R, m, sigma);
M = Is_in (E, seuil);
size (M,1)

[ct,Xt,Rt] = parametres(E, seuil)

%[c, R, Vec] = Hough_transform(E,ct,Rt,Xt,seuil)

%[x, y, z] = ellipsoid(ct(1),ct(2),ct(3),Rt(1),Rt(2),Rt(3),30);
%hMesh=mesh(x,y,z);
%rotate(hMesh,[0 0 1],45);
%xlabel('x');
%ylabel('y');
%zlabel('z');
%axis equal;
hold on;
scatter3(M(:,1),M(:,2),M(:,3));
hold off;
