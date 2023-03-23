
function SetInitFromClim(grd,clmfile,initfile,imon,varargin);


    if nargin == 5
         num_var=11;
    else
         num_var=7;
    end
    in=netcdf(initfile,'w');
    clim=netcdf(clmfile);
    disp([' Make Init from CLima timeind - ',num2str(imon)]);
    variables={'u' 'v' 'temp' 'salt' 'zeta' 'ubar' 'vbar' 'NO3' ...
                'phytoplankton' 'zooplankton' 'detritus'};

    
    for i=1:num_var
      disp(variables{i});
      in{variables{i}}(1,:,:,:)=clim{variables{i}}(imon,:,:,:);
    end
    disp('ocean_time');
    % convert also to sec
   in{'ocean_time'}(1)=clim{'tclm_time'}(imon)*24*60*60;
      
   
    in{'job'}(:) = 0 ;
    in{'vintrp'}(:) = 2 ;
    in{'tstart'}(:) = clim{'tclm_time'}(imon);
    in{'tend'}(:) = clim{'tclm_time'}(imon);
    
    
    
    in{'Tcline'}(:)=grd.tcline;
    in{'theta_s'}(:)=grd.thetas;
    in{'theta_b'}(:)=grd.thetab;
   
   close(in); close(clim);
