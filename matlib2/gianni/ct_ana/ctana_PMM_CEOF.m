function [CEOF] = ctana_PMM_CEOF(SST,USTR,VSTR,varargin)
%
% This function compute the North Pacific Meridional Mode performing 
% an Combined EOF analysis of Spring (MAM, March-April-May) 
% anomalies of Wind speed and sst. Indicies are recoved by projectiong 
% anomalies on the first SST/U/V SVD spatial mode
%
%
% Input: 
%       SST, U, V
%       (Optional) 'PMMregion', default is [-21S 30N 175E 95W]
%       (Optional) 'NINOregion', default is  [-6S 6N 180E 90W]
%       (Optional) 'period', default is ALL AVAILABLE YEARS
%
%       Variables needed in the SST structure array:
%       SST.lon
%       SST.lat
%       SST.mask
%       SST.datenum
%       SST.fld (this field may have a different name) 
%
%     Optional arguments: 
%
%       Use  (...,'PPMregion',[-21 32 -185 -95]) for Chiang&Vimont,2004
%       Use  (...,'PPMregion',[-20 20 -210 -95]) for ChangETal,2007
%   
%       Use  (...,'NINOregion',[-6 6 -180 -90]) for CTI (ColdTongueIndex)
%       Use  (...,'NINOregion',[-5 5 -150 -90]) for NINO3 Index 
%       Use  (...,'NINOregion',[-5 5 -200 -150]) for NINO4 Index
%       Use  (...,'NINOregion',[-5 5 -170 -120]) for NINO3.4 Index
%
%       Use  (...,'period',[1950 2012])
%       Use  (...,'TypeDetrend','qua') for Quadratic Detrend 
%       Use  (...,'freq','monthly') or 'MAM' for March-April-May
%
% Output:
%   
% %   if SST,USTR,VSTR = 
% 
%         lon: [197x94 double]
%         lat: [197x94 double]
%        mask: [197x94 double]
%     datenum: [1x768 double]
%         fld: [197x94x768 double]
%        desc: 'Celcius'
%
%     then [CEOF] = ctana_PMM(SST,USTR,VSTR,'plot',1,'PMMregion',[-21 32 -210 -95],'period',[1960 1990]);
%
%       CEOF = 
% 
%            note: {'MM computed as in Chang et al. (2007) except that here we SLP...'}
%             lon: [61x28 double]
%             lat: [61x28 double]
%            mask: [61x28 double]
%            Teof: [61x28x10 double]
%            Ueof: [61x28x10 double]
%            Veof: [61x28x10 double]
%             Cpc: [31x10 double]
%     Cpc_datenum: [31x1 double]
%           Cvexp: [10x1 double]
%           Tnorm: 0.1277
%           Unorm: 0.0900
%           Vnorm: 0.0914
%            MMpT: [61x28 double]
%            MMpU: [61x28 double]
%            MMpV: [61x28 double]
%         MMiTano: [372x1 double]
%         MMiUano: [372x1 double]
%         MMiVano: [372x1 double]
%        MMiTerem: [372x1 double]
%        MMiUerem: [372x1 double]
%        MMiVerem: [372x1 double]
%        MMiTanos: [372x1 double]
%        MMiUanos: [372x1 double]
%        MMiVanos: [372x1 double]
%     MMi_datenum: [1x372 double]
%
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


%% Customize SVD analysis
p = inputParser;

defaultPMMregion = [-21 32 -185 -95]; % Chaing and Vimont. 2004
defaultNINOregion = [-6 6 -180 -90];  % CTI
defaultMAKEplot = 0;
defaultPERIOD = nan; % nan means ALL YEARS
defaultDetrend='lin';

addRequired(p,'SST',@isstruct);
addRequired(p,'USTR',@isstruct);
addRequired(p,'VSTR',@isstruct);
addParameter(p,'PMMregion',defaultPMMregion,@isnumeric)
addParameter(p,'NINOregion',defaultNINOregion,@isnumeric)
addParameter(p,'plot',defaultMAKEplot,@isnumeric)
addParameter(p,'period',defaultPERIOD,@isnumeric)
addParameter(p,'TypeDetrend',defaultDetrend,@ischar)
addParameter(p,'freq',defaultFreq,@ischar)


parse(p,SST,USTR,VSTR,varargin{:})

if ~isempty(fieldnames(p.Unmatched))
   disp('Extra inputs:')
   disp(p.Unmatched)
end
if ~isempty(p.UsingDefaults)
   disp('Using defaults: ')
   disp(p.UsingDefaults)
end

disp(['PMM region: [',n2s(p.Results.PMMregion),']',])
disp(['NINO region: [',n2s(p.Results.NINOregion),']'])
disp(['Detrend Type: ',p.Results.TypeDetrend])
disp(['Frequency: ',p.Results.freq])
freq=p.Results.freq;


