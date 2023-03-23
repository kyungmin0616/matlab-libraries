function ENSO = ctana_EPCPenso(SST,varargin)
% This function compute the TP/EP/CP indices and varius NINO indices as done
% by Yu and Kim, 2010
% [..."combined regression-Empirical Orthogonal Function (EOF) analysis 
% [Kao and Yu, 2009; Yu and Kim, 2010]. We first remove the tropical 
% Pacific SST anomalies that are regressed with 
% the Niño1 + 2 (0°-10°S, 80°W-90°W) SST index and then apply EOF analysis 
% to the remaining (residual) SST anomalies to obtain the SST anomaly 
% pattern for the CP ENSO. Similarly, we subtract the SST anomalies 
% regressed with the Niño4 (5°S?5°N, 160°E?150°W) index from the total SST 
% anomalies and then apply EOF analysis to identify the leading structure 
% of the EP ENSO."] 
%
%
% Input: 
%       SST,
%       (Optional) 'NINOregion', default is  [-20S 20N 120E 80W]
%       (Optional) 'period', default is ALL AVAILABLE YEARS
%       (Optional) 'fieldname', default is 'fld'
%
%       Variables needed in the SST structure array:
%       SST.lon
%       SST.lat
%       SST.mask
%       SST.datenum
%       SST.fld (this field may have a different name) 
%
%       Optional arguments: 
%   
%       Use  (...,'NINOregion',[-25 25 -220 -90])  
%       Use  (...,'period',[1950 2012])
%       Use  (...,'fieldname','temp') % use this if the field name is not 'fld' 
%
% Output:
%   
%
%  Example: If SST: 
%          SST = 
% 
%             lon: [197x94 double]
%             lat: [197x94 double]
%            mask: [197x94 double]
%         datenum: [1x768 double]
%             fld: [197x94x768 double]
%            desc: 'Celcius'
%      
%       then ENSO=ctana_EPCPenso(SST)   gives:
%
%
%     ENSO = 
% 
%              lon: [85x22 double]
%              lat: [85x22 double]
%             mask: [85x22 double]
%          datenum: [1x768 double]
%              sst: [1x1 struct]
%     NINOidx_list: {'CTI'  'NINO1+2'  'NINO3'  'NINO4'  'NINO3.4'}
%          NINOidx: [768x5 double]
%              TPp: [85x22 double]
%              TPi: [768x1 double]
%            TPeof: [85x22x10 double]
%            TPpcs: [768x10 double]
%              EPp: [85x22 double]
%              EPi: [768x1 double]
%            EPeof: [85x22x10 double]
%            EPpcs: [768x10 double]
%              CPp: [85x22 double]
%              CPi: [768x1 double]
%            CPeof: [85x22x10 double]
%            CPpcs: [768x10 double]   
%                      
%   See also ctana_RemoveIndex, ctana_get_ts, ctana_doEof
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


p = inputParser;

defaultNINOregion = [-20 20 -240 -80];  % CTI
defaultMAKEplot = 0;
defaultPERIOD = nan; % nan means ALL YEARS 
defaultFLD = 'fld';
defaultDetrend='lin'; %other option is 'qua' (quadratic)


addRequired(p,'SST',@isstruct);
addParamValue(p,'NINOregion',defaultNINOregion,@isnumeric)
addParamValue(p,'plot',defaultMAKEplot,@isnumeric)
addParamValue(p,'period',defaultPERIOD,@isnumeric)
addParamValue(p,'fieldname',defaultFLD,@ischar)
addParamValue(p,'TypeDetrend',defaultDetrend,@ischar)


parse(p,SST,varargin{:})

if ~isempty(fieldnames(p.Unmatched))
   disp('Extra inputs:')
   disp(p.Unmatched)
end
if ~isempty(p.UsingDefaults)
   disp('Using defaults: ')
   disp(p.UsingDefaults)
end

disp(['NINO region: [',n2s(p.Results.NINOregion),']'])
disp(['Detrend Type: ',p.Results.TypeDetrend])

%-- Set input parametes 
MMregion_plt=p.Results.plot;
NIDXylim=p.Results.NINOregion(1:2);
NIDXxlim=p.Results.NINOregion(3:4);
fieldname=p.Results.fieldname;
TrendType=p.Results.TypeDetrend;

%-- Set period of analysis 
if isnan(p.Results.period)
    [YRstart,~]=ctana_date_datenum(SST.datenum(1));
    [YRend,~]=ctana_date_datenum(SST.datenum(end));
    idxfld=1:numel(SST.datenum);
else
    YRstart=p.Results.period(1);
    YRend=p.Results.period(2);
    
    [YY,MM,DD]=ctana_date_datenum(SST.datenum);
    idxfld=find(YY>=YRstart & YY<=YRend);
end

disp(['Period analyzed: ',n2s(YRstart),'-',n2s(YRend)])




%% (1) select data inside the Tropical Pacific Domain ylimit=[-20 20]; xlimit=[-240 -80];

lon=SST.lon; lat=SST.lat;

[I,J]=rgrd_FindIJ(lon,lat, NIDXxlim, NIDXylim);

% select grid points         
sst.lon=SST.lon(I,J);
sst.lat=SST.lat(I,J);
sst.datenum=SST.datenum(idxfld);
tmpmask=SST.fld(I,J,1);
tmpmask(~isnan(tmpmask))=1;
sst.mask=SST.mask(I,J).*tmpmask;
f=getfield(SST,fieldname);
sst.fld=f(I,J,idxfld);       

time=sst.datenum;


%% (2) compute detrended anomalies 
[~,MM,~]=ctana_date_datenum(time);

[anom, seas] = ctana_RemoveSeas(sst.fld,MM);
[anomd, ftrend] = ctana_dtrend2d(anom,TrendType);
sst.ano=anomd;

ENSO.lon=sst.lon;
ENSO.lat=sst.lat;
ENSO.mask=sst.mask;
ENSO.datenum=sst.datenum;
ENSO.sst.clm=seas;
ENSO.sst.trend=ftrend;


%% (2) compute NINO indices

% EN NINO indices CTI NINO1+2 NINO3 NINO4 NINO3.4
xlimit={[180 270]-360, [-90 -80], [210 270]-360, [160 210]-360, [190 240]-360,};
ylimit={[-10 0],       [-5 5],    [-5 5],        [-5 5],        [-6 6]};

%[IN,JN]=rgrd_FindIJ(sst.lon,sst.lat, NIDXxlim, NIDXylim);
%tmp=sst.ano(IN,JN,:);
%CTI=sq(nanmean(nanmean(tmp,1),2)); % plot(sst.datenum,CTI),datetick

ENSO.NINOidx_list={'CTI','NINO1+2','NINO3','NINO4','NINO3.4'};
for i=1:numel(xlimit);
   ENSO.NINOidx(:,i)=ctana_get_ts(sst.lon,sst.lat,sst.ano,[xlimit{i},ylimit{i}]);
end



%% (3) Remove NINO indices from anomalies

[sstN12rem]=ctana_RemoveIndex(time,sst.ano,sst.mask,ENSO.NINOidx(:,2));
[sstN4rem]=ctana_RemoveIndex(time,sst.ano,sst.mask,ENSO.NINOidx(:,4));


%-- compute TP-ENSO and save first 10 EOF
[eofs,eofs_coeff,varexp]=ctana_doEof(sst.ano,sst.mask,1);

ENSO.TPvexp=varexp;
ENSO.TPp=eofs(:,:,1);
ENSO.TPi=eofs_coeff(:,1);
ENSO.TPeof=eofs(:,:,1:10);
ENSO.TPpcs=eofs_coeff(:,1:10);

%-- compute EP-ENSO and save first 10 EOF
[eofs,eofs_coeff,varexp]=ctana_doEof(sstN4rem,sst.mask,1);

ENSO.EPvexp=varexp;
ENSO.EPp=eofs(:,:,1);
ENSO.EPi=eofs_coeff(:,1);
ENSO.EPeof=eofs(:,:,1:10);
ENSO.EPpcs=eofs_coeff(:,1:10);

%-- compute EP-ENSO and save first 10 EOF
[eofs,eofs_coeff,varexp]=ctana_doEof(sstN12rem,sst.mask,1);

ENSO.CPvexp=varexp;
ENSO.CPp=eofs(:,:,1);
ENSO.CPi=eofs_coeff(:,1);
ENSO.CPeof=eofs(:,:,1:10);
ENSO.CPpcs=eofs_coeff(:,1:10);













