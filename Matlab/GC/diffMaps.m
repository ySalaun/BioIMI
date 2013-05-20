function [ M ] = diffMaps( E, l, E2, l2 )
% Compute the vector of points in the nodule from the matrix of probabilities 
[m,n]=size(E);
M=zeros(m*n,3);
t=1;

for i=1:size(E,1)
    for j=1:size(E,2)
        for k=1:size(E,3)
            if (E(i,j,k) == l && E2(i,j,k) < l2) || (E(i,j,k) ~= l && E2(i,j,k) >= l2)
                M(t,1)=i;
                M(t,2)=j; 
                M(t,3)=k;
                t=t+1;
            end
        end
    end
end

M=M(1:(t-1) , :);

end
