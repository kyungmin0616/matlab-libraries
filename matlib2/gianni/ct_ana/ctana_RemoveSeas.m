function [anom, seas] = ctana_RemoveSeas(field,month_list,varargin)
%% ctana_RemoveSeas: Calculates the climatology and resultant timeseries of anomaly from timeseries of upto 3-D data
%  [anom, seas] = ctana_RemoveSeas(field,month_list,varargin)
%
%   INPUTS: field = upto 4-D timeseries of data with time as last index
%           month_list = list of months corresponding to each data point
%           varargin = to specify the dimension of the field array
%
%   OUTPUT: anom = anomaly timeseries
%           seas = climatology of the data
%
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


if nargin > 2
  n = varargin{1}
else
n=length(size(field));
end
anom=field*nan;

if n == 1
   for imon =1:12
      in=find(month_list == imon);
	seas(imon) = meanNaN(field(in),1);
   end
   
   for it = 1 : length(field)
      imon = month_list(it);
	anom(it) = field(it) - seas(imon);
   end
end


if n == 2
   for imon =1:12
      in=find(month_list == imon);
	seas(:,imon) = meanNaN(field(:,in),2);
   end
   
   for it = 1 : size(field,2)
      imon = month_list(it);
	anom(:,it) = field(:,it) - seas(:,imon);
   end
end

if n == 3
   for imon =1:12
      in=find(month_list == imon);
	seas(:,:,imon) = meanNaN(field(:,:,in),3);
   end
   
   for it = 1 : size(field,3)
      imon = month_list(it);
	anom(:,:,it) = field(:,:,it) - seas(:,:,imon);
   end
end

if n == 4
   for imon =1:12
      in=find(month_list == imon);
        seas(:,:,:,imon) = meanNaN(field(:,:,:,in),4);
   end

   for it = 1 : size(field,n)
      imon = month_list(it);
        anom(:,:,:,it) = field(:,:,:,it) - seas(:,:,:,imon);
   end
end
