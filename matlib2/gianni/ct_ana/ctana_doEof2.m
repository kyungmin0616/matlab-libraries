function EOFS = ctana_doEof2(SST,varargin)
% This function compute EOFs 
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
%       then EOFS=ctana_doEof2(SST)   gives:
%
%
%     EOFS = 
% 
%              lon: [85x22 double]
%              lat: [85x22 double]
%             mask: [85x22 double]
%          datenum: [1x768 double]
%              sst: [1x1 struct]  
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

defaultregion = [-20 20 -240 -80];  % CTI
defaultMAKEplot = 0;
defaultPERIOD = nan; % nan means ALL YEARS 
defaultFLD = 'fld';
defaultDetrend='lin';


addRequired(p,'SST',@isstruct);
addParamValue(p,'region',defaultregion,@isnumeric)
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

disp(['region: [',n2s(p.Results.region),']'])
disp(['Detrend Type: ',p.Results.TypeDetrend])

%-- Set input parametes 
MMregion_plt=p.Results.plot;
NIDXylim=p.Results.region(1:2);
NIDXxlim=p.Results.region(3:4);
fieldname=p.Results.fieldname;

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

f=getfield(SST,fieldname);

tmpmask=f(I,J,1);
tmpmask(~isnan(tmpmask))=1;
sst.mask=SST.mask(I,J).*tmpmask;

sst.fld=f(I,J,idxfld);       

time=sst.datenum;


%% (2) compute detrended anomalies 
[~,MM,~]=ctana_date_datenum(time);

[anom, seas] = ctana_RemoveSeas(sst.fld,MM);
[anomd1, ftrend] = ctana_dtrend2d(anom,p.Results.TypeDetrend);


% TEMP BY GL  ############ ADD OPTION 
filter_fld=0;
if filter_fld
N=4*12;
winname='blackman';
anomd1lf=rnt_filter3d(anomd1, sst.mask, N, winname);
anomd1lf(isnan(anomd1lf))=0;
anomd=anomd1lf;
else
anomd=anomd1;
end
% ______________________________________________


sst.ano=anomd;

EOFS.lon=sst.lon;
EOFS.lat=sst.lat;
EOFS.mask=sst.mask;
EOFS.datenum=sst.datenum;
EOFS.sst.clm=seas;
EOFS.sst.trend=ftrend;


%% (2) compute NINO indices

% EN NINO indices CTI NINO1+2 NINO3 NINO4 NINO3.4
%xlimit={[180 270]-360, [-90 -80], [210 270]-360, [160 210]-360, [190 240]-360,};
%ylimit={[-10 0],       [-5 5],    [-5 5],        [-5 5],        [-6 6]};

%[IN,JN]=rgrd_FindIJ(sst.lon,sst.lat, NIDXxlim, NIDXylim);
%tmp=sst.ano(IN,JN,:);
%CTI=sq(nanmean(nanmean(tmp,1),2)); % plot(sst.datenum,CTI),datetick

%EOFS.NINOidx_list={'CTI','NINO1+2','NINO3','NINO4','NINO3.4'};
%for i=1:numel(xlimit);
%   EOFS.NINOidx(:,i)=ctana_get_ts(sst.lon,sst.lat,sst.ano,[xlimit{i},ylimit{i}]);
%end



%% (3) Remove NINO indices from anomalies

%[sstN12rem]=ctana_RemoveIndex(time,sst.ano,sst.mask,EOFS.NINOidx(:,2));
%[sstN4rem]=ctana_RemoveIndex(time,sst.ano,sst.mask,EOFS.NINOidx(:,4));

%-- compute EP-EOFS and save first 10 EOF
[eofs,eofs_coeff,varexp]=ctana_doEof(sst.ano,sst.mask,1);

EOFS.vexp=varexp;
EPp=eofs(:,:,1);
EPi=eofs_coeff(:,1);
EOFS.eof=eofs(:,:,1:10);
EOFS.pcs=eofs_coeff(:,1:10);

        if MMregion_plt==1
            figure
            %rnc_map(SST.mask,SST)
            
            ctplt_pmap(EPp,EOFS),hold on,axis([-240 -50 -60 60 ]),hold on
            % plot the region
            XboxCorn=[lon(I(1),J(1)),lon(I(end),J(1)),lon(I(end),J(1)),lon(I(1),J(1))];
            YboxCorn=[lat(I(1),J(1)),lat(I(1),J(1)),lat(I(1),J(end)),lat(I(1),J(end))];
            % close the rectangle
            XboxCorn(5)=XboxCorn(1);YboxCorn(5)=YboxCorn(1);
            plot(XboxCorn,YboxCorn,'Color','r','LineStyle','--','linewidth',2)
            
            shg
        end














