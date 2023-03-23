function vnew = sigmatoz(var,z,depth)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                           %
% function  vnew = sigmatoz(var,z,depth)                                    %
%                                                                           %
% This function interpolate a 3D variable on a horizontal level of constant %
% depth                                                                     %
%                                                                           %
% On Input:                                                                 %
%                                                                           %
%    var     Variable to process (3D matrix).                               %
%    z       Depths (m) of RHO- or W-points (3D matrix).                    %
%    depth   Slice depth (scalar; meters, negative).                        %
%                                                                           %
% On Output:                                                                %
%                                                                           %
%    vnew    Horizontal slice (2D matrix).                                  %
%                                                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[N,Mp,Lp]=size(z);
%
% Find the grid position of the nearest vertical levels
% levs=nb of vert. levels at each grid points (i,j)
% pos ~lower k value at each (i,j) for vert. interp.
%
a=z<depth;
levs=squeeze(sum(a,1));
levs(levs==N)=N-1;
warning off; mask=levs./levs; warning on
[imat,jmat]=meshgrid((1:Lp),(1:Mp));
pos=N*Mp*(imat-1)+N*(jmat-1)+levs;
pos(pos==0)=1; % safety to avoid corner pt. problems
%
% Do the interpolation
%
z1=z(pos+1);
z2=z(pos);
v1=var(pos+1);
v2=var(pos);
vnew=mask.*(((v1-v2)*depth+v2.*z1-v1.*z2)./(z1-z2));
return
