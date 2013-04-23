function [ M ] = Is_in( E )
% Compute the vector of points in the nodule from the matrix of probabilities 

M=ones(1,3);

for i=1:size(E,1)
    for j=1:size(E,2)
        for k=1:size(E,3)
            if E(i,j,k)>=0.5
                M=[M;[i j k]];
            end
        end
    end
end

n=size(M,1);
M=M(2:n , :);

end

