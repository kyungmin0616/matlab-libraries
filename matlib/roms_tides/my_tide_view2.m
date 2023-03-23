%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     h(t,x) = h(x) cos [w (t - t0) + V0(t0)]
%
% where V0(t0) is the astronomical argument for the constituent 
% at t0.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; 
%close all;

frcfile='uswc_z20_coamps.nc';
grdfile='uswc_z20_grd.nc';

plot_tidal_comp=1;
Itide=1;              % tidal period to plot

plot_tides_t0=0;
Ntides =8;

UV_TIDES=1;

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


% TIDAL ELEVATION SSH

ssh=zeros(M,L);
for itide=1:NTC;
   omega=0; %2*pi*time(itime)/Tperiod(itide); 
   ssh = ssh + ...
    squeeze(Eamp(itide,:,:).*cos(omega - Ephase(itide,:,:)));
end;


% TIDAL CURRENTS U,V

if UV_TIDES,
 u=zeros(M,L-1);
 v=zeros(M-1,L);
 for itide=1:NTC;
  
    omega=0; %2*pi*time(itime)/Tperiod(itide);
    angle=squeeze(UV_Tangle(itide,:,:))-angler;
    phase=omega-squeeze(UV_Tphase(itide,:,:));
    Cangle=cos(angle);
    Cphase=cos(phase);
    Sangle=sin(angle);
    Sphase=sin(phase);
    
    u = u + squeeze( ...
        0.125*( (squeeze(UV_Tmajor(itide,:,1:L-1))+ ...
                 squeeze(UV_Tmajor(itide,:,2:L))).* ...
                 (Cangle(:,1:L-1)+Cangle(:,2:L)).* ...
                 (Cphase(:,1:L-1)+Cphase(:,2:L))- ...
                 (squeeze(UV_Tminor(itide,:,1:L-1))+ ...
                  squeeze(UV_Tminor(itide,:,2:L))).* ...
                 (Sangle(:,1:L-1)+Sangle(:,2:L)).* ...
                 (Sphase(:,1:L-1)+Sphase(:,2:L)) ) ...
                    );
    v = v + squeeze( ...
         0.125*((squeeze(UV_Tmajor(itide,1:M-1,:))+ ...
                 squeeze(UV_Tmajor(itide,2:M  ,:))).* ...
                (Sangle(1:M-1,:)+Sangle(2:M,:)).* ...
                (Cphase(1:M-1,:)+Cphase(2:M,:))+ ...
                (squeeze(UV_Tminor(itide,1:M-1,:))+ ...
                 squeeze(UV_Tminor(itide,2:M  ,:))).* ...
                (Cangle(1:M-1,:)+Cangle(2:M,:)).* ...
                (Sphase(1:M-1,:)+Sphase(2:M,:))) ...
                    );
 end;
end;

%hu=rho2u(h); hv=rho2v(h);
%u=u.*hu;
%v=v.*hv;
%...................................................
% Plot
%

if plot_tidal_comp,

% Tidal components
figure('position',[100 100 1000 800]);

subplot(2,3,1)
z=squeeze(Eamp(Itide,:,:)).*mask./mask;
pcolor(x,y,z);shading flat;
colorbar; grid on;
title('Elevation Amplitude [m]');

subplot(2,3,2)
z=squeeze(UV_Tmajor(Itide,:,:)).*mask./mask;
pcolor(x,y,z);shading flat;
caxis([0 0.06]);
colorbar; grid on;
title('Maximum Tidal Current [m/s]');

subplot(2,3,3)
z=squeeze(UV_Tminor(Itide,:,:)).*mask./mask;
pcolor(x,y,z);shading flat;
caxis([0 0.01]);
colorbar; grid on;
title('Minimum Tidal Current [m/s]');

subplot(2,3,4)
z=squeeze(cos(Ephase(Itide,:,:))).*mask./mask;
pcolor(x,y,z);shading flat;
colorbar; grid on;
title('Cos. of Elev. Phase Angle');

subplot(2,3,5)
z=squeeze(cos(UV_Tphase(Itide,:,:))).*mask./mask;
pcolor(x,y,z);shading flat;
colorbar; grid on;
title('Cos. of current phase angle');

subplot(2,3,6)
z=squeeze(cos(UV_Tangle(Itide,:,:))).*mask./mask;
pcolor(x,y,z);shading flat;
colorbar; grid on;
title('Cos. of current inclination angle');

end;

if plot_tides_t0,

% Elevation and currents at time 0

figure('position',[100 100 1000 400]);

subplot(1,3,1)
z=ssh(:,:).*mask./mask;
pcolor(x,y,z);shading flat;
caxis=([-.8 .8]); colorbar;
grid on;
title('Elevation [m]');

subplot(1,3,2)
z=v2rho(u).*mask./mask;;
pcolor(x,y,z);shading flat;
caxis=([-0.05 0.05]); colorbar;
grid on;
title('Zonal currents [m/s]');

subplot(1,3,3)
z=u2rho(v).*mask./mask;;
pcolor(x,y,z);shading flat;
caxis=([-0.05 0.05]); colorbar;
grid on;
title('Meridional currents [m/s]');

end;


