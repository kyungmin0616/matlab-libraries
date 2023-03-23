% transfer stuff from 1 grid to the other

function [grd,grdc]=rgrd_ex_bry_nested_oa(sub_I, sub_J, grdp, grdc, bryfile, res, timeind_range, ctlp, opt );

    time=ctlp.time(timeind_range)/60/60/24; % transofrm in days
    % create the bry file  ../rnt/rnt_makebryfile.m    

    % find subdomain
    disp(['   | using subdomain of ', grdp.grdfile]);
    I=grdc.grd_pos(1)-2:grdc.grd_pos(2)+2;
    J=grdc.grd_pos(3)-2:grdc.grd_pos(4)+2;

    in=netcdf(bryfile,'w');
    in{'bry_time'}(:)=time;
                                                                                                               
                                                                                                               
    %V={'temp' 'salt'  'u' 'v' 'zeta' 'ubar' 'vbar'};

    V=opt.vars;
    
    for it=1:length(time)
    disp([' | extracting bry ... ',num2str(it)]);
    for ivar=1:length(V)
     if opt.dims(ivar)==3
     disp(V{ivar});
     [out,grdp,grdc]=rnt_grid2gridN(grdp,grdc,ctlp,it,V{ivar});
      tmp=perm(out.data);
      in{[V{ivar},'_north']}(it,:,:)=sq(tmp(:,end,:));
      in{[V{ivar},'_south']}(it,:,:)=sq(tmp(:,1,:));
      in{[V{ivar},'_west']}(it,:,:)=sq(tmp(:,:,1));
      in{[V{ivar},'_east']}(it,:,:)=sq(tmp(:,:,end));
      end
	
	if opt.dims(ivar)==2
      disp(V{ivar});
     [out,grdp,grdc]=rnt_grid2gridN(grdp,grdc,ctlp,it,V{ivar});
      tmp=perm(out.data);
      in{[V{ivar},'_north']}(it,:)=sq(tmp(end,:));
      in{[V{ivar},'_south']}(it,:)=sq(tmp(1,:));
      in{[V{ivar},'_west']}(it,:)=sq(tmp(:,1));
      in{[V{ivar},'_east']}(it,:)=sq(tmp(:,end));
	end
    
    end  
    end                                                                                                           
    close(in); 


