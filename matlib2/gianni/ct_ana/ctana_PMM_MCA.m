function [MCA] = ctana_PMM_MCA(SST,USTR,VSTR,varargin)
%
% This function compute the North Pacific Meridional Mode similarly to 
% Chang at al. (2007).  Is based on an MCA analysis of Spring (MAM, March-April-May) 
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
%            note: {'PMM computed as in Chang et al. (2007) except that here we SLP...'}
%             lon: [61x28 double]
%             lat: [61x28 double]
%            mask: [61x28 double]
%            Tsvd: [61x28x10 double]
%            Usvd: [61x28x10 double]
%            Vsvd: [61x28x10 double]
%             Cpc: [31x10 double]
%     Cpc_datenum: [31x1 double]
%           Cvexp: [10x1 double]
%           PMMpT: [61x28 double]
%           PMMpU: [61x28 double]
%           PMMpV: [61x28 double]
%        PMMiTano: [372x1 double]
%        PMMiUano: [372x1 double]
%        PMMiVano: [372x1 double]
%       PMMiTerem: [372x1 double]
%       PMMiUerem: [372x1 double]
%       PMMiVerem: [372x1 double]
%       PMMiTanos: [372x1 double]
%       PMMiUanos: [372x1 double]
%       PMMiVanos: [372x1 double]
%    PMMi_datenum: [1x372 double]
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
defaultFreq='monthly'; %Montly or MAM March-April-May 
defaultNorm='mean'; % or 'mean' or 'none'

addRequired(p,'SST',@isstruct);
addRequired(p,'USTR',@isstruct);
addRequired(p,'VSTR',@isstruct);
addParamValue(p,'PMMregion',defaultPMMregion,@isnumeric)
addParamValue(p,'NINOregion',defaultNINOregion,@isnumeric)
addParamValue(p,'plot',defaultMAKEplot,@isnumeric)
addParamValue(p,'period',defaultPERIOD,@isnumeric)
addParamValue(p,'TypeDetrend',defaultDetrend,@ischar)
addParamValue(p,'freq',defaultFreq,@ischar)
addParamValue(p,'norm',defaultNorm,@ischar)

parse(p,SST,USTR,VSTR,varargin{:})

if ~isempty(fieldnames(p.Unmatched))
   disp('Extra inputs:')
   disp(p.Unmatched)
end
if ~isempty(p.UsingDefaults)
   disp('Using defaults: ')
   disp(p.UsingDefaults)
end

disp('Setting: ')
disp(['PMM region: [',n2s(p.Results.PMMregion),']',])
disp(['NINO region: [',n2s(p.Results.NINOregion),']'])
disp(['Detrend Type: ',p.Results.TypeDetrend])
disp(['Frequency: ',p.Results.freq])
disp(['Norm.: ',p.Results.norm])

%-- Set input parametes 
MMregion_plt=p.Results.plot;
PMMylim=p.Results.PMMregion(1:2);
PMMxlim=p.Results.PMMregion(3:4);
NIDXylim=p.Results.NINOregion(1:2);
NIDXxlim=p.Results.NINOregion(3:4);
TrendType=p.Results.TypeDetrend;
freq=p.Results.freq;
norm=p.Results.norm;

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
disp(' ')


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
tmpmask=USTR.fld(I,J,1);
tmpmask(~isnan(tmpmask))=1;
%ustr.mask=ones(size(USTR.mask(I,J)));
ustr.mask=USTR.mask(I,J).*tmpmask;
ustr.fld=USTR.fld(I,J,idxfld);

vstr.lon=VSTR.lon(I,J);
vstr.lat=VSTR.lat(I,J);
vstr.datenum=VSTR.datenum(idxfld);
tmpmask=VSTR.fld(I,J,1);
tmpmask(~isnan(tmpmask))=1;
%vstr.mask=ones(size(VSTR.mask(I,J)));
vstr.mask=VSTR.mask(I,J).*tmpmask;
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

