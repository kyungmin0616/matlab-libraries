function [inifile, ctli, dstart ]=rgrd_ex_init_nested(sub_I, sub_J, grdp, grdc, nameitc, res, timeind, ctlp, opt);
% function [inifile, ctli, dstart ]=rgrd_ex_init_nested(sub_I, sub_J, grdp, grdc, nameitc, res, timeind, ctlp, opt);
%   Extract a subgrid of GRD at resolution RES for the 
%   subdomain SUB_I, SUB_J.
%   RES=1  keep existing resolution
%   RES=2  double the resolution
%   INITTIME choosen date for initial condition in MATLAB datenum format
%   NP number of passive tracers to introduce in initial cond.
%   NPZD =1 to introduce NPZD variables, else =0 
%%
%   Requires RNT, RGRD, RNC, Opendap and netcdf
%   
%   GLOBEC Ocean Modeling Support 
%   - E. Di Lorenzo (globec_extract@o3d.org)
%

% {'salt' 'temp' 'u' 'v' 'ubar' 'vbar' 'zeta' };

inifile=[nameitc,'-init.nc'];

% Set options for initial condition file creation
optini.npzd=opt.npzd;
optini.ptracer=opt.np;
ex_vars=opt.vars;
%       'detritus' 'phytoplankton' 'zooplankton' 'NO3'};

% Create initial condition
disp (['Creating Sub INI file  ',inifile]);
rnc_CreateIniFile(grdc,inifile,optini);
nc=netcdf(inifile,'w'); nc{'ocean_time'}(1)=ctlp.time(timeind); close(nc);
dstart=ctlp.time(timeind)/(24*60*60);
ctli=rnt_timectl({inifile},'ocean_time','r');


if res == 1
state=rnt_loadStateSub(ctlp,timeind,ex_vars,grdp,sub_I,sub_J);
rnt_saveState(ctli,1,ex_vars,state);
else
disp('3D mapping of initial conditions');
%opt.decorr=3;
[grdp, grdc]=rgrd_ex_init_nested_oa(ctlp,grdp,grdc,inifile,timeind,opt);
end



%/drive/edl/matlib-master/rnc/rnc_CreateIniFile.m

% Set passive tracers to zero
nc = netcdf(inifile, 'w');
for inert=1:optini.ptracer

if inert<10 
str=['dye_0',num2str(inert)];
else
str=['dye_',num2str(inert)];
end
nc{str}(:) = 0;

end
close(nc);

