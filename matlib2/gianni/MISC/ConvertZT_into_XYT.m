function fout=ConvertZT_into_XYT(f,mask);
%% Convert a (Z,T) field to a (X,Y,T) field, Z has dimension of X*Y;
%  


[I,J]=size(mask);
[Z,T]=size(f);

in=find(isnan( mask(:) ) == 0);
fout=zeros(I,J,T);
fout=reshape(fout,[I*J,T]);
fout(in,:)=f;
fout=reshape(fout,[I, J, T]);
