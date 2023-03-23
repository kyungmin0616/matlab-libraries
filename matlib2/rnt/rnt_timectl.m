% RNT_TIMECTL
% function [ctl]=rnt_timectl(files,timevar,unit_type,offset);
% Constructs a structure array called 'ctl' used to access
% variables whos time content is stored in more than
% one file.
%
% Assume you have 30 history files of the model
% and you want to load the temperature and you want to
% construct a timeindex which is the composite of all
% the 30 files for the temperature.
%
% ctl.time(:)   time value as a concatenated array for all 30 file
% ctl.file{:}   file names used in the composite
% ctl.ind(:)    indicies of the time array
% ctl.segm(:)   indicies that link  ctl.time   to the actual file
%               names. This is usefull for when you use rnt_loadvar
%               accessing multiple files.
% INPUT
%   files = {'file1.nc' 'file2.nc' .... }
%   timevar = 'scrum_time' or whatever the name of the time variable
%   unit_type  ther 'd' for matlab datenum format, or 'r' for Julian 
%   date. Default is 'd' if onthing is passed.
%   offset = [1950 0 0] will add this date to the time. THis is optional
%
% EXAMPLE:
% w=what('rnt_examples'); % find the test data directory
% files=rnt_getfilenames( w.path, 'nena8km-his'); % get all file names
% ctl=rnt_timectl(files,'ocean_time','r');
%
% See also web tutorial http://rnt.ocean3d.org
%
function [ctl]=rnt_timectl(files,timevar,varargin)
  
%==========================================================
% % generate time control struct array ctl
%==========================================================
 
   
  if ~isa(files, 'cell')
    files{1} = files;
  end
  if nargin ==1
     timevar='scum_time';
  end
  unittype = 'd';
  if nargin > 2
     unittype = varargin{1};
  end
  if nargin > 3
     offset=varargin{2};
   end     
  
  
  tmp=0;
  ctl.time=[]; ctl.file=[]; ctl.ind=[]; ctl.segm=0;
  
  for i=1:length(files)
    ctl.file{i} = files{i};
    nc=netcdf(files{i}); tmp=nc{timevar}(:);
    ctl.time = [ctl.time ; tmp ];
    tmp(:)=i; ctl.ind = [ctl.ind ; [1:length(tmp)]'];
%    ctl.segm = [ctl.segm length(tmp)*i];
    ctl.segm = [ctl.segm ctl.segm(end)+length(tmp)];
    close(nc);
  end  

  
  if strcmp(timevar,'scrum_time') | strcmp(timevar,'ocean_time')
    mytimeday = ctl.time/24 + datenum('2000-01-01 00:00:00');
  else
    mytimeday = ctl.time/24;
  end

    if unittype=='d'
      ctl.date(:,3) = str2num(datestr(mytimeday,10));
      ctl.date(:,2) = str2num(datestr(mytimeday,5));
      ctl.date(:,1) = str2num(datestr(mytimeday,7));
    else
      ctl.date=rnt_date(mytimeday,unittype);
    end
  
  if exist('offset')
  ctl.date(:,3) = ctl.date(:,3)+offset(1);
  ctl.date(:,2) = ctl.date(:,2)+offset(2);
  ctl.date(:,1) = ctl.date(:,1)+offset(3);
  end
      
  ctl.datenum=datenum(ctl.date(:,3),ctl.date(:,2),ctl.date(:,1));
  ctl.month=ctl.date(:,2);
  ctl.year=ctl.date(:,3);
  ctl.day=ctl.date(:,1);
  
  

