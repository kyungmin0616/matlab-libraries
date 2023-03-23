function rnc_CreateBryFile(grd,filename, varargin) 
% function rnc_CreateBryFile(grd,filename
%    E. Di Lorenzo (edl@ucsd.edu)
% 


%% ncdump('bry-levitus.nc')   %% Generated 07-Sep-2002 14:30:13
 % Default options
   opt.npzd=0;
   opt.bry_time = 12;
   opt.bry_time_cycle=360;
   opt.ptracer = 0;
   opt.bry_timeVal = [15:30:360];
   forc_timevars{1}='bry_time';

% user defined options to be overwritten
if nargin > 2
   optnew = varargin{1};
   f=fieldnames(optnew);
   for i=1:length(f)
     eval(['opt.',f{i},'=optnew.',f{i},';']);
   end
end      

nc = netcdf(filename, 'clobber');
if isempty(nc), return, end
 
%% Global attributes:

nc.title = ncchar('');
nc.history = ncchar('BOUNDARY file, 1.0  ');
nc.type = ncchar('BOUNDARY FORCING file');
nc.source = ncchar('');
nc.out_file = ncchar('');
nc.grd_file = ncchar('');
 
%% Dimensions:
nc('xi_rho') = grd.Lp;
nc('xi_u') = grd.L;
nc('xi_v') = grd.Lp;
nc('eta_rho') = grd.Mp;
nc('eta_u') = grd.Mp;
nc('eta_v') = grd.M;
nc('s_rho') = grd.N;
nc('s_w') = grd.N+1;

nc('bry_time') = opt.bry_time; %% (record dimension)
 
%% Variables and attributes:
 
nc{'bry_time'} = ncdouble('bry_time'); %% 12 elements.
nc{'bry_time'}.long_name = ncchar('open boundary conditions time');
nc{'bry_time'}.units = ncchar('days since 0000-01-01 00:00:00');
if opt.bry_time_cycle ~=0
nc{'bry_time'}.cycle_length = ncdouble(opt.bry_time_cycle);
end
nc{'bry_time'}.field = ncchar('bry_time, scalar, series');
 
nc{'zeta_west'} = ncdouble('bry_time', 'eta_rho'); %% 1440 elements.
nc{'zeta_west'}.long_name = ncchar('free-surface western boundary condition');
nc{'zeta_west'}.units = ncchar('meter');
nc{'zeta_west'}.field = ncchar('zeta_west, scalar, series');
nc{'zeta_west'}.time = ncchar('bry_time');

nc{'zeta_east'} = ncdouble('bry_time', 'eta_rho'); %% 1440 elements.
nc{'zeta_east'}.long_name = ncchar('free-surface eastern boundary condition');
nc{'zeta_east'}.units = ncchar('meter');
nc{'zeta_east'}.field = ncchar('zeta_east, scalar, series');
nc{'zeta_east'}.time = ncchar('bry_time');
 
nc{'zeta_south'} = ncdouble('bry_time', 'xi_rho'); %% 960 elements.
nc{'zeta_south'}.long_name = ncchar('free-surface southern boundary condition');
nc{'zeta_south'}.units = ncchar('meter');
nc{'zeta_south'}.field = ncchar('zeta_south, scalar, series');
nc{'zeta_south'}.time = ncchar('bry_time');
 
nc{'zeta_north'} = ncdouble('bry_time', 'xi_rho'); %% 960 elements.
nc{'zeta_north'}.long_name = ncchar('free-surface northern boundary condition');
nc{'zeta_north'}.units = ncchar('meter');
nc{'zeta_north'}.field = ncchar('zeta_north, scalar, series');
nc{'zeta_north'}.time = ncchar('bry_time');
 
nc{'ubar_west'} = ncdouble('bry_time', 'eta_u'); %% 1440 elements.
nc{'ubar_west'}.long_name = ncchar('2D u-momentum western boundary condition');
nc{'ubar_west'}.units = ncchar('meter second-1');
nc{'ubar_west'}.field = ncchar('ubar_west, scalar, series');
nc{'ubar_west'}.time = ncchar('bry_time');

nc{'ubar_east'} = ncdouble('bry_time', 'eta_u'); %% 1440 elements.
nc{'ubar_east'}.long_name = ncchar('2D u-momentum eastern boundary condition');
nc{'ubar_east'}.units = ncchar('meter second-1');
nc{'ubar_east'}.field = ncchar('ubar_east, scalar, series');
nc{'ubar_east'}.time = ncchar('bry_time');
 
nc{'ubar_south'} = ncdouble('bry_time', 'xi_u'); %% 948 elements.
nc{'ubar_south'}.long_name = ncchar('2D u-momentum southern boundary condition');
nc{'ubar_south'}.units = ncchar('meter second-1');
nc{'ubar_south'}.field = ncchar('ubar_south, scalar, series');
nc{'ubar_south'}.time = ncchar('bry_time');
 
nc{'ubar_north'} = ncdouble('bry_time', 'xi_u'); %% 948 elements.
nc{'ubar_north'}.long_name = ncchar('2D u-momentum northern boundary condition');
nc{'ubar_north'}.units = ncchar('meter second-1');
nc{'ubar_north'}.field = ncchar('ubar_north, scalar, series');
nc{'ubar_north'}.time = ncchar('bry_time');
 
nc{'vbar_west'} = ncdouble('bry_time', 'eta_v'); %% 1428 elements.
nc{'vbar_west'}.long_name = ncchar('2D v-momentum western boundary condition');
nc{'vbar_west'}.units = ncchar('meter second-1');
nc{'vbar_west'}.field = ncchar('vbar_west, scalar, series');
nc{'vbar_west'}.time = ncchar('bry_time');

nc{'vbar_east'} = ncdouble('bry_time', 'eta_v'); %% 1428 elements.
nc{'vbar_east'}.long_name = ncchar('2D v-momentum eastern boundary condition');
nc{'vbar_east'}.units = ncchar('meter second-1');
nc{'vbar_east'}.field = ncchar('vbar_east, scalar, series');
nc{'vbar_east'}.time = ncchar('bry_time');
 
nc{'vbar_south'} = ncdouble('bry_time', 'xi_v'); %% 960 elements.
nc{'vbar_south'}.long_name = ncchar('2D v-momentum southern boundary condition');
nc{'vbar_south'}.units = ncchar('meter second-1');
nc{'vbar_south'}.field = ncchar('vbar_south, scalar, series');
nc{'vbar_south'}.time = ncchar('bry_time');
 
nc{'vbar_north'} = ncdouble('bry_time', 'xi_v'); %% 960 elements.
nc{'vbar_north'}.long_name = ncchar('2D v-momentum northern boundary condition');
nc{'vbar_north'}.units = ncchar('meter second-1');
nc{'vbar_north'}.field = ncchar('vbar_north, scalar, series');
nc{'vbar_north'}.time = ncchar('bry_time');
 
nc{'u_west'} = ncdouble('bry_time', 's_rho', 'eta_u'); %% 28800 elements.
nc{'u_west'}.long_name = ncchar('3D u-momentum western boundary condition');
nc{'u_west'}.units = ncchar('meter second-1');
nc{'u_west'}.field = ncchar('u_west, scalar, series');
nc{'u_west'}.time = ncchar('bry_time');

nc{'u_east'} = ncdouble('bry_time', 's_rho', 'eta_u'); %% 28800 elements.
nc{'u_east'}.long_name = ncchar('3D u-momentum eastern boundary condition');
nc{'u_east'}.units = ncchar('meter second-1');
nc{'u_east'}.field = ncchar('u_east, scalar, series');
nc{'u_east'}.time = ncchar('bry_time');
 
nc{'u_south'} = ncdouble('bry_time', 's_rho', 'xi_u'); %% 18960 elements.
nc{'u_south'}.long_name = ncchar('3D u-momentum southern boundary condition');
nc{'u_south'}.units = ncchar('meter second-1');
nc{'u_south'}.field = ncchar('u_south, scalar, series');
nc{'u_south'}.time = ncchar('bry_time');
 
nc{'u_north'} = ncdouble('bry_time', 's_rho', 'xi_u'); %% 18960 elements.
nc{'u_north'}.long_name = ncchar('3D u-momentum northern boundary condition');
nc{'u_north'}.units = ncchar('meter second-1');
nc{'u_north'}.field = ncchar('u_north, scalar, series');
nc{'u_north'}.time = ncchar('bry_time');
 
nc{'v_west'} = ncdouble('bry_time', 's_rho', 'eta_v'); %% 28560 elements.
nc{'v_west'}.long_name = ncchar('3D v-momentum western boundary condition');
nc{'v_west'}.units = ncchar('meter second-1');
nc{'v_west'}.field = ncchar('v_west, scalar, series');
nc{'v_west'}.time = ncchar('bry_time');

nc{'v_east'} = ncdouble('bry_time', 's_rho', 'eta_v'); %% 28560 elements.
nc{'v_east'}.long_name = ncchar('3D v-momentum eastern boundary condition');
nc{'v_east'}.units = ncchar('meter second-1');
nc{'v_east'}.field = ncchar('v_east, scalar, series');
nc{'v_east'}.time = ncchar('bry_time');
 
 
nc{'v_south'} = ncdouble('bry_time', 's_rho', 'xi_v'); %% 19200 elements.
nc{'v_south'}.long_name = ncchar('3D v-momentum southern boundary condition');
nc{'v_south'}.units = ncchar('meter second-1');
nc{'v_south'}.field = ncchar('v_south, scalar, series');
nc{'v_south'}.time = ncchar('bry_time');
 
nc{'v_north'} = ncdouble('bry_time', 's_rho', 'xi_v'); %% 19200 elements.
nc{'v_north'}.long_name = ncchar('3D v-momentum northern boundary condition');
nc{'v_north'}.units = ncchar('meter second-1');
nc{'v_north'}.field = ncchar('v_north, scalar, series');
nc{'v_north'}.time = ncchar('bry_time');
 
nc{'temp_west'} = ncdouble('bry_time', 's_rho', 'eta_rho'); %% 28800 elements.
nc{'temp_west'}.long_name = ncchar('potential temperature western boundary condition');
nc{'temp_west'}.units = ncchar('Celsius');
nc{'temp_west'}.field = ncchar('temp_west, scalar, series');
nc{'temp_west'}.time = ncchar('bry_time');

nc{'temp_east'} = ncdouble('bry_time', 's_rho', 'eta_rho'); %% 28800 elements.
nc{'temp_east'}.long_name = ncchar('potential temperature eastern boundary condition');
nc{'temp_east'}.units = ncchar('Celsius');
nc{'temp_east'}.field = ncchar('temp_east, scalar, series');
nc{'temp_east'}.time = ncchar('bry_time');
 
nc{'temp_south'} = ncdouble('bry_time', 's_rho', 'xi_rho'); %% 19200 elements.
nc{'temp_south'}.long_name = ncchar('potential temperature southern boundary condition');
nc{'temp_south'}.units = ncchar('Celsius');
nc{'temp_south'}.field = ncchar('temp_south, scalar, series');
nc{'temp_south'}.time = ncchar('bry_time');
 
nc{'temp_north'} = ncdouble('bry_time', 's_rho', 'xi_rho'); %% 19200 elements.
nc{'temp_north'}.long_name = ncchar('potential temperature northern boundary condition');
nc{'temp_north'}.units = ncchar('Celsius');
nc{'temp_north'}.field = ncchar('temp_north, scalar, series');
nc{'temp_north'}.time = ncchar('bry_time');
 
nc{'salt_west'} = ncdouble('bry_time', 's_rho', 'eta_rho'); %% 28800 elements.
nc{'salt_west'}.long_name = ncchar('salinity western boundary condition');
nc{'salt_west'}.units = ncchar('PSU');
nc{'salt_west'}.field = ncchar('salt_west, scalar, series');
nc{'salt_west'}.time = ncchar('bry_time');

nc{'salt_east'} = ncdouble('bry_time', 's_rho', 'eta_rho'); %% 28800 elements.
nc{'salt_east'}.long_name = ncchar('salinity eastern boundary condition');
nc{'salt_east'}.units = ncchar('PSU');
nc{'salt_east'}.field = ncchar('salt_east, scalar, series');
nc{'salt_east'}.time = ncchar('bry_time');
 
nc{'salt_south'} = ncdouble('bry_time', 's_rho', 'xi_rho'); %% 19200 elements.
nc{'salt_south'}.long_name = ncchar('salinity southern boundary condition');
nc{'salt_south'}.units = ncchar('PSU');
nc{'salt_south'}.field = ncchar('salt_south, scalar, series');
nc{'salt_south'}.time = ncchar('bry_time');
 
nc{'salt_north'} = ncdouble('bry_time', 's_rho', 'xi_rho'); %% 19200 elements.
nc{'salt_north'}.long_name = ncchar('salinity northern boundary condition');
nc{'salt_north'}.units = ncchar('PSU');
nc{'salt_north'}.field = ncchar('salt_north, scalar, series');
nc{'salt_north'}.time = ncchar('bry_time');


for inert=1:opt.ptracer
  if inert<10 
   str1=['dye_0',num2str(inert)];
  else
   str1=['dye_',num2str(inert)];
  end

% north
str=[str1,'_north'];
nc{str} = ncfloat('bry_time', 's_rho', 'xi_rho'); %% 5183640 elem
          str2=['dye concentration, type ',str];
nc{str}.long_name = ncchar(str2);
nc{str}.units = ncchar('kilogram meter-3');
nc{str}.time = ncchar('bry_time');
str2=[str,',scalar, series'];
nc{str}.field = ncchar(str2);


% south
str=[str1,'_south'];
nc{str} = ncfloat('bry_time', 's_rho', 'xi_rho'); %% 5183640 elem
          str2=['dye concentration, type ',str];
nc{str}.long_name = ncchar(str2);
nc{str}.units = ncchar('kilogram meter-3');
nc{str}.time = ncchar('bry_time');
str2=[str,',scalar, series'];
nc{str}.field = ncchar(str2);


% east
str=[str1,'_east'];
nc{str} = ncfloat('bry_time', 's_rho', 'eta_rho'); %% 5183640 elem
          str2=['dye concentration, type ',str];
nc{str}.long_name = ncchar(str2);
nc{str}.units = ncchar('kilogram meter-3');
nc{str}.time = ncchar('bry_time');
str2=[str,',scalar, series'];
nc{str}.field = ncchar(str2);

% west
str=[str1,'_west'];
nc{str} = ncfloat('bry_time', 's_rho', 'eta_rho'); %% 5183640 elem
          str2=['dye concentration, type ',str];
nc{str}.long_name = ncchar(str2);
nc{str}.units = ncchar('kilogram meter-3');
nc{str}.time = ncchar('bry_time');
str2=[str,',scalar, series'];
nc{str}.field = ncchar(str2);



end



if opt.npzd==1
biovar={'phyt' 'NO3' 'zoop' 'detritus'};
for ivar=1:4
str1=biovar{ivar};
% north
str=[str1,'_north'];
nc{str} = ncfloat('bry_time', 's_rho', 'xi_rho'); %% 5183640 elem
          str2=['bio concentration, type ',str];
nc{str}.long_name = ncchar(str2);
nc{str}.units = ncchar('millimole_nitrogen meter-3');
nc{str}.time = ncchar('bry_time');
str2=[str,',scalar, series'];
nc{str}.field = ncchar(str2);


% south
str=[str1,'_south'];
nc{str} = ncfloat('bry_time', 's_rho', 'xi_rho'); %% 5183640 elem
          str2=['bio concentration, type ',str];
nc{str}.long_name = ncchar(str2);
nc{str}.units = ncchar('millimole_nitrogen meter-3');
nc{str}.time = ncchar('bry_time');
str2=[str,',scalar, series'];
nc{str}.field = ncchar(str2);


% east
str=[str1,'_east'];
nc{str} = ncfloat('bry_time', 's_rho', 'eta_rho'); %% 5183640 elem
          str2=['bio concentration, type ',str];
nc{str}.long_name = ncchar(str2);
nc{str}.units = ncchar('millimole_nitrogen meter-3');
nc{str}.time = ncchar('bry_time');
str2=[str,',scalar, series'];
nc{str}.field = ncchar(str2);

% west
str=[str1,'_west'];
nc{str} = ncfloat('bry_time', 's_rho', 'eta_rho'); %% 5183640 elem
          str2=['bio concentration, type ',str];
nc{str}.long_name = ncchar(str2);
nc{str}.units = ncchar('millimole_nitrogen meter-3');
nc{str}.time = ncchar('bry_time');
str2=[str,',scalar, series'];
nc{str}.field = ncchar(str2);

end

end


endef(nc)
close(nc)

in = netcdf(filename, 'w');

for i=1:length(forc_timevars)
  eval(['tmp=opt.', forc_timevars{i} ,'Val;']);
  in{ forc_timevars{i} }(:) = tmp;
end

% initialize to zero all variables
Vb={'salt' 'temp' 'u' 'v' 'ubar' 'vbar' 'zeta' };
    for ivar=1:4
      in{[Vb{ivar},'_north']}(:,:,:)=0;
      in{[Vb{ivar},'_south']}(:,:,:)=0;
      in{[Vb{ivar},'_west']}(:,:,:)=0;
      in{[Vb{ivar},'_east']}(:,:,:)=0;
    end
   for ivar=5:7
      in{[Vb{ivar},'_north']}(:,:)=0;
      in{[Vb{ivar},'_south']}(:,:)=0;
      in{[Vb{ivar},'_west']}(:,:)=0;
      in{[Vb{ivar},'_east']}(:,:)=0;
    end

if opt.npzd==1
Vb={'phytoplankton' 'NO3' 'zooplankton' 'detritus'};
    for ivar=1:4
      in{[Vb{ivar},'_north']}(:,:,:)=0;
      in{[Vb{ivar},'_south']}(:,:,:)=0;
      in{[Vb{ivar},'_west']}(:,:,:)=0;
      in{[Vb{ivar},'_east']}(:,:,:)=0;
    end
end

for inert=1:opt.ptracer
  if inert<10 
   str1=['dye_0',num2str(inert)];
  else
   str1=['dye_',num2str(inert)];
  end
      in{[str1,'_north']}(:,:,:)=0;
      in{[str1,'_south']}(:,:,:)=0;
      in{[str1,'_west']}(:,:,:)=0;
      in{[str1,'_east']}(:,:,:)=0;
end

close(in) 
