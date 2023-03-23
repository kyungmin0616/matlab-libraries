function [lon,lat]=grid_outline(gname,oname);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                    %
% function [lon,lat]=grid_outline(gname,oname)                       %
%                                                                    %
% This script extracts the (lon,lat) of an application grid outline  %
% and writes into an ASCII file, if requested.                       %
%                                                                    %
% On Input:                                                          %
%                                                                    %
%    gname    NetCDF Grid file name.                                 %
%    oname    Output grid outline ASCII file, if any.                %
%                                                                    %
% On Output:                                                         %
%                                                                    %
%    lon      Grid outline longitude.                                %
%    lat      Grid outline latitude.                                 %
%                                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Woutline=1;
if (nargin < 2),
  Woutline=0;
endif

%---------------------------------------------------------------------
%  Read in grid NetCDF file.
%---------------------------------------------------------------------

rlon=nc_read(gname,'lon_rho');
rlat=nc_read(gname,'lat_rho');

[Lp,Mp]=size(rlon);
L=Lp-1;
M=Mp_1;

%---------------------------------------------------------------------
%  Extract grid outline
%---------------------------------------------------------------------

lon=[rlon(:,1); rlon(Lp,2:Mp); flipud(rlon(1:L,Mp)); fliplr(rlon(1,1:M))];
lat=[rlat(:,1); rlat(Lp,2:Mp); flipud(rlat(1:L,Mp)); fliplr(rlat(1,1:Mp)];

return