%-- Set input parametes 
MMregion_plt=p.Results.plot;
PMMylim=p.Results.PMMregion(1:2);
PMMxlim=p.Results.PMMregion(3:4);
NIDXylim=p.Results.NINOregion(1:2);
NIDXxlim=p.Results.NINOregion(3:4);
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



%% (1) select data in the PMM region ylimit=[-21 32]; xlimit=[-210 -95];


    % EN NINO indices NINO3 NINO4 NINO3.4, CTI
    %xlimit={[210 270]-360,[160 210]-360,[190 240]-360,[180 270]-360};
    %ylimit={[-5 5],[-5 5],[-5 5]};

lon=SST.lon; lat=SST.lat;

[I,J]=rgrd_FindIJ(lon,lat, PMMxlim, PMMylim);
[In,Jn]=rgrd_FindIJ(lon,lat, NIDXxlim, NIDXylim);

% select grid points         
sst.lon=SST.lon(I,J);
sst.lat=SST.lat(I,J);
sst.datenum=SST.datenum(idxfld);
tmpmask=SST.fld(I,J,1);
tmpmask(~isnan(tmpmask))=1;
%sst.mask=tmpmask;
sst.mask=SST.mask(I,J).*tmpmask;
sst.fld=SST.fld(I,J,idxfld);

ustr.lon=USTR.lon(I,J);
ustr.lat=USTR.lat(I,J);
ustr.datenum=USTR.datenum(idxfld);
ustr.mask=ones(size(USTR.mask(I,J)));
ustr.fld=USTR.fld(I,J,idxfld);

vstr.lon=VSTR.lon(I,J);
vstr.lat=VSTR.lat(I,J);
vstr.datenum=VSTR.datenum(idxfld);
vstr.mask=ones(size(VSTR.mask(I,J)));
vstr.fld=VSTR.fld(I,J,idxfld);       

time=sst.datenum;

% save memory deleting variables not used 
clear SST USTR VSTR    
        
%% (2) compute detrended anomalies 
[~,MM,~]=ctana_date_datenum(time);

[anom, seas] = ctana_RemoveSeas(sst.fld,MM);
[anomd, ftrend] = ctana_dtrend2d(anom,TrendType);
sst.ano=anomd;
[anom, seas] = ctana_RemoveSeas(ustr.fld,MM);
[anomd, ftrend] = ctana_dtrend2d(anom,TrendType);
ustr.ano=anomd;
[anom, seas] = ctana_RemoveSeas(vstr.fld,MM);
[anomd, ftrend] = ctana_dtrend2d(anom,TrendType);
vstr.ano=anomd;

disp(['          detrended montlhy mean anomalies computed'])



%% (3) compute NINO index (CTI) and linearly remove ENSO from the anomalies.
[IN,JN]=rgrd_FindIJ(sst.lon,sst.lat, NIDXxlim, NIDXylim);
tmp=sst.ano(IN,JN,:);
CTI=sq(nanmean(nanmean(tmp,1),2)); % plot(sst.datenum,CTI),datetick

[sstCTIrem]=ctana_RemoveIndex(time,sst.ano,sst.mask,CTI);
[ustrCTIrem]=ctana_RemoveIndex(time,ustr.ano,ustr.mask,CTI);
[vstrCTIrem]=ctana_RemoveIndex(time,vstr.ano,vstr.mask,CTI);

disp(['          ENSO Linear removed'])


%% (4) Standardize anomalies and compute spring (MAM) anomalies  *** DO YOU LIKE THIS NORMALIZATION?

sstaSTD = stdNaN(sstCTIrem,3);
ustrSTD = stdNaN(ustrCTIrem,3);
vstrSTD = stdNaN(vstrCTIrem,3);

T = size(sstCTIrem,3);
sst.anos = sstCTIrem ./ repmat(sstaSTD, [1 1 T]);
ustr.anos = ustrCTIrem ./ repmat(ustrSTD, [1 1 T]);
vstr.anos = vstrCTIrem ./ repmat(vstrSTD, [1 1 T]);



disp(['          Variables standardized and spring(MAM) anomalies computed'])



%% (5) Compute NPMM. via SVD of MAM anomalies of SST/USTR/VSTR
% recover the MM index SLP(SST) based projectiong the monthy mean anomalies on the first CEOF of SLP(SST)

if strcmp(freq,'MAM')
    sstaMAM=ctana_mom2seas(time,sst.anos,[3,3]);
    ustraMAM=ctana_mom2seas(time,ustr.anos,[3,3]);
    vstraMAM=ctana_mom2seas(time,vstr.anos,[3,3]);
    [EOFsst, EOFu, EOFv, PC, TIME, VEXP, norm_x, norm_y, norm_z]=rnt_combined10EOF_3FLD(sstaMAM.DSEAS_dates, sstaMAM.DSEASa,...
        sst.mask, ustraMAM.DSEAS_dates, ustraMAM.DSEASa, ustr.mask, vstraMAM.DSEAS_dates, vstraMAM.DSEASa, vstr.mask);  
