
function rgrd_AnaGrid(dx,dy,Lp,Mp,filename)
% FUNCTION AnaGrid(dx,dy,Lp,Mp,filename)
% Generate rectangular grid with following
%  dx=500;  % m in X direction
%  dy=500;  % m in Y direction
%  Lp=96;   % number of points in X direction
%  Mp=24;   % number of points in Y direction
%  filename='test-grid.nc';
%
%  05/03  E. Di Lorenzo (edl@ucsd.edu) 


M=Mp-1;
Mm=Mp-2;
L=Lp-1;
Lm=Lp-2;

disp('Creating grid file ...');
CreateGridFile(Lp,Mp,filename);

nc=netcdf(filename,'w');
%
%---------------------------------------------------------------------
%  Set grid parameters:
%
%     Xsize    Length (m) of domain box in the XI-direction.
%     Esize    Length (m) of domain box in the ETA-direction.
%     depth    Maximum depth of bathymetry (m).
%     f0       Coriolis parameter, f-plane constant (1/s).
%     beta     Coriolis parameter, beta-plane constant (1/s/m).
%---------------------------------------------------------------------
%
      Xsize=dx*(Lm);
      Esize=dy*(Mm);
%
%  Load grid parameters to global storage.
%

        xl=Xsize;
        el=Esize;
	  nc{'xl'}(:)=xl;
	  nc{'el'}(:)=el;
        nc{'spherical'}(:)='F';
%
%---------------------------------------------------------------------
%  Compute the (XI,ETA) coordinates at PSI- and RHO-points.
%  Set grid spacing (m).
%---------------------------------------------------------------------
%
%
%  Compute (XI,ETA) coordinate at PSI-points and RHO-points.
%
disp('Computing (X,Y) coordinates on C-Grid');
      for j=1:Mp
        for i=1:Lp
          xp(i,j)=dx*(i-1);
          xr(i,j)=dx*((i-1)+0.5);
          yp(i,j)=dy*(j-1);
          yr(i,j)=dy*((j-1)+0.5);
        end
      end
	xu=(xp(2:end,:) + xp(1:end-1,:))/2;
	yu=(yp(2:end,:) + yp(1:end-1,:))/2;	
	xv=(xp(:,2:end) + xp(:,1:end-1))/2;
	yv=(yp(:,2:end) + yp(:,1:end-1))/2;	
	
	nc{'x_rho'}(:,:)=xr';
	nc{'y_rho'}(:,:)=yr';
	nc{'x_psi'}(:,:)=xp(2:Lp,2:Mp)';
	nc{'y_psi'}(:,:)=yp(2:Lp,2:Mp)';
	nc{'x_u'}(:,:)=xu';
	nc{'y_u'}(:,:)=yu';
	nc{'x_v'}(:,:)=xv';
	nc{'y_v'}(:,:)=yv';
	

	nc{'lon_rho'}(:,:)=xr';
	nc{'lat_rho'}(:,:)=yr';
	nc{'lon_psi'}(:,:)=xp(2:Lp,2:Mp)';
	nc{'lat_psi'}(:,:)=yp(2:Lp,2:Mp)';
	nc{'lon_u'}(:,:)=xu';
	nc{'lat_u'}(:,:)=yu';
	nc{'lon_v'}(:,:)=xv';
	nc{'lat_v'}(:,:)=yv';
	

disp('Adding Mask == 1');	
	nc{'mask_rho'}(:,:)=xr'*0 + 1;
	nc{'mask_psi'}(:,:)=xp(2:Lp,2:Mp)'*0 + 1;
	nc{'mask_u'}(:,:)=xu'*0 + 1;
	nc{'mask_v'}(:,:)=yv'*0 + 1;
	
	
	
	
%
%---------------------------------------------------------------------
% Compute coordinate transformation metrics at RHO-points "pm" and
% "pn"  (1/m) associated with the differential distances in XI and
% ETA, respectively.
%---------------------------------------------------------------------
%
disp('Computing coordinate transformation metrics 1/dx 1/dy');
      for j=1:Mp
        for i=1:Lp
          pm(i,j)=1.0/dx;
          pn(i,j)=1.0/dy;
        end
      end
	nc{'pm'} (:,:)=pm';
	nc{'pn'} (:,:)=pn';

%
%---------------------------------------------------------------------
%  Compute Coriolis parameter (1/s) at RHO-points.
%---------------------------------------------------------------------
%
disp('Computing Coriolis ');
      f0=-8.26d-5;
      beta=0.0d00;

      val1=0.5*Esize;
      for j=1:Mp
        for i=1:Lp
          f(i,j)=f0+beta*(yr(i,j)-val1);
        end
      end
	nc{'f'} (:,:)=f';
%

