
function [I,J] = rgrd_FindPoint(grd,n)
%function [I,J] = rgrd_FindPoint(grd,n)

if ~isfield(grd, 'lonr')
   grd.lonr=grd.lon;
   grd.latr=grd.lat;
end

[x,y] = ginput(n);
for k=1:length(x)

   dist = (grd.lonr - x(k)).^2 + (grd.latr - y(k)).^2;
   [It,Jt]=find( dist ==  min(dist(:)));
   plot(grd.lonr(It,Jt), grd.latr(It,Jt), '*k');
   I(k) = It;
   J(k) = Jt;
end   
   
