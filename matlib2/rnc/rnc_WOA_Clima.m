function  woa = rnc_WOA_Clima(grd,varargin);
% Compute woa climatology for grid specified in grd.
% If updateClima == 1 then write and interpolate the climatology
% into the clmfile.

    
%z_r=rnt_setdepth(0,grd);

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

opt.fillval=0;
if nargin  > 1
   optnew = varargin{1};
   f=fieldnames(optnew);
   for i=1:length(f)
     eval(['opt.',f{i},'=optnew.',f{i},';']);
   end
end

if isfield(opt,'months')
  MONTHS=opt.months;
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
  in=find(~isnan(temp));
  mask(in)=1;
 
if opt.fillval==1
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
 end
     z(end+1)=7000;
     temp(:,:,end+1,:)=temp(:,:,end,:);
     salt(:,:,end+1,:)=salt(:,:,end,:);  
     mask(:,:,end+1,:)=mask(:,:,end,:);  
    
      
     woa.lon=lon;
     woa.lat=lat;
     woa.temp=temp(:,:,:,MONTHS);
     woa.salt=salt(:,:,:,MONTHS);
     woa.mask=mask(:,:,:,MONTHS);
     woa.z=z;
     woa.months=MONTHS;
     

   
   
