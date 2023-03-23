function nestvar3d(np,nc,igrid_par,jgrid_par,...
                   igrid_child,jgrid_child,...
                   varname,tindex,grd_global)
%
%  Interpole a 3D variable on a nested grid...
%
imin=min(min(igrid_par));
imax=max(max(igrid_par));
jmin=min(min(jgrid_par));
jmax=max(max(jgrid_par));

var_par=squeeze(np{varname}(tindex,jmin:jmax,imin:imax));

% need to mask with nan the land.
 %mask array from parent grid.

grd_parent=grd_global.parent;

 [J,I] = size(var_par);
 if J == grd_parent.Mp & I == grd_parent.Lp
 	var_par = var_par.* grd_parent.maskr';
 end
 if J == grd_parent.Mp & I == grd_parent.L
 	var_par = var_par.* grd_parent.masku';
 end
 if J == grd_parent.M & I == grd_parent.Lp
 	var_par = var_par.* grd_parent.maskv';
 end
    
  var_par=rnt_fill(igrid_par,jgrid_par,var_par,5,5);

var_child=interp2(igrid_par,jgrid_par,var_par,igrid_child,jgrid_child,'cubic');
nc{varname}(tindex,:,:)=var_child;
return
