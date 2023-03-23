function [lon,lat]=grid_outline(Gname,Oname);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                    %
% function [lon,lat]=grid_outline(Gname,Oname)                       %
%                                                                    %
% This script extracts the (lon,lat) of an application grid outline  %
% and writes into an ASCII file, if requested.                       %
%                                                                    %
% On Input:                                                          %
%                                                                    %
%    Gname    NetCDF Grid file name.                                 %
%    Oname    Output grid outline ASCII file, if any.                %
%                                                                    %
% On Output:                                                         %
%                                                                    %
%    lon      Grid outline longitude.                                %
%    lat      Grid outline latitude.                                 %
%                                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

IWRITE=1;
if (nargin < 2),
  IWRITE=0;
end

%---------------------------------------------------------------------
%  Read in grid NetCDF file.
%---------------------------------------------------------------------

rlon=nc_read(Gname,'lon_rho');
rlat=nc_read(Gname,'lat_rho');

[Lp,Mp]=size(rlon);
L=Lp-1;
M=Mp-1;

%---------------------------------------------------------------------
%  Extract grid outline
%---------------------------------------------------------------------

lon=[squeeze(rlon(:,1)); ...
     squeeze(rlon(Lp,2:Mp))'; ...
     squeeze(flipud(rlon(1:L,Mp))); ...
     squeeze(fliplr(rlon(1,1:M)))'];

lat=[squeeze(rlat(:,1)); ...
     squeeze(rlat(Lp,2:Mp))'; ...
     squeeze(flipud(rlat(1:L,Mp))); ...
     squeeze(fliplr(rlat(1,1:M)))'];

%---------------------------------------------------------------------
%  Write out grid outline.
%---------------------------------------------------------------------

if (IWRITE),
  fid=fopen(Oname,'w');
  if (fid < 0),
    error(['Cannot create ' Oname '.']);
  else,  
    spval=999.0;
    fprintf(fid,'%11.6f  %11.6f\n',spval,spval);
    for i=1:length(lon),
      fprintf(fid,'%11.6f  %11.6f\n',lat(i),lon(i));
    end,
    fprintf(fid,'%11.6f  %11.6f\n',spval,spval);
    fclose(fid);
  end,
end,

return
