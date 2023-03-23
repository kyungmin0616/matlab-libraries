% transfer stuff from 1 grid to the other

function rgrd_SaveOBCfromFile(bryfile,clmfile,it);

  
                                                                                                            
     disp(['Assigning OBC = ',num2str(it)]);


    in=netcdf(bryfile,'w');
    clim=netcdf(clmfile);
%    timeind=clim{'tclm_time'}(:);
    timeind=clim{'ocean_time'}(1);
    in{'bry_time'}(it)=timeind;


    V={'temp' 'salt'  'u' 'v' 'zeta' 'ubar' 'vbar'};

    for ivar=1:4
     disp(V{ivar});
      in{[V{ivar},'_north']}(it,:,:)=clim{V{ivar}}(1,:,end,:);
      in{[V{ivar},'_south']}(it,:,:)=clim{V{ivar}}(1,:,1,:);
      in{[V{ivar},'_west']}(it,:,:)=clim{V{ivar}}(1,:,:,1);
      in{[V{ivar},'_east']}(it,:,:)=clim{V{ivar}}(1,:,:,end);
    end


    for ivar=5:7
     disp(V{ivar});
      in{[V{ivar},'_north']}(it,:,:)=clim{V{ivar}}(1,end,:);
      in{[V{ivar},'_south']}(it,:,:)=clim{V{ivar}}(1,1,:);
      in{[V{ivar},'_west']}(it,:,:)=clim{V{ivar}}(1,:,1);
      in{[V{ivar},'_east']}(it,:,:)=clim{V{ivar}}(1,:,end);
    end

    close(in); close(clim);
