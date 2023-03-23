function [B, Tiso, Siso,Uiso, Viso, Ziso, Niso]=rnt_bernoulli(T,S,U,V,zeta,zr,hz,iso, varargin)

rho0=1025;
B=zeta*rho0;
rho=zr*0;

for iz=1:size(rho,3)
  rho(:,:,iz)=rnt_rho_eos(T(:,:,iz),S(:,:,iz),zr(:,:,iz)) + rho0;
end

[I,J,K]=size(hz);
rhodz=rho.*hz;

dz=zeros(I,J,K);
Bz=zeros(I,J,K);

for k=K:-1:1
   Bz(:,:,k) = sum(rhodz(:,:,K:-1:k),3) + B;
   dz(:,:,k)=sum(hz(:,:,K:-1:k),3);   
end

B=rnt_2sigma(Bz, -(rho-rho0),-abs(iso));
dz=rnt_2sigma(dz, -(rho-rho0),-abs(iso));
Ziso=dz;
Tiso=rnt_2sigma(T, -(rho-rho0),-abs(iso));
Siso=rnt_2sigma(S, -(rho-rho0),-abs(iso));

tmp=rnt_2grid(-(rho-rho0), 'r','u');
Uiso=rnt_2sigma(U, tmp,-abs(iso));
tmp=rnt_2grid(-(rho-rho0), 'r','v');
Viso=rnt_2sigma(V, tmp,-abs(iso));

if nargin == 7
NO3=varargin{1};
Niso=rnt_2sigma(NO3, -(rho-rho0),-abs(iso));
end

for i=1:length(iso)
B(:,:,i)=B(:,:,i)- (iso(i)+rho0)*dz(:,:,i);
end

return

ctl=ctlc;
i=1:12;
T=mean(rnt_loadvar(ctl,i,'temp'),4);
S=mean(rnt_loadvar(ctl,i,'salt'),4);
%zeta=mean(rnt_loadvar(ctl,i,'zeta'),3);
zeta=grd.h*0;
[zr,zw,hz]=rnt_setdepth(zeta,grd);
B=rnt_bernoulli(T,S,zeta,zr,hz,iso);



