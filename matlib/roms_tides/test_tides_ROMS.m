%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     h(t,x) = h(x) cos [w (t - t0) + V0(t0)]
%
% where V0(t0) is the astronomical argument for the constituent 
% at t0.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; 
%close all;

frcfile='usw15_coamps_testides.nc';
grdfile='usw15_grid.nc';
clmfile='usw15_Lclm.nc';
hisfile='/disk27/patrickm/TMP/his.nc';

Ntides =10;
UV_TIDES=0;
charact=0;
%...................................................
% set time array
%

time0 = mjd(2002,1,1);          % starting day for L.A. data
ndays = 6;                      % nb of days
res   = 24;                     % nb points a day
NT    = res*ndays+1;

for i=1:NT;
  time(i)=time0+i/res;          % days
end;  

%...................................................
% TPXO.5 Model interpolated on ROMS grid
%

nc=netcdf(frcfile);
Tperiod  =nc{'tide_period'}(:)./24;      % days
Ephase   =nc{'tide_Ephase'}(:)*pi/180;   % deg
Eamp     =nc{'tide_Eamp'}(:);            % m
if UV_TIDES,
 UV_Tphase=nc{'tide_Cphase'}(:)*pi/180;  % deg
 UV_Tangle=nc{'tide_Cangle'}(:)*pi/180;  % deg
 UV_Tminor=nc{'tide_Cmin'}(:);           % m/s
 UV_Tmajor=nc{'tide_Cmax'}(:);           % m/s
end;
close(nc);

ng=netcdf(grdfile);
x=ng{'lon_rho'}(:);
y=ng{'lat_rho'}(:);
mask=ng{'mask_rho'}(:);
angler=ng{'angle'}(:);
h=ng{'h'}(:);
close(ng);

[NTC,M,L]=size(Eamp); 
if Ntides>0, NTC=Ntides; end;
disp(['NTC = ',num2str(NTC)]);

ssh=zeros(NT,M,L);
for itime=1:NT;
  for itide=1:NTC;
    omega=2*pi*time(itime)/Tperiod(itide); 
    ssh(itime,:,:)=ssh(itime,:,:) + ...
      Eamp(itide,:,:).*cos(omega - Ephase(itide,:,:));
  end;
end;

if UV_TIDES,
 u=zeros(NT,M,L-1);
 v=zeros(NT,M-1,L);
 for itime=1:NT;
  for itide=1:NTC;
  
    omega=2*pi*time(itime)/Tperiod(itide);
    angle=squeeze(UV_Tangle(itide,:,:))-angler;
    phase=omega-squeeze(UV_Tphase(itide,:,:));
    Cangle=cos(angle);
    Cphase=cos(phase);
    Sangle=sin(angle);
    Sphase=sin(phase);
    
    u(itime,:,:)=squeeze(u(itime,:,:)) + ...
        0.125*( (squeeze(UV_Tmajor(itide,:,1:L-1))+ ...
                 squeeze(UV_Tmajor(itide,:,2:L))).* ...
                 (Cangle(:,1:L-1)+Cangle(:,2:L)).* ...
                 (Cphase(:,1:L-1)+Cphase(:,2:L))- ...
                 (squeeze(UV_Tminor(itide,:,1:L-1))+ ...
                  squeeze(UV_Tminor(itide,:,2:L))).* ...
                 (Sangle(:,1:L-1)+Sangle(:,2:L)).* ...
                 (Sphase(:,1:L-1)+Sphase(:,2:L)) );

    v(itime,:,:)=squeeze(v(itime,:,:)) + ...
         0.125*((squeeze(UV_Tmajor(itide,1:M-1,:))+ ...
                 squeeze(UV_Tmajor(itide,2:M  ,:))).* ...
                (Sangle(1:M-1,:)+Sangle(2:M,:)).* ...
                (Cphase(1:M-1,:)+Cphase(2:M,:))+ ...
                (squeeze(UV_Tminor(itide,1:M-1,:))+ ...
                 squeeze(UV_Tminor(itide,2:M  ,:))).* ...
                (Cangle(1:M-1,:)+Cangle(2:M,:)).* ...
                (Sphase(1:M-1,:)+Sphase(2:M,:)));
  end;
 end;
end;

%...................................................
% ROMS output
%
nc=netcdf(hisfile);
zeta=nc{'zeta'}(:); [NT2 M L]=size(zeta);
ub  =nc{'ubar'}(:);
vb  =nc{'vbar'}(:);
time2=nc{'scrum_time'}(:)./86400;
close(nc)

