function DrawCstLine(matfile)
% function DrawCstLine(matfile)
% if opt=1: convert [+0 to 180] to [-360 -180]
% if opt=0; do nothing
%figure;
load(matfile)

opt=0;
if opt ==1;
in=find(lon>=0);
in2=find(lon>=0 & lon <= 2);
lon(in) = lon(in) -360;
lon(in2)=nan;
lat(in2)=nan;
end

plot(lon,lat,'k')

set(gca,'xlim',[min(lon) max(lon)]);
set(gca,'ylim',[min(lat) max(lat)]);
hold on
