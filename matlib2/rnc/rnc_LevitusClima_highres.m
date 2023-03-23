function  levitus = rnc_LevitusClima(grd,clmfile);
% Compute levitus climatology for grid specified in grd.
% If updateClima == 1 then write and interpolate the climatology
% into the clmfile.
  
  
  

    file=which('LevitusTS_monthly.nc');
    nc = netcdf(file);
    lon=nc{'lon'}(:)';
    lat=nc{'lat'}(:)';
    z=nc{'z'}(:);
    z=z(1:31);
    
    % initialize storage arrays    
    [I,J]=size(grd.lonr);
    K=length(z);
    tempZ=zeros(I,J,K,12);
    saltZ=zeros(I,J,K,12);
    
    % find if there are positive values in grd.lonr;
    in=find(grd.lonr(:) > 0);
    if length(in) > 1
      %need to shift the levitus grid
      lon(:,1:179)=lon(:,1:179)+360;
    end
    
    lonmin = min(grd.lonr(:))-2;
    lonmax = max(grd.lonr(:))+2;
    latmin = min(grd.latr(:))-2;
    latmax = max(grd.latr(:))+2;
    
    [levitus.lon,levitus.lat]=meshgrid(lonmin:lonmax,latmin:latmax);
    levitus.lon=levitus.lon';    levitus.lat=levitus.lat';

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

    

%==========================================================
%	do interpolation    
%==========================================================
RecomputePMAP=1;

for iz=1:length(z)
  disp(['  -- vert level ',num2str(iz)]); 
  for it=1:12
  disp(['  -- time level ',num2str(it)]);
      
       
	  temp = permute(nc{'temp'}(:,:,iz,it),[2 1 3 4]);	  
        temp(temp< -999)=nan;
        inside = find(~isnan(temp));   % find ocean points
    	  
    I1=inside;
    mask=grd.maskr;
    if iz==1
      I2=find(~isnan(mask));
    else
      % as you go deeper in the water cloumn just
      % interpolate on the points that are needed
      in = find( abs(grd.h.*mask) < abs(z(iz-1)) );
      mask(in) = nan;
      I2=find(~isnan(mask));
	if length(in) > 1 , RecomputePMAP=1; end
    end
    
    if ~isempty(I2)   %---------------------
      if  isempty(I1)
        warning('CLimatology does not extend deep enought!')
      else
        if it==1 & RecomputePMAP==1
	    RecomputePMAP=0;
          % first OA compute PMAP
          [tmp,err,pmap]=rnt_oa2d(lon(I1),lat(I1),temp(I1), ...
             grd.lonr(I2),grd.latr(I2),degrad,degrad);
        else
          [tmp,err]=rnt_oa2d(lon(I1),lat(I1),temp(I1), ...
             grd.lonr(I2),grd.latr(I2),degrad,degrad,pmap,10);
        end
        tmp2=grd.lonr*nan; tmp2(I2) = tmp;
        tempZ(:,:,iz,it)=tmp2;
        
        salt=nc{'salt'}(:,:,iz,it)';
        salt(salt< -999)=nan;
        [tmp,err]=rnt_oa2d(lon(I1),lat(I1),salt(I1), ...
              grd.lonr(I2),grd.latr(I2),degrad,degrad,pmap,10);
        tmp2=grd.lonr*nan; tmp2(I2) = tmp;
        saltZ(:,:,iz,it)=tmp2;
      end
    end               %---------------------
    
	          
  end
end


    close(nc);
    z(end+1)=7000;
    tempZ(:,:,end+1,:)=tempZ(:,:,end,:);
    saltZ(:,:,end+1,:)=saltZ(:,:,end,:);
    
    clear levitus
    
    levitus.lon=grd.lonr;
    levitus.lat=grd.latr;
    levitus.temp=tempZ;
    levitus.salt=saltZ;
    levitus.z=z;
  
  
    z_r=rnt_setdepth(0,grd);
    
    nc=netcdf(clmfile,'w');
    for it=1:12
      disp(['  -- time level ',num2str(it)]);
      
       disp ('Updating ...');

      tmp=rnt_2s(tempZ(:,:,:,it) ,z_r,-z);
      nc{'temp'}(it,:,:,:) = permute(tmp,[3 2 1 ]);
	
      tmp=rnt_2s(saltZ(:,:,:,it) ,z_r,z);
      nc{'salt'}(it,:,:,:) = permute(tmp,[3 2 1 ]);
    end
   close(nc)
  

