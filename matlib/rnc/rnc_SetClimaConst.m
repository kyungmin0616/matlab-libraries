

function  SetClimaConst(grd,clmfile)
% Set the climatology to constant values for TS 
% and Zero for the rest
%  - E. Di Lorenzo (edl@ucsd.edu)
  

    in=netcdf(clmfile,'w');
    
    if length (in{'tclm_time'}(:)) == 12  
       disp(' Looks like climatology time index array.');
       timeind=[15, 45, 75, 105, 135, 165, 195, 225, 255, 285, 315, 345 ]';
    else
       disp(' - Time index is > 12, please make sure to put in the times');
	 timeind=1:length (in{'tclm_time'}(:));
    end
    
	 
    % section 1
    % assign timevariables and some others
    timevar={'vclm_time' 'tclm_time' 'sclm_time' 'ssh_time' 'uclm_time' ...
       'job' 'vintrp' 'tstart' 'tend'  'hc'};
    for i=1:5
      disp(timevar{i});
      in{timevar{i}}(:) = timeind;
    end
    in{'job'}(:) = 0 ;
    in{'vintrp'}(:) = 1 ;
    in{'tstart'}(:) = 1 ;
    in{'tend'}(:) = 1 ;
    
    
    
    in{'Tcline'}(:)=grd.tcline;
    in{'theta_s'}(:)=grd.thetas;
    in{'theta_b'}(:)=grd.thetab;
    
    variables={'temp' 'salt' 'zeta' 'ubar' 'vbar' 'u' 'v'};
    %skip temp and salt
    
    disp(variables{1});
    in{variables{1}}(:)=10;
    disp(variables{2});    
    in{variables{2}}(:)=35;    
    
    for i=3:length(variables)
      disp(variables{i});
      in{variables{i}}(:)=0;
    end
    
    
%    eval(grid.assign);
%    z_r=rnt_setdepth(0);
%    z_r=permute(z_r,[3 2 1]);
%    salt=34.68-2*exp((z_r)/400);
%    temp=14*exp(z_r/400) +  1.1;
        
%    for imon=1:length(timeind)
%      disp(variables{2});
%      in{'salt'}(imon,:,:,:)=salt;
%      disp(variables{1});
%      in{'temp'}(imon,:,:,:)=temp;
%    end
    close (in);
    disp(' Make Clim DONE. ');
  
