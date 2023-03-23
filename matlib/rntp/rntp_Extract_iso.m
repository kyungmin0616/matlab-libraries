
function rntp_Extract_iso(ctl,prefix,grd,inp)
% function rntp_ExtractAvgZ(ctl,prefix,grd,inp)
%   Create monlty climatology for salt, temp,u,v,zeta,hbl
%   on a Z grid.
% Will also save Isopycnal depths
% inp = input parameter structure array , see details in m file/

ncquiet;
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

if isfield(inp,'ISOgrid')
	ISOgrid=-abs(inp.ISOgrid);
else
	ISOgrid =- [ 24.4:0.2:27 27.5:0.5:30 ]';
end
fields =[myvar myvar2D];
Z=length(ISOgrid);
zr=rnt_setdepth(0,grd);


%==========================================================

  file=[prefix,'.nc'];
  rntp_CreateNCfile(file,I,J,Z,length(ctl.time),fields)
  
  nc=netcdf(file,'w');
  for ictl = 1: length(ctl.time)  
   disp(datestr(ctl.datenum(ictl)))
   
% 3D fields   
    for i=1:length(myvar)
      varname=myvar{i};
      disp([' Var - ',varname]);
      temp=rnt_loadvarsum(ctl,ictl,'temp');
      salt=rnt_loadvarsum(ctl,ictl,'salt');		
      rho=-rnt_rho_eos(temp,salt,zr);

      % put on z grid
      if varname == 'u'
	   zu=rnt_2grid(rho,'r','u');
	   tmp=rnt_loadvarsum(ctl,ictl,varname);
         tmp = rnt_2sigma(tmp,zu,ISOgrid);
      elseif varname == 'v'
	   zv=rnt_2grid(rho,'r','v');
	   tmp=rnt_loadvarsum(ctl,ictl,varname);
         tmp = rnt_2sigma(tmp,zv,ISOgrid);
      elseif varname == 'temp'
         tmp = rnt_2sigma(temp,rho,ISOgrid);
	elseif varname == 'salt'
	   tmp = rnt_2sigma(salt,rho,ISOgrid);
      elseif varname == 'isoZ'
	   tmp = rnt_2sigma(abs(zr),rho,ISOgrid);
		else
	    error ('no variable selected');
      end
      tmp(isnan(tmp)) = -99999;
      nc{varname}(ictl,:,:,:) = permute(tmp,[3 2 1]);
    end
          
    
%  2D fields
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

