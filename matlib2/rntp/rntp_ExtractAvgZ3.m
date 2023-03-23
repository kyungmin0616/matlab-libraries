
function ExtractAvg(ctl,prefix,grd,inp,pmapr)
% function rntp_ExtractAvgZ(ctl,prefix,grd,inp)
%   Create monlty climatology for salt, temp,u,v,zeta,hbl
%   on a Z grid.
% Will also save Isopycnal depths
% inp = input parameter structure array , see details in m file/
  
  
  YearStart = 1952;
  YearEnd   = 1999;
  YEARS=[1954:1970, 1976:1999];
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
  [II,JJ,S] = size(tmp);
  
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
  maskr = repmat(grd.maskr, [ 1 1 S]);
  maskv = repmat(grd.maskv, [ 1 1 S]);
  masku = repmat(grd.masku, [ 1 1 S]);
  
  %==========================================================
  for iyear=YEARS
    file=[prefix,'-',num2str(iyear),'Z.nc'];
    rntp_CreateNCfile(file,II,JJ,Z,24,myvar);
    in=find(ctl.year == iyear);
    
    nc=netcdf(file,'w');
    itime =0;
    
    for istep=1:3:72
      itime=itime + 1;
      for i=1:length(myvar)
        tic
        scrumtime(itime)=ctl.datenum(in(istep));
        
        disp([' Itime - ',num2str(itime),'  ',datestr(scrumtime(itime))]);
        
        varname=myvar{i};
        disp([' Var - ',varname]);
        tmp=rnt_loadvar(ctl,in(istep),varname);
        
        % subsampling startegy
        I=[1:6:55, 58:3:80];J=1:6:120;
        
        % put on z grid
        if varname == 'u'
          tmp = rnt_2z(tmp,zu,Zgrid);
          tmp = tmp.*masku;
          clear tmp2;
          for k=1:length(Zgrid)
            k
            tmp2(:,:,k)=rnt_oa2d(grd.lonu(I,J),grd.latu(I,J), ...
               tmp(I,J,k),grd.lonu,grd.latu,1,1);
          end
          
        elseif varname == 'v'
          tmp = rnt_2z(tmp,zv,Zgrid);
          tmp = tmp.*maskv;
          clear tmp2;
          for k=1:length(Zgrid)
            k
            tmp2(:,:,k)=rnt_oa2d(grd.lonv(I,J),grd.latv(I,J), ...
               tmp(I,J,k),grd.lonv,grd.latv,1,1);
          end
          
        else
          tmp = tmp.*maskr;
          tmp = rnt_2z(tmp,zr,Zgrid);
          
          clear tmp2;
          for k=1:length(Zgrid)
            tmp2(:,:,k)=rnt_oa2d(grd.lonr(I,J),grd.latr(I,J), ...
               tmp(I,J,k),grd.lonr,grd.latr,1,1,pmapr(:,:,k));
            %           [t1,t2,t3]=rnt_oa2d(grd.lonr(I,J),grd.latr(I,J), ...
            %               tmp(I,J,k),grd.lonr,grd.latr,1,1);
            %     pmapr(:,:,k) = t3;
            
          end
        end
        
        
        tmp(isnan(tmp)) = -99999;
        nc{varname}(itime,:,:,:) = permute(tmp2,[3 2 1]);
      end
      toc
      
      for i=1:length(myvar2D)
        varname=myvar2D{i};
        disp([' Var - ',varname]);
        tmp=rnt_loadvar(ctl,in(istep),varname);
        clear tmp2;
        tmp2 =rnt_oa2d(grd.lonr(I,J),grd.latr(I,J), ...
           tmp(I,J),grd.lonr,grd.latr,1,1,pmapr(:,:,1));
        
        nc{varname}(itime,:,:,:) = permute(tmp2,[3 2 1]);
      end
      
    end
    nc{'scrum_time'}(:) = scrumtime;
    close(nc);
  end
  %==========================================================

