function ctplt_box(xlimits, ylimits,varargin)
%% ctplt_box: Plot a rectangular box   
%  ctplt_box( xlimits, ylimits )
%  
%  This function plot 
%
%
%  INPUTS: 
%       xlimits,     
%       ylimits,  
%
%  OUTPUTS:
%
%
%  Example: ctplt_globe(ssta,grd)
% 
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


hold on
XboxCorn=[xlimits(1),xlimits(2),xlimits(2),xlimits(1),xlimits(1)];
YboxCorn=[ylimits(1),ylimits(1),ylimits(2),ylimits(2),ylimits(1)];
plot(XboxCorn,YboxCorn,varargin{:},'linewidth',1.5)

