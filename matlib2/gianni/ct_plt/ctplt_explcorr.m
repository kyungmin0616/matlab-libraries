function ctplt_explcorr(fplt, f3d,forcd,dt,mask_switch)
%% ctplt_explcorr: Explore the correlation structure of a 3D field (X,Y,T)  
%      
%  This fuction compute the correlation map...
%
%  INPUTS: 
%       fplt, A 2D matrix which will be plotted 
%       f3d,  The field used to compute the spatial correlations 
%       forcd, Structura array containing lon, lat, mask fields
%       dt, Timestep between two
%       (Optional),mask_switch
%
%  OUTPUTS:   Spatial correlation map
%        
%                      
%   See also CTANA_corr2d
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

figure
pcolorjw(forcd.lon,forcd.lat, fplt.*forcd.mask);
shading interp
hold on
gradsmap4;
colorbar('horiz');
ctplt_coast('color','k','linewidth',2);shg
pause
[i,j]=rgrd_FindIJ(forcd.lon,forcd.lat);

% add ginput!

if3da=(sq(nanmean(nanmean(f3d(i,j,:),1),2)));

[f2d]=ConvertXYT_into_ZT(f3d,forcd.mask);


if nargin==5;
    forcd.mask=ones(size(forcd.mask));
end


o=ctana_corr2d(forcd.datenum,f3d, forcd.mask, forcd.datenum, if3da, dt);

figure
subplot(1,2,1)
ctplt_map(o.corr,forcd)
hold on
caxis([-1 1])

[xM,xm]=minmax(forcd.lon(i,j));
[yM,ym]=minmax(forcd.lat(i,j));

plot([xm,xM,xM,xm,xm],[ym,ym,yM,yM,ym],'b-')

subplot(1,2,2)
ctplt_map(o.regress,forcd)
gradsmap4 


