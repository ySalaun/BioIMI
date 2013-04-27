function [Vectors,Values,Psi] = pca_prof(A,numvecs)

% pca - compute the principal component analysis.
%
%   [Y,X1,v] = pca(X,numvecs)
%
%   X is a matrix of size dimension x sample size.
%   X1 is the matrix of size numvect x sample size (projection on the numvect first eigenvectors)
%	Y the matrix  of size dimension x numvect of numvect first eigenvector of the covariance matrix A*A'
%	v is the vector of size numvecs of eigenvalues of the cov matrix.
%
%   Copyright (c) 2005 Gabriel Peyr
%   Updated by Arnak Dalalyan 2011



% Check arguments

if nargin ~= 2
    error('usage: [Vectors,Values,Psi] = pca(A,numvecs)');
end;


nexamp = size(A,2);

% Now compute the eigenvectors of the covariance matrix

% Compute the "average" vector
% mean(A) gives you a row vector containing the mean of each column of A

% fprintf(1,'Computing average vector and vector differences from avg...\n');
Psi = mean(A')';

% Compute difference with average for each vector

for i = 1:nexamp
    A(:,i) = A(:,i) - Psi;
end;

% Get the eigenvectors (columns of Vectors) and eigenvalues (diag of Values)

% fprintf(1,'Calculating eigenvectors of L...\n');
if size(A,1)>size(A,2)
    [Vectors,Values,V]=svd(A,0);
    Values=Values.^2;
else
    [Vectors,Values]=eig(A*A');
end


% Sort the vectors/values according to size of eigenvalue

% fprintf(1,'Sorting evectors/values...\n');
[Vectors,Values] = sortem(Vectors,Values);

% Get the eigenvalues out of the diagonal matrix 

Values = diag(Values);

Vectors = Vectors(:,1:numvecs);

At = (Vectors')*A;



    function [vectors values] = sortem(vectors, values)

        %this error message is directly from Matthew Dailey's sortem.m
        if nargin ~= 2
            error('Must specify vector matrix and diag value matrix')
        end;

        vals = max(values); %create a row vector containing only the eigenvalues
        [svals inds] = sort(vals,'descend'); %sort the row vector and get the indicies
        vectors = vectors(:,inds); %sort the vectors according to the indicies from sort
        values = max(values(:,inds)); %sort the eigenvalues according to the indicies from sort
        values = diag(values); %place the values into a diagonal matrix

 
 