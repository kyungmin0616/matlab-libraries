function [z]=xpolygon(Imin,Imax,Jmin,Jmax,Xgrd,Ygrd);

x=[Xgrd(Imin:Imax-1,Jmin)' ...
   Xgrd(Imax,Jmin:Jmax-1)  ...
   Xgrd(Imax:-1:Imin+1,Jmax)' ...
   Xgrd(Imin,Jmax:-1:Jmin)];

y=[Ygrd(Imin:Imax-1,Jmin)' ...
   Ygrd(Imax,Jmin:Jmax-1)  ...
   Ygrd(Imax:-1:Imin+1,Jmax)' ...
   Ygrd(Imin,Jmax:-1:Jmin)];

z=complex(x,y);

return



