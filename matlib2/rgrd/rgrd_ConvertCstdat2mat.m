function ConvertCstdat2mat(datfile,matfile)
% function ConvertCstdat2mat(datfile,matfile)
%  Convert a coastline file in from .dat to .mat
%  E. Di Lorenzo

data=load(datfile);
lon=data(:,1);
lat=data(:,2);
save(matfile,'lon','lat');

