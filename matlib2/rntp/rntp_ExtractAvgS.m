
function ExtractAvg(ctl,prefix,grd)
% function rntp_ExtractAvgS(ctl,prefix,grd)
%   Create monlty climatology for salt, temp,u,v,zeta,hbl


YearStart = ctl.year(1);
YearEnd   = ctl.year(end);
myvar={'salt' 'temp' 'u' 'v' 'zeta'};
itime=0;
tmp = rnt_loadvar(ctl,1,'temp');
[I,J,S] = size(tmp);

%==========================================================
for iyear=YearStart:YearEnd
  file=[prefix,'-',num2str(iyear),'.nc'];
%  [I,J,S] = size(zeta); 
%  rntp_CreateNCfile(file,I,J,S,12)
  opt.time=12;
  rnc_CreateIniFile(grd,file,opt);  
  nc=netcdf(file,'w');
  for imon=1:12
    itime=imon;
    in=find(ctl.month == imon & ctl.year == iyear);
    scrumtime(itime)=datenum(iyear,imon,15);
    disp([' Itime - ',num2str(itime),'  ',datestr(scrumtime(itime))]);
    for i=1:4
      varname=myvar{i};
      disp([' Var - ',varname]);
      tmp=rnt_loadvarsum(ctl,in,varname);
      tmp=tmp/length(in);
      nc{varname}(itime,:,:,:) = permute(tmp,[3 2 1]);
    end
    for i=5
      varname=myvar{i};
      disp([' Var - ',varname]);
      tmp=rnt_loadvarsum(ctl,in,varname);
      tmp=tmp/length(in);
      nc{varname}(itime,:,:) = permute(tmp,[2 1]);
    end
  end
  nc{'ocean_time'}(:) = scrumtime;
  close(nc);
end
%==========================================================

