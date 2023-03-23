function [value,time,lon,lat,z,sta]=loadarr(name,variable,depth)

format long g

  fid=fopen('/d2/emanuele/ASSIMILATION/config/assloc.dat');
  carr=fscanf(fid,'%f',[7 inf]);
  carr=carr';
  fclose(fid);

  fid=fopen(name);
  arr=fscanf(fid,'%f',[1 inf]);
  arr=arr';

  in=find(carr(:,5) == variable);
  carr=carr(in,:);
  arr=arr(in,:);

  in=find(carr(:,4) == depth);
  carr=carr(in,:);
  arr=arr(in,:);

  in=find(arr(:,1) <  999999 );
  carr=carr(in,:);
  arr=arr(in,:);

  fclose(fid);
  time=carr(:,1); 
  lon=carr(:,2);
  lat=carr(:,3);
  z=carr(:,4);
  var=carr(:,5);
  value=arr(:,1);
  sta=carr(:,7);





