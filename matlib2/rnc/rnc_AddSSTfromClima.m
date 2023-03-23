function AddSSTfromClima(clmfile,forcfile)
% Takes the surface T from clmfile and puts it into forcfile.
% It also takes the time. Assumes forc and clim Temperature have
% same length of time index


nc1=netcdf(clmfile);
nc2=netcdf(forcfile,'w');

nc2{'sst_time'}(:)=nc1{'tclm_time'}(:);
disp('Assigning SST ... in forcing file');
nc2{'SST'}(:,:,:)=squeeze(nc1{'temp'}(:,end,:,:));
close(nc2); close(nc1);
disp(' DONE.');
