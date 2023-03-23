% transfer stuff from 1 grid to the other

function rgrd_SaveOBCfromState(bryfile,state,it);

  
    in=netcdf(bryfile,'w');
    in{'bry_time'}(it)=state.day;
                                                                                                               
                                                                                                               
    V={'temp' 'salt'  'u' 'v' 'zeta' 'ubar' 'vbar'};

    
    disp([' | extracting bry ... ',num2str(it)]);
    for ivar=1:4
     disp(V{ivar});
     eval([ 'tmp=state.',V{ivar},';']);
     tmp=perm(tmp);
      
      in{[V{ivar},'_north']}(it,:,:)=sq(tmp(:,end,:));
      in{[V{ivar},'_south']}(it,:,:)=sq(tmp(:,1,:));
      in{[V{ivar},'_west']}(it,:,:)=sq(tmp(:,:,1));
      in{[V{ivar},'_east']}(it,:,:)=sq(tmp(:,:,end));
    end
    for ivar=5:7
     disp(V{ivar});
      eval([ 'tmp=state.',V{ivar},';']);
     tmp=perm(tmp);
     in{[V{ivar},'_north']}(it,:)=sq(tmp(end,:));
      in{[V{ivar},'_south']}(it,:)=sq(tmp(1,:));
      in{[V{ivar},'_west']}(it,:)=sq(tmp(:,1));
      in{[V{ivar},'_east']}(it,:)=sq(tmp(:,end));
    end
                                                                                                            
     


