%RNT_GRIDLOAD 
% function grd = rnt_gridload(his)
% Loads grid variables from model output file HIS/AVG
% Returns a structure array GRD with all the fields contained 
% in the grid.
%

function grd = rnt_gridload(hisfile)


grdfile=hisfile;
grd.name=hisfile;
grd.id=hisfile;
grd.grdfile=hisfile;

if nc_isvar(grdfile, 's_rho')
grd.thetas=nc_varget(grdfile, 'theta_s');
grd.thetab=nc_varget(grdfile, 'theta_b');
grd.hc=nc_varget(grdfile, 'hc');
grd.tcline=nc_varget(grdfile, 'Tcline');
tmp=nc_varget(grdfile, 's_rho');
grd.N=length(tmp);
end

if nc_isvar(grdfile, 'lon_rho')
grd.lonr=nc_varget(grdfile, 'lon_rho')';
grd.latr=nc_varget(grdfile, 'lat_rho')';
grd.lonu=nc_varget(grdfile, 'lon_u')';
grd.latu=nc_varget(grdfile, 'lat_u')';
grd.lonv=nc_varget(grdfile, 'lon_v')';
grd.latv=nc_varget(grdfile, 'lat_v')';
grd.lonp=nc_varget(grdfile, 'lon_psi')';
grd.latp=nc_varget(grdfile, 'lat_psi')';
end

if nc_isvar(grdfile, 'mask_rho')
grd.maskr=nc_varget(grdfile, 'mask_rho')';
grd.masku=nc_varget(grdfile, 'mask_u')';
grd.maskv=nc_varget(grdfile, 'mask_v')';
grd.maskp=nc_varget(grdfile, 'mask_psi')';
end


if nc_isvar(grdfile, 'x_rho')
grd.xr=nc_varget(grdfile, 'x_rho')';
grd.yr=nc_varget(grdfile, 'y_rho')';
grd.xu=nc_varget(grdfile, 'x_u')';
grd.yu=nc_varget(grdfile, 'y_u')';
grd.xv=nc_varget(grdfile, 'x_v')';
grd.yv=nc_varget(grdfile, 'y_v')';
grd.xp=nc_varget(grdfile, 'x_psi')';
grd.yp=nc_varget(grdfile, 'y_psi')';
end


if nc_isvar(grdfile, 'angle')
grd.angle=nc_varget(grdfile, 'angle')'; angler=grd.angle;
end

if nc_isvar(grdfile, 'f')
grd.f=nc_varget(grdfile, 'f')'; f=grd.f;
end

grd.h=nc_varget(grdfile, 'h')'; h=grd.h;

if nc_isvar(grdfile, 'grd_pos')
grd.grd_pos=nc_varget(grdfile, 'grd_pos')';
end


[Lp,Mp]=size(grd.h);
[grd.Lp,grd.Mp]=size(grd.h);
L=Lp-1;
M=Mp-1;
Lm=Lp-2;
Mm=Mp-2;

% define indicies
Istr=2; Iend=L;
IstrR=1; IendR=Lp;
Jstr=2; Jend=M;
JstrR=1; JendR=Mp;
IU_RANGE =Istr:IendR;
IV_RANGE =IstrR:IendR;
JU_RANGE =JstrR:JendR;
JV_RANGE = Jstr:JendR;

if ~nc_isvar(grdfile, 'lon_rho')

grd.lonu=grd.xu;
grd.latu=grd.yu;
grd.lonv=grd.xv;
grd.latv=grd.yv;
grd.lonp=grd.xp;
grd.latp=grd.yp;
grd.lonr=grd.xr;
grd.latr=grd.yr;

end

if ~nc_isvar(grdfile, 'mask_rho')
grd.maskr=ones(Lp,Mp);
grd.masku=ones(L,Mp);
grd.maskv=ones(Lp,M);
grd.maskp=ones(L,M);
end


