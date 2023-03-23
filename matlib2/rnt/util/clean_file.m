function file=clean_file(filein,fileout)

unix(['cat -v ',filein,' >  .tmp.',filein]);

file = textread(['.tmp.',filein],'%s','delimiter','\n','whitespace','');



fid = fopen(fileout,'w');

for i=1:length(file)
  a=file{i};
  if a(end)=='M'
     a=a(1:end-2);
  end
  fprintf(fid,'%s\n',a);
end

fclose(fid);

