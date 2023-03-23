
grids={'wrd' 'ias20' 'northsea' 'nepd' 'china25' 'indian'};

for i=1:length(grids)
  grd=rnt_gridload( grids{i} );
  dx=1./grd.pm/1000;
  dx=num2str(mean(dx(:)));
  
  mfig
  rnt_plcm(grd.h,grd);
  title ([grd.name, '   AVG RES = ',dx,'  KM']);
end
  
