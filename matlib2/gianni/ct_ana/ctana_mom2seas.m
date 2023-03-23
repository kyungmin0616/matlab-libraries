 function [b]=ctana_mom2seas(time,data,seasdef)
%% ctana_mom2seas: compute seasonal statistics from monthly mean values  
% [SEASdata] = ctana_mom2seas(dates,MOMdata,custom_season)
%  
%  This function compute the seasonal mean from a monthly mean dataset.
%  The season definition follow the most commun convention:  
%  DJF for Winter, MAM for Spring, JJA for Summer and SON for Autumn       
%  Only season having 3 months are computed in a way that uncomplete 
%  seasons in front and in the and of the times series are not 
%  considered.
%  User can specify the season season definition using the additional input.  
%
%  G. Liguori, 2014 (@GATECH)
%
%  INPUTS: 
%       dates,      Vector of dates in matlab format convention   
%       MOMdata,    multidimensional array having the time in the last 
%                   dimension: MOMdata(dim1,dim2,...,dim5,month); (No more
%                   then 5 dim)
%       custom_seas,  User season defintion. This is a two component
%                     vector. The first component is the starting month and
%                     the second component is the # of consecutive month to
%                     retain. For example, custom_seas=[11,4] means NDJF
%                     
%       (optional)                         
%
%  OUTPUTS:
%       SEASdata,    struct containing all the seasonal mean values
%      
%       SEASdata.seas,       SEASdata.seas(dim1,dim2,...,dimN,Nseas)
%       SEASdata.seas_dates, SEASdata.seas_dates(Nseas)     
%       SEASdata.DJF,        SEASdata.DJF(dim1,dim2,...,dimN,Nseas)
%       SEASdata.DJF_dates,  SEASdata.DJF_dates(N_DJF_seas )
%       SEASdata.MAM,        ...
%       SEASdata.MAM_dates,  ...
%       SEASdata.JJA,        ...
%       SEASdata.JJA_dates,  ... 
%       SEASdata.SON,        ... 
%       SEASdata.SON_dates,  ...
%   
%
%
%  Example: If MOMdata: MOMdata(170,64,480), lon,lat,time (40yrs)
%                   dates:   dates(1,480)
%      
%       then [SEASdata]=ctana_mom2seas(dates, MOMdata)   gives:
%
%
%          SEASdata = 
%
%                DJF: [170x64x39 double]
%          DJF_dates: [1x39 double]
%                MAM: [170x64x40 double]
%          MAM_dates: [1x40 double]
%                JJA: [170x64x40 double]
%          JJA_dates: [1x40 double]
%                SON: [170x64x40 double]
%          SON_dates: [1x40 double]
%               seas: [170x64x159 double]
%         seas_dates: [1x159 double]     
%                      
%   See also MEDIAN, STD, MIN, MAX, VAR, COV, MODE.
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

 
[~,month,~]=ctana_date_datenum(time);
ndim=numel(size(data)); 
smon=month(1); %starting month
%lmon=numel(time); %number of months

