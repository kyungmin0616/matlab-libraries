function rnc_InitBio(filename, type)


if strcmp(type, 'clima')
% Initialize BIO
ctl=rnt_ctl(filename,'tclm_time');
f=rnt_loadvar(ctl,1,'NO3');
f(:)=2.0;
for it=1:12, rnt_savevar(ctl,it,'NO3',f); end;
f(:)=0.08;
%f(:)=0.0;
for it=1:12, rnt_savevar(ctl,it,'phytoplankton',f); end;
f(:)=0.06;
%f(:)=0.0;
for it=1:12, rnt_savevar(ctl,it,'zooplankton',f); end;
f(:)=0.04;
%f(:)=0.0;
for it=1:12, rnt_savevar(ctl,it,'detritus',f); end;

end


if strcmp(type, 'init')
% Initialize BIO
ctl=rnt_ctl(filename,'ocean_time');
f=rnt_loadvar(ctl,1,'NO3');
f(:)=2.0;
for it=1:1, rnt_savevar(ctl,it,'NO3',f); end;
f(:)=0.08;
%f(:)=0.0;
for it=1:1, rnt_savevar(ctl,it,'phytoplankton',f); end;
f(:)=0.06;
%f(:)=0.0;
for it=1:1, rnt_savevar(ctl,it,'zooplankton',f); end;
f(:)=0.04;
%f(:)=0.0;
for it=1:1, rnt_savevar(ctl,it,'detritus',f); end;

end


