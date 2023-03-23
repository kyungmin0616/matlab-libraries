function ctplt_pmap(f, forcd, varargin)
%% ctplt_pmap: Plot a lon-lat map using the grid information  
%  ctplt_pmap( 2Dfield, GridStruture )
%  
%  This function is similar to ct_plt_map but use pcolor instead of the contourf 
%  This is especially useful when the fields has discontinuities    
%
%
%  INPUTS: 
%       2Dfield, A 2D matrix    
%       GridStruture, Structura array containing lon, lat, mask fields 
%
%  OUTPUTS:
%
%
%  Example: ct_plt_map(ssta,grd)
% 
%  where grd is something like this: 
%  grd = 
%       lon: [96x39 double]
%       lat: [96x39 double]
%      mask: [96x39 double]
%      year: [601x1 double]
%     month: [601x1 double]
%      ssta: [96x39x601 double]
%                      
%   See also CT_PLT_CONTOURFILL.
% =========================================================================
%  This function is part of the Climate toolbox for Matlab (CliMat toolbox). 
%  CliMat is a collection of matlab functions for processing and analyzing 
%  climate related data. 
%          Giovanni.Liguori@gatech.edu, 2015
%
%  Every function follows this naming convection ct[type]_[fucntionname]   
% 
%  [Type] may be one of the follow strings:
%  ext: Extracting data (like NOOA SST, NCEP, etc, cmip5) from any server 
%       (mostly our server) to  matlab workspace 
%  ana: Any kind of analysis. For ex. Correlations, EOFs, Time_series, 
%       Time and spatial Filtering, Hovmuller, Statistics,...
%  plt: Visualization and plotting functions
%  rnc: Creanting files for ROMS (Grid, Input frc files from extracted data)
%  rnt: Working with ROMS input/output files 
%  
%  [Functionname] is the name of the fucntion  
% =========================================================================
if nargin < 1
load ct_plt_map_data 
forcd=grd; f=ssta_true;
end


if nargin==2
    p=0;
elseif nargin==3
    p=varargin{1};
elseif nargin==4
    p=varargin{1};
    satscale=varargin{2};
    fld(fld<satscale(1))=satscale(1);
    fld(fld>satscale(2))=satscale(2);
end

pcolorjw(forcd.lon,forcd.lat, f.*forcd.mask);
shading interp
hold on
colormap(getpmap(7));
colorbar('horiz');
ctplt_coast('color','k','linewidth',2)

if p==1
ctplt_coastp('color','k','linewidth',2);
elseif p==0
ctplt_coast('color','k','linewidth',2);    
end
if nargin==4
caxis(satscale)
end