if nargin>2

    % find indices
    % seasdef: [sm,# of months]; e.g., [11,3] means NDJ
    % find starting months
    SM=find(month==seasdef(1));

    % eliminate the last season if if not complete
     mdiff=numel(month) - (SM(end)+seasdef(2)-1);
     endseas=numel(SM);
     if mdiff < 0
         endseas=numel(SM)-1;       
     end
     
     if ndim==2
         for j=1:endseas
             seasidx(:,j)=SM(j):SM(j)+seasdef(2)-1;
             def_seas(j)=mean(data(seasidx(:,j)));
             def_seas_time(j)=mean(time(seasidx(:,j)));
         end
         
         a.DSEAS=def_seas;   
         a.DSEASa=def_seas-nanmean(def_seas);
         a.DSEAS_dates=def_seas_time';
         
         
     elseif ndim==3
         for j=1:endseas
             seasidx(:,j)=SM(j):SM(j)+seasdef(2)-1;
             def_seas(:,:,j)=mean(data(:,:,seasidx(:,j)),ndim);
             def_seas_time(j)=mean(time(seasidx(:,j)));
         end
         
         
         a.DSEAS=def_seas;   
         a.DSEASa=def_seas-repmat(nanmean(def_seas,3),[1,1,endseas]);
         a.DSEAS_dates=def_seas_time';
         
     elseif ndim==4
         %write it!
     end
     
%     b=a;
      b.SEASclm=sq(mean(a.DSEAS,3));
      b.SEASa=a.DSEASa;
      b.SEASdates=a.DSEAS_dates;
    
    
    
    
else
%determine starting computational month
if smon==1 || smon==2 || smon==3;
smonc=3-smon+1; wi=4;sp=1;su=2;au=3;
elseif smon==4 || smon==5 || smon==6;
smonc=6-smon+1; wi=3;sp=4;su=1;au=2;   
elseif smon==7 || smon==8 || smon==9;
smonc=9-smon+1; wi=2;sp=3;su=4;au=1;
elseif smon+1==10 || smon==11 || smon==12;
smonc=12-smon+1; wi=1;sp=2;su=3;au=4;
end

%lmonc: number of months used in the computation 
lmonc=numel(time(smonc:end))-mod(numel(time(smonc:end)),3);

lseas=lmonc/3; %number of computable seasons

idx=smonc;
time_seas=time(smonc+1:3:end-mod(numel(time(smonc:end)),3));

arrsize=size(data);
ndim=numel(arrsize);

par_seas=zeros([arrsize(1:end-1),lseas]);

if ndim==2
    par_seas=0;
   for iseas=1:lseas 
       par_seas(iseas)=mean(data(idx:idx+2)); idx=idx+3;
   end
   a.DJF=par_seas(wi:4:end);
   a.MAM=par_seas(sp:4:end);
   a.JJA=par_seas(su:4:end);
   a.SON=par_seas(au:4:end);
   
   a.DJFa=par_seas(wi:4:end)-mean(par_seas(wi:4:end));
   a.MAMa=par_seas(sp:4:end)-mean(par_seas(sp:4:end));
   a.JJAa=par_seas(su:4:end)-mean(par_seas(su:4:end));
   a.SONa=par_seas(au:4:end)-mean(par_seas(au:4:end));
   

elseif ndim==3
   for iseas=1:lseas 
        par_seas(:,:,iseas)=mean(data(:,:,idx:idx+2),ndim); idx=idx+3;
   end
   a.DJF=par_seas(:,:,wi:4:end);
   a.MAM=par_seas(:,:,sp:4:end);
   a.JJA=par_seas(:,:,su:4:end);
   a.SON=par_seas(:,:,au:4:end); 
   
    %a.DJFa=par_seas(:,:,wi:4:end)-sq(mean(par_seas(:,:,wi:4:end),3));
    %a.MAMa=par_seas(:,:,sp:4:end)-sq(mean(par_seas(:,:,sp:4:end),3));
    %a.JJAa=par_seas(:,:,su:4:end)-sq(mean(par_seas(:,:,su:4:end),3));
    %a.SONa=par_seas(:,:,au:4:end)-sq(mean(par_seas(:,:,au:4:end),3));
    
    a.DJFclm=mean(a.DJF,3);
    a.MAMclm=mean(a.MAM,3);
    a.JJAclm=mean(a.JJA,3);
    a.SONclm=mean(a.SON,3);
    
    
    
for i=1:size(a.DJF,3);
a.DJFa(:,:,i)=a.DJF(:,:,i)-mean(a.DJF,3);
end
for i=1:size(a.MAM,3);
a.MAMa(:,:,i)=a.MAM(:,:,i)-mean(a.MAM,3);
end
for i=1:size(a.JJA,3);
a.JJAa(:,:,i)=a.JJA(:,:,i)-mean(a.JJA,3);
end
for i=1:size(a.SON,3);
a.SONa(:,:,i)=a.SON(:,:,i)-mean(a.SON,3);
end
    

elseif ndim==4
   for iseas=1:lseas 
        par_seas(:,:,:,iseas)=mean(data(:,:,:,idx:idx+2),ndim); idx=idx+3;
   end
   a.DJF=par_seas(:,:,:,wi:4:end);
   a.MAM=par_seas(:,:,:,sp:4:end);
   a.JJA=par_seas(:,:,:,su:4:end);
   a.SON=par_seas(:,:,:,au:4:end); 
   


elseif ndim==5
   for iseas=1:lseas 
        par_seas(:,:,:,:,iseas)=mean(data(:,:,:,:,idx:idx+2),ndim); idx=idx+3;
   end
   a.DJF=par_seas(:,:,:,:,wi:4:end);
   a.MAM=par_seas(:,:,:,:,sp:4:end);
   a.JJA=par_seas(:,:,:,:,su:4:end);
   a.SON=par_seas(:,:,:,:,au:4:end);   
   
   
end


a.DJF_dates=time_seas(wi:4:end);
a.MAM_dates=time_seas(sp:4:end);
a.JJA_dates=time_seas(su:4:end);
a.SON_dates=time_seas(au:4:end);

b.DJFclm=a.DJFclm;
b.MAMclm=a.MAMclm;
b.JJAclm=a.JJAclm;
b.SONclm=a.SONclm;

noanom=0;
if noanom
b.DJF=a.DJF;
b.MAM=a.MAM(:,:,2:end);
b.JJA=a.JJA(:,:,2:end);
b.SON=a.SON(:,:,2:end);
else
b.DJFa=a.DJFa;
b.MAMa=a.MAMa(:,:,2:end);
b.JJAa=a.JJAa(:,:,2:end);
b.SONa=a.SONa(:,:,2:end);
end

b.DJFdates=a.DJF_dates(1:end);
b.MAMdates=a.MAM_dates(2:end);
b.JJAdates=a.JJA_dates(2:end);
b.SONdates=a.SON_dates(2:end);


%a.seas=par_seas;
%a.seas_dates=time_seas;

%%%%%%%%%%%% Temporaney, needs to be optimized 
% for i=1:size(a.DJF,3);
% a.DJFa(:,:,i)=a.DJF(:,:,i)-mean(a.DJF,3);
% end
% for i=1:size(a.MAM,3);
% a.MAMa(:,:,i)=a.MAM(:,:,i)-mean(a.MAM,3);
% end
% for i=1:size(a.JJA,3);
% a.JJAa(:,:,i)=a.JJA(:,:,i)-mean(a.JJA,3);
% end
% for i=1:size(a.SON,3);
% a.SONa(:,:,i)=a.SON(:,:,i)-mean(a.SON,3);
% end

end


