function [bryfile, ctlcb]=rgrd_ex_bry_nested(sub_I, sub_J, grdp, grdc, nameitc, res, timeind_range, ctlp, opt);
% function [bryfile, ctlcb]=rgrd_ex_bry_nested(sub_I, sub_J, grdp, grdc, nameitc, res, timeind_range, ctlp, opt);
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



bryfile=[nameitc,'-bry.nc'];

% INPUTS
optbry.npzd=opt.npzd;
optbry.bry_time = length(timeind_range);
optbry.bry_time_cycle=0;
optbry.ptracer = opt.np;
optbry.bry_timeVal = ctlp.time(timeind_range)/60/60/24;

% extract openboundary conndition
disp (['Creating Sub BRY file  ',bryfile]);
rnc_CreateBryFile(grdc,bryfile, optbry);

% /dods/matlib/rnc/rnc_SubBryEx.m
if res == 1
 rnc_SubBryEx(ctlp,grdp,grdc,timeind_range,bryfile,sub_I,sub_J, optbry);
else
  disp('3D OA mapping for BRY ...');
  rgrd_ex_bry_nested_oa(sub_I, sub_J, grdp, grdc, bryfile, res, timeind_range, ctlp, opt );
end

ctlcb=rnt_timectl({bryfile}, 'bry_time','r');
% /drive/edl/matlib-master/rnc/rnc_Sub_Ini_Bry.m
% /drive/edl/matlib-master/rnc/rnc_SubBryEx.m
% /drive/edl/matlib-master/rnc/rnc_CreateBryFile.m