if ~isempty(grd.maskr)
    grd.maskr(grd.maskr==0)=NaN;
    grd.masku(grd.masku==0)=NaN;
    grd.maskv(grd.maskv==0)=NaN;
    grd.maskp(grd.maskp==0)=NaN;
else
    grd.maskr=ones(Lp,Mp);
    grd.maskv=ones(Lp,M);
    grd.masku=ones(L,Mp);
    grd.maskp=ones(L,M);
end   

if nc_isvar(grdfile, 'pm')
grd.pm=nc_varget(grdfile, 'pm')';
grd.pn=nc_varget(grdfile, 'pn')';
pm=nc_varget(grdfile, 'pm')';
pn=nc_varget(grdfile, 'pn')';
end

if nc_isvar(grdfile, 'hraw')
grd.hraw=nc_varget(grdfile, 'hraw')';
grd.hraw=permute(grd.hraw,[3 2 1]);
end


[Lp,Mp]=size(h);
grd.L=Lp-1;
grd.M=Mp-1;
grd.Lm=Lp-2;
grd.Mm=Mp-2;

% define indicies
Istr=2; Iend=L;
IstrR=1; IendR=Lp;
Jstr=2; Jend=M;
JstrR=1; JendR=Mp;


% initialize other metrics
%  Set f/mn,at horizontal RHO-points.
fomn= f./(pm.*pn);
%
%  Compute n/m and m/n; all at horizontal RHO-points.
%
j=JU_RANGE;
i=IV_RANGE;
pnom_r(i,j)=pn(i,j)./pm(i,j);
pmon_r(i,j)=pm(i,j)./pn(i,j);
%if (defined CURVGRID && defined UV_ADV)
%
%  Compute d(1/n)/d(xi) and d(1/m)/d(eta) tems, both at RHO-points.
%
j=Jstr:Jend;
i=Istr:Iend;
grd.dndx(i,j)=0.5./pn(i+1,j)-0.5./pn(i-1,j);
grd.dmde(i,j)=0.5./pm(i,j+1)-0.5./pm(i,j-1);
%endif /* UV_ADV && CURVGRID */
%
%  Compute m/n at horizontal U-points.
%
j=JU_RANGE;
i=IU_RANGE;
pmon_u(i,j)=(pm(i,j)+pm(i-1,j)) ./(pn(i,j)+pn(i-1,j));
om_u(i,j)=2./(pm(i,j)+pm(i-1,j));
on_u(i,j)=2./(pn(i,j)+pn(i-1,j));
%
%  Compute n/m at horizontal V-points.
%
j=JV_RANGE;
i=IV_RANGE;
pnom_v(i,j)=(pn(i,j)+pn(i,j-1))      ./(pm(i,j)+pm(i,j-1));
om_v(i,j)=2./(pm(i,j)+pm(i,j-1));
on_v(i,j)=2./(pn(i,j)+pn(i,j-1));
%
%  Compute n/m and m/n at horizontal PSI-points.
%
j=JV_RANGE;
i=IU_RANGE;
pnom_p(i,j)=(pn(i,j)+pn(i,j-1)+pn(i-1,j)+pn(i-1,j-1))      ...
   ./(pm(i,j)+pm(i,j-1)+pm(i-1,j)+pm(i-1,j-1));
pmon_p(i,j)=(pm(i,j)+pm(i,j-1)+pm(i-1,j)+pm(i-1,j-1))      ...
   ./(pn(i,j)+pn(i,j-1)+pn(i-1,j)+pn(i-1,j-1));
%
%  Compute n and m at horizontal PSI-points.
%
j=Jstr:Jend;
i=Istr:Iend;
pm_p(i,j)=(pm(i,j) + pm(i-1,j) + pm(i,j-1) + pm(i-1,j-1))*0.25;
pn_p(i,j)=(pn(i,j) + pn(i-1,j) + pn(i,j-1) + pn(i-1,j-1))*0.25;

