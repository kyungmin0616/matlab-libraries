function  qscb = rnc_NCEP_QSCATT_Forcing(grd,forcfile, ncepfile);
% get ncep winds.
% If updateClima == 1 then write and interpolate the climatology
% into the clmfile.
  
  
  shiftGrid=0;
  in=find(grd.lonr > 0);
  if length(in) > 0
    shiftGrid=1;
  end
  in=find(grd.lonr > 182);
  if length(in) > 0
    error 'The climatologies available do not cover this long. range'
    return
  end
  
  
  nc = netcdf(ncepfile);
  lon1=perm(nc{'lon'}(:));
  lat1=perm(nc{'lat'}(:));
  
  if shiftGrid==1
    [tmp,lon,lat]=rnc_shift_grid(lon1,lat1,lon1);
  else
    lon=lon1;
    lat=lat1;
  end
  
  
  
  
  lonmin = min(grd.lonr(:))-4;
  lonmax = max(grd.lonr(:))+4;
  latmin = min(grd.latr(:))-4;
  latmax = max(grd.latr(:))+4;
  
  % nw sw se ne
  %corn.lon = [grd.lonr(1,end) grd.lonr(1,1) grd.lonr(end,1) grd.lonr(end,end)]';
  %corn.lat = [grd.latr(1,end) grd.latr(1,1) grd.latr(end,1) grd.latr(end,end)]';
  
  % extract grid Region
  i=find ( squeeze(lon(:,1)) > lonmin & squeeze(lon(:,1)) < lonmax);
  j=find ( squeeze(lat(1,:)) > latmin & squeeze(lat(1,:)) <latmax);
  
  lon=lon(i,j);
  lat=lat(i,j);
  % use only 31 levels ..below that not much data
  
  if shiftGrid==1
    sustr=perm(nc{'sustr'}(:,:,:));
    svstr=perm(nc{'svstr'}(:,:,:));
    mask= perm(nc{'mask'}(:,:));
    disp(' -- lon/lat shifted');
    mask=rnc_shift_grid(lon1,lat1,mask);
    sustr=rnc_shift_grid(lon1,lat1,sustr);
    svstr=rnc_shift_grid(lon1,lat1,svstr);
    sustr=sustr(i,j,:);
    svstr=svstr(i,j,:);
    mask=mask(i,j,:);
    
  else
  %disp('here')
    sustr=perm(nc{'sustr'}(:,j,i));
    svstr=perm(nc{'svstr'}(:,j,i));
    mask=perm(nc{'mask'}(j,i));

  end
 % size(sustr)
 % size(lon)
 % size(mask)
  mask(mask==0)=nan;
  nc=netcdf(forcfile,'w');
  % add some offset for CCS
  %ncep.lon=ncep.lon+1;
  %ncep.lat=ncep.lat+1;
  [I,J,T]=size(sustr);
  disp('-- QSCATT/NCEP blend forcing');
  for i = 1:T
    disp(['--  timelev ',num2str(i)]);
    %svstr(:,:,i) = rnt_fill(lon,lat,svstr(:,:,i).*mask,4,4);
    sv=interp2((lon)',(lat)', svstr(:,:,i)', ...
       grd.lonr,grd.latr,'cubic');
    
    %sustr(:,:,i) = rnt_fill(lon,lat,sustr(:,:,i).*mask,4,4);
    su=interp2((lon)',(lat)', sustr(:,:,i)', ...
       grd.lonr,grd.latr,'cubic');
    
    [ su, sv ] = rnt_rotate(su,sv,grd.angle);
    sustr_tmp=rnt_2grid(su,'r','u');
    svstr_tmp=rnt_2grid(sv,'r','v');
    
    nc{'svstr'}(i,:,:)=svstr_tmp';
    nc{'sustr'}(i,:,:)=sustr_tmp';
  end
  close (nc);
  disp(' DONE.');
%end
%
qscb.lon=lon;
qscb.lat=lat;
qscb.mask=mask;
qscb.sustr=sustr;
qscb.svstr=svstr;
