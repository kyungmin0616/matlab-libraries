function ctplt_tableplot( C, Xlabels, Ylabels, colorscale, boldlev )
%% ctplt_tableplot: Plot....  
%  ctplt_tableplot( C, Xlabels, Ylabels, colorscale )
%  
%  This function plot...
%
%  G. Liguori, 2014 (@GATECH)
%
%  INPUTS: 
%       C, A 2D data matrix    
%       Xlabels(Optional),
%       Ylabels(Optional),
%       colorscale(Optional),
%
%  OUTPUTS:
%
%
%  Example: ctana_tableplot(CorrMatrix,{'GFDL','HadGEM','MPI','CMCC'})
%                      
%   See also CTANA_CORRCOEFF.
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

if nargin < 1 %Plot an example     
C=rand(4,6); 
Xlabels={'GFDL','HadGEM','MPI','CCSM4','CMCC','CNRS'};
Ylabels={'DJF','MAM','JJA','SON'};
colorscale=[0 1];
boldlev=0;
disp('____________________________________')
disp('HERE AN EXAMPLE OF THIS TYPE OF PLOT')
else
if nargin < 2
Xlabels=1:size(C,2);
end
if nargin < 3
Ylabels=1:size(C,1);
end
if nargin < 4
colorscale=[0 1];
end
if nargin < 5
boldlev=0;
end
if nargin < 6
nofig=0;
end
end

% add one row and one column (pcolor issue)
[r,c]=size(C);
if ~numel(Xlabels)==c;
    disp('Xlabels must equal the number of columns of C') 
end

CC=C;
CC(end+1,:)=nan;
CC(:,end+1)=nan;

%if ~nofig
%figure
%end

pcolor(abs(CC)),%colorbar
set(gca,'XTick',1.5:c+1,'YTick',1.5:r+1,...
    'XTickLabel',Xlabels,'YTickLabel',Ylabels,...
    'clim',[colorscale(1) colorscale(2)],'fontsize',12)


colormap(flipud(gray(24)));  %# Change the colormap to gray (so higher values are
                         %#   black and lower values are white)

                         
                         textStrings = num2str(C(:),'%0.2f');  %# Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding
[x,y] = meshgrid(1.5:1:c+0.5,1.5:1:r+0.5);   %# Create x and y coordinates for the strings
hStrings1 = text(x(:),y(:),textStrings(:),...      %# Plot the strings
                'HorizontalAlignment','center','fontsize',12);          

            
            
            
midValue = mean(get(gca,'CLim'));  %# Get the middle value of the color range
textColors = repmat(abs(C(:)) > midValue,1,3);  %# Choose white or black for the                                          %#   the background color
set(hStrings1,{'Color'},num2cell(textColors,2));%# Change the text colors

if boldlev
set(hStrings1(abs(C(:)) > boldlev),'FontWeight','bold','fontsize',13);
end

end

