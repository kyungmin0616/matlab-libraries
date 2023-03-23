function ctplt_map2(f, forcd,varargin)
%% ctplt_map: Plot a lon-lat map using the grid information  
%  ctplt_map( 2Dfield, GridStruture )
%  
%  This function plot 
%
%
%  INPUTS: 
%       2Dfield, A 2D matrix    
%       GridStruture, Structura array containing lon, lat, mask fields 
%
%  OUTPUTS:
%
%
%  Example: ctplt_map(ssta,grd)
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
%   See also CTPLT_CONTOURFILL.
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

%ctplt_contourfill(forcd.lon,forcd.lat, f.*forcd.mask, 40);
% hold on
% colormap(getpmap(7));
% colorbar('horiz');
% if p==1
% ctplt_coastp('color','k','linewidth',2);
% else
% ctplt_coast('color','k','linewidth',2);    
% end


fld=f.*forcd.mask;
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

ctplt_contourfill(forcd.lon,forcd.lat, fld, 40);
hold on
%colormap(getpmap(7));
%colorbar('horiz');
if p==1
ctplt_coastp('color','k','linewidth',2);
elseif p==0
ctplt_coast('color','k','linewidth',1);    
end
if nargin==4
caxis(satscale)
end



