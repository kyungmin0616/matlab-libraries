function o=ctana_corr2d(t2,s2, mask, t1, s1, dt, STDunits)
%% ctana_corr2d: compute correlation and regression maps   
% o = ctana_corr2d(t2,s2, mask, t1, s1, dt);
%  
%  This function compute correlation and regression maps.
%  For each point we have: 
%            s2 = a*s1+b
%            a: regression coeff, cov(s1*s2)/var(s1)
%            b: residual, b=s2-a*s1;
%
%  
%  The regression computed by this fucntion (o.regress) represents the 
%  amplitude of s2 that can be associated with a one standard deviation 
%  variation of s1. 
%
%
%
%  INPUTS: 
%       t2, time vector for s2   
%       s2, 3D data field, usually (LON,LAT,TIME)
%       t1, time vector for s1
%       s1, time series we want to use to regress s2 
%       dt, time between to consecutive time steps
%       STDunits(OPTIONAL),set this to 0 if you do not want regression in units of std
%
%  OUTPUTS:
%       o.corr, correlation map 
%       o.regress, regression map in [s2]/units of std(s1)
%       o.a, regression map in [s2]/[s1] units 
%       o.cov, Covariance map  [s2]*[s1] units 
%
%  Example: 
%                      
%   See also CTANA_CORRCOEFF.
% =========================================================================
%  This function is part of the Climate toolbox for Matlab (CliMat toolbox). 
%  CliMat is a collection of matlab functions for processing and analyzing 
%  climate related data (www.oceanography.eas.gatech.edu/gianni/climat/). 
%                           Giovanni Liguori, 2014 (@GATECH)
%
%  Every function follows this naming convection ct_[type]_[fucntionname]   
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

if nargin < 7
    STDunits=1;
end

[I,J,T]=size(s2);
o.corr=zeros(I,J)*nan;
o.regress=o.corr*nan;


t_start= max(t1(1), t2(1));
t_end  =min(t1(end), t2(end));

s1=interp1(t1,s1,t2,'linear');

tidx = t2 >= t_start & t2 <= t_end;


s2c=s2(:,:,tidx);
s1c=s1(tidx);
s1c=s1c(:);



[f2d]=ConvertXYT_into_ZT_mod(s2c,mask); % note this is a modify version of Manu's function

cov2=(1./numel(s1c))*(f2d*s1c);
[cov2FLD]=ConvertZT_into_XYT(cov2,mask);


%r2=sum(s1.*s2)/sum(s2.*s2)* std(s2);
%sum(s2.*s1)/sum(s1.*s1)* std(s1);
if STDunits
regress=cov2/std(s1c); %use this to get [s2 unit / std of s1]
else
regress=cov2/var(s1c); %tmp
end

[o.regress]=ConvertZT_into_XYT(regress,mask);

a=cov2/var(s1c);
[o.a]=ConvertZT_into_XYT(regress,mask);

corr2=cov2./(std(f2d,0,2)*std(s1c));
[corr2FLD]=ConvertZT_into_XYT(corr2,mask);

o.corr=corr2FLD;
o.cov=cov2FLD;

function fout=ConvertXYT_into_ZT_mod(f,mask);

[I,J,T]=size(f);
 f=f.*repmat(mask,[ 1 1 T]);
 f=reshape(f,[I*J,T]);
 in=find(isnan( mask(:) ) == 0);
 %in=find(isnan(f(:,1)) == 0);
 fout=f(in,:);
 return
    
function fout=ConvertZT_into_XYT(f,mask);

[I,J]=size(mask);
[Z,T]=size(f);

in=find(isnan( mask(:) ) == 0);
fout=zeros(I,J,T);
fout=reshape(fout,[I*J,T]);
fout(in,:)=f;
fout=reshape(fout,[I, J, T]);