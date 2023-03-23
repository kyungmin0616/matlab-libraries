function [tri,lon,lat,depth,amp,pha]=tide_view(con);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                           %
% function [tri,lon,lat,amp,pha]=tide_view(con)                             %
%                                                                           %
% This function plots tidal elevation amplitude and phase of a particular   %
% constituent from a finite element tidal model (East Coast ADCIRC run).    %
%                                                                           %
% On Input:                                                                 %
%                                                                           %
%    con        Tidal constituent to plot (stream):                         %
%                 con => 'Steady', 'O1', 'K1', 'N2', 'M2', 'S2', 'M4', 'M6' %
%                         (Steady for tidal residual elevation)             %
%                                                                           %
% On Output:                                                                %
%                                                                           %
%    tri        Triangular mesh 3D face matrix.                             %
%    lon        Longitude ot triangle vertexes.                             %
%    lat        Latitude ot triangle vertexes.                              %
%    depth      Depth of the mesh.                                          %
%                                                                           %
% To plot the mesh use:                                                     %
%                                                                           %
%    trimesh(tri,lon,lat,depth); view(2); shading('flat'); colorbar;        %
%                                                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load ADCIRC data.

load adcirc_tide_fix.mat

% Determine index of tidal constituent to plot.

[m,n]=size(names);
iconst=0;
for i=1:m,
  if (strcmp(names(i,1:length(con)),con)),
    iconst=i;
  end,
end ,
if (iconst==0),
  disp(sprintf('The %s constituent is not valid',con))
  return
end,

%----------------------------------------------------------------------------
%  Plot amplitude.
%----------------------------------------------------------------------------

if (strcmp(con,'Steady')),
  amp=elev(:,iconst);
  pha=[];
  trisurf(tri,lon,lat,amp); view(2); shading('flat'); colorbar;
else
  amp=abs(elev(:,iconst));
  subplot(211);
  trisurf(tri,lon,lat,amp); view(2); shading('flat'); colorbar;
end,
title(['Amplitude of ' names(iconst,:) ' (meters)']);
dasp(41); % set aspect ratio for 41 degrees north

%----------------------------------------------------------------------------
%  Plot phase.
%----------------------------------------------------------------------------

if (~strcmp(con,'Steady')),
  pha=180/pi*angle(elev(:,iconst));
  subplot(212);
  trisurf(tri,lon,lat,pha); view(2); shading('flat'); colorbar;
  title(['Greenwich Phase of ' names(iconst,:) ' (degrees)']);
  dasp(41);  % set aspect ratio for 41 degrees north
end,

return
