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

minY=min(min(min(Y)));
maxY=max(max(max(Y)));
Y=(Y-minY)/(maxY-minY);


% création d'un masque
YY=zeros(siz(1),siz(2));
for xx=1:siz(1)
    for yy=1:siz(2)
        vec=squeeze(Y1(xx,yy,:));
        coeff=polyfit(1:siz(3),vec',2);
        a=coeff(1);
        b=coeff(2);
        L=siz(3);
        if (a<0) && (b> (-2*a)) && (b< (-2*a*siz(3))) && (-1*a*L*L > 0.01) &&  (-1*a*L > 1*abs(b))          % maximum sur la plage
            YY(xx,yy)=1;
            disp(a);
        end
    end
end
figure;
imagesc(YY);
end