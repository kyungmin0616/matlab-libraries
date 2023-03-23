function [ctl, ctlf, grd]=rout(str);

% function [ctl, ctlf, grd]=rout(str);
if nargin == 0
help rnl_nepd
opt={'nepd10 ncep #1' 'nepd10 ncep #2' 'nepd20 ncep #1-3' 'nepd20 rsm #1' 'nepd20 rsm #2' ...
     'Pacific NCEP #2' 'NPacific NCEP #1'}
return
end

if strcmp(str,'nepd10 ncep #1'); desc='NEPD 10m 1950-2007, forced by NCEP monthly, SST relax, ens #1';
files1=rnt_getfilenames('/neo/vc/NAS_RunsOutput/NEPD10/Spinup/out1_old/avg','nepd_ff_');
files2=rnt_getfilenames('/neo/vc/NAS_RunsOutput/NEPD10/Spinup/out1_old2/avg','nepd_ff_');
files3=rnt_getfilenames('/neo/vc/NAS_RunsOutput/NEPD10/Spinup/out1_old3/avg','nepd_ff_');
files4=rnt_getfilenames('/neo/vc/NAS_RunsOutput/NEPD10/Spinup/out1/avg','nepd_ff_');
files=[files1;files2;files3;files4];
ctl=rnt_timectl(files,'ocean_time','r',[1950 0 0]);
ctl.desc=desc;
%!files 1: 01-Feb-1950    01-Nov-1964
%!files 2: 01-Feb-1964    01-Apr-1969
%!files 3: 01-Feb-1969    01-Oct-1997
%!files 4: 01-Feb-1997    01-Aug-2005
grd=rnt_gridload('nepd10');
ctlf.winds=rnt_timectl({'/nas/vc/NEPD10/NEPD_10km_1950/nepd09-forc-winds-2007.nc'},'sms_time','r',[1950 0 0]);
ctlf.sst=rnt_timectl({'/nas/vc/NEPD10/NEPD_10km_1950/nepd09-forc-SST-2007.nc'},'sst_time','r',[1950 0 0]);
ctlf.bflux=rnt_timectl({'/nas/vc/NEPD10/NEPD_10km_1950/nepd09-forc-heat-fresh-CLIMA.nc'},'srf_time','r',[1950 0 0]);
end

if strcmp(str,'nepd10 ncep #2'); desc='NEPD 10m 1950-2007, forced by NCEP monthly, SST relax, ens #2';
load  /nas/vc/Data/NEPD10/LoadGrdCtl.mat
ctl.desc=desc;
grd=rnt_gridload('nepd10');
ctlf.winds=rnt_timectl({'/nas/vc/NEPD10/NEPD_10km_1950/nepd09-forc-winds-2007.nc'},'sms_time','r',[1950 0 0]);
ctlf.sst=rnt_timectl({'/nas/vc/NEPD10/NEPD_10km_1950/nepd09-forc-SST-2007.nc'},'sst_time','r',[1950 0 0]);
ctlf.bflux=rnt_timectl({'/nas/vc/NEPD10/NEPD_10km_1950/nepd09-forc-heat-fresh-CLIMA.nc'},'srf_time','r',[1950 0 0]);
end

if strcmp(str,'nepd20 ncep #1-3'); desc='NEPD 20m 1950-2004, forced by NCEP monthly, SST relax, SSS corrected, ens #1-3';
filen=rnt_getfilenames('/drive/edl/NEPD/forc_full/rst5/avg','avg','/bin/ls -1 /drive/edl/NEPD/forc_full/rst5/avg/nepd_ff_avg*');
ctln=rnt_timectl(filen,'ocean_time','r');
grd=rnt_gridload('nepd');
ctln.cycle=ctln.time*nan;
for icycle=ceil(ctln.year(end)/55):-1:1
   in=find(ctln.year <= [54 + (icycle-1)*55] );
   ctln.cycle(in)=icycle;
end
in=find(ctln.cycle ==1);
ctln.year(in)+1950;
for i=2:4
  in=find(ctln.cycle ==i);
  ctln.year(in)=ctln.year(in)+1950 - ctln.year(in(1));
