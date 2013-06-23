%% Graph cut part

%% LOAD PARAMETERS
generated_input = true;

if generated_input
	% size of the 3D picture
	n = 40;
	s = [n n n];
	% center of the ellipsoid
	c = [n/2 n/2 n/2];
    c = [34.4766   30.8156   10.8640];
	% axis directions
	X1 = [1 0 0];
	X2 = [0 0 1];
	X3 = [0 1 0];
	X = [X1/sqrt(sum(X1.*X1)) ; X2/sqrt(sum(X2.*X2)) ; X3/sqrt(sum(X3.*X3))];
    X = [ 0.0717   -0.1028   -0.9921 ;  0.9650    0.2589    0.0429 ; -0.2524    0.9604   -0.1177 ];
	% axis rays
	R = [5 8 15];
    R = [12.1924    6.8147    5.4075];
    % law inside and outside
	m = [0.7 0.3];
	sigma = [0.3 0.3];

	% generate proba_ellipsoid
	ellipsoid = generate_ellipsoid(s, c, X, R, m, sigma);
    
    m_color = [45 123];
    sigma_color = [0 0];
    
    % generate color_ellipsoid
	I = generate_ellipsoid(s, c, X, R, m_color, sigma_color);
    
    % generate true_ellipsoid
    m = [1 0];
	sigma = [0 0];
    true_ellipsoid = generate_ellipsoid(s, c, X, R, m, sigma);
end

% display ellipsoid
M = Is_in (ellipsoid, 0.5);
hold on;
scatter3(M(:,1),M(:,2),M(:,3));
hold off;



%% GRAPH CUT

% compile cpp file
mex GC/GC.cpp

for lambda = 0:0.1:1

% execute mex file
[label_map] = GC(I, ellipsoid, [c' X' R'], lambda);

l0 = label(label_map, 0);
hold on;
scatter3(l0(:,1),l0(:,2),l0(:,3));
hold off;

l0 = diffMaps(label_map, 0, true_ellipsoid, 0.5);
hold on;
scatter3(l0(:,1),l0(:,2),l0(:,3));
hold off;

lambda
ratio = sum(sum(sum(l0==1)))/sum(sum(sum(true_ellipsoid)))*100

end