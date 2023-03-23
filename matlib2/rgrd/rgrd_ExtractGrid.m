function [grdfile, grdn, gridconf] = rgrd_ex_grid_nested(sub_I, sub_J, grd, nameit, res)
% function [grdfile, grdc, gridconf] =rgrd_ex_grid_nested(sub_I, sub_J, grd, nameit, res)
%   Extract a subgrid of GRD at resolution RES for the 
%   subdomain SUB_I, SUB_J.
%   RES=1  keep existing resolution
%   RES=2  double the resolution
%   GRDFILE returns the name of the subgrid
%   GRDN returns the new grid
%   GRIDCONF returns the configuration file used to load the grid
%
%   Requires RNT, RGRD and netcdf
%    
%   - E. Di Lorenzo (edl@gatech.edu)
%
gridname=[nameit,'-grid.nc'];
if res ==1
  rgrd_SubGridEx(grd,sub_I,sub_J,gridname);
else
  inp.grdname= grd.grdfile;
  inp.childgrdname= gridname;
  inp.refinecoeff= res;
  inp.newtopo= 0;   % set to 1 for new topo
  inp.topofile= 'topography file';
  inp.nband= 15;
  inp.rtarget= 0.2500;
  inp.command= 'rgrd_ExtractGrids(inp);'
  inp.index= [sub_I(1) sub_I(end) sub_J(1) sub_J(end)];
  rgrd_ExtractGrids(inp);
end


gridnamel=[pwd,'/',gridname];
gridconf=[pwd,'/',nameit,'_conf.txt'];
str{1}='gridindo.id      = gridid;';
str{2}=['gridindo.name    = ''',nameit,''';'];
str{3}=['gridindo.grdfile = ''',gridnamel,''';'];
str{4}=['gridindo.N       = ',num2str(grd.N),';'];
str{5}=['gridindo.thetas  = ',num2str(grd.thetas),';'];
str{6}=['gridindo.thetab  = ',num2str(grd.thetab),';'];

fid=fopen(gridconf,'w');
fprintf(fid,'%s \n',str{:});
fclose(fid);

grdn=rnt_gridload(gridconf);
grdfile=grdn.grdfile;


return



