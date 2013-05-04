function Y=convolution_gabor(I,vparametres)
% calcul la réponse obtenue en chaque point par l'application d'une série
% de filtre de Gabor à l'image 3D

% entrées : I image lxhx1xp, vparametres parametres des filtres n*4 (sur
% chaque ligne : sigma,a,b,c)

% sorties : J 'image' l-2rxh-2rxp-2rxn

rayon=2;

    function f=gabor(a,b,c,sigma,x,y,z)
        % evalue le filtre de Gabor centré de paramètres a,b,c,sigma au point (x,y,z)
        f=cos(a*x+b*y+c*z)*exp(-1*(x^2+y^2+z^2)/(2*sigma^2));
    end

    function f=filtre_gabor(a,b,c,sigma,s)
        % renvoie le noyau de convolution de taille 2s+1
        % pas d'utilisation de la parite
        f=zeros(2*s+1,2*s+1,2*s+1);
        f(s+1,s+1,s+1)=1;
        for ii=-s:s
            for jj=-s:s
                for kk=-s:s
                    f(s+1+ii,s+1+jj,s+1+kk)=gabor(a,b,c,sigma,ii,jj,kk);
                end
            end
        end
        
    end

n=size(vparametres,1);
I=squeeze(I); % supprime la dimension inutile
Y=zeros([size(I)-2*rayon,n]);
for i=1:n
    disp(['Iteration ',int2str(i)]);
    sigma=vparametres(i,1);
    a=vparametres(i,2);
    b=vparametres(i,3);
    c=vparametres(i,4);
    kern=filtre_gabor(a,b,c,sigma,rayon);
    % Convolution
    Y(:,:,:,i)=convn(I,kern,'valid');
end


end