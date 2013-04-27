s = [100 100 100];
c = [50 50 50];
X1 = [1 1 0];
X2 = [-1 1 0];
X3 = [0 0 1];
X = [X1/sqrt(sum(X1.*X1)) ; X2/sqrt(sum(X2.*X2)) ; X3/sqrt(sum(X3.*X3))];
R = [30 5 5];
m = [1 0];
sigma = [0 0];
E = generate_ellipsoid (s, c, X, R, m, sigma);
M = Is_in(E);

%[x, y, z] = ellipsoid(50,50,50,R(1),R(2),R(3),30);
%Mesh=mesh(x,y,z);
%rotate(hMesh,[0 0 1],45);
xlabel('x');
ylabel('y');
zlabel('z');
axis equal;
hold on;
scatter3(M(:,1),M(:,2),M(:,3));
hold off;
[Vect, Val, Mean] = pca(M,3);
Val=sqrt(Val)
Vect