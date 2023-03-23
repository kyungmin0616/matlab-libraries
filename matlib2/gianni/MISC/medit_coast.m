function medit_coast(varargin)

if nargin == 0
   color='k';
   varargin{1} = color;
end

load(which('Medit_coarse_res.mat'));
plot(cstlon,cstlat,varargin{:})