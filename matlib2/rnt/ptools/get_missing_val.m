function field=get_missing_val(lon,lat,field,tempmask,ro)
%
% remove the masked points of an horizontal gridded slice
%


ismask=(tempmask==0);
isdata=1-ismask;
[M,L]=size(field);
%[lon,lat]=meshgrid(lon,lat);
%
% test if there is data or not
%
if (sum(sum(isdata))==0) 
  disp('no data')
  return
end
if (sum(sum(ismask))==0) 
  disp('no mask')
  return
end
%
% extract the data used to fill the bad values
%
I=find(isdata);
latdata=lat(I);
londata=lon(I);
fielddata=field(I);
%
% get the positions of the masked points
%
I=find(ismask);
lonmask=lon(I);
latmask=lat(I);
%
% perform the oa
%
maskfield= oainterp(londata,latdata,fielddata,lonmask,latmask,ro);
%maskfield=griddata(londata,latdata,fielddata,lonmask,latmask,'nearest');
field(I)=maskfield;
return




