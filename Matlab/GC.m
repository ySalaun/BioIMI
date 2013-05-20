%% Graph cut part

%% LOAD PARAMETERS
generated_input = true;

if generated_input
	% size of the 3D picture
	n = 40;
	s = [n n n];
	% center of the ellipsoid
	c = [n/2 n/2 n/2];
	% axis directions
	X1 = [1 0 0];
	X2 = [0 0 1];
	X3 = [0 1 0];
	X = [X1/sqrt(sum(X1.*X1)) ; X2/sqrt(sum(X2.*X2)) ; X3/sqrt(sum(X3.*X3))];
	% axis rays
	R = [5 8 15];
	% law inside and outside
	m = [0.7 0.3];
	sigma = [0.3 0.3];

	% generate ellipsoid
	ellipsoid = generate_ellipsoid(s, c, X, R, m, sigma);
    
    m_color = [45 123];
    sigma = [45 60];
    
    % generate ellipsoid
	I = generate_ellipsoid(s, c, X, R, m, sigma);
end

% display ellipsoid
M = Is_in (ellipsoid);
hold on;
scatter3(M(:,1),M(:,2),M(:,3));
hold off;



%% GRAPH CUT

% compile cpp file
mex GC/GC.cpp

% execute mex file
[label_map] = GC(I, ellipsoid, [c' X' R'], 0);

l0 = label(label_map, 0);
hold on;
scatter3(l0(:,1),l0(:,2),l0(:,3));
hold off;

l0 = diffMaps(label_map, 0, ellipsoid, 0.5);
hold on;
scatter3(l0(:,1),l0(:,2),l0(:,3));
hold off;