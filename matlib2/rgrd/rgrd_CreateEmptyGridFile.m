
function rgrd_CreateEmptyGridFile(Lp,Mp,filename, varargin)
% FUNCTION rgrd_CreateEmptyGridFile(Lp,Mp,filename)
% Creates an empty grid file of dimension Lp x Lm
%
%  05/03  E. Di Lorenzo (edl@ucsd.edu) 

%Mp=44;
%Lp=92;
M=Mp-1;
Mm=Mp-2;
L=Lp-1;
Lm=Lp-2;

opt.scope=0;

% user defined options to be overwritten
if nargin > 3
   optnew = varargin{1};
   f=fieldnames(optnew);
   for i=1:length(f)
     eval(['opt.',f{i},'=optnew.',f{i},';']);
   end
end      

nc = netcdf(filename, 'clobber');
 
%% Global attributes:
 
nc.type = ncchar('Gridpak file');
nc.gridid = ncchar('                                                                                                                                ');
nc.history = ncchar('Created by E. Di Lorenzo ');
 
%% Dimensions:
 
nc('xi_psi') = L;
nc('xi_rho') = Lp;
nc('xi_u') = L;
nc('xi_v') = Lp;
nc('eta_psi') = M;
nc('eta_rho') = Mp;
nc('eta_u') = Mp;
nc('eta_v') = M;
nc('two') = 2;
nc('bath') = 1; %% (record dimension)
nc('one') = 1;
nc('two') = 2;
nc('four') = 4;
nc('bath') = 2; %% (record dimension)

nc.title = ncchar('no title');
nc.date = ncchar(datestr(now));
nc.parent_grid = ncchar('no parent');
nc.generated = ncchar('RGRD - edl@eas.gatech.edu');
 
%% Variables and attributes:
nc{'xl'} = ncdouble; %% 1 element.
nc{'xl'}.long_name = ncchar('domain length in the XI-direction');
nc{'xl'}.units = ncchar('meter');
 
nc{'el'} = ncdouble; %% 1 element.
nc{'el'}.long_name = ncchar('domain length in the ETA-direction');
nc{'el'}.units = ncchar('meter');
 
nc{'JPRJ'} = ncchar('two'); %% 2 elements.
nc{'JPRJ'}.long_name = ncchar('Map projection type');
nc{'JPRJ'}.optionME = ncchar('Mercator');
nc{'JPRJ'}.optionST = ncchar('Stereographic');
nc{'JPRJ'}.optionLC = ncchar('Lambert conformal conic');
 
nc{'PLAT'} = ncfloat('two'); %% 2 elements.
nc{'PLAT'}.long_name = ncchar('Reference latitude(s) for map projection');
nc{'PLAT'}.units = ncchar('degree_north');
 
nc{'PLONG'} = ncfloat; %% 1 element.
nc{'PLONG'}.long_name = ncchar('Reference longitude for map projection');
nc{'PLONG'}.units = ncchar('degree_east');
 
nc{'ROTA'} = ncfloat; %% 1 element.
nc{'ROTA'}.long_name = ncchar('Rotation angle for map projection');
nc{'ROTA'}.units = ncchar('degree');
 
nc{'JLTS'} = ncchar('two'); %% 2 elements.
nc{'JLTS'}.long_name = ncchar('How limits of map are chosen');
nc{'JLTS'}.optionCO = ncchar('P1, .. P4 define two opposite corners ');
nc{'JLTS'}.optionMA = ncchar('Maximum (whole world)');
nc{'JLTS'}.optionAN = ncchar('Angles - P1..P4 define angles to edge of domain');
nc{'JLTS'}.optionLI = ncchar('Limits - P1..P4 define limits in u,v space');
 
nc{'P1'} = ncfloat; %% 1 element.
nc{'P1'}.long_name = ncchar('Map limit parameter number 1');
 
nc{'P2'} = ncfloat; %% 1 element.
nc{'P2'}.long_name = ncchar('Map limit parameter number 2');
 
nc{'P3'} = ncfloat; %% 1 element.
nc{'P3'}.long_name = ncchar('Map limit parameter number 3');
 
nc{'P4'} = ncfloat; %% 1 element.
nc{'P4'}.long_name = ncchar('Map limit parameter number 4');
 
nc{'XOFF'} = ncfloat; %% 1 element.
nc{'XOFF'}.long_name = ncchar('Offset in x direction');
nc{'XOFF'}.units = ncchar('meter');
 
nc{'YOFF'} = ncfloat; %% 1 element.
nc{'YOFF'}.long_name = ncchar('Offset in y direction');
nc{'YOFF'}.units = ncchar('meter');
 
