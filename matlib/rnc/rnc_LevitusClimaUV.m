function  levitus = rnc_LevitusClimaUV(grd,clmfile,levitus);
% Compute levitus climatology for grid specified in grd.
% If updateClima == 1 then write and interpolate the climatology
% into the clmfile.

    
    z_r=rnt_setdepth(0,grd);

file = which('LevitusUVP_monthly.nc');
nc = netcdf(file);
lon=nc{'lon'}(:)';
lat=nc{'lat'}(:)';
z=nc{'z'}(:);

% nw sw se ne
corn.lon = [grd.lonr(1,end) grd.lonr(1,1) grd.lonr(end,1) grd.lonr(end,end)]';
corn.lat = [grd.latr(1,end) grd.latr(1,1) grd.latr(end,1) grd.latr(end,end)]';

% extract Southern California Region
  j=find ( squeeze(lon(1,:)) > min(corn.lon)-2 & squeeze(lon(1,:)) < max(corn.lon)+2);
  i=find ( squeeze(lat(:,1)) > min(corn.lat)-2 & squeeze(lat(:,1)) < max(corn.lat)+2);

  lon=lon(i,j);
  lat=lat(i,j);
  % use only 31 levels ..below that not much data
  ugeo=permute(nc{'ugeo'}(j,i,1:31,:),[2 1 3 4]);
  vgeo=permute(nc{'vgeo'}(j,i,1:31,:),[2 1 3 4]);
  z=z(1:31);
  close(nc);
 
 
    for it=1:12
    	disp(['  -- time level ',num2str(it)]);   
    for k=1:length(z)
	disp(['  -- vert level ',num2str(k)]);   
        ugeo(:,:,k,it)=rnt_fill(lon,lat,ugeo(:,:,k,it),3,3);
	  vgeo(:,:,k,it)=rnt_fill(lon,lat,vgeo(:,:,k,it),3,3);
     end
     end
     
     z(end+1)=7000;
     ugeo(:,:,end+1,:)=ugeo(:,:,end,:);
     vgeo(:,:,end+1,:)=vgeo(:,:,end,:);   
     
     levitus.lon=lon;
     levitus.lat=lat;
     levitus.ugeo=ugeo;
     levitus.vgeo=vgeo;
     levitus.z=z;
     

if updateClima ==1

   nc=netcdf(clmfile,'w');
    for it=1:12
    	disp(['  -- time level ',num2str(it)]);   
    for k=1:length(z)	
        ugeogr(:,:,k)=interp2(lon,lat,ugeo(:,:,k,it),grd.lonr,grd.latr,'cubic');
        vgeogr(:,:,k)=interp2(lon,lat,vgeo(:,:,k,it),grd.lonr,grd.latr,'cubic');
     end
     disp ('Updating ...');
     tmp=rnt_2s(ugeogr,z_r,z);
     nc{'ugeo'}(it,:,:,:) = permute(tmp,[3 2 1 ]);
     tmp=rnt_2s(vgeogr,z_r,z);
     nc{'vgeo'}(it,:,:,:) = permute(tmp,[3 2 1 ]);
     
     end
end     
     
     
   
   
