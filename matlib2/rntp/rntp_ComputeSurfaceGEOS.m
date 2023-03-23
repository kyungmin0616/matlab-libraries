

files1=rnt_getfilenames('/neo/vc/NEPD/run/out1_old/avg','nepd_ff_');
files2=rnt_getfilenames('/neo/vc/NEPD/run/out1_old2/avg','nepd_ff_');
files3=rnt_getfilenames('/neo/vc/NEPD/run/out1_old3/avg','nepd_ff_');
files4=rnt_getfilenames('/neo/vc/NEPD/run/out1/avg','nepd_ff_');
files=[files1;files2;files3;files4];
ctl=rnt_timectl(files,'ocean_time','r',[1950 0 0])

%files 1: 01-Feb-1950    01-Nov-1964
%files 2: 01-Feb-1964    01-Apr-1969
%files 3: 01-Feb-1969    01-Oct-1997
%files 4: 01-Feb-1997    01-Aug-2005

grd=rnt_gridload('/neo/vc/Grids/nepd09-grid_conf.txt');
%ketty code start
warning off
in = 1:689; %length(ctl.time) = 689 due to overlap

fgeo='/drive/edl/NEPD/process_data/eddy-ccs/nepd-UV-geost-10km.nc';
ftot='/drive/edl/NEPD/process_data/eddy-ccs/nepd-UV-total-10km.nc';
fage='/drive/edl/NEPD/process_data/eddy-ccs/nepd-UV-ageos-10km.nc';
rntp_CreateNCfile(fgeo,grd.Lp,grd.Mp,1,length(in),{'u' 'v'});
rntp_CreateNCfile(ftot,grd.Lp,grd.Mp,1,length(in),{'u' 'v' 'zeta'});
rntp_CreateNCfile(fage,grd.Lp,grd.Mp,1,length(in),{'u' 'v'});
f={fgeo ftot fage};
for i=1:3
  nc=netcdf(f{i}, 'w');
    nc{'ocean_time'}(:)=ctl.time;
    nc{'year'}(:)=ctl.year;
    nc{'month'}(:)=ctl.month;
    nc{'day'}(:)=ctl.day;
    nc{'datenum'}(:)=ctl.datenum;
    nc{'cycle'}(:)=1;
   close(nc);
end
ctl_geo=rnt_timectl(f(1),'ocean_time','r',[1950 0 0]);
ctl_tot=rnt_timectl(f(2),'ocean_time','r',[1950 0 0]);
ctl_age=rnt_timectl(f(3),'ocean_time','r',[1950 0 0]);


N=grd.N;

for i=1:length(in)
i
tic
I=1:grd.Lp; J=1:grd.Mp;
temp=rnt_loadvar_segp(ctl,in(i),'temp',I,J,N);
salt=rnt_loadvar_segp(ctl,in(i),'salt',I,J,N);
zeta=rnt_loadvar(ctl,in(i),'zeta');
I=1:grd.L; J=1:grd.Mp;
uu=rnt_loadvar_segp(ctl,in(i),'u',I,J,N);
I=1:grd.Lp; J=1:grd.M;
vv=rnt_loadvar_segp(ctl,in(i),'v',I,J,N);

[zr,zw,hz]=rnt_setdepth(zeta,grd);

rho=rnt_rho_eos(temp, salt, zr(:,:,N));
rho0=1028;
rho=rho.*repmat(grd.maskr,[1 1 length(N)]);
%toc % 8s - 2s

%tic
[ugeo,vgeo]=rnt_prsV2(zeta.*grd.maskr,rho,rho0,zr(:,:,N),zw(:,:,N:N+1),hz(:,:,N),grd.f,grd);
toc  % 24s - 3s
% /drive/edl/matlib-master/rnt/rnt_prsV2.m


rnt_savevar(ctl_tot,i,'u',uu);
rnt_savevar(ctl_tot,i,'v',vv);
rnt_savevar(ctl_tot,i,'zeta',zeta);

rnt_savevar(ctl_geo,i,'u',ugeo);
rnt_savevar(ctl_geo,i,'v',vgeo);

rnt_savevar(ctl_age,i,'u',uu-ugeo);
rnt_savevar(ctl_age,i,'v',vv-vgeo);

end

return

% Goes/Ageo/Total velocity is stored in NC files 
fgeo='/drive/edl/NEPD/process_data/eddy-ccs/nepd-UV-geost-10km.nc';
ftot='/drive/edl/NEPD/process_data/eddy-ccs/nepd-UV-total-10km.nc';
fage='/drive/edl/NEPD/process_data/eddy-ccs/nepd-UV-ageos-10km.nc';

% Creat CTL array for each file
ctl_geo=rnt_timectl(f(1),'ocean_time','r',[1950 0 0]);
ctl_tot=rnt_timectl(f(2),'ocean_time','r',[1950 0 0]);
ctl_age=rnt_timectl(f(3),'ocean_time','r',[1950 0 0]);

% take care of overlap
[time, npgo, pdo]=rnl_npgo_index;
[year, month]=dates_datenum(time);
clear in2 in3
k=0;
for i=1:660 
  in=find( ctl_geo.year == year(i) & ctl_geo.month == month(i) );
  if ~isempty(in)
    k=k+1;
    in2(k)=in(1);
    in3(k)=in(end);
  else
   disp(datestr(time(i)));
  end
end
ind=in2;


% Load velocity components e.g. ugeo
% ugeo = rnt_loadvar( ctl_geo, ind , 'u' );





