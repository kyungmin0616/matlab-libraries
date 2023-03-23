

function [ncepR, ncep, basis] = rnc_reconstructNCEP_with_QSCATT(lonr,latr,mydatenum,avg_freq,varargin);

vars=    {'sustr' 'svstr'};


 
% extract monthly first

if nargin < 5
n=0;
for yr=2000:2004
for mon=1:12
  n=n+1;
  mydatenum2(n)=datenum(yr,mon,15);
end
end
qscb = rnc_ExtractNCEP_QSCATT(lonr,latr,mydatenum2, 'monthly');  
[eofsU,eofs_coeffU,varexpU]=rnt_doEof(qscb.sustr,qscb.mask);
[eofsV,eofs_coeffV,varexpV]=rnt_doEof(qscb.svstr,qscb.mask);
qscb.eofsU=eofsU;
qscb.eofsV=eofsV;
qscb.varexpU=varexpU;
qscb.varexpV=varexpV;
else
  qscb=varargin{1};
end

basis=qscb;
ncep = rnc_Extract_SurfFluxes_NCEP(qscb.lon,qscb.lat, mydatenum, 'monthly',vars);



modes=15;
in=find(~isnan(qscb.mask)); 

ncepR.datenum=ncep.datenum;
ncepR.month=ncep.month;
ncepR.year=ncep.year;
ncepR.day=ncep.day;
ncepR.mask=qscb.mask;

[I,J]=size(qscb.lon);
ncepR.lon=qscb.lon;
ncepR.lat=qscb.lat;
IT=length(ncep.datenum);
ncepR.svstr=zeros(I,J,IT)*nan;
ncepR.sustr=zeros(I,J,IT)*nan;

%==========================================================
%	v comp
%==========================================================
clear E
for n=1:modes
  e=qscb.eofsV(:,:,n);
  E(:,n) = e(in);
end

for it=1:IT
  f=interp2(ncep.lon',ncep.lat',ncep.svstr(:,:,it)',qscb.lon,qscb.lat,'cubic');  
  f1=f(in);
  fhat=qscb.mask*nan;
  
  
  CME=E'*E + diag(ones(modes,1)*0.01);
  m=CME\(E'*f1);
  
  
  f2 = E*m;
  fhat=f; fhat(:)=0;
  fhat(in)=f2;
  ncepR.svstr(:,:,it) = fhat;
%it
end  
  
%==========================================================
%	u comp
%==========================================================
clear E
for n=1:modes
  e=qscb.eofsU(:,:,n);
  E(:,n) = e(in);
end

for it=1:IT
  f=interp2(ncep.lon',ncep.lat',ncep.sustr(:,:,it)',qscb.lon,qscb.lat,'cubic');  
  f1=f(in);
  fhat=qscb.mask*nan;
  
  
  CME=E'*E + diag(ones(modes,1)*0.01);
  m=CME\(E'*f1);
  
  
  f2 = E*m;
  fhat=f; fhat(:)=0;
  fhat(in)=f2;
  ncepR.sustr(:,:,it) = fhat;
%it
end  
  
  
  
in=find(isnan(qscb.mask));
noin=find(~isnan(qscb.mask));
[pmap]=rnt_oapmap(qscb.lon(noin),qscb.lat(noin),qscb.mask(noin) ,qscb.lon(in),qscb.lat(in),20);

vars={'sustr' 'svstr'};
for i=1:IT
    %disp(['Filling nan for month... ',num2str(i)]);
    for iv=1:length(vars)
        disp(vars{iv});
    eval(['tmp=ncepR.',vars{iv},'(:,:,i);']);
    tmp(in)=rnt_oa2d(qscb.lon(noin),qscb.lat(noin),qscb.mask(noin).*tmp(noin), ...
                 qscb.lon(in),qscb.lat(in),3,3,pmap);
    eval(['ncepR.',vars{iv},'(:,:,i)=tmp;']);
    end
end



% add daily component
if strcmp(avg_freq,'daily');
[ncepd] = rnc_reconstructNCEP_add_daily(lonr,latr,mydatenum,ncepR);

end


return

pp=mean(ncepR.svstr,3);
pp2=interp2(ncepR.lon',ncepR.lat',pp',grd.lonr,grd.latr,'cubic');
rnt_plcm(pp2,grd)


pp=mean(qscb.svstr,3);
pp2=interp2(ncepR.lon',ncepR.lat',pp',grd.lonr,grd.latr,'cubic');

pp=mean(ncep.svstr,3);
pp2=interp2(ncep.lon',ncep.lat',pp',grd.lonr,grd.latr,'cubic');
rnt_plcm(pp2,grd)



