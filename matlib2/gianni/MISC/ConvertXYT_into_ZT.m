function fout=ConvertXYT_into_ZT(f,mask);
%% Convert a (X,Y,T) field to a (Z,T) field, where Z has dimension of X*Y; 
%  
[I,J,T]=size(f);
 f=f.*repmat(mask,[ 1 1 T]);
 f=reshape(f,[I*J,T]);
 in=find(isnan(f(:,1)) == 0);
 fout=f(in,:);

