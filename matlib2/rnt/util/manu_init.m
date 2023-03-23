function (initfile,temp,salt)
  
  initfile ='roms_init_vel'
  salt=permute(S,[3 1 2]);
  temp=permute(T,[3 1 2]);
  
  salt=S;
  temp=T;
  nc = netcdf(initfile,'w');
  nc{'temp'}(1,:,:,:) = temp(20:-1:1,:,:);
  nc{'salt'}(1,:,:,:) = salt(20:-1:1,:,:);
  
  nc{'temp'}(1,:,:,:) = permute(leet_temp_s,[3 1 2])
  nc{'salt'}(1,:,:,:) = permute(leet_salt_s,[3 1 2])
  
  nc{'temp'}(1,:,:,:) = T;
  nc{'salt'}(1,:,:,:) = S;
  
  for k=1:20
    for j=1:120
      temp(k,j,50:80)= temp(k,j,50);
      salt(k,j,:)= salt(k,j,50);
    end
  end
  
  %old calcofi
  nc{'theta_b'}(:)=0.4;
  nc{'theta_s'}(:)=5.0;
  
  % patrick
  nc{'theta_b'}(:)=0.0;
  nc{'theta_s'}(:)=7.0;
  close(nc);
  
  for i=1:120
    i
    for j=1:80
      temp(i,j,:)=interp1(squeeze(Zz(i,j,:)), ...
         squeeze(Tz(i,j,:)), ...
         squeeze(Zs(i,j,:)),'cubic');
    end
  end
  temp=permute(temp,[3 1 2]);
  
  for i=1:120
    i
    for j=1:80
      salt(i,j,:)=interp1(squeeze(Zz(i,j,:)), ...
         squeeze(Sz(i,j,:)), ...
         squeeze(Zs(i,j,:)),'cubic');
    end
  end
  salt=permute(salt,[3 1 2]);
  
  nc = netcdf(initfile,'w');
  nc{'temp'}(1,:,:,:) = temp;
  nc{'salt'}(1,:,:,:) = salt;
  close(nc);
  
  nc=netcdf('roms_forc','w');
  nc{'sustr':q
  
  
  

