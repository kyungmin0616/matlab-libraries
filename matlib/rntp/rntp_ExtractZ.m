
function rntp_ExtractZ(ctl,prefix,grd,inp)
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

itime=0;
tmp = rnt_loadvar(ctl,1,'temp');
[I,J,S] = size(tmp);

if isfield(inp,'Zgrid')
	Zgrid=inp.Zgrid;
else
	Zgrid =- [ 0 10 20 30 40 50 75 100 125 ...
             150 200 250 300 350 400 500 600 800 ]';
end
fields =[myvar myvar2D];
Z=length(Zgrid);
zr=rnt_setdepth(0,grd);
zu=rnt_2grid(zr,'r','u');
zv=rnt_2grid(zr,'r','v');

%==========================================================

  file=[prefix,'.nc'];
  rntp_CreateNCfile(file,I,J,Z,length(ctl.time),fields)
  
  nc=netcdf(file,'w');
  for ictl = 1: length(ctl.time)  
   disp(datestr(ctl.datenum(ictl)))
    for i=1:length(myvar)
      varname=myvar{i};
      disp([' Var - ',varname]);
      tmp=rnt_loadvarsum(ctl,ictl,varname);

      % put on z grid
      if varname == 'u'
         tmp = rnt_2z(tmp,zu,Zgrid);
      elseif varname == 'v'
         tmp = rnt_2z(tmp,zv,Zgrid);
      else
         tmp = rnt_2z(tmp,zr,Zgrid);
      end
      tmp(isnan(tmp)) = -99999;
      nc{varname}(ictl,:,:,:) = permute(tmp,[3 2 1]);
    end
    
    for i=1:length(myvar2D)
      varname=myvar2D{i};
      disp([' Var - ',varname]);
      tmp=rnt_loadvarsum(ctl,ictl,varname);
    
      nc{varname}(ictl,:,:) = permute(tmp,[2 1]);
    end
  end
  nc{'scrum_time'}(:) = ctl.time;
  nc{'ocean_time'}(:) = ctl.time;  
  nc{'year'}(:) = ctl.year;  
  nc{'month'}(:) = ctl.month;  
  nc{'day'}(:) = str2num(datestr(ctl.datenum,7));  
  nc{'datenum'}(:) =ctl.datenum;  
  close(nc);

%==========================================================

