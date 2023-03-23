
function ExtractAvg(ctl,prefix,grd,inp)
% function rntp_ExtractAvgZ(ctl,prefix,grd,inp)
%   Create monlty climatology for salt, temp,u,v,zeta,hbl
%   on a Z grid.
% Will also save Isopycnal depths
% inp = input parameter structure array , see details in m file/


if isfield(inp,'myvar')
	myvar=inp.myvar;
else
	myvar={'salt' 'temp' 'u' 'v' };
end
if isfield(inp,'myvar2D')
        myvar2D=inp.myvar2D;
else
	myvar2D={'zeta' 'Hsbl' };
end

if isfield(inp,'years')
        YEARS=inp.years;
else
	YEARS=ctl.year(1):ctl.year(end);
end

itime=0;
tmp = rnt_loadvar(ctl,1,'temp');
[I,J,S] = size(tmp);

if isfield(inp,'Zgrid')
	Zgrid=inp.Zgrid;
else
	Zgrid =- [ 0 10 20 30 40 50 75 100 125 ...
             150 200 250 300 350 400 500 600 800 ]';
end

Z=length(Zgrid);
zr=rnt_setdepth(0,grd);
zu=rnt_2grid(zr,'r','u');
zv=rnt_2grid(zr,'r','v');

%==========================================================
for iyear=YEARS
  file=[prefix,'-',num2str(iyear),'Z.nc'];
  rntp_CreateNCfile(file,I,J,Z,12,[myvar myvar2D])
  
  nc=netcdf(file,'w');
  for imon=1:12
    itime=imon;
    in=find(ctl.month == imon & ctl.year == iyear);
    scrumtime(itime)=datenum(iyear,imon,15);
    disp([' Itime - ',num2str(itime),'  ',datestr(scrumtime(itime))]);
    for i=1:length(myvar)
      varname=myvar{i};
      disp([' Var - ',varname]);
      tmp=rnt_loadvarsum(ctl,in,varname);
      tmp=tmp/length(in);

      % put on z grid
      if varname == 'u'
         tmp = rnt_2z(tmp,zu,Zgrid);
      elseif varname == 'v'
         tmp = rnt_2z(tmp,zv,Zgrid);
      else
         tmp = rnt_2z(tmp,zr,Zgrid);
      end
      tmp(isnan(tmp)) = -99999;
      nc{varname}(itime,:,:,:) = permute(tmp,[3 2 1]);
    end
    for i=1:length(myvar2D)
      varname=myvar2D{i};
      disp([' Var - ',varname]);
      tmp=rnt_loadvarsum(ctl,in,varname);
      tmp=tmp/length(in);
      nc{varname}(itime,:,:,:) = permute(tmp,[3 2 1]);
    end
  end
  nc{'scrum_time'}(:) = scrumtime;
  nc{'ocean_time'}(:) = scrumtime;
  close(nc);
end
%==========================================================

