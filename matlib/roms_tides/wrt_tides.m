function [Vname,status]=wrt_tides(Fname,Tide);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2000 Rutgers University.                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Hernan G. Arango %%%
%                                                                           %
% function [Vname,status]=wrt_tides(Fname,Tide)                             %
%                                                                           %
% This function writes tide data to an existing FORCING NetCDF file.        %
%                                                                           %
% On Input:                                                                 %
%                                                                           %
%    Fname       FORCING NetCDF file name (string).                         %
%    Tide        Tide data (structure array):                               %
%                   Tide.period => Tidal angular period.                    %
%                   Tide.Ephase => Tidal elevation phase angle.             %
%                   Tide.Eamp   => Tidal elevation amplitude.               %
%                   Tide.Cphase => Tidal current phase angle.               %
%                   Tide.Cangle => Tidal current inclination angle.         %
%                   Tide.Cmin   => Minimum tidal current, semi-minor axis.  %
%                   Tide.Cmax   => Maximum tidal current, semi-major axis.  %
%                                                                           %
% On Output:                                                                %
%                                                                           %
%    Vname       Names of tide variables (structure array).                 %
%    status      Error flag.                                                %
%                                                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global IPRINT
IPRINT=0;

%----------------------------------------------------------------------------
%  Get some NetCDF parameters.
%----------------------------------------------------------------------------

[ncglobal]=mexcdf('parameter','nc_global');
[nclong]=mexcdf('parameter','nc_long');
[ncdouble]=mexcdf('parameter','nc_double');
[ncunlim]=mexcdf('parameter','nc_unlimited');
[ncfloat]=mexcdf('parameter','nc_float');
[ncchar]=mexcdf('parameter','nc_char');

%----------------------------------------------------------------------------
%  Inquire about dimensions.
%----------------------------------------------------------------------------

[Ntides]=length(Tide.period);

gotDim.xr  =0;  Dname.xr   ='xi_rho';
gotDim.yr  =0;  Dname.yr   ='eta_rho';
gotDim.Tide=0;  Dname.Tide ='tide_period';  Dsize.Tide=Ntides;

[Dnames,Dsizes]=nc_dim(Fname);
ndims=length(Dsizes);
for n=1:ndims,
  dimid=n-1;
  name=deblank(Dnames(n,:));
  switch name
  case {Dname.xr}
    Dsize.xr=Dsizes(n);
    did.xr=dimid;
    gotDim.xr=1;
  case {Dname.yr}
    Dsize.yr=Dsizes(n);
    did.yr=dimid;
    gotDim.yr=1;
  case {Dname.Tide}
    Dsize.Tide=Dsizes(n);
    did.Tide=dimid;
    gotDim.Tide=1;    
  end,
end,
%----------------------------------------------------------------------------
%  Inquire variables.
%----------------------------------------------------------------------------

got.period=0;  Vname.period='tide_period';
got.Cphase=0;  Vname.Cphase='tide_Cphase';
got.Cangle=0;  Vname.Cangle='tide_Cangle';
got.Cmax  =0;  Vname.Cmax  ='tide_Cmax';
got.Cmin  =0;  Vname.Cmin  ='tide_Cmin';
got.Eamp  =0;  Vname.Eamp  ='tide_Eamp';
got.Ephase=0;  Vname.Ephase='tide_Ephase';

[varnam,nvars]=nc_vname(Fname);
for n=1:nvars,
  name=deblank(varnam(n,:));
  switch name
    case {Vname.period}
      got.period=1;
    case {Vname.Cphase}
      got.Cphase=1;
    case {Vname.Cangle}
      got.Cangle=1;
    case {Vname.Cmax}
      got.Cmax=1;
    case {Vname.Cmin}
      got.Cmin=1;
    case {Vname.Eamp}
      got.Eamp=1;
    case {Vname.Ephase}
      got.Ephase=1;
  end,
end,

%----------------------------------------------------------------------------
%  Open FORCING NetCDF file and put it in definition mode.
%----------------------------------------------------------------------------

defmode=0;

if (~gotDim.Tide),
  [ncid]=mexcdf('ncopen',Fname,'nc_write');
  if (ncid == -1),
    error(['WRT_TIDES: ncopen - unable to open file: ', Fname])
    return
  end
  [status]=mexcdf('ncredef',ncid);
  if (status == -1),
    error(['WRT_TIDES: ncrefdef - unable to put into define mode.'])
    return
  end
  defmode=1;
end,

%----------------------------------------------------------------------------
%  If appropriate, define tide dimension.
%----------------------------------------------------------------------------

if (~gotDim.Tide),
  [did.Tide]=mexcdf('ncdimdef',ncid,Dname.Tide,Dsize.Tide);
  if (did.Tide == -1),
    error(['WRT_TIDES: ncdimdef - unable to define dimension: ', ...
           Dname.Tide]);
  end,
end,

%----------------------------------------------------------------------------
%  Define tide variables.
%----------------------------------------------------------------------------

