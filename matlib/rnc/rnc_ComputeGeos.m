
function lev=rnc_ComputeGeos(lev);
% function levitus=rnc_ComputeGeos(levitus)
% compute geostrophy from levitus data contained in levitus struct.
% array
%
% E. Di Lorenzo (edl@ucsd.edu)

lon=lev.lon;
lat=lev.lat;
z=lev.z;
g=9.81;
rho0=1025;
[I,J,K,T]=size(lev.temp);
K=length(z);

%==========================================================
%	PRESSURE
%==========================================================
  
  press=zeros(I,J,K,T);
      
  for it=1:T
    %load TS
    
    % compute and store pressure field.
    
    for k=2:K
      disp(['--  computing pressure lev ',num2str(k)]);      

	temp=lev.temp(:,:,k,it) .* lev.mask(:,:,k,it);
	salt=lev.salt(:,:,k,it) .* lev.mask(:,:,k,it);	
	Z = ones(I,J)*z(k);
      rhok  =rnt_rho_eos( temp, salt , Z );

	temp=lev.temp(:,:,k-1,it) .* lev.mask(:,:,k-1,it);
	salt=lev.salt(:,:,k-1,it) .* lev.mask(:,:,k-1,it);	      
	Z = ones(I,J)*z(k-1);
	rhokm =rnt_rho_eos( temp, salt , Z );
	
	
	dZ= abs(z(k-1)-z(k));
      press(:,:,k,it)= press(:,:,k-1,it)+ g*[rhok+rhokm]/2 *dZ;
    end
  end
  lev.press=press;



%==========================================================
%	UV
%==========================================================
  % compute and store U V geos relative to z=0;
  dX=rnt_earthdist(lon(2:end,:) , lat(2:end,:) , lon(1:end-1,:) , lat(1:end-1,:));
  dY=rnt_earthdist(lon(:,2:end) , lat(:,2:end) , lon(:,1:end-1) , lat(:,1:end-1));
  % avoid equatorial lats.
  mylat=lat;
  in=find(mylat < 5 & mylat >=0);
  mylat(in) =5;
  in=find(mylat > -5 & mylat <=0);
  mylat(in) =-5;
  f=(4*pi/86400)*sin(mylat*pi/180);
  

  lev.ugeo=zeros(I,J,K,T);
  lev.vgeo=zeros(I,J,K,T);
    
  for it=1:T

    inan=find(abs(lat) < 1);
    inan2=find(abs(lat) > 85);
    
    % scale factors for u and v
    cff=1./f/(rho0);
    cffV=[cff(2:end,:) + cff(1:end-1,:)]/2;
    cffU=[cff(:,2:end) + cff(:,1:end-1)]/2;
    
    for k=2:K
      disp(['--  computing UV geo lev ',num2str(k)]);
      press = lev.press(:,:,k,it);
      press(inan) =nan;
      press(inan2) =nan;
      
      vgeo =  cffV.*[press(2:end,:) - press(1:end-1,:)]./dX;
      ugeo = -cffU.*[press(:,2:end) - press(:,1:end-1)]./dY;
      
      tmp  =  [ugeo(:,2:end) + ugeo(:,1:end-1)]/2;
      ugeo=zeros(I,J)*nan;
      ugeo(:,2:end-1)=tmp;
      ugeo(:,end) = ugeo(:,end-1);
      ugeo(:,1  ) = ugeo(:,1  +1);
      
      tmp  =  [vgeo(2:end,:) + vgeo(1:end-1,:)]/2;
      vgeo=zeros(I,J)*nan;
      vgeo(2:end-1,:)=tmp;
      vgeo(end,:) = ugeo(end-1,:);
      vgeo(1  ,:) = ugeo(1  +1,:);
      
      
      lev.ugeo(:,:,k,it) = ugeo;
      lev.vgeo(:,:,k,it) = vgeo;
    end
  end
  
  
  % fill the nan values
  for it =1:T
  disp(['--  filling NaN for U,V P   timelev ',num2str(it)]);
  for k =1:length(z)
  disp(['--                     klev ',num2str(k)]);
	  lev.ugeo(:,:,k,it)=rnt_fill(lon,lat,lev.ugeo(:,:,k,it),5,5);
	  lev.vgeo(:,:,k,it)=rnt_fill(lon,lat,lev.vgeo(:,:,k,it),5,5);
	  lev.press(:,:,k,it)=rnt_fill(lon,lat,lev.press(:,:,k,it),5,5);
  end
  end

return

