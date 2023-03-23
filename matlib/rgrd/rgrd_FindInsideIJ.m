
function [I,J] = rgrd_FindInsideIJ(lon1,lat1,lon2,lat2)
% (R)oms (GRD)GRiD toolbox
% 
% FUNCTION [I,J] = rgrd_FindInsideIJ(lon1,lat1,lon2,lat2);
%
% LON2(x,y), LAT2(..) are the coordinates of the bigger grid.
% LON1(x,y), LAT1(..) are the coordinates of the smaller grid, which
% is completely contained into the bigger grid.
%
% The function will find the subset I,J range of the bigger grid
% which contain the smaller grid.
%
%
% RGRD - E. Di Lorenzo (edl@ucsd.edu)

[Ipos,Jpos]=rnt_hindicesTRI(lon1(:),lat1(:),lon2,lat2);
 
I= floor(min(Ipos))-1 : ceil(max(Ipos))+1; 
J= floor(min(Jpos))-1 : ceil(max(Jpos))+1;       
   Irange = [I(1) I(end)];
  Jrange = [J(1) J(end)];
 disp(['I range = ',num2str(Irange)]);
  disp(['J range = ',num2str(Jrange)]);

return

% the code below works only if the parent grid
% is squared in cartesian coordinate. To make the routine
% general we use the above hindices routiune.
    dx=abs(lon2(2,1)-lon2(1,1));
    dx2=abs(lon1(2,1)-lon1(1,1));
    if dx2 > dx, dx=dx2; end

    dy=lat2(1,2)-lat2(1,1);
    dy2=lat1(1,2)-lat1(1,1);
    if dy2 > dy, dy=dy2; end

[Ipos,Jpos]=rnt_hindicesTRI(lon1(:),lat1(:),lon2,lat2);
 
I= floor(min(Ipos))-1 : ceil(max(Ipos))+1; 
J= floor(min(Jpos))-1 : ceil(max(Jpos))+1;       

    lonmin = min(lon1(:))-2*dx;
    lonmax = max(lon1(:))+2*dx;
    latmin = min(lat1(:))-2*dy;
    latmax = max(lat1(:))+2*dy;
 
  I=find ( squeeze(lon2(:,1)) > lonmin & squeeze(lon2(:,1)) < lonmax);
  J=find ( squeeze(lat2(1,:)) > latmin & squeeze(lat2(1,:)) <latmax);
  Irange = [I(1) I(end)];
  Jrange = [J(1) J(end)];
  
  disp(['I range = ',num2str(Irange)]);
  disp(['J range = ',num2str(Jrange)]);
