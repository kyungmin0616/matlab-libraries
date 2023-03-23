

function SetBryFromClim(grd,clmfile,bryfile);


    in=netcdf(bryfile,'w');
    clim=netcdf(clmfile);        
    timeind=clim{'tclm_time'}(:);
%    timeind=clim{'ocean_time'}(:);
    in{'bry_time'}(:)=timeind;


    V={'temp' 'salt'  'u' 'v' 'zeta' 'ubar' 'vbar'};
    
    for ivar=1:4
     disp(V{ivar});
      in{[V{ivar},'_north']}(:,:,:)=clim{V{ivar}}(:,:,end,:);
      in{[V{ivar},'_south']}(:,:,:)=clim{V{ivar}}(:,:,1,:);
      in{[V{ivar},'_west']}(:,:,:)=clim{V{ivar}}(:,:,:,1);
      in{[V{ivar},'_east']}(:,:,:)=clim{V{ivar}}(:,:,:,end);		      
    end


    for ivar=5:7
     disp(V{ivar});
      in{[V{ivar},'_north']}(:,:,:)=clim{V{ivar}}(:,end,:);
      in{[V{ivar},'_south']}(:,:,:)=clim{V{ivar}}(:,1,:);
      in{[V{ivar},'_west']}(:,:,:)=clim{V{ivar}}(:,:,1);
      in{[V{ivar},'_east']}(:,:,:)=clim{V{ivar}}(:,:,end);		      
    end

bioclm={'phytoplankton' 'NO3' 'zooplankton' 'detritus'};
biovar={'phyt' 'NO3' 'zoop' 'detritus'};
    for ivar=1:4
     disp(bioclm{ivar});
      in{[biovar{ivar},'_north']}(:,:,:)=clim{bioclm{ivar}}(:,:,end,:);
      in{[biovar{ivar},'_south']}(:,:,:)=clim{bioclm{ivar}}(:,:,1,:);
      in{[biovar{ivar},'_west']}(:,:,:)=clim{bioclm{ivar}}(:,:,:,1);
      in{[biovar{ivar},'_east']}(:,:,:)=clim{bioclm{ivar}}(:,:,:,end);		      
    end



    
    close(in); close(clim);
