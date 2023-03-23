
j=0;
for ifile=3:5
j=j+1;
files{j}=['/d3/manu/runs/NCEP_POA-1/roms_avg_Y',num2str(ifile),'.nc'];
end
fields = { 'scrum_time' 'zeta' 'temp' 'salt' 'ubar' 'vbar' 'v' 'u' }

[self]=comp_vars(files,fields);
comp_ncsize(self)
[self]=comp_vars(files,'temp');
