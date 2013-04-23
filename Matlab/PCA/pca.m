function [ Vectors,Values ] = pca(A,nb_vec)

% pca compute the principal component analysis.

% A is a matrix of size : dimension x sample size
% nb_vec is the number of representative caracteristics
% Values is the vector of size nb_vec with the major eigenvalues
% Vectors is the matrix of size nb_vec x dimension whose column correspond to the major eigenvector 

% Compute the "average" vector

Mean = mean(A);

for i = 1:size(A,1)
    A(i,:) = A(i,:) - Mean;
end;

% Get the eigenvectors (columns of Vectors) and eigenvalues (diag of
% Values) then sort them according to size of eigenvalue

[Vectors,Values]=eig(A'*A) ;

val = max(Values); % raw vector with eigenvalues
[sort_val, i] = sort(val,'descend'); % sorted eigenvalues and indices
Values = sort_val;
Vectors = Vectors(:,i); % sort the eigenvector according to the indices from sort

% Get only the nb_vec major Values and Vectors

if size(Values)~= nb_vec
    Values = Values(1:nb_vec);
    Vectors = Vectors(:,1:nb_vec);
end;