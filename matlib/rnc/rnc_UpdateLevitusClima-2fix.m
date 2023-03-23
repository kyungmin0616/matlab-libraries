
function  rnc_UpdateLevitusClima(grd,clmfile,levitus);
% 
% Write and interpolate the Levitus climatology
% into the clmfile.
   % initialize storage arrays    
    [I,J]=size(grd.lonr);
    K=length(z);
    tempZ=zeros(I,J,K,12);
    saltZ=zeros(I,J,K,12);
 
%==========================================================
%	do interpolation    LEVITUS on model grid
%==========================================================
[F,Ipos,Jpos]=rnt_griddata(levitus.lon,levitus.lat,   levitus.temp(:,:,1,1) , ...
                                  grd.lonr,   grd.latr,  'cubic');

for it=1:12
disp(['  -- time level ',num2str(it)]);
for k=1:length(levitus.z)
disp(['  --                 - vert level ',num2str(k)]);
% -----------------------------------------------------------------

      tempZ(:,:,k,it)=rnt_griddata(levitus.lon,levitus.lat,levitus.temp(:,:,k,it), ...
               grd.lonr,grd.latr,'cubic',Ipos,Jpos);	

      saltZ(:,:,k,it)=rnt_griddata(levitus.lon,levitus.lat,levitus.salt(:,:,k,it), ...
               grd.lonr,grd.latr,'cubic',Ipos,Jpos);	

% -----------------------------------------------------------------
end
end


    z=levitus.z;
    z(end+1)=7000;
    tempZ(:,:,end+1,:)=tempZ(:,:,end,:);
    saltZ(:,:,end+1,:)=saltZ(:,:,end,:);
    
  

    z_r=rnt_setdepth(0,grd);
    
    nc=netcdf(clmfile,'w');
    for it=1:12
      disp (['Z --> S  time lev ...',num2str(it)]);
      tmp=rnt_2s( tempZ(:,:,:,it) ,z_r,z);
      nc{'temp'}(it,:,:,:) = permute(tmp,[3 2 1 ]);
      tmp=rnt_2s( saltZ(:,:,:,it) ,z_r,z);
      nc{'salt'}(it,:,:,:) = permute(tmp,[3 2 1 ]);
      
    end
    close(nc)
    
  
  
  

