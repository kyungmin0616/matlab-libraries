function ctplt_ens(time,YY,color_line,color_shg)
%% ctplt_ens: Add ensemble spread   
%  ctplt_spread(time,YY)
%  
%  This function plot the ensemble mean with its ensemble spread (1 STD)
%
%
%  INPUTS: 
%       t, vector time    
%       YY, ensemble data organized as colum vectors 
%       color_line(optional), line color, default is 'r'
%       color_shg(optional), shading color, default is [1 0.6 0.2]
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


    lclr='r';
    clr=[1 0.6 0.2];

if nargin<2
    time=1:size(YY,1);
elseif nargin==3
    lclr=color_line;
elseif nargin==4
    lclr=color_line;
    clr=color_shg;
end

time=time(:);
Ymean=mean(YY,2);
Ylow=Ymean-std(YY,0,2);
Yup=Ymean+std(YY,0,2);

plot(time,Ymean,'color',lclr,'linewidth',2);

hold on
X=[time',fliplr(time')];                %#create continuous x value array for plotting
Y=[Ylow',fliplr(Yup')];%#create y values for out and then back
h=fill(X,Y,clr); 
set(h,'EdgeColor',[1 1 1],'FaceAlpha',0.18)



