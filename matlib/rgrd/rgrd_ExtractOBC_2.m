
function [grd,grd1]=rgrd_ExtractOBC_2(ctl,grd,grd1,bryfile, varargin);
% function [grd,grd1]=rgrd_ExtractOBC_2(ctl,grd,grd1,bryfile,[opt]);
%
% This function generates a boundary data file for grid GRD1
% using the information in GRD. THe data on GRD is accessed through
% the time control array CTL (see rnt_timectl.m). THe CTL struct. array
% ctl.time variable needs to be converted in units of days before beeing
% passed to this function.
%
%  OPT is optional, the default is
%     OPT.bry_time = length(ctl.time);
%     OPT.bry_time_cycle=0;  % which means that there is no cycle_length
% you also need to sepcify which boundaty data
% e.g. OPT.south=1; OPT.north=1; OPT.west=1;
% This routine is different from rgrd_ExtractOBC in that it does not
% use the 3D OA mapping but extracts only vertical slabs. It is perhaps
% more accurate but slower.
%  04/05  E. Di Lorenzo (edl@eas.gatech.edu)
%
 warning off
% need to speed up rnt_section_fast, and rnt_fill indside rnt_extr_bry
   time=ctl.time;
   opt.bry_time = length(time);
   opt.bry_time_cycle=0;
   
   if nargin > 4
   optnew = varargin{1};
   f=fieldnames(optnew);
   for i=1:length(f)
     eval(['opt.',f{i},'=optnew.',f{i},';']);
   end
   end
   opt
   rnc_CreateBryFile(grd1,bryfile, opt) 
   
    % find subdomain
    disp('-finding subdomain.');
   [I,J] = rgrd_FindInsideIJ(grd1.lonr,grd1.latr,grd.lonr,grd.latr);
   K=1:grd.N;
   
   %assign the time
    in=netcdf(bryfile,'w');
    in{'bry_time'}(:)=time;
                                                                                                               
                                                                                                               
    V={'temp' 'salt'  'u' 'v' 'zeta' 'ubar' 'vbar'};

    for it=1:length(time)
    disp([' | extracting bry ... ',num2str(it)]);
    
% 3D variables    
    for ivar=1:4
     disp(V{ivar});
     %field1 = rnt_loadvar_segp(ctl,it,V{ivar},I,J,K);
     field1 = rnt_loadvar(ctl,it,V{ivar});
     %[out,grd,grd1]=rnt_grid2gridN(grd,grd1,ctl,it,V{ivar});
     
     [bry, grd, grd1] = rnt_extr_bry(grd,field1,grd1,opt);

      if isfield(opt,'north'), in{[V{ivar},'_north']}(it,:,:)=bry.sect2_N'; end
      if isfield(opt,'south'), in{[V{ivar},'_south']}(it,:,:)=bry.sect2_S'; end
      if isfield(opt,'west'), in{[V{ivar},'_west']}(it,:,:)=bry.sect2_W'; end
      if isfield(opt,'east'), in{[V{ivar},'_east']}(it,:,:)=bry.sect2_E'; end
    end


% 2D variables
    for ivar=5:7
     disp(V{ivar});
     [out,grd,grd1]=rnt_grid2gridN(grd,grd1,ctl,it,V{ivar});
      tmp=perm(out.data);
      in{[V{ivar},'_north']}(it,:)=sq(tmp(end,:));
      in{[V{ivar},'_south']}(it,:)=sq(tmp(1,:));
      in{[V{ivar},'_west']}(it,:)=sq(tmp(:,1));
      in{[V{ivar},'_east']}(it,:)=sq(tmp(:,end));
    end
    end                                                                                                           
    close(in); 


% [bry, grd1, grd2] = rnt_extr_bry(grd1,field1,grd2,OPT);

% /sdb/edl/ROMS-pak/matlib/rnt/rnt_extr_bry.m
% /sdb/edl/ROMS-pak/matlib/rnt/rnt_section.m