nc=netcdf(clmfile);
mzeta0=zeros(NT2,M,L);
%mzeta0(1,:,:)=nc{'SSH'}(1,:,:);
mzeta0(1,:,:)=mean(zeta);
mzeta=repmat(mzeta0(1,:,:),[NT2 1 1]);
zeta=zeta-mzeta; clear mzeta;
close(nc)

%...................................................
% Computation of characteristic values H*u+C*SSH
%
if charact,

ipos=30;
g=9.8;
H0=squeeze(.5*(h(1:M-1,ipos)+h(2:M,ipos)))';

H=repmat(H0,[NT 1]);
E=squeeze(.5*(ssh(:,1:M-1,ipos)+ssh(:,2:M,ipos)));
Cdata=squeeze(v(:,:,ipos))+sqrt(g./H).*E;

H2=repmat(H0,[NT2 1]);
E2=squeeze(.5*(zeta(:,1:M-1,ipos)+zeta(:,2:M,ipos)));
Cmodel=squeeze(vb(:,:,ipos))+sqrt(g./H2).*E2;

figure(1); pcolor(Cdata); colorbar;
figure(2); pcolor(Cmodel); colorbar;

return
end,

%...................................................
% Plot
%

time_TPXO=time  -time0;
time_ROMS=time2 -time0;

%x1=time_TPXO(1); x2=time_TPXO(NT); y1=-1.5; y2=-y2;
x1=0; x2=ndays; y1=-1.5; y2=1.5;

figure(1)
I=L-6; J=34; 
%I=50; J=60; 
a=plot(time_TPXO,ssh(:,J,I),'r'); hold on;
b=plot(time_ROMS,zeta(:,J,I),'g'); hold off;
legend([a b],'TPXO','ROMS');
grid on; axis([x1 x2 y1 y2]);
print -djpeg TPXO_ROMS_LA.jpg

return

figure(2)
I=30;
plot(time_TPXO,ssh(:,2,I),'r'); hold on;
plot(time_TPXO,ssh(:,64,I),'g'); hold on;
plot(time_TPXO,ssh(:,128,I),'b'); hold off;
grid on; axis([x1 x2 y1 y2]);

figure(3)
plot(time_ROMS,zeta(:,2,I),'r'); hold on;
plot(time_ROMS,zeta(:,64,I),'g'); hold on;
plot(time_ROMS,zeta(:,128,I),'b'); hold off;
grid on; axis([x1 x2 y1 y2]);

if UV_TIDES,

figure(4)
I=L-7; J=34; 
I=30; J=127;
plot(time_TPXO,v(:,J,I),'r'); hold on;
plot(time_ROMS,vb(:,J,I),'g'); hold on;
plot(time_TPXO,ssh(:,J,I)./20,'r','LineStyle',':'); hold off;
grid on;
axis([x1 x2 -.1 .1]);

figure(5)
I=30;
plot(time_TPXO,v(:,2,I),'r'); hold on;
plot(time_TPXO,v(:,64,I),'g'); hold on;
plot(time_TPXO,v(:,127,I),'b'); hold off;
grid on;
axis([x1 x2 -.1 .1]);

figure(6)
I=30;
plot(time_ROMS,vb(:,2,I),'r'); hold on;
plot(time_ROMS,vb(:,64,I),'g'); hold on;
plot(time_ROMS,vb(:,127,I),'b'); hold off;
grid on;
axis([x1 x2 -.1 .1]);

end;

return

figure(5)
it=25; 
%it=50;
z=squeeze(zeta(it,:,:)).*mask./mask;
contourf(x,y,z,[-.8:.05:.8]);
caxis([-.8 .8]); colorbar;
grid on;

figure(6)
it=44; 
%it=88;
z=squeeze(ssh(it,:,:)).*mask./mask;
contourf(x,y,z,[-.8:.05:.8]);
caxis([-.8 .8]); colorbar;
grid on;

figure(7)
it=1; 
z=v2rho(squeeze(u(it,:,:)));
contourf(x,y,z,[-0.05:0.002:0.05]);
caxis=([-0.05 0.05]); colorbar;
grid on;

figure(8)
it=1; 
z=u2rho(squeeze(v(it,:,:)));
contourf(x,y,z,[-0.05:0.002:0.05]);
caxis=([-0.05 0.05]); colorbar;
grid on;



