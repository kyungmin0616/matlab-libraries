function [OUTstr]=ctana_reduceres(INstr,xfac,yfac,varib);

nanmean_oper=0;

[nlon,nlat,ntime]=size(INstr.fld);

% rx=1.25;
% ry=1;
% dx=2; % smooth SST into nx by ny bins, (dx and dy are in degree)
% dy=2;
% nx=round(dx/rx);
% ny=round(dy/ry);

nx=xfac;
ny=yfac;


f=getfield(INstr,varib);

lonl=INstr.lon(:,1); latl=INstr.lat(1,:);
varfld = nan(nlon/nx, nlat/ny,ntime) ;

lon2 = nan(nlon/nx,1) ;
lat2 = nan(nlat/ny,1) ;
for i = 1:nlon/nx ;
    indx = nx*(i-1)+[1:nx] ;
    lon2(i) = mean(lonl(indx)) ;
    for j = 1:nlat/ny ;
        indy = ny*(j-1)+[1:ny] ;
        if nanmean_oper;
            OUTstr.fld(i,j,:) = nanmean(nanmean(f(indx,indy,:), 1), 2);
            OUTstr.mask(i,j) = nanmean(nanmean(INstr.mask(indx,indy), 1), 2);
        else
            OUTstr.fld(i,j,:) = mean(mean(f(indx,indy,:), 1), 2);
            OUTstr.mask(i,j) = mean(mean(INstr.mask(indx,indy), 1), 2);
        end
        lat2(j) = mean(latl(indy)) ;
    end
    %if mod(i,20)==0,disp(i),end
end
[LAT2,LON2]=meshgrid(lat2,lon2);


OUTstr.lon=LON2;
OUTstr.lat=LAT2;
OUTstr.datenum=INstr.datenum;


