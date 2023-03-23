function ncrst=create_rstfile(rstfile,gridfile,parentfile,title,...
                              N,time,time_step,clobber)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2000 IRD                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                 %
%                                                                 %
%  function ncrst=create_inifile(inifile,gridfile,theta_s,...  %
%                  theta_b,Tcline,N,ttime,stime,utime,...         %
%                  cycle,clobber)                                 %
%                                                                 %
%                                                                 %
%   This function create the header of a Netcdf climatology       %
%   file.                                                         %
%                                                                 %
%                                                                 %
%   Input:                                                        %
%                                                                 %
%   inifile      Netcdf initial file name (character string).     %
%   gridfile     Netcdf grid file name (character string).        %
%   theta_s      S-coordinate surface control parameter.(Real)    % 
%   theta_b      S-coordinate bottom control parameter.(Real)     %
%   Tcline       Width (m) of surface or bottom boundary layer    %
%                where higher vertical resolution is required     %
%                during stretching.(Real)                         %
%   N            Number of vertical levels.(Integer)              %
%   time         Initial time.(Real)                              %
%   clobber      Switch to allow or not writing over an existing  %
%                file.(character string)                          %
%                                                                 %
%                                                                 %
%   Output                                                        %
%                                                                 %
%   ncrst       Output netcdf object.                             %
%                                                                 %
%                                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(' ')
disp(' ')
disp(['Creating the file : ',rstfile])
disp(' ')
%
%  Read the grid file
%
ncgrid = netcdf(gridfile, 'nowrite');
theVar = ncgrid{'h'};
h = theVar(:);  
status=close(ncgrid);
[Mp,Lp]=size(h);
L=Lp-1;
M=Mp-1;
Np=N+1;
%
%  Create the initial file
%
type = 'RESTART file' ; 
history = 'ROMS' ;
ncrst = netcdf(rstfile,clobber);
result = redef(ncrst);
%
%  Create dimensions
%
ncrst('xi_u') = L;
ncrst('xi_v') = Lp;
ncrst('xi_rho') = Lp;
ncrst('eta_u') = Mp;
ncrst('eta_v') = M;
ncrst('eta_rho') = Mp;
ncrst('s_rho') = N;
ncrst('s_w') = Np;
ncrst('tracer') = 2;
ncrst('time') = 0;
ncrst('one') = 1;
ncrst('auxil') = 4;
%
%  Create variables
%
ncrst{'time_step'} = ncint('time','auxil') ;
ncrst{'scrum_time'} = ncdouble('time') ;
ncrst{'zeta'} = ncdouble('time','eta_rho','xi_rho') ;
ncrst{'ubar'} = ncdouble('time','eta_u','xi_u') ;
ncrst{'vbar'} = ncdouble('time','eta_v','xi_v') ;
ncrst{'u'} = ncdouble('time','s_rho','eta_u','xi_u') ;
ncrst{'v'} = ncdouble('time','s_rho','eta_v','xi_v') ;
ncrst{'temp'} = ncdouble('time','s_rho','eta_rho','xi_rho') ;
ncrst{'salt'} = ncdouble('time','s_rho','eta_rho','xi_rho') ;
%
%  Create attributes
%
ncrst{'time_step'}.long_name = ncchar('time step and record numbers from initialization');
ncrst{'tstart'}.long_name = 'time step and record numbers from initialization';
%
ncrst{'scrum_time'}.long_name = ncchar('time since initialization');
ncrst{'scrum_time'}.long_name = 'time since initialization';
ncrst{'scrum_time'}.units = ncchar('second');
ncrst{'scrum_time'}.units = 'second';
ncrst{'scrum_time'}.field = ncchar('time, scalar, series');
ncrst{'scrum_time'}.field = 'time, scalar, series'  ;
%
ncrst{'u'}.long_name = ncchar('u-momentum component');
ncrst{'u'}.long_name = 'u-momentum component';
ncrst{'u'}.units = ncchar('meter second-1');
ncrst{'u'}.units = 'meter second-1';
ncrst{'u'}.field = ncchar('u-velocity, scalar, series');
ncrst{'u'}.field = 'u-velocity, scalar, series';
%
ncrst{'v'}.long_name = ncchar('v-momentum component');
ncrst{'v'}.long_name = 'v-momentum component';
ncrst{'v'}.units = ncchar('meter second-1');
ncrst{'v'}.units = 'meter second-1';
ncrst{'v'}.field = ncchar('v-velocity, scalar, series');
ncrst{'v'}.field = 'v-velocity, scalar, series';
%
ncrst{'ubar'}.long_name = ncchar('vertically integrated u-momentum component');
ncrst{'ubar'}.long_name = 'vertically integrated u-momentum component';
ncrst{'ubar'}.units = ncchar('meter second-1');
ncrst{'ubar'}.units = 'meter second-1';
ncrst{'ubar'}.field = ncchar('ubar-velocity, scalar, series');
ncrst{'ubar'}.field = 'ubar-velocity, scalar, series';
%
ncrst{'vbar'}.long_name = ncchar('vertically integrated v-momentum component');
ncrst{'vbar'}.long_name = 'vertically integrated v-momentum component';
ncrst{'vbar'}.units = ncchar('meter second-1');
ncrst{'vbar'}.units = 'meter second-1';
ncrst{'vbar'}.field = ncchar('vbar-velocity, scalar, series');
ncrst{'vbar'}.field = 'vbar-velocity, scalar, series';
%
ncrst{'zeta'}.long_name = ncchar('free-surface');
ncrst{'zeta'}.long_name = 'free-surface';
ncrst{'zeta'}.units = ncchar('meter');
ncrst{'zeta'}.units = 'meter';
ncrst{'zeta'}.field = ncchar('free-surface, scalar, series');
ncrst{'zeta'}.field = 'free-surface, scalar, series';
%
ncrst{'temp'}.long_name = ncchar('potential temperature');
ncrst{'temp'}.long_name = 'potential temperature';
ncrst{'temp'}.units = ncchar('Celsius');
ncrst{'temp'}.units = 'Celsius';
ncrst{'temp'}.field = ncchar('temperature, scalar, series');
ncrst{'temp'}.field = 'temperature, scalar, series';
%
ncrst{'salt'}.long_name = ncchar('salinity');
ncrst{'salt'}.long_name = 'salinity';
ncrst{'salt'}.units = ncchar('PSU');
ncrst{'salt'}.units = 'PSU';
ncrst{'salt'}.field = ncchar('salinity, scalar, series');
ncrst{'salt'}.field = 'salinity, scalar, series';
%
% Create global attributes
%
ncrst.title = ncchar(title);
ncrst.title = title;
ncrst.grd_file = ncchar(gridfile);
ncrst.grd_file = gridfile;
ncrst.parent_file = ncchar(parentfile);
ncrst.parent_file = parentfile;
ncrst.type = ncchar(type);
ncrst.type = type;
ncrst.history = ncchar(history);
ncrst.history = history;
%
% Leave define mode
%
result = endef(ncrst);
%
% Write variables
%
time_step(1)=3*(time_step(1)-1)+1
theVar = ncrst{'time_step'};
theVar(1,:) =  time_step; 
theVar = ncrst{'scrum_time'};
theVar(1) =  time; 
theVar = ncrst{'u'};
theVar(:) =  0; 
theVar = ncrst{'v'};
theVar(:) =  0; 
theVar = ncrst{'zeta'};
theVar(:) =  0; 
theVar = ncrst{'ubar'};
theVar(:) =  0; 
theVar = ncrst{'vbar'};
theVar(:) =  0; 
theVar = ncrst{'temp'};
theVar(:) =  0; 
theVar = ncrst{'salt'};
theVar(:) =  0; 
%
% Synchronize on disk
%
result = sync(ncrst);
return