if (~got.period),
  Var.name =Vname.period;
  Var.type =ncdouble;
  Var.dimid=[did.Tide];
  Var.long ='tide angular period';
  Var.units='hours';
  Var.field=[Vname.period,', scalar'];
  [varid,status]=nc_vdef(ncid,Var);
  clear Var
end,

if (~got.Ephase),
  Var.name =Vname.Ephase;
  Var.type =ncdouble;
  Var.dimid=[did.Tide did.yr did.xr];
  Var.long ='tidal elevation phase angle';
  Var.units='degrees, time of maximum elevation with respect chosen time origin';
  Var.field=[Vname.Ephase,', scalar'];
  [varid,status]=nc_vdef(ncid,Var);
  clear Var
end,

if (~got.Eamp),
  Var.name =Vname.Eamp;
  Var.type =ncdouble;
  Var.dimid=[did.Tide did.yr did.xr];
  Var.long ='tidal elevation amplitude';
  Var.units='meter';
  Var.field=[Vname.Eamp,', scalar'];
  [varid,status]=nc_vdef(ncid,Var);
  clear Var
end,

if (~got.Cphase),
  Var.name =Vname.Cphase;
  Var.type =ncdouble;
  Var.dimid=[did.Tide did.yr did.xr];
  Var.long ='tidal current phase angle';
  Var.units='degrees, time of maximum velocity with respect chosen time origin';
  Var.field=[Vname.Cphase,', scalar'];
  [varid,status]=nc_vdef(ncid,Var);
  clear Var
end,

if (~got.Cangle),
  Var.name =Vname.Cangle;
  Var.type =ncdouble;
  Var.dimid=[did.Tide did.yr did.xr];
  Var.long ='tidal current inclination angle';
  Var.units='degrees between semi-major axis and East';
  Var.field=[Vname.Cangle,', scalar'];
  [varid,status]=nc_vdef(ncid,Var);
  clear Var
end,

if (~got.Cmin),
  Var.name =Vname.Cmin;
  Var.type =ncdouble;
  Var.dimid=[did.Tide did.yr did.xr];
  Var.long ='minimum tidal current, ellipse semi-minor axis';
  Var.units='meter second-1';
  Var.field=[Vname.Cmin,', scalar'];
  [varid,status]=nc_vdef(ncid,Var);
  clear Var
end,

if (~got.Cmax),
  Var.name =Vname.Cmax;
  Var.type =ncdouble;
  Var.dimid=[did.Tide did.yr did.xr];
  Var.long ='maximum tidal current, ellipse semi-major axis';
  Var.units='meter second-1';
  Var.field=[Vname.Cmax,', scalar'];
  [varid,status]=nc_vdef(ncid,Var);
  clear Var
end,

%----------------------------------------------------------------------------
%  Leave definition mode.
%----------------------------------------------------------------------------

if (defmode),
  [status]=mexcdf('ncendef',ncid);
  if (status == -1),
    error(['WRT_TIDES: ncendef - unable to leave definition mode.'])
  end,
  [status]=mexcdf('ncclose',ncid);
  if (status == -1),
    error(['WRT_TIDES: ncclose - unable to close NetCDF file: ', Iname])
  end
end,

%----------------------------------------------------------------------------
%  Write out tide data.
%----------------------------------------------------------------------------

if (isfield(Tide,'period')),
  [status]=nc_write(Fname,Vname.period,Tide.period);
end,

if (isfield(Tide,'Ephase')),
  ind=isnan(Tide.Ephase);
  if (~isempty(ind)), Tide.Ephase(ind)=0; end,
  [status]=nc_write(Fname,Vname.Ephase,Tide.Ephase);
end,

if (isfield(Tide,'Eamp')),
  ind=isnan(Tide.Eamp);
  if (~isempty(ind)), Tide.Eamp(ind)=0; end,
  [status]=nc_write(Fname,Vname.Eamp,Tide.Eamp);
end,

if (isfield(Tide,'Cphase')),
  ind=isnan(Tide.Cphase);
  if (~isempty(ind)), Tide.Cphase(ind)=0; end,
  [status]=nc_write(Fname,Vname.Cphase,Tide.Cphase);
end,

if (isfield(Tide,'Cangle')),
  ind=isnan(Tide.Cangle);
  if (~isempty(ind)), Tide.Cangle(ind)=0; end,
  [status]=nc_write(Fname,Vname.Cangle,Tide.Cangle);
end,

if (isfield(Tide,'Cmin')),
  ind=isnan(Tide.Cmin);
  if (~isempty(ind)), Tide.Cmin(ind)=0; end,
  [status]=nc_write(Fname,Vname.Cmin,Tide.Cmin);
end,

if (isfield(Tide,'Cmax')),
  ind=isnan(Tide.Cmax);
  if (~isempty(ind)), Tide.Cmax(ind)=0; end
  [status]=nc_write(Fname,Vname.Cmax,Tide.Cmax);
end,

return
