function lprfigs(direc, figrange, prefix)
%function lprfigs(direc, figrange, prefix)


for i=figrange
  str=[direc,'/',prefix,'_',num2str(i),'.eps'];
  figure(i);
  disp(['Printing figure ... ', str]);
  lpr(str);
end  
