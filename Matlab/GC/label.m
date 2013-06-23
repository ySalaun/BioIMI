function [ M ] = label( E, l )
% Compute the vector of points in the nodule from the matrix of probabilities 
M=zeros(size(E));

for i=1:size(E,1)
    for j=1:size(E,2)
        for k=1:size(E,3)
            if E(i,j,k) == l
                M(i,j,k) = 1;
            end
        end
    end
end
end
