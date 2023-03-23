function [f]=ptiles(NtileI,NtileJ,fname,vname);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2003 Rutgers University.                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                           %
% function [f]=ptiles(NtileI,NtileJ,fname,vname)                            %
%                                                                           %
% This function plots the requested field and draws the requested parallel  %
% partition.                                                                %
%                                                                           %
% On Input:                                                                 %
%                                                                           %
%    NtileI      Number of parallel partitions in the I-direction.          %
%    NtileJ      Number of parallel partitions in the J-direction.          %
%    fname       NetCDF file name (character string).                       %
%    vname       NetCDF variable name to read (character string), if not    %
%                specified, it will overlie on current figure.              %
%                                                                           %
% On Output:                                                                %
%                                                                           %
%    f           Field (scalar, matrix or array).                           %
%                                                                           %
% calls:         tile                                                       %
%                                                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%----------------------------------------------------------------------------
% Inquire information from NetCDF file.
%----------------------------------------------------------------------------

% Inquire about file dimensions.

[dnames,dsizes]=nc_dim(fname);

for n=1:length(dsizes),
  name=deblank(dnames(n,:));
  switch name
    case 'xi_rho',
      Im=dsizes(n);
    case 'eta_rho',
      Jm=dsizes(n);
  end,
end,

% Detemine tile partition.

Ntiles=NtileI*NtileJ-1;
Mytile=0:1:Ntiles;

[Istr,Iend,Jstr,Jend]=tile(Im-2,Jm-2,NtileI,NtileJ,Mytile);

%----------------------------------------------------------------------------
%  Read in and plot requested 2D-field.
%----------------------------------------------------------------------------

if (nargin > 3),
  [f]=nc_read(fname,vname);
  pcolor(f'); shading flat;
else
  f=ones([Im Jm]);
end,
  
%  Draw tile boundaries.

hold on;

x=1:1:Im;
y=1:1:Jm;

if (NtileI > 1 ),
  for i=1:NtileI-1,
    s=ones(size(y)).*Iend(i);
    plot(s,y,'k-');
  end,
end,  

if (NtileJ > 1 ),
  for i=1:NtileJ-1,
    j=1+(i-1)*NtileI;
    s=ones(size(x)).*Jend(j);
    plot(x,s,'k-');
  end,
end,

hold off

return