elseif strcmp(freq,'monthly')
    [EOFsst, EOFu, EOFv, PC, TIME, VEXP, norm_x, norm_y, norm_z]=rnt_combined10EOF_3FLD(sst.datenum, sst.anos,...
        sst.mask, ustr.datenum, ustr.anos, ustr.mask, vstr.datenum, vstr.anos, vstr.mask);
end
%VEXP is just an estimation as has it account only for the first 10 modes

disp(['          SVD performed'])

CEOF.note={'MM computed as in Chang et al. (2007) except that here we SLP instead of wind speed. SVD on MAM anomalies'};
CEOF.lon=sst.lon;
CEOF.lat=sst.lat;
CEOF.mask=sst.mask;
CEOF.Teof=EOFsst;
CEOF.Ueof=EOFu;
CEOF.Veof=EOFv;
CEOF.Cpc=PC;% compbined PC
CEOF.Cpc_datenum=sstaMAM.DSEAS_dates;
CEOF.Cvexp=VEXP;
CEOF.Tnorm=norm_x;
CEOF.Unorm=norm_y;
CEOF.Vnorm=norm_z;


%% (6) Compute NPMM monthly mean index by projecting monthly mean anomalies on the 1st CEOF pattern 

% get spatial pattern
CEOF1T=ConvertXYT_into_ZT(CEOF.Teof(:,:,1),sst.mask);
CEOF1U=ConvertXYT_into_ZT(CEOF.Ueof(:,:,1),ustr.mask);
CEOF1V=ConvertXYT_into_ZT(CEOF.Veof(:,:,1),vstr.mask);

CEOF.MMpT=CEOF.Teof(:,:,1);
CEOF.MMpU=CEOF.Ueof(:,:,1);
CEOF.MMpV=CEOF.Veof(:,:,1);

% get anomalies 
sstaZT=ConvertXYT_into_ZT(sst.ano,sst.mask);
ustraZT=ConvertXYT_into_ZT(ustr.ano,ustr.mask);
vstraZT=ConvertXYT_into_ZT(vstr.ano,vstr.mask);
CEOF.MMiTano=(sstaZT'*CEOF1T)/std(sstaZT'*CEOF1T);
CEOF.MMiUano=(ustraZT'*CEOF1U)/std(ustraZT'*CEOF1U);
CEOF.MMiVano=(vstraZT'*CEOF1V)/std(vstraZT'*CEOF1V);


sstaZT=ConvertXYT_into_ZT(sstCTIrem,sst.mask);
ustraZT=ConvertXYT_into_ZT(ustrCTIrem,ustr.mask);
vstraZT=ConvertXYT_into_ZT(vstrCTIrem,vstr.mask);
CEOF.MMiTerem=(sstaZT'*CEOF1T)/std(sstaZT'*CEOF1T);
CEOF.MMiUerem=(ustraZT'*CEOF1U)/std(ustraZT'*CEOF1U);
CEOF.MMiVerem=(vstraZT'*CEOF1V)/std(vstraZT'*CEOF1V);

sstaZT=ConvertXYT_into_ZT(sst.anos,sst.mask);
ustraZT=ConvertXYT_into_ZT(ustr.anos,ustr.mask);
vstraZT=ConvertXYT_into_ZT(vstr.anos,vstr.mask);
CEOF.MMiTanos=(sstaZT'*CEOF1T)/std(sstaZT'*CEOF1T);
CEOF.MMiUanos=(ustraZT'*CEOF1U)/std(ustraZT'*CEOF1U);
CEOF.MMiVanos=(vstraZT'*CEOF1V)/std(vstraZT'*CEOF1V);

CEOF.MMi_datenum=time;

disp(['          NPMM computed'])


        if MMregion_plt==1
            figure
            %rnc_map(SST.mask,SST)
            
            ctplt_pmap(CEOF.MMpT,CEOF),hold on,axis([-240 -50 -60 60 ]),hold on
            % plot the region
            XboxCorn=[lon(I(1),J(1)),lon(I(end),J(1)),lon(I(end),J(1)),lon(I(1),J(1))];
            YboxCorn=[lat(I(1),J(1)),lat(I(1),J(1)),lat(I(1),J(end)),lat(I(1),J(end))];
            % close the rectangle
            XboxCorn(5)=XboxCorn(1);YboxCorn(5)=YboxCorn(1);
            plot(XboxCorn,YboxCorn,'Color','r','LineStyle','--','linewidth',2)
            
            XboxCornN=[lon(In(1),Jn(1)),lon(In(end),Jn(1)),lon(In(end),Jn(1)),lon(In(1),Jn(1))];
            YboxCornN=[lat(In(1),Jn(1)),lat(In(1),Jn(1)),lat(In(1),Jn(end)),lat(In(1),Jn(end))];
            XboxCornN(5)=XboxCornN(1);YboxCornN(5)=YboxCornN(1);
            plot(XboxCornN,YboxCornN,'Color','b','LineStyle','-','linewidth',1)
            shg
        end















