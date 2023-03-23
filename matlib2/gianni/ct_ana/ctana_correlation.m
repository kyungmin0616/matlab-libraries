function [c12,c12p, r1 ,r2]=ctana_correlation(t1,s1,t2,s2,dt);
%% ctana_correlation: Plot....  
%  [c12,c12p, r1 ,r2]=ctana_correlation(t1,s1,t2,s2,dt);
%   
%  Modified version of Manu's function which return also the correlation 
%  significance
%
%
%  INPUTS: 
%       t1,    
%       s1, 
%       t2,
%       s2,
%       dt,
%
%  OUTPUTS:
%       c12
%       c12p,
%       r1,
%       r2,
%
%  Example: 
%                      
%   See also CT_ANA_CORRCOEFF.
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
%       Time and spatial Filtering, Hovmuller, Statistics,...
%  plt: Visualization and plotting functions
%  rnc: Creanting files for ROMS (Grid, Input frc files from extracted data)
%  rnt: Working with ROMS input/output files 
%  
%  [Functionname] is the name of the fucntion  
% =========================================================================

% Clear NaN values
in=find(~isnan(s1)); s1=s1(in); t1=t1(in);
in=find(~isnan(s2)); s2=s2(in); t2=t2(in);
 

% align time series so that the begin and end at the same time
t_start= max(t1(1), t2(1));
t_end  =min(t1(end), t2(end));


% create a new time array and interpolate the timeseries so 
% that they have the exact times.
time=t_start:dt:t_end;
s1=interp1(t1,s1,time,'linear');
s2=interp1(t2,s2,time,'linear');
% detrend
s1=detrend(s1(:));
s2=detrend(s2(:));


r2=sum(s1.*s2)/sum(s2.*s2)* std(s2);  %sum(s1.*s2)=s1*s2'
r1=sum(s2.*s1)/sum(s1.*s1)* std(s1);

% normalize
s1=s1/std(s1);
s2=s2/std(s2);

% compute correlation
[tmp,c12p]=corrcoef(s1,s2); 
c12=(tmp(2,1));
 
