function comp_CLIMA;


  istart=input('Start index: ');
  iend=input('End   index: ');
  
  fields = { 'scrum_time' 'zeta' 'temp' 'salt' 'ubar' 'vbar' 'v' 'u' };
  j=0;
  for ifile=3:16
    j=j+1;
    files{j}=['/d3/manu/runs/NCEP_POA-1/roms_avg_Y',num2str(ifile),'.nc'];
  end
 
  j=0;
  for ifile=3:16
    j=j+1;
    files{j}=['/d3/manu/runs/RSM-clima/roms_avg_Y',num2str(ifile),'.nc'];
  end
 
 
  
  
  
  
  assignin('base','fields',fields);
  
  
  for ifield = 1:length(fields);
    i=0;
    disp (['Loading ... ', fields{ifield}]);
    self = ncvar;
    for ifile=1:length(files);
      i=i+1;
      file=files{ifile};
      nc=netcdf(file);
      theVars=nc{ fields{ifield} };
      
      varsize=ncsize(theVars);
      t=varsize(1);
      dt= 1+t*(i-1) : t*i;
      t=1:t;
      theSrcsubs(1)={ t };
      theDstsubs(1)={ dt};
      
      % other indicies stay the same
      for j=2:length(varsize)
        tmp = 1:varsize(j);
        theSrcsubs(j)= {tmp};
        theDstsubs(j)= {tmp};
      end
      
      
      self.itsVars{i} = theVars;
      self.itsSrcsubs{i} = theSrcsubs;
      self.itsDstsubs{i} = theDstsubs;
    end
    assignin('base',fields{ifield},self);
    fieldsize{ifield} = comp_ncsize(self);
     
    end
    assignin('base','fieldsize',fieldsize);
  
  

