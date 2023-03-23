function [u_geo,v_geo, u_ageo, v_ageo, zeta ]=rnt_geos(grd,ctl,it)


N=1:grd.N;

for i=it
%================================================================
%	Load T,S, SSH
%================================================================	
I=1:grd.Lp; J=1:grd.Mp;
temp=rnt_loadvar_segp(ctl,it,'temp',I,J,N);
salt=rnt_loadvar_segp(ctl,it,'salt',I,J,N);
zeta=rnt_loadvar(ctl,it,'zeta');

%================================================================
%	Load U
%================================================================	
I=1:grd.L; J=1:grd.Mp;
uu=rnt_loadvar_segp(ctl,it,'u',I,J,N);

%================================================================
%	Load V
%================================================================	
I=1:grd.Lp; J=1:grd.M;
vv=rnt_loadvar_segp(ctl,it,'v',I,J,N);

%================================================================
%	Compute depths and density
%================================================================	
[zr,zw,hz]=rnt_setdepth(zeta,grd);
rho=rnt_rho_eos(temp, salt, zr(:,:,N)); rho0=1028;

%rho=rho.*repmat(grd.maskr,[1 1 length(N)]);

%================================================================
%	Compute Gostrophy
%================================================================	
%[u_geo,v_geo]=rnt_prsV2(zeta.*grd.maskr,rho,rho0,zr(:,:,N),zw(:,:,N:N+1),hz(:,:,N),grd.f,grd);
[u_geo,v_geo]=rnt_prsV2(zeta.*grd.maskr,rho,rho0,zr,zw,hz,grd.f,grd);

u_ageo=uu-u_geo;
v_ageo=vv-v_geo;

end
