%
%     h(t,x) = h(x) cos [w (t - t0) + V0(t0)]
%
% where V0(t0) is the astronomical argument for the constituent at t0.

clear all; 
%close all;

COMPARE=1;

%...................................................
% set time array
%

time0 = mjd(2002,10,28);     % starting day for L.A. data
ndays = 2*7;                 % nb of days
res   = 24;                  % nb points a day
NT    = res*ndays;
jul_off = 0; mjd(1992,1,1);

for i=1:NT;
  time(i)=time0+i/res;
end;  

%...................................................
% TPXO.5 Model interpolated on ROMS grid
%

nc=netcdf('usw15_z40_forc_meinte.nc');
Tperiod=nc{'tide_period'}(:)./24;     % days
Ephase =nc{'tide_Ephase'}(:)*pi/180;  % deg
Eamp   =nc{'tide_Eamp'}(:);           % m
close(nc);

ng=netcdf('usw15_z40_grid.nc');
x=ng{'lon_rho'}(:);
y=ng{'lat_rho'}(:);
mask=ng{'mask_rho'}(:);
close(ng);

[NTC,M,L]=size(Eamp); 
disp(['NTC = ',num2str(NTC)]);

ssh=zeros(NT,M,L);
for itime=1:NT;
  for itide=1:NTC;
    omega=2*pi/Tperiod(itide)*(time(itime)-jul_off); 
    ssh(itime,:,:)=ssh(itime,:,:) + ...
      Eamp(itide,:,:).*cos(omega - Ephase(itide,:,:));
 end;
end;
%...................................................
% L.A. Data
%

if COMPARE,
 load -ASCII tides.dat
 y_data=tides(:,1);
 m_data=tides(:,2);
 d_data=tides(:,3);
 h_data=tides(:,4);
 mn_data=tides(:,5);
 ssh_data=tides(:,6)-.9;
 time_data=mjd(y_data,m_data,d_data,h_data);
end;

%...................................................
% Plot
%

figure
I=L-6; J=34; 
time_m=time-time0;
plot(time_m,ssh(:,J,I),'r'); hold on;
if COMPARE,
 time_d=time_data-time0;
 plot(time_d,ssh_data,'b'); 
end;
hold off;
axis([time_m(1) time_m(NT) -1.5 1.5]);