nc{'depthmin'} = ncshort; %% 1 element.
nc{'depthmin'}.long_name = ncchar('Shallow bathymetry clipping depth');
nc{'depthmin'}.units = ncchar('meter');
 
nc{'depthmax'} = ncshort; %% 1 element.
nc{'depthmax'}.long_name = ncchar('Deep bathymetry clipping depth');
nc{'depthmax'}.units = ncchar('meter');
 
nc{'spherical'} = ncchar; %% 1 element.
nc{'spherical'}.long_name = ncchar('Grid type logical switch');
nc{'spherical'}.optionT = ncchar('spherical');
nc{'spherical'}.optionF = ncchar('Cartesian');

nc{'refine_coef'} = nclong('one'); %% 1 element.
nc{'refine_coef'}.long_name = ncchar('Grid refinment coefficient');
 
nc{'grd_pos'} = nclong('four'); %% 4 elements.
nc{'grd_pos'}.long_name = ncchar('Subgrid location in the parent grid: psi corner points (imin imax jmin jmax)');
 
nc{'hraw'} = ncdouble('bath', 'eta_rho', 'xi_rho'); %% 23936 elements.
nc{'hraw'}.long_name = ncchar('Working bathymetry at RHO-points');
nc{'hraw'}.units = ncchar('meter');
nc{'hraw'}.field = ncchar('bath, scalar');
 
nc{'h'} = ncdouble('eta_rho', 'xi_rho'); %% 23936 elements.
nc{'h'}.long_name = ncchar('Final bathymetry at RHO-points');
nc{'h'}.units = ncchar('meter');
nc{'h'}.field = ncchar('bath, scalar');
 
nc{'f'} = ncdouble('eta_rho', 'xi_rho'); %% 23936 elements.
nc{'f'}.long_name = ncchar('Coriolis parameter at RHO-points');
nc{'f'}.units = ncchar('second-1');
nc{'f'}.field = ncchar('Coriolis, scalar');
 
nc{'pm'} = ncdouble('eta_rho', 'xi_rho'); %% 23936 elements.
nc{'pm'}.long_name = ncchar('curvilinear coordinate metric in XI');
nc{'pm'}.units = ncchar('meter-1');
nc{'pm'}.field = ncchar('pm, scalar');
 
nc{'pn'} = ncdouble('eta_rho', 'xi_rho'); %% 23936 elements.
nc{'pn'}.long_name = ncchar('curvilinear coordinate metric in ETA');
nc{'pn'}.units = ncchar('meter-1');
nc{'pn'}.field = ncchar('pn, scalar');
 
nc{'dndx'} = ncdouble('eta_rho', 'xi_rho'); %% 23936 elements.
nc{'dndx'}.long_name = ncchar('xi derivative of inverse metric factor pn');
nc{'dndx'}.units = ncchar('meter');
nc{'dndx'}.field = ncchar('dndx, scalar');
 
nc{'dmde'} = ncdouble('eta_rho', 'xi_rho'); %% 23936 elements.
nc{'dmde'}.long_name = ncchar('eta derivative of inverse metric factor pm');
nc{'dmde'}.units = ncchar('meter');
nc{'dmde'}.field = ncchar('dmde, scalar');
 
nc{'x_rho'} = ncdouble('eta_rho', 'xi_rho'); %% 23936 elements.
nc{'x_rho'}.long_name = ncchar('x location of RHO-points');
nc{'x_rho'}.units = ncchar('meter');
 
nc{'y_rho'} = ncdouble('eta_rho', 'xi_rho'); %% 23936 elements.
nc{'y_rho'}.long_name = ncchar('y location of RHO-points');
nc{'y_rho'}.units = ncchar('meter');
 
nc{'x_psi'} = ncdouble('eta_psi', 'xi_psi'); %% 23625 elements.
nc{'x_psi'}.long_name = ncchar('x location of PSI-points');
nc{'x_psi'}.units = ncchar('meter');
 
nc{'y_psi'} = ncdouble('eta_psi', 'xi_psi'); %% 23625 elements.
nc{'y_psi'}.long_name = ncchar('y location of PSI-points');
nc{'y_psi'}.units = ncchar('meter');
 
nc{'x_u'} = ncdouble('eta_u', 'xi_u'); %% 23800 elements.
nc{'x_u'}.long_name = ncchar('x location of U-points');
nc{'x_u'}.units = ncchar('meter');
 
nc{'y_u'} = ncdouble('eta_u', 'xi_u'); %% 23800 elements.
nc{'y_u'}.long_name = ncchar('y location of U-points');
nc{'y_u'}.units = ncchar('meter');
 
nc{'x_v'} = ncdouble('eta_v', 'xi_v'); %% 23760 elements.
nc{'x_v'}.long_name = ncchar('x location of V-points');
nc{'x_v'}.units = ncchar('meter');
 