disp(['Montlhy mean anomalies detrended...'])



%% (3) compute NINO index (CTI) and linearly remove ENSO from the anomalies.
[IN,JN]=rgrd_FindIJ(sst.lon,sst.lat, NIDXxlim, NIDXylim);
tmp=sst.ano(IN,JN,:);
CTI=sq(nanmean(nanmean(tmp,1),2)); % plot(sst.datenum,CTI),datetick

[sstCTIrem]=ctana_RemoveIndex(time,sst.ano,sst.mask,CTI);
[ustrCTIrem]=ctana_RemoveIndex(time,ustr.ano,ustr.mask,CTI);
[vstrCTIrem]=ctana_RemoveIndex(time,vstr.ano,vstr.mask,CTI);

disp(['ENSO removed linearly...'])


%% (4) Standardize anomalies and compute spring (MAM) anomalies  *** DO YOU LIKE THIS NORMALIZATION?

    sstaSTD = stdNaN(sstCTIrem,3);
    ustrSTD = stdNaN(ustrCTIrem,3);
    vstrSTD = stdNaN(vstrCTIrem,3);

if strcmp(norm,'full')    
    T = size(sstCTIrem,3);
    sst.anos = sstCTIrem ./ repmat(sstaSTD, [1 1 T]);
    ustr.anos = ustrCTIrem ./ repmat(ustrSTD, [1 1 T]);
    vstr.anos = vstrCTIrem ./ repmat(vstrSTD, [1 1 T]);
    
elseif strcmp(norm,'mean')
    
    sst.anos = sstCTIrem ./ nanmean(sstaSTD(:));
    ustr.anos = ustrCTIrem ./ nanmean(ustrSTD(:));
    vstr.anos = vstrCTIrem ./ nanmean(vstrSTD(:));
    
elseif strcmp(norm,'none')
    sst.anos = sstCTIrem;
    ustr.anos = ustrCTIrem;
    vstr.anos = vstrCTIrem;
end

%disp(['          Variables standardized'])



%% (5) Compute NPMM. via SVD of MAM anomalies of SST/USTR/VSTR
% recover the MM index SLP(SST) based projectiong the monthy mean anomalies on the first CEOF of SLP(SST)

if strcmp(freq,'MAM')
    sstaMAM=ctana_mom2seas(time,sst.anos,[3,3]);
    ustraMAM=ctana_mom2seas(time,ustr.anos,[3,3]);
    vstraMAM=ctana_mom2seas(time,vstr.anos,[3,3]);
    [EOFsst, EOFu, EOFv, EOFwind PCsst,PCwind, TIME, VEXP,EIG10,]=ctana_MCA_3FLD(sstaMAM.DSEAS_dates, sstaMAM.DSEASa,...
        sst.mask, ustraMAM.DSEAS_dates, ustraMAM.DSEASa, ustr.mask, vstraMAM.DSEAS_dates, vstraMAM.DSEASa, vstr.mask);
elseif strcmp(freq,'monthly')
    [EOFsst, EOFu, EOFv, EOFwind, PCsst,PCwind, TIME, VEXP,EIG10,]=ctana_MCA_3FLD(sst.datenum, sst.anos,...
        sst.mask, ustr.datenum, ustr.anos, ustr.mask, vstr.datenum, vstr.anos, vstr.mask);
end


%VEXP is just an estimation as has it account only for the first 10 modes

disp(['SVD performed...'])

CEOF.note={'MM computed as in Chang et al. (2007) except that here we SLP instead of wind speed. SVD on MAM anomalies'};
CEOF.lon=sst.lon;
CEOF.lat=sst.lat;
CEOF.mask=sst.mask;
CEOF.Tsvd=EOFsst;
CEOF.Wsvd=EOFwind;
CEOF.Usvd=EOFu;
CEOF.Vsvd=EOFv;
CEOF.Tpcs=PCsst; % compbined PC
CEOF.Wpcs=PCwind;
CEOF.pcs_datenum=TIME;
CEOF.VEXP=VEXP;
CEOF.EIGS=EIG10;


