function nestvar4d(np,nc,igrid_par,jgrid_par,...
                   igrid_child,jgrid_child,...
                   varname,zindex,tindex)
%
%  Interpole a 4D variable on a nested grid...
%
imin=min(min(igrid_par));
imax=max(max(igrid_par));
jmin=min(min(jgrid_par));
jmax=max(max(jgrid_par));

var_par=squeeze(np{varname}(tindex,zindex,jmin:jmax,imin:imax));
if mean(mean(var_par))~=0,
  warning off;
  var_par=nozero(igrid_par,jgrid_par,var_par);
  warning on;
end;
var_child=interp2(igrid_par,jgrid_par,var_par,igrid_child,jgrid_child,'cubic');
nc{varname}(tindex,zindex,:,:)=var_child;
return
