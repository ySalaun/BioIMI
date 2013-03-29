function [ e ] = generate_ellipsoid( s, c, X, R, m, sigma)
% generate a matrix in M_{s[1] x s[2] x s[3]} containing an ellipsoid with parameters:
%   - R^3 vector c:     center of the ellipsoid
%   - M_{3x3} matrix X: directions of the ellipsoid
%   - R^3 vector R:     rays of the ellipsoid
% the probability of the voxels are randomly generated with mean m[1]]
% inside the ellipsoid and m[2] outside and standard deviation sigma[1]
% inside the ellipsoid and sigma[2] outside.
%
% How to generate parameters: (CTRL+T the next line and change the values
% s = [s1 s2 s3];
% c = [c1 c2 c3];
% X1 = [x11 x12 x13];
% X2 = [x21 x22 x23];
% X3 = [x31 x32 x33];
% X = [X1/sqrt(sum(X1.*X1)) ; X2/sqrt(sum(X2.*X2)) ; X3/sqrt(sum(X3.*X3))];
% R = [R1 R2 R3];
% m = [m1 m2];
% sigma = [sigma1 sigma2];

% quick test for size
for i=1:3
    if s(i) < 2*R(i) || s(i) < c(i) + R(i) || c(i) < R(i)
        disp('error, the ellispoid needs to be shorter than the whole picture')
    end
end

% generate whole picture with zeros
e = zeros(s(1), s(2), s(3));

% generate probabilities whether the voxel is inside or outside the
% ellipsoid
for i=1:s(1)
    for j=1:s(1)
        for k=1:s(1)
            % voxel coordinates
            voxel = [i j k];
            % compute if the voxel is inside the ellipsoid
            d = 0;
            for l=1:3
                d = d + sum((((voxel-c).*X(l,:))/R(l)).^2);
            end
            % if inside the ellipsoid
            if(d <= 1) 
                e(i,j,k) = m(1) + (2*rand(1)-1)*sigma(1);
            else
                e(i,j,k) = m(2) + (2*rand(1)-1)*sigma(2);
            end
        end
    end
end

end