%% (6) Compute NPMM monthly mean index by projecting monthly mean anomalies on the 1st CEOF pattern 

% get spatial pattern
%UVmask=ones(size(sq(CEOF.Wsvd(:,:,1))));
UVmask=[ustr.mask,vstr.mask];

CEOF1T=ConvertXYT_into_ZT(CEOF.Tsvd(:,:,1),sst.mask);
CEOF1W=ConvertXYT_into_ZT(CEOF.Wsvd(:,:,1),UVmask);
CEOF1U=ConvertXYT_into_ZT(CEOF.Usvd(:,:,1),ustr.mask);
CEOF1V=ConvertXYT_into_ZT(CEOF.Vsvd(:,:,1),vstr.mask);

CEOF.pT=CEOF.Tsvd(:,:,1);
CEOF.pW=CEOF.Wsvd(:,:,1);
CEOF.pU=CEOF.Usvd(:,:,1);
CEOF.pV=CEOF.Vsvd(:,:,1);

% get anomalies 
sstaZT=ConvertXYT_into_ZT(sst.ano,sst.mask);
windaZW=ConvertXYT_into_ZT([ustr.ano,vstr.ano],UVmask);
ustraZT=ConvertXYT_into_ZT(ustr.ano,ustr.mask);
vstraZT=ConvertXYT_into_ZT(vstr.ano,vstr.mask);
CEOF.iTano=(sstaZT'*CEOF1T)/std(sstaZT'*CEOF1T);
CEOF.iWano=(windaZW'*CEOF1W)/std(windaZW'*CEOF1W);
CEOF.iUano=(ustraZT'*CEOF1U)/std(ustraZT'*CEOF1U);
CEOF.iVano=(vstraZT'*CEOF1V)/std(vstraZT'*CEOF1V);


sstaZT=ConvertXYT_into_ZT(sstCTIrem,sst.mask);
windaZW=ConvertXYT_into_ZT([ustrCTIrem,vstrCTIrem],UVmask);
ustraZT=ConvertXYT_into_ZT(ustrCTIrem,ustr.mask);
vstraZT=ConvertXYT_into_ZT(vstrCTIrem,vstr.mask);
CEOF.iTerem=(sstaZT'*CEOF1T)/std(sstaZT'*CEOF1T);
CEOF.iWerem=(windaZW'*CEOF1W)/std(windaZW'*CEOF1W);
CEOF.iUerem=(ustraZT'*CEOF1U)/std(ustraZT'*CEOF1U);
CEOF.iVerem=(vstraZT'*CEOF1V)/std(vstraZT'*CEOF1V);

sstaZT=ConvertXYT_into_ZT(sst.anos,sst.mask);
windaZW=ConvertXYT_into_ZT([ustr.anos,vstr.anos],UVmask);
ustraZT=ConvertXYT_into_ZT(ustr.anos,ustr.mask);
vstraZT=ConvertXYT_into_ZT(vstr.anos,vstr.mask);
CEOF.iTanos=(sstaZT'*CEOF1T)/std(sstaZT'*CEOF1T);
CEOF.iWanos=(windaZW'*CEOF1W)/std(windaZW'*CEOF1W);
CEOF.iUanos=(ustraZT'*CEOF1U)/std(ustraZT'*CEOF1U);
CEOF.iVanos=(vstraZT'*CEOF1V)/std(vstraZT'*CEOF1V);

CEOF.i_datenum=time;

disp(['PMM computed'])


        if MMregion_plt==1
            figure
            %rnc_map(SST.mask,SST)
            
            ctplt_pmap(CEOF.pT,CEOF),hold on,axis([-240 -50 -60 60 ]),hold on
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

MCA=CEOF;














