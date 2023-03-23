function  levitus = rnc_UpdateLevitusClimaUV(grd,clmfile,levitus);
% Compute levitus climatology for grid specified in grd.
% If updateClima == 1 then write and interpolate the climatology
% into the clmfile.

    
   z_r=rnt_setdepth(0,grd);
   z=levitus.z;
   lon=levitus.lon;
   lat=levitus.lat;
   
   nc=netcdf(clmfile,'w');
    for it=1:12
    	disp(['  -- time level ',num2str(it)]);   
    for k=1:length(z)
    
        ugeo=levitus.ugeo(:,:,k,it);
	  vgeo=levitus.vgeo(:,:,k,it);
	  [ugeo,vgeo]=rnt_rotate(ugeo,vgeo,grd.angle);
	  	
        ugeogr(:,:,k)=interp2(lon',lat',ugeo(:,:)',grd.lonu,grd.latu,'cubic');
        vgeogr(:,:,k)=interp2(lon',lat',vgeo(:,:)',grd.lonv,grd.latv,'cubic');
     end
     disp ('Updating ...');
     tmp=rnt_2s(ugeogr,z_r,z);
     nc{'ugeo'}(it,:,:,:) = permute(tmp,[3 2 1 ]);
     tmp=rnt_2s(vgeogr,z_r,z);
     nc{'vgeo'}(it,:,:,:) = permute(tmp,[3 2 1 ]);
     
     end
     
    close(nc); 
   
   
