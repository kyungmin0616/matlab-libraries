
function  rnc_UpdateLevitusClima(grd,clmfile,levitus);
% 
% Write and interpolate the Levitus climatology
% into the clmfile.

temp=levitus.temp;
salt=levitus.salt;
lon=levitus.lon;
lat=levitus.lat;
z=levitus.z;
    
    z_r=rnt_setdepth(0,grd);

  nc=netcdf(clmfile,'w');
    for it=1:12
    	disp(['  -- time level ',num2str(it)]);   
    for k=1:length(z)	
        tempgr(:,:,k)=interp2(lon',lat',temp(:,:,k,it)',grd.lonr,grd.latr,'cubic');
        saltgr(:,:,k)=interp2(lon',lat',salt(:,:,k,it)',grd.lonr,grd.latr,'cubic');
     end
     disp ('Updating ...');
     tmp=rnt_2s(tempgr,z_r,z);
     nc{'temp'}(it,:,:,:) = permute(tmp,[3 2 1 ]);
     tmp=rnt_2s(saltgr,z_r,z);
     nc{'salt'}(it,:,:,:) = permute(tmp,[3 2 1 ]);
     
     end
close(nc)
