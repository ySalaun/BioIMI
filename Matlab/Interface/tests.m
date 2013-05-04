X=read_dicom(1:10);

vpar=[5 1 1 1;20 1 2 1];
Y=convolution_gabor(X,vpar);

siz=size(Y);

A=reshape(Y,siz(1)*siz(2)*siz(3),siz(4));

Z=classification_acp(Y);
ZI=reshape(Z,siz(1),siz(2),1,siz(3));

display_scans(ZI);