function distfigures(varargin);


direc1='.';
direc2='.';

if nargin > 0
direc1=varargin {1};
direc2=direc1;
end
if nargin > 1
direc2=varargin {2};
end



direc1=[direc1,'/'];
direc2=[direc2,'/'];

ext={'epsP' 'eps' 'tif' 'jpg' 'pdf'};
ext2={'-P.eps' '.eps' '.tif' '.jpg' '.pdf'};


if nargin > 2
% we want to remove a figure
fig=varargin {3};
  for i=1:5
  str=['rm ','  ',direc2,ext{i},'/',fig,ext2{i}];
  disp(str);
  unix(str);
  end
return
end


if ~exist([direc2,ext{1}])
  for i=1:5
  str=['mkdir ',direc2,ext{i}];
  unix(str);
  end
end

  for i=1:5
  str=['mv ',direc1,'*',ext2{i},'  ',direc2,ext{i}];
  disp(str);
  unix(str);
  end
