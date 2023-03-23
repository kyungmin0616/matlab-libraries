function nestvar(np,nc,igrid_par,jgrid_par,...
                   igrid_child,jgrid_child,...
                   varname,tindex,zindex)
%
%  Interpole horinzontally on a nested grid...
%

if nargin< 9, zindex=0; end;


disp([' ... ',varname,' ...']);

imin=min(min(igrid_par));
imax=max(max(igrid_par));
jmin=min(min(jgrid_par));
jmax=max(max(jgrid_par));

if zindex==0,
  var_par=squeeze(np{varname}(tindex,jmin:jmax,imin:imax));
else,
  var_par=squeeze(np{varname}(tindex,zindex,jmin:jmax,imin:imax));
end;

if mean(mean(var_par))~=0,
  warning off;
  var_par=nozero(igrid_par,jgrid_par,var_par);
  warning on;
end;
var_child=interp2(igrid_par,jgrid_par,var_par,igrid_child,jgrid_child,'cubic');

if zindex==0,
  nc{varname}(tindex,:,:)=var_child;
else,
  nc{varname}(tindex,zindex,:,:)=var_child;
end;

return
