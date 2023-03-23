function y=ctana_get_ts(lon,lat,field,boxlimit) 




[I,J]=rgrd_FindIJ(lon,lat,boxlimit(1:2), boxlimit(3:4));
y=sq(nanmean(nanmean(field(I,J,:))));