end
ctl=ctln;
ctl.desc=desc;
ctl.datenum=datenum(ctl.year,ctl.month,15);   
ctlf.winds=rnt_timectl({'/drive/edl/NEPD/nepd-data/nepd-forc-winds-50yr.nc'},'sms_time','r',[1950 0 0]);
ctlf.sst=rnt_timectl({'/drive/edl/NEPD/nepd-data/nepd-forc-SST-50yr.nc'},'sst_time','r',[1950 0 0]);
ctlf.bflux=rnt_timectl({'/drive/edl/NEPD/nepd-data/nepd-forc-heat-fresh-CLIMA-noSST.nc'},'srf_time','r',[1950 0 0]);
end

if strcmp(str,'nepd20 rsm #1'); desc='NEPD 20m 1950-2004, forced by RSM monthly, SST relax, ens #1';
files1=rnt_getfilenames('/neo/NEPD/forc_full_bio/rst1/avg','nepd_ff_'); files1=files1(1:end-1);
files=files1(1:55*2);
ctl=rnt_timectl(files,'ocean_time','r',[1950 0 0]);
ctl.desc=desc;
grd=rnt_gridload('nepd');
ctlf.winds=rnt_timectl({'/drive/edl/NEPD/nepd-data/nepd-forc-winds-50yr+RSM.nc'},'sms_time','r',[1950 0 0]);
ctlf.sst=rnt_timectl({'/drive/edl/NEPD/nepd-data/nepd-forc-SST-50yr.nc'},'sst_time','r',[1950 0 0]);
ctlf.bflux=rnt_timectl({'/drive/edl/NEPD/nepd-data/nepd-forc-heat-fresh-CLIMA-noSST.nc'},'srf_time','r',[1950 0 0]);
end

if strcmp(str,'nepd20 rsm #2'); desc='NEPD 20m 1950-2004, forced by RSM monthly, SST relax, ens #2';
files1=rnt_getfilenames('/neo/NEPD/forc_full_bio/rst2/avg','bio_avg_'); files1=files1(1:end-1);
files=files1(1:55*2);
ctl=rnt_timectl(files,'ocean_time','r',[1950 0 0]);
ctl.desc=desc;
grd=rnt_gridload('nepd');
ctlf.winds=rnt_timectl({'/drive/edl/NEPD/nepd-data/nepd-forc-winds-50yr+RSM.nc'},'sms_time','r',[1950 0 0]);
ctlf.sst=rnt_timectl({'/drive/edl/NEPD/nepd-data/nepd-forc-SST-50yr.nc'},'sst_time','r',[1950 0 0]);
ctlf.bflux=rnt_timectl({'/drive/edl/NEPD/nepd-data/nepd-forc-heat-fresh-CLIMA-noSST.nc'},'srf_time','r',[1950 0 0]);
end

if strcmp(str,'Pacific NCEP #2'); desc='Pacific 1950-2005, forced by NCEP monthly, SST relax, corrected SSS flux ens #2';
load /nas/vc/Data/PAC/ctl.mat
ctlf.winds=rnt_timectl({'/data/nas/vc/PAC/Run/input/pac-forc-winds-1950-2005.nc'},'sms_time','r',[1950 0 0]);
ctlf.sst=rnt_timectl({'/data/nas/vc/PAC/Run/input/pac-forc-others-1950-2005_flxCorr.nc'},'sst_time','r',[1950 0 0]);
ctlf.bflux=ctlf.sst;
end

if strcmp(str,'NPacific NCEP #1'); desc='NPacific 1950-2005, forced by NCEP monthly, SST relax, corrected SSS flux ens #1';
outdir='/neo/GFD_Class/gfd_root/roms-examples/npacific/out_1950_2005';
files=rnt_getfilenames(outdir, 'avg');
files=files(1:55);
ctl=rnt_timectl(files, 'ocean_time', 'r', [1950 0 0]);
grd=rnt_gridload('npacific');
ctlf.winds=rnt_timectl({'/neo/GFD_Class/gfd_root/roms-examples/npacific/input/npacific-forc-winds-1950-2005.nc'},'sms_time','r',[1950 0 0]);
ctlf.sst=rnt_timectl({'/neo/GFD_Class/gfd_root/roms-examples/npacific/input/npacific-flxCorr.nc'},'sst_time','r',[1950 0 0]);
ctlf.bflux=ctlf.sst;
end


