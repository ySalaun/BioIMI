function [ M ] = Is_in( E, seuil )
% Compute the vector of points in the nodule from the matrix of probabilities 
[m,n,p]=size(E);
M=zeros(m*n*p,3);
t=1;

for i=1:size(E,1)
    for j=1:size(E,2)
        for k=1:size(E,3)
            if E(i,j,k)>seuil
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

