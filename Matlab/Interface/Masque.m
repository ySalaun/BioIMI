function YY=Masque(Y)
% création d'un masque
% l'idée de réduire les possibilités d'emplacement d'un nodule
% en décrivant l'évolution selon z.
% Y : image originale (l*h*z)
% YY: image binaire selon xy (l*h) 

siz=size(Y);

YY=zeros(siz(1),siz(2));
for xx=1:siz(1)
    for yy=1:siz(2)
        vec=squeeze(Y(xx,yy,:));
        coeff=polyfit(1:siz(3),vec',2);
        a=coeff(1);
        b=coeff(2);
        L=siz(3);
        if (a<0) && (b> (-2*a)) && (b< (-2*a*siz(3))) && (-1*a*L*L > 0.01) &&  (-1*a*L > 1*abs(b))  % maximum sur la plage
            YY(xx,yy)=1;
            %disp(a);
        end
    end
end

YY2=YY;

for xx=2:siz(1)-1
    for yy=2:siz(2)-1
        if (YY2(xx,yy)==1)
            if(YY2(xx-1,yy)==0 || YY2(xx+1,yy)==0 || YY2(xx,yy-1)==0 || YY2(xx,yy+1)==0)
                YY(xx,yy)=0;
            end        
        end
    end
end

end