%---------------------------------------------------------------------
%  Set bathymetry (meters; positive) at RHO-points.
%---------------------------------------------------------------------
%
disp('Seting Topograhpy to constant 1000 m ');
disp('   ... modify topo later as you like.');
      val1=(Mp/2)*dx;
      val2=dx*(Mp);

      for j=1:Mp
        for i=1:Lp
          val3=2.0*(yr(i,j)-val1)/val2;
          h(i,j)= 49 - 47* val3*val3;
        end
      end
	h(:)=1000;

        hmax=max(h(:));
	  hmin=min(h(:));
	  nc{'depthmin'}(:)=hmin;
	  nc{'depthmax'}(:)=hmax;

        nc{'hraw'}(:,:)=h';
	  nc{'h'}(:,:)=h';
	
	
	
close(nc)	

return














function CreateGridFile(Lp,Mp,filename)
% FUNCTION CreateGridFile(Lp,Mp,filename)
% Creates an empty grid file of dimension Lp x Lm
%
%  05/03  E. Di Lorenzo (edl@ucsd.edu) 

%Mp=44;
%Lp=92;
M=Mp-1;
Mm=Mp-2;
L=Lp-1;
Lm=Lp-2;

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
 
%% Variables and attributes:
 
nc{'xl'} = ncdouble; %% 1 element.
nc{'xl'}.long_name = ncchar('domain length in the XI-direction');
nc{'xl'}.units = ncchar('meter');
 
nc{'el'} = ncdouble; %% 1 element.
nc{'el'}.long_name = ncchar('domain length in the ETA-direction');
nc{'el'}.units = ncchar('meter');
 
 
nc{'depthmin'} = ncshort; %% 1 element.
nc{'depthmin'}.long_name = ncchar('Shallow bathymetry clipping depth');
nc{'depthmin'}.units = ncchar('meter');
 
nc{'depthmax'} = ncshort; %% 1 element.
nc{'depthmax'}.long_name = ncchar('Deep bathymetry clipping depth');
nc{'depthmax'}.units = ncchar('meter');


nc{'spherical'} = ncchar; %% 1 element.
nc{'spherical'}.long_name = ncchar('Grid type logical switch');
nc{'spherical'}.option_T = ncchar('spherical');
nc{'spherical'}.option_F = ncchar('Cartesian');
 
 
nc{'hraw'} = ncdouble('bath', 'eta_rho', 'xi_rho'); %% 2068 elements.
nc{'hraw'}.long_name = ncchar('Working bathymetry at RHO-points');
nc{'hraw'}.units = ncchar('meter');
nc{'hraw'}.field = ncchar('bath, scalar');
 
nc{'h'} = ncdouble('eta_rho', 'xi_rho'); %% 2068 elements.
nc{'h'}.long_name = ncchar('Final bathymetry at RHO-points');
nc{'h'}.units = ncchar('meter');
nc{'h'}.field = ncchar('bath, scalar');
 
nc{'f'} = ncdouble('eta_rho', 'xi_rho'); %% 2068 elements.
nc{'f'}.long_name = ncchar('Coriolis parameter at RHO-points');
nc{'f'}.units = ncchar('second-1');
nc{'f'}.field = ncchar('Coriolis, scalar');
 
nc{'pm'} = ncdouble('eta_rho', 'xi_rho'); %% 2068 elements.
nc{'pm'}.long_name = ncchar('curvilinear coordinate metric in XI');
nc{'pm'}.units = ncchar('meter-1');
nc{'pm'}.field = ncchar('pm, scalar');
 
nc{'pn'} = ncdouble('eta_rho', 'xi_rho'); %% 2068 elements.
nc{'pn'}.long_name = ncchar('curvilinear coordinate metric in ETA');
nc{'pn'}.units = ncchar('meter-1');
nc{'pn'}.field = ncchar('pn, scalar');
  
nc{'x_rho'} = ncdouble('eta_rho', 'xi_rho'); %% 2068 elements.
nc{'x_rho'}.long_name = ncchar('x location of RHO-points');
nc{'x_rho'}.units = ncchar('meter');
 
nc{'y_rho'} = ncdouble('eta_rho', 'xi_rho'); %% 2068 elements.
nc{'y_rho'}.long_name = ncchar('y location of RHO-points');
nc{'y_rho'}.units = ncchar('meter');
 
nc{'x_psi'} = ncdouble('eta_psi', 'xi_psi'); %% 1953 elements.
nc{'x_psi'}.long_name = ncchar('x location of PSI-points');
nc{'x_psi'}.units = ncchar('meter');
 
nc{'y_psi'} = ncdouble('eta_psi', 'xi_psi'); %% 1953 elements.
nc{'y_psi'}.long_name = ncchar('y location of PSI-points');
nc{'y_psi'}.units = ncchar('meter');
 
nc{'x_u'} = ncdouble('eta_u', 'xi_u'); %% 2046 elements.
nc{'x_u'}.long_name = ncchar('x location of U-points');
nc{'x_u'}.units = ncchar('meter');
 
