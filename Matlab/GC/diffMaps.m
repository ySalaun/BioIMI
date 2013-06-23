function [ M ] = diffMaps( E, l, E2, l2 )
% Compute the difference between the resulting segmentation and another
% (not necessarily a segmentation)
M=zeros(size(E));

for i=1:size(E,1)
    for j=1:size(E,2)
        for k=1:size(E,3)
            if (E(i,j,k) == l && E2(i,j,k) < l2) || (E(i,j,k) ~= l && E2(i,j,k) >= l2)
                M(i,j,k) = 1;
            end
        end
    end
end

end
