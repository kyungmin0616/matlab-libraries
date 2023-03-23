function  levitus = rnc_LevitusClima(grd,clmfile,updateClima);
% function  levitus = rnc_LevitusClima(grd,clmfile,updateClima);
% Compute levitus climatology for grid specified in grd.
% If updateClima == 1 then write and interpolate the climatology
% into the clmfile.
%  E. Di Lorenzo (edl@ucsd.edu)
  
  
  






    file=which('LevitusTS_monthly.nc');
    nc = netcdf(file);
    lon=nc{'lon'}(:)';
    lat=nc{'lat'}(:)';
    z=nc{'z'}(:);
    z=z(1:31);
    
    K=length(z);
    
    % find if there are positive values in grd.lonr;
    in=find(grd.lonr(:) > 0);
    if length(in) > 1
      %need to shift the levitus grid
      lon(:,1:179)=lon(:,1:179)+360;
	disp('The levitus data is on LON -360 to 0 - grid is not');
    end
    
    lonmin = min(grd.lonr(:))-2;
    lonmax = max(grd.lonr(:))+2;
    latmin = min(grd.latr(:))-2;
    latmax = max(grd.latr(:))+2;
    
    [levitus.lon,levitus.lat]=meshgrid(lonmin:lonmax,latmin:latmax);
    levitus.lon=levitus.lon';    levitus.lat=levitus.lat';

    [I,J]=size(levitus.lon);
    levitus.temp=zeros(I,J,K,12);
    levitus.salt=zeros(I,J,K,12);

    % use only 31 levels ..below that not much data
    
%==========================================================
%	    % compute indices and erromaps to begin with
%==========================================================
    mask = permute(nc{'temp'}(:,:,1,1),[2 1 3 4]);
    pmap=rnt_oapmap(lon,lat,mask,levitus.lon,levitus.lat,10);
    
    [tmp,err]    =rnt_oa2d    (        lon,        lat,    mask, ...
                               levitus.lon,levitus.lat, 1,1,pmap,10);
					 
    [F,Ipos,Jpos]=rnt_griddata(levitus.lon,levitus.lat,    err , ...
                                  grd.lonr,   grd.latr,  'cubic');
    

    % find ocean points in model grid 
    in=find(~isnan(grd.maskr));

%==========================================================
%	    % find decorrelation lenght scale to reduce error
%==========================================================    
    maxerr=1;
    degrad=0;
    
    while maxerr > 0.5
      degrad=degrad+1;
      [tmp,err]=rnt_oa2d(lon,lat,mask,levitus.lon,levitus.lat, ...
                          degrad,degrad,pmap,10);
      
	[err]=rnt_griddata(levitus.lon,levitus.lat,err, ...
         grd.lonr,grd.latr,'cubic',Ipos,Jpos);
      maxerr=max(err(in));
    end
    disp('To keep OA error below 0.5');
    disp(['Decorrelation lenght scale set to DEG: ',num2str(degrad)]);
    degrad=degrad+2;

    

%==========================================================
%	do interpolation    LEVITUS on intermidiate grid
%==========================================================


for k=1:length(z)
disp(['  -- vert level ',num2str(k)]);
disp(['  -- time level ']);
for it=1:12
disp(['  --            ',num2str(it)]);
% -----------------------------------------------------------------
	tmp = permute(nc{'temp'}(:,:,k,it),[2 1 3 4]);
	if it==1 
	   [tmp,err]=rnt_oa2d(lon,lat,tmp,levitus.lon,levitus.lat,degrad,degrad); 
	   tmp(err>0.5)=nan;
	   levitus.temp(:,:,k,it)=tmp;
	else	
	   [tmp,err]=rnt_oa2d(lon,lat,tmp,levitus.lon,levitus.lat,degrad,degrad,pmap,10);
	   tmp(err>0.5)=nan;
	   levitus.temp(:,:,k,it)=tmp;
	end


      tmp = permute(nc{'salt'}(:,:,k,it),[2 1 3 4]);
	[tmp,err]=rnt_oa2d(lon,lat,tmp,levitus.lon,levitus.lat,degrad,degrad,pmap,10);
	tmp(err>0.5)=nan;
	levitus.salt(:,:,k,it)=tmp;

% -----------------------------------------------------------------
end
end 
levitus.z=z;
close(nc);


if updateClima ==1
rnc_UpdateLevitusClima(grd,clmfile,levitus);
end

