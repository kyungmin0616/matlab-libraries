
% This script extracts the biological runs into z grid
% There are two runs, see below.
% cd /wd2/halem/LongTermBioRun

inp.myvar= {'salt' 'temp' 'u' 'v' ...
         'NO3' 'CHLA' 'PHYTO' 'ZOO' ...
	   'NH4' 'SDET' 'LDET'};	   
inp.myvar2D={'zeta' };
% standard depth to which extract data
inp.Zgrid =- [ 0 10 20 30 40 50 75 100 125 150 200 ...
           250 300 350 400 500 600 800 ]';	   	     
grd=rnt_gridload('calc7');



%undefine values are set to -99999 in the nc files

% RUN # 1
% this run has thermocline depth variations and NCEP forcing
load /d5/manu/LF-BIO/LF_BIO_CTL
rntp_ExtractAvgZ(ctl,'lf-bio',grd,inp);
% files are saved as lf-bio-<year>Z.nc
% the variables are saved as monthly means.

% RUN # 2
% this run has NO thermocline depth variations but
% has NCEP forcing
load /d5/manu/LFFORC-BIO/LFFORC_BIO_CTL
rntp_ExtractAvgZ(ctl,'lf-forc-bio',grd,inp);
% files are saved in lf-forc-bio as lf-forc-bio-<year>Z.nc
% the variables are saved as monthly means.



vars={'salt' 'temp' 'u' 'v' 'ubar' 'vbar' 'zeta'};
grd=rnt_gridload('usw20');
files ={'/sgi/edl/CCS/his.6624.nc'};
ctl=rnt_timectl( files, 'ocean_time');
filename='/tmp/testclima.nc';

 rnt_MakeClima(grd,ctl,vars,filename)
