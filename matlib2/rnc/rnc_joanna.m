grd=rnt_gridload('northsea');
grd.inside = find(~isnan(grd.maskr));

file=which('janssen_climatology.nc');
nc = netcdf(file);
lon=nc{'lon'}(:)';
lat=nc{'lat'}(:)';
[lon,lat]=meshgrid(lon,lat);
lon=lon';
lat=lat';
z=nc{'z'}(:);
/wd3/edl/d6/ROMS-pak/northsea-data/Main_NorthSea.m
% example of OA
% load temperature
temp=nc{'temp'}(1,1,:,:)';temp(temp< -999)=nan;
% find ocean points
inside = find(~isnan(temp)); I1=inside; I2=grd.inside;
% do 1st OA
disp('Computing 1st OA and saving PMAP')
tic
[tmp,err,pmap]=rnt_oa2d(lon(I1),lat(I1),temp(I1),grd.lonr(I2),grd.latr(I2),5,5);
toc
disp('Computing another OA using the saved PMAP');
tic
[tmp,err]=rnt_oa2d(lon(I1),lat(I1),temp(I1),grd.lonr(I2),grd.latr(I2),5,5,pmap,10);
toc

% now put the ocean points back into the matrix
temp_model=grd.lonr*nan; temp_model(I2) = tmp;
%plot the field
figure;
rnt_plcm(temp_model,grd)
title 'JAN SST'
print -djpeg100 JAN-SST.jpg
return

%below is a loop to do all the fields.

[I,J]=size(grd.lonr);
tempZ=zeros(I,J,18);

for iz=1:18
  for it=1:12
    
    temp=nc{'temp'}(it,iz,:,:)';
    temp(temp< -999)=nan;
    inside = find(~isnan(temp));
    disp(['Doing time ... ',num2str(it)]);
    I1=inside;
    I2=grd.inside;
    if it==1
      [tmp,err,pmap]=rnt_oa2d(lon(I1),lat(I1),temp(I1),grd.lonr(I2),grd.latr(I2),5,5);
    else
      [tmp,err]=rnt_oa2d(lon(I1),lat(I1),temp(I1),grd.lonr(I2),grd.latr(I2),5,5,pmap,10);
    end
    tmp2=grd.lonr*nan; tmp2(I2) = tmp;
    tempZ(:,:,iz,it)=tmp2;
    
    
  end
end

%[tmp,err]=rnt_oa2d(lon,lat(inside),temp(inside),grd.lonr(II),grd.latr(II),5,5);
%[tmp,Ipos,Jpos]=rnt_griddata(lon,lat,temp,grd.lonr,grd.latr,'cubic');
%[tmp,Ipos,Jpos]=rnt_griddata(lon,lat,temp,grd.lonr,grd.latr,'cubic',Ipos,Jpos);
%pmap=rnt_oapmap(lon,lat,temp,grd.lonr,grd.latr,10);

