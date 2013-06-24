function[M] = Matrix (Int1,Int2,Int3,c,X,R)

M = zeros(size(Int1,2),size(Int2,2),size(Int3,2));

for i=Int1
    for j=Int2
        for k=Int3
            % voxel coordinates
            voxel = [i j k];
            % compute the efficiency of the model
            d = 0;
            for l=1:3
                d = d + (sum( (voxel-c).*X(l,:) )/R(l) )^2;
            end
            if (d<=1) % if the voxel is in the ellipsoide
                M(i-Int1(1)+1,j-Int2(1)+1,k-Int3(1)+1)=1;
            end
        end
    end
end