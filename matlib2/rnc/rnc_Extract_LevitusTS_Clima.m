function  levitus =  rnc_Extract_Levitus_Clima(lonr,latr, mydatenum, type);
%function  levitus =  rnc_Extract_Levitus_Clima(lonr,latr, mydatenum, type);
% need to write some more info.... but it works
% Compute levitus climatology for grid specified in grd.
% If updateClima == 1 then write and interpolate the climatology
% into the clmfile.

grd.lonr=lonr;
grd.latr=latr;    

file = which('LevitusTS_monthly.nc');
in=find(grd.lonr > 0);
if length(in) > 0
file = which('LevitusTS_monthlyGreenW.nc');
end
in=find(grd.lonr > 182);
if length(in) > 0
  error 'The climatologies available do not cover this long. range'
end


nc = netcdf(file);
lon=nc{'lon'}(:);
lat=nc{'lat'}(:);
z=nc{'z'}(:);

    lonmin = min(grd.lonr(:))-4;
    lonmax = max(grd.lonr(:))+4;
    latmin = min(grd.latr(:))-4;
    latmax = max(grd.latr(:))+4;
  i=find ( squeeze(lon(:,1)) > lonmin & squeeze(lon(:,1)) < lonmax);
  j=find ( squeeze(lat(1,:)) > latmin & squeeze(lat(1,:)) <latmax);

  lon=lon(i,j);
  lat=lat(i,j);
  % use only 31 levels ..below that not much data
  temp=nc{'temp'}(i,j,1:31,:);
  salt=nc{'salt'}(i,j,1:31,:);
  TEMP=temp;
  SALT=salt;
  z=z(1:31);
  close(nc);
  [I,J,K,T]=size(temp);
  mask=zeros(I,J,K,T)*nan;
  mask_tmp=zeros(I,J);
 
  clear temp salt
  if strcmp(type,'surface')
      K=1;
  else
      K=length(z);	
  end
   
    months = str2num(datestr(mydatenum,5));
    for it=1:length(mydatenum)
        imon=months(it);
        disp([' --month ',num2str(imon)]); 
	 
       for k=1:K
	   disp(['      depth = ',num2str(z(k)),'m']);   
	   tmp=TEMP(:,:,k,imon);
	   mask_tmp(:)=NaN; mask_tmp(~isnan(tmp))=1;
	   mask(:,:,k,it)=mask_tmp;	  
         temp(:,:,k,it)=rnt_fill(lon,lat,TEMP(:,:,k,imon),3,3);
	   salt(:,:,k,it)=rnt_fill(lon,lat,SALT(:,:,k,imon),3,3);
     end
     end
     
     if K > 1
     z(end+1)=7000;
     temp(:,:,end+1,:)=temp(:,:,end,:);
     salt(:,:,end+1,:)=salt(:,:,end,:);  
     mask(:,:,end+1,:)=mask(:,:,end,:);  
     levitus.temp=temp;
     levitus.salt=salt;
     levitus.mask=mask;
     levitus.z=z;
     else
       levitus.mask=sq(mask(:,:,1,:));
     end
     
     levitus.lon=lon;
     levitus.lat=lat;
     levitus.SST=sq(temp(:,:,1,:));
     levitus.SSS=sq(salt(:,:,1,:));     
     levitus.datenum=mydatenum;
     
   
    
    
    
       


