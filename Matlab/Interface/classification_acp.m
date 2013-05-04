function Y=classification_acp(I)

% I image l-2r*h-2r*p-2r*n : vecteurs de taille n associé à chaque pixel
% pour l'instant sépare en 2 parties.
% Y image l-2r*h-2r*p-2r

siz=size(I);
It=reshape(I,siz(1)*siz(2)*siz(3),siz(4));
[ Vectors,Values,Mean ] = pca(It,1);

It=sum((It*Vectors),2); % (lhp*n) * (n,1)
siz(4)=1;
Y=reshape(It,siz);

end