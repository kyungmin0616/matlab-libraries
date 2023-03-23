function ctplt_coast(varargin)
%% ctplt_coast: Add world coast to a lon-lat 2D plot  
% ctplt_tableplot( )
%  
%  This function add the world coast to the lon-lat map. 
%  Use this fucntion if the range of longitudes is [-360 0], where 0 is Greenwich
%  
%
%  INPUTS: optional
%
%  OUTPUTS:
%
%
%  Example: ctplt_coast('color','k','linewidth',2)
%                      
% 
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

if nargin == 0
   color='k';
   varargin{1} = color;
end

load(which('rgrd_WorldCstLinePacific.mat'));
plot(lon,lat,varargin{:})