nc{'y_u'} = ncdouble('eta_u', 'xi_u'); %% 2046 elements.
nc{'y_u'}.long_name = ncchar('y location of U-points');
nc{'y_u'}.units = ncchar('meter');
 
nc{'x_v'} = ncdouble('eta_v', 'xi_v'); %% 1974 elements.
nc{'x_v'}.long_name = ncchar('x location of V-points');
nc{'x_v'}.units = ncchar('meter');
 
nc{'y_v'} = ncdouble('eta_v', 'xi_v'); %% 1974 elements.
nc{'y_v'}.long_name = ncchar('y location of V-points');
nc{'y_v'}.units = ncchar('meter');
 
nc{'lat_rho'} = ncdouble('eta_rho', 'xi_rho'); %% 2068 elements.
nc{'lat_rho'}.long_name = ncchar('latitude of RHO-points');
nc{'lat_rho'}.units = ncchar('degree_north');
 
nc{'lon_rho'} = ncdouble('eta_rho', 'xi_rho'); %% 2068 elements.
nc{'lon_rho'}.long_name = ncchar('longitude of RHO-points');
nc{'lon_rho'}.units = ncchar('degree_east');
 
nc{'lat_psi'} = ncdouble('eta_psi', 'xi_psi'); %% 1953 elements.
nc{'lat_psi'}.long_name = ncchar('latitude of PSI-points');
nc{'lat_psi'}.units = ncchar('degree_north');
 
nc{'lon_psi'} = ncdouble('eta_psi', 'xi_psi'); %% 1953 elements.
nc{'lon_psi'}.long_name = ncchar('longitude of PSI-points');
nc{'lon_psi'}.units = ncchar('degree_east');
 
nc{'lat_u'} = ncdouble('eta_u', 'xi_u'); %% 2046 elements.
nc{'lat_u'}.long_name = ncchar('latitude of U-points');
nc{'lat_u'}.units = ncchar('degree_north');
 
nc{'lon_u'} = ncdouble('eta_u', 'xi_u'); %% 2046 elements.
nc{'lon_u'}.long_name = ncchar('longitude of U-points');
nc{'lon_u'}.units = ncchar('degree_east');
 
nc{'lat_v'} = ncdouble('eta_v', 'xi_v'); %% 1974 elements.
nc{'lat_v'}.long_name = ncchar('latitude of V-points');
nc{'lat_v'}.units = ncchar('degree_north');
 
nc{'lon_v'} = ncdouble('eta_v', 'xi_v'); %% 1974 elements.
nc{'lon_v'}.long_name = ncchar('longitude of V-points');
nc{'lon_v'}.units = ncchar('degree_east');
 
nc{'mask_rho'} = ncdouble('eta_rho', 'xi_rho');
nc{'mask_rho'}.long_name = ncchar('mask on RHO-points');
nc{'mask_rho'}.long_name = 'mask on RHO-points';
nc{'mask_rho'}.option_0 = ncchar('land');
nc{'mask_rho'}.option_0 = 'land';
nc{'mask_rho'}.option_1 = ncchar('water');
nc{'mask_rho'}.option_1 = 'water';

nc{'mask_u'} = ncdouble('eta_u', 'xi_u');
nc{'mask_u'}.long_name = ncchar('mask on U-points');
nc{'mask_u'}.long_name = 'mask on U-points';
nc{'mask_u'}.option_0 = ncchar('land');
nc{'mask_u'}.option_0 = 'land';
nc{'mask_u'}.option_1 = ncchar('water');
nc{'mask_u'}.option_1 = 'water';

nc{'mask_v'} = ncdouble('eta_v', 'xi_v');
nc{'mask_v'}.long_name = ncchar('mask on V-points');
nc{'mask_v'}.long_name = 'mask on V-points';
nc{'mask_v'}.option_0 = ncchar('land');
nc{'mask_v'}.option_0 = 'land';
nc{'mask_v'}.option_1 = ncchar('water');
nc{'mask_v'}.option_1 = 'water';

nc{'mask_psi'} = ncdouble('eta_psi', 'xi_psi');
nc{'mask_psi'}.long_name = ncchar('mask on PSI-points');
nc{'mask_psi'}.long_name = 'mask on PSI-points';
nc{'mask_psi'}.option_0 = ncchar('land');
nc{'mask_psi'}.option_0 = 'land';
nc{'mask_psi'}.option_1 = ncchar('water');
nc{'mask_psi'}.option_1 = 'water';
 
%nc{'angle'} = ncdouble('eta_rho', 'xi_rho'); %% 2068 elements.
%nc{'angle'}.long_name = ncchar('angle between xi axis and east');
%nc{'angle'}.units = ncchar('degree');
 
endef(nc)
close(nc)
 
