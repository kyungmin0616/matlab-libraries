
function [field, lon,lat]=rnc_shift_grid(lon,lat,field)
% function [lon,lat,field]=rnc_shift_grid(lon,lat,field)
%   shift fields from a grid on 
%   LON -360 0
% to 
%   LON -180 +180
%
% E. Di Lorenzo (edl@ucsd.edu)

l1=lon(:,1);
in=find(l1 < -180);
l1(in) =l1(in) + 360;
inpos=find(l1 >=0);
inneg=find(l1 < 0);
[I,J]=size(lon);
lon=repmat(l1,[1 J]);



lon=ShiftMatrix(lon,inpos,inneg);
lat=ShiftMatrix(lat,inpos,inneg);
field=ShiftMatrix(field,inpos,inneg);

return
  
  
  

function l2= ShiftMatrix(l1,inpos,inneg)
l2=l1*nan;
I=length(inneg);
l2(1:I,:,:) = l1(inneg,:,:);
l2(I+1:end,:,:) = l1(inpos,:,:);
return



 
 
 
 
