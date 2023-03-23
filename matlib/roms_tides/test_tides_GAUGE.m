%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     h(t,x) = h(x) cos [w (t - t0) + V0(t0)]
%
% where V0(t0) is the astronomical argument for the constituent at t0.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; 
%close all;

fname='uswc_z20_coamps.nc';
gname='uswc_z20_grd.nc';
gauge_file='/disk27/patrickm/CONFIG/grid15_z40/tides_LA_01jan02.dat';
COMPARE=1;

%...................................................
% set time array
%

time0 = mjd(2002,1,1);     % starting day for L.A. data
ndays = 2*7;               % nb of days
res   = 24;                % nb points a day
NT    = res*ndays;
jul_off = 0;

for i=1:NT;
  time(i)=time0+i/res;
end;  

%...................................................
% TPXO.5 Model interpolated on ROMS grid
%

nc=netcdf(fname);
Tperiod=nc{'tide_period'}(:)./24;     % days
Ephase =nc{'tide_Ephase'}(:)*pi/180;  % deg
Eamp   =nc{'tide_Eamp'}(:);           % m
close(nc);

ng=netcdf(gname);
lon=ng{'lon_rho'}(:);
lat=ng{'lat_rho'}(:);
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
% Find j,i indices for L.A.
lat0=33.93; lon0=-118.71; % UCLA Mooring
for i=1:L-1; for j=1:M-1;
  if (lat(j,i)<lat0 & lat0<lat(j+1,i+1) & ...
      lon(j+1,i)<lon0 & lon0<lon(j,i+1)),
    I=i;lon1=lon(j,i); disp(['I = ',int2str(I)])
    J=j;lat1=lat(j,i); disp(['J = ',int2str(J)])
  end;
end; end;

%...................................................
% L.A. Data
%
 eval(['!cp ',gauge_file,' tides.dat'])
 load -ASCII tides.dat
 y_data=tides(:,1);
 m_data=tides(:,2);
 d_data=tides(:,3);
 h_data=tides(:,4);
 mn_data=tides(:,5);
 ssh_data=tides(:,6)-.9;
 time_data=mjd(y_data,m_data,d_data,h_data);

%...................................................
% Plot
%

figure
time_m=time-time0;
a=plot(time_m,ssh(:,J,I),'r'); hold on;
time_d=time_data-time0;
b=plot(time_d,ssh_data,'b'); 
legend([a b],'TPXO','Tidal Gauge');
hold off;
axis([time_m(1) time_m(NT) -1.5 1.5]);