nc{'y_v'} = ncdouble('eta_v', 'xi_v'); %% 23760 elements.
nc{'y_v'}.long_name = ncchar('y location of V-points');
nc{'y_v'}.units = ncchar('meter');
 
nc{'lat_rho'} = ncdouble('eta_rho', 'xi_rho'); %% 23936 elements.
nc{'lat_rho'}.long_name = ncchar('latitude of RHO-points');
nc{'lat_rho'}.units = ncchar('degree_north');
 
nc{'lon_rho'} = ncdouble('eta_rho', 'xi_rho'); %% 23936 elements.
nc{'lon_rho'}.long_name = ncchar('longitude of RHO-points');
nc{'lon_rho'}.units = ncchar('degree_east');
 
nc{'lat_psi'} = ncdouble('eta_psi', 'xi_psi'); %% 23625 elements.
nc{'lat_psi'}.long_name = ncchar('latitude of PSI-points');
nc{'lat_psi'}.units = ncchar('degree_north');
 
nc{'lon_psi'} = ncdouble('eta_psi', 'xi_psi'); %% 23625 elements.
nc{'lon_psi'}.long_name = ncchar('longitude of PSI-points');
nc{'lon_psi'}.units = ncchar('degree_east');
 
nc{'lat_u'} = ncdouble('eta_u', 'xi_u'); %% 23800 elements.
nc{'lat_u'}.long_name = ncchar('latitude of U-points');
nc{'lat_u'}.units = ncchar('degree_north');
 
nc{'lon_u'} = ncdouble('eta_u', 'xi_u'); %% 23800 elements.
nc{'lon_u'}.long_name = ncchar('longitude of U-points');
nc{'lon_u'}.units = ncchar('degree_east');
 
nc{'lat_v'} = ncdouble('eta_v', 'xi_v'); %% 23760 elements.
nc{'lat_v'}.long_name = ncchar('latitude of V-points');
nc{'lat_v'}.units = ncchar('degree_north');
 
nc{'lon_v'} = ncdouble('eta_v', 'xi_v'); %% 23760 elements.
nc{'lon_v'}.long_name = ncchar('longitude of V-points');
nc{'lon_v'}.units = ncchar('degree_east');
 
nc{'mask_rho'} = ncdouble('eta_rho', 'xi_rho'); %% 23936 elements.
nc{'mask_rho'}.long_name = ncchar('mask on RHO-points');
nc{'mask_rho'}.option0 = ncchar('land');
nc{'mask_rho'}.option1 = ncchar('water');
 
nc{'mask_u'} = ncdouble('eta_u', 'xi_u'); %% 23800 elements.
nc{'mask_u'}.long_name = ncchar('mask on U-points');
nc{'mask_u'}.option0 = ncchar('land');
nc{'mask_u'}.option1 = ncchar('water');
 
nc{'mask_v'} = ncdouble('eta_v', 'xi_v'); %% 23760 elements.
nc{'mask_v'}.long_name = ncchar('mask on V-points');
nc{'mask_v'}.option0 = ncchar('land');
nc{'mask_v'}.option1 = ncchar('water');
 
nc{'mask_psi'} = ncdouble('eta_psi', 'xi_psi'); %% 23625 elements.
nc{'mask_psi'}.long_name = ncchar('mask on PSI-points');
nc{'mask_psi'}.option0 = ncchar('land');
nc{'mask_psi'}.option1 = ncchar('water');
 
nc{'angle'} = ncdouble('eta_rho', 'xi_rho'); %% 23936 elements.
nc{'angle'}.long_name = ncchar('angle between xi axis and east');
nc{'angle'}.units = ncchar('degree');

if opt.scope == 1
nc{'scope_rho'} = ncdouble('eta_rho', 'xi_rho'); %% 23936 elements.
nc{'scope_rho'}.long_name = ncchar('SCOPE of RHO-points');
nc{'scope_rho'}.units = ncchar('scope_rho');
 
nc{'scope_u'} = ncdouble('eta_u', 'xi_u'); %% 23800 elements.
nc{'scope_u'}.long_name = ncchar('SCOPE of U-points');
nc{'scope_u'}.units = ncchar('scope_u');

nc{'scope_v'} = ncdouble('eta_v', 'xi_v'); %% 23760 elements.
nc{'scope_v'}.long_name = ncchar('SCOPE of V-points');
nc{'scope_v'}.units = ncchar('scope_v');
end

endef(nc)
close(nc)
 
if opt.scope == 1
nc=netcdf(filename,'w');
  nc{'scope_rho'}(:,:)=1;
  nc{'scope_v'}(:,:)=1;
  nc{'scope_u'}(:,:)=1;
close(nc);
end
