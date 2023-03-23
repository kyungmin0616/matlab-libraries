function ctplt_cbsubplot1(m)
%% ctplt_cbsubplot1: Add unique colorbar in subplot type plot 
% ctplt_cbsubplot1(m)
%
% INPUTS:
%      m, number of colum in the subplot1 
%
% See also CTPLT_subplot1.
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

if m==2
colorbar('peer',gca,...
    [0.925 0.15238095 0.0214285714 0.6785714285]);
end

if m==3
colorbar('peer',gca,...
    [0.925 0.15238095 0.0214285714 0.6785714285]);
end

if m==8
colorbar('peer',gca,...
[0.949479166 0.1565303 0.0214285 0.678571]);
end

if m==10
colorbar('peer',gca,...
    [0.95703125 0.179226587583892 0.0214285714 0.6785714285]);
end