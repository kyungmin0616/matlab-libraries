function [f3d_IndexRem]=ctana_RemoveIndex(time,f3d,mask,IND)
% This function function remove from the f3d field the anomalies that are 
% regressed with the user provided time series (IND).
%
%
% Input: 
%       time,
%       f3d,  this is a (lon,lat,time) field 
%       mask,
%       IND
%
%
% Output:
%       f3d_IndexRem, of size (lon,lat,time)    
%
% 
%                      
%   See also ctana_RemoveIndex, ctana_get_ts, ctana_doEof, ctana_corr2d
% =========================================================================
%  This function is part of the Climate toolbox for Matlab (CliMat toolbox). 
%  CliMat is a collection of matlab functions for processing and analyzing 
%  climate related data (www.oceanography.eas.gatech.edu/gianni/climat/).
%                           Giovanni Liguori, 2014 (@GATECH)
%
%  Every function follows this naming convection ct[type]_[fucntionname]   
% 
%  [Type] may be one of the follow strings:
%  ext: Extracting data (like NOOA SST, NCEP, etc, cmip5) from any server 
%       (mostly our server) to  matlab workspace 
%  ana: Any kind of analysis. For ex. Correlations, EOFs, Time_series, 
%       Time and spatial Filtering, Statistics,...
%  plt: Visualization and plotting functions
%  rnc: Creanting files for ROMS (Grid, Input frc files from extracted data)
%  rnt: Working with ROMS input/output files 
%  
%  [Functionname] is the name of the fucntion  
% =========================================================================

[I,J,ntime]=size(f3d);
    % Regression coeff.
    % T1=sq(sst.ano(55,22,:));
    % r1=(CTI'*T1)/(CTI'*CTI);
    % P = polyfit(CTI,T1,1);   P(1) and r1 are the same
    of3d_idx=ctana_corr2d(time,f3d,mask,time,IND, 30,0);
for i =1:ntime
    f3d_IndexRem(:,:,i)=f3d(:,:,i)-IND(i)*of3d_idx.regress;
end
