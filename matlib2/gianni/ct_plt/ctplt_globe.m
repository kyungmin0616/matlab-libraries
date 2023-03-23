function ctplt_globe(f, forcd,Pcoord)
%% ctplt_globe: Plot a parameter on a globe using the grid information  
%  ctplt_globe( 2Dfield, GridStruture, Pcoord )
%  
%  This function plot 
%
%
%  INPUTS: 
%       2Dfield, A 2D matrix    
%       GridStruture, Structura array containing lon, lat, mask fields 
%       Pcoord, Lon and lat of the globe orientation (e.g., Pcoord=[15,-150])
%  OUTPUTS:
%
%
%  Example: ctplt_globe(ssta,grd)
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
%   See also CTPLT_CONTOURFILL CTPLT_MAP.
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

if nargin >2
m_proj('Satellite','lat',Pcoord(2),'long',Pcoord(1));
else
m_proj('Satellite','lat',15','long',-155'); % good one to use
end
m_contourf(forcd.lon,forcd.lat,f);
%m_pcolor(forcd.lon,forcd.lat,f);
%shading interp
%caxis([-.5 .5]); gradsmap4; shading flat
m_coast('patch',[.7 .7 .7],'LineWidth',2);
%m_coast('patch','w','LineWidth',2);
%m_grid('linest','-','xticklabels',[],'yticklabels',[]);
%m_grid('xticklabels',[],'yticklabels',[]);
colorbar


