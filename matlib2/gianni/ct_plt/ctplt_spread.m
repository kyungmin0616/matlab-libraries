function ctplt_speard(time, PC_low, PC_up, color_shg)
%% ctplt_spread: Add ensemble spread   
%  ctplt_spread(t,Ylow,Yup)
%  
%  This function add the spread to the current plot 
%
%
%  INPUTS: 
%       t, vector time    
%       Ylow, vector spread lower bound 
%       Yup, vector spread upper bound 
%       color_shg(optional), color to use, default is [1 0.6 0.2]
%
%  OUTPUTS:
%      add spread to the current plot
%
%  Example: ctplt_spread(t,Ylow,Yup,[1 .7 .2])
% 
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



if nargin<4
    clr=[1 0.6 0.2];
else
    clr=color_shg
end

hold on
X=[time,fliplr(time)];                %#create continuous x value array for plotting
Y=[PC_low,fliplr(PC_up)];%#create y values for out and then back
h=fill(X,Y,clr); 
set(h,'EdgeColor',[1 1 1],'FaceAlpha',0.18)



