function  levitus = rnc_LevitusClima(grd,clmfile,updateClima, varargin);
% Compute levitus climatology for grid specified in grd.
% If updateClima == 1 then write and interpolate the climatology
% into the clmfile.

    
    z_r=rnt_setdepth(0,grd);

file = which('LevitusTS_monthly.nc');
in=find(grd.lonr > 0);
if length(in) > 0
disp('GreenW convention');
file = which('LevitusTS_monthlyGreenW.nc');
end
in=find(grd.lonr > 182);
if length(in) > 0
  error 'The climatologies available do not cover this long. range'
end

MONTHS=1:12;

if nargin > 3
  MONTHS=varargin{1};
  disp(['Doing Months: ',num2str(MONTHS)]);
end

nc = netcdf(file);
lon=nc{'lon'}(:);
lat=nc{'lat'}(:);
z=nc{'z'}(:);

    lonmin = min(grd.lonr(:))-4;
    lonmax = max(grd.lonr(:))+4;
    latmin = min(grd.latr(:))-4;
    latmax = max(grd.latr(:))+4;

% nw sw se ne
%corn.lon = [grd.lonr(1,end) grd.lonr(1,1) grd.lonr(end,1) grd.lonr(end,end)]';
%corn.lat = [grd.latr(1,end) grd.latr(1,1) grd.latr(end,1) grd.latr(end,end)]';

% extract Southern California Region
  i=find ( squeeze(lon(:,1)) > lonmin & squeeze(lon(:,1)) < lonmax);
  j=find ( squeeze(lat(1,:)) > latmin & squeeze(lat(1,:)) <latmax);

  lon=lon(i,j);
  lat=lat(i,j);
  % use only 31 levels ..below that not much data
  temp=nc{'temp'}(i,j,1:31,:);
  salt=nc{'salt'}(i,j,1:31,:);
  z=z(1:31);
  close(nc);
  [I,J,K,T]=size(temp);
  mask=zeros(I,J,K,T)*nan;
  mask_tmp=zeros(I,J);
 
    for it=MONTHS
    	disp(['  -- time level ',num2str(it)]);   
    for k=1:length(z)
	disp(['  -- vert level ',num2str(k)]);   
	  tmp=temp(:,:,k,it);
	  mask_tmp(:)=NaN; mask_tmp(~isnan(tmp))=1;
	  mask(:,:,k,it)=mask_tmp;	  
    temp(:,:,k,it)=rnt_fill(lon,lat,temp(:,:,k,it),3,3);
	  salt(:,:,k,it)=rnt_fill(lon,lat,salt(:,:,k,it),3,3);
     end
     end
     
     z(end+1)=7000;
     temp(:,:,end+1,:)=temp(:,:,end,:);
     salt(:,:,end+1,:)=salt(:,:,end,:);  
     mask(:,:,end+1,:)=mask(:,:,end,:);  
     
     levitus.lon=lon;
     levitus.lat=lat;
     levitus.temp=temp;
     levitus.salt=salt;
     levitus.mask=mask;
     levitus.z=z;
     

if updateClima ==1

   nc=netcdf(clmfile,'w');
    for it=MONTHS
    	disp(['  -- time level ',num2str(it)]);   
    for k=1:length(z)	
        tempgr(:,:,k)=interp2(lon',lat',temp(:,:,k,it)',grd.lonr,grd.latr,'cubic');
        saltgr(:,:,k)=interp2(lon',lat',salt(:,:,k,it)',grd.lonr,grd.latr,'cubic');
     end
     disp ('Updating ...');
     tmp=rnt_2s(tempgr,z_r,z);
     nc{'temp'}(it,:,:,:) = permute(tmp,[3 2 1 ]);
     tmp=rnt_2s(saltgr,z_r,z);
     nc{'salt'}(it,:,:,:) = permute(tmp,[3 2 1 ]);
     
     end
end     
     
     
   
   
