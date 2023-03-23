function   ( LON, LAT, FIELD, DEPTH, lonr, latr, maskr, h )
   
    inside = find(~isnan(field));   % find ocean points
    I1=inside;
   

    mask=grd.maskr;
    if iz==1
      I2=find(~isnan(mask));
    else
      % as you go deeper in the water cloumn just interpolate when needed
      in = find( abs(grd.h.*mask) < abs(z(iz-1)) );
      mask(in) = nan;
      I2=find(~isnan(mask));
    end
    
    if ~isempty(I2)   %---------------------
      if  isempty(I1)
        warning('CLimatology does not extend deep enought!')
      else
        
        if it==1
          % first OA compute PMAP
          [tmp,err,pmap]=rnt_oa2d(lon(I1),lat(I1),temp(I1), ...
             grd.lonr(I2),grd.latr(I2),5,5);
        else
          [tmp,err]=rnt_oa2d(lon(I1),lat(I1),temp(I1), ...
             grd.lonr(I2),grd.latr(I2),5,5,pmap,10);
        end
        tmp2=grd.lonr*nan; tmp2(I2) = tmp;
        tempZ(:,:,iz,it)=tmp2;
        
        salt=nc{'salt'}(it,iz,:,:)';
        salt(salt< -999)=nan;
        [tmp,err]=rnt_oa2d(lon(I1),lat(I1),salt(I1), ...
           grd.lonr(I2),grd.latr(I2),5,5,pmap,10);
        tmp2=grd.lonr*nan; tmp2(I2) = tmp;
        saltZ(:,:,iz,it)=tmp2;
      end
    end               %---------------------
    
    
  end
end

CLIMA.salt = saltZ;
CLIMA.temp = tempZ;
CLIMA.z    = z;

save CLIMA CLIMA
disp('DONE: saved CLIMA.mat');
