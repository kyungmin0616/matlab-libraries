% transfer stuff from 1 grid to the other

function [grd,grd1]=rgrd_ExtractOBC_noInterp(ctl,grd,grd1,bryfile,sub_I,sub_J,varargin);
   time=ctl.time;
   opt.bry_time = length(time);
   opt.bry_time_cycle=0;
   
   if nargin > 6
   optnew = varargin{1};
   f=fieldnames(optnew);
   for i=1:length(f)
     eval(['opt.',f{i},'=optnew.',f{i},';']);
   end
   end
   opt
   rnc_CreateBryFile(grd1,bryfile, opt) 

    

sub_Iu=sub_I(1):sub_I(end-1);
sub_Ju=sub_J;
sub_Iv=sub_I;
sub_Jv=sub_J(1):sub_J(end-1);

    % find subdomain
    disp(['   | using subdomain of ', grd.grdfile]);
    I=grd1.grd_pos(1)-2:grd1.grd_pos(2)+2;
    J=grd1.grd_pos(3)-2:grd1.grd_pos(4)+2;

    in=netcdf(bryfile,'w');
    in{'bry_time'}(:)=time;
                                                                                                               
                                                                                                               
    V={'temp' 'salt'  'u' 'v' 'zeta' 'ubar' 'vbar'};

    for it=1:length(time)
    disp([' | extracting bry ... ',num2str(it)]);
    for ivar=1:2
     disp(V{ivar});
     tmp=rnt_loadvar(ctl,it,V{ivar});
     tmp=tmp(sub_I,sub_J,:);   
     tmp=perm(tmp);
      in{[V{ivar},'_north']}(it,:,:)=sq(tmp(:,end,:));
      in{[V{ivar},'_south']}(it,:,:)=sq(tmp(:,1,:));
      in{[V{ivar},'_west']}(it,:,:)=sq(tmp(:,:,1));
      in{[V{ivar},'_east']}(it,:,:)=sq(tmp(:,:,end));
    end

    for ivar=3
     disp(V{ivar});
     tmp=rnt_loadvar(ctl,it,V{ivar});
     tmp=tmp(sub_Iu,sub_Ju,:);     tmp=perm(tmp);
      in{[V{ivar},'_north']}(it,:,:)=sq(tmp(:,end,:));
      in{[V{ivar},'_south']}(it,:,:)=sq(tmp(:,1,:));
      in{[V{ivar},'_west']}(it,:,:)=sq(tmp(:,:,1));
      in{[V{ivar},'_east']}(it,:,:)=sq(tmp(:,:,end));
    end

    for ivar=4
     disp(V{ivar});
     tmp=rnt_loadvar(ctl,it,V{ivar});
     tmp=tmp(sub_Iv,sub_Jv,:);     tmp=perm(tmp);
      in{[V{ivar},'_north']}(it,:,:)=sq(tmp(:,end,:));
      in{[V{ivar},'_south']}(it,:,:)=sq(tmp(:,1,:));
      in{[V{ivar},'_west']}(it,:,:)=sq(tmp(:,:,1));
      in{[V{ivar},'_east']}(it,:,:)=sq(tmp(:,:,end));
    end


    for ivar=5
     disp(V{ivar});
     tmp=rnt_loadvar(ctl,it,V{ivar});
     tmp=tmp(sub_I,sub_J);tmp=perm(tmp);
      in{[V{ivar},'_north']}(it,:)=sq(tmp(end,:));
      in{[V{ivar},'_south']}(it,:)=sq(tmp(1,:));
      in{[V{ivar},'_west']}(it,:)=sq(tmp(:,1));
      in{[V{ivar},'_east']}(it,:)=sq(tmp(:,end));
    end
    for ivar=6
     disp(V{ivar});
     tmp=rnt_loadvar(ctl,it,V{ivar});
     tmp=tmp(sub_Iu,sub_Ju);tmp=perm(tmp);
      in{[V{ivar},'_north']}(it,:)=sq(tmp(end,:));
      in{[V{ivar},'_south']}(it,:)=sq(tmp(1,:));
      in{[V{ivar},'_west']}(it,:)=sq(tmp(:,1));
      in{[V{ivar},'_east']}(it,:)=sq(tmp(:,end));
    end
    for ivar=7
     disp(V{ivar});
     tmp=rnt_loadvar(ctl,it,V{ivar});
     tmp=tmp(sub_Iv,sub_Jv);tmp=perm(tmp);
      in{[V{ivar},'_north']}(it,:)=sq(tmp(end,:));
      in{[V{ivar},'_south']}(it,:)=sq(tmp(1,:));
      in{[V{ivar},'_west']}(it,:)=sq(tmp(:,1));
      in{[V{ivar},'_east']}(it,:)=sq(tmp(:,end));
    end
    end                                                                                                           
    close(in); 


