function SetForcZero(grd,forcfile);
% Set the Forc to Zero
%  - E. Di Lorenzo (edl@ucsd.edu)
  

    in=netcdf(forcfile,'w');
    
    if length (in{'sms_time'}(:)) == 12  
       disp(' Looks like climatology time index array.');
       timeind=[15, 45, 75, 105, 135, 165, 195, 225, 255, 285, 315, 345 ]';
    else
       disp(' - Time index is > 12, please make sure to put in the times');
	 timeind=1:length (in{'sms_time'}(:));
    end
    
      timevar={'sms_time' 'shf_time' 'swf_time' 'sst_time' 'srf_time' };
    
  for i=1:length(timevar)
    in{timevar{i}}(:) = timeind;
  end
     vars={'sustr' 'svstr' 'shflux' 'swflux' 'SST' 'SSS' 'dQdSST' 'swrad'};
  
   for i=1:length(vars)
      disp(vars{i});
      in{vars{i}}(:,:,:) = 0;
   end
   
   % For flux correction
   %in{'svstr'}(:,:,:) = 0.05;

  close(in);
 


    disp(' Make Forc DONE. ');
