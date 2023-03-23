function [qsc]=qsc_MakeMonthly(mydatenumn)

clear mydatenum
n=0;
for year=2000:2004
for mon=1:12
  n=n+1;
  mydatenum(n)= datenum(year,mon,15);
end
end



% read the first file
[files, mydatenum2] = qsc_getfiles(1999);
month=str2num(datestr(mydatenum2,5));
[TAUXn,TAUYn,lon,lat,time]=qsc_read_L3stress(files{1});
[I1,J1]=size(lon);


qsc.lon=lon;
qsc.lat=lat;


ctlf.datenum=mydatenum;
ctlf.year=str2num(datestr(mydatenum,10));
ctlf.month=str2num(datestr(mydatenum,5));

TIMEINDEX=length(ctlf.datenum);
[I,J]=size(lon);
qsc.sustr=zeros(I,J,TIMEINDEX);
qsc.svstr=zeros(I,J,TIMEINDEX);
LOADED_YEAR=0;
TIMEINDEX=0;

for TIMEINDEX=1: length(ctlf.datenum)

  year=ctlf.year(TIMEINDEX);        
  % load data if needed.
  if LOADED_YEAR ~= year 
    disp(['Loading ... ',num2str(year)])
    [files, mydatenum2] = qsc_getfiles(year);
    month=str2num(datestr(mydatenum2,5));
    LOADED_YEAR=year;
   end
     
    % you can find the dates now with datestr
        ifiles=find(month == ctlf.month(TIMEINDEX) );
        TAUXn=zeros(I1,J1);
        TAUYn=zeros(I1,J1);
        TAUX=TAUXn;
        TAUY=TAUYn;
        for ii=ifiles'
            [taux,tauy,LON,LAT,time]=qsc_read_L3stress(files{ii});
		  in = find(~isnan(taux));
            TAUXn(in) = TAUXn(in) +1;
            TAUX(in) = TAUX(in) + taux(in);
    
            in = find(~isnan(tauy));
            TAUYn(in) = TAUYn(in) +1;
            TAUY(in) = TAUY(in) + tauy(in) ;
         end    
         % end of average
         taux = TAUX./TAUXn;
         tauy = TAUY./TAUYn;
         qsc.svstr(:,:,TIMEINDEX)=(tauy(i,j));
         qsc.sustr(:,:,TIMEINDEX)=(taux(i,j));   

	  
   end
        % common to all
        qsc.year(TIMEINDEX)  = ctlf.year(TIMEINDEX);
        qsc.month(TIMEINDEX) = ctlf.month(TIMEINDEX);
	  qsc.datenum(TIMEINDEX) = ctlf.datenum(TIMEINDEX);
	  qsc.day(TIMEINDEX) = ctlf.day(TIMEINDEX);
end

save /sdb/edl/ROMS-pak/matlib/qsc/qsc_monthly qsc










return
