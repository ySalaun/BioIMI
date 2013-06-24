function [efficiency_max coeff_opt]= optimum (M,IResized,eff_max,coef_opt,c,R,X,threshold)

    volume=sum(sum (sum(M)));

    efficiency=sum(sum(sum(M.*IResized)))-threshold*volume;
    
    if ( efficiency>eff_max )
        efficiency_max=efficiency;
        coeff_opt = [ c R X(1,:) X(2,:) X(3,:) ];
    else 
        efficiency_max=eff_max;
        coeff_opt=coef_opt;
    end