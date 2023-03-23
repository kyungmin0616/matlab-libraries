function forcd = rnc_forcdStats(forcd1,varib, varargin)

forcd=forcd1;
warning off
[year,month]=dates_datenum(forcd1.datenum);
forcd.year=year;
forcd.month=month;
f=getfield(forcd1,varib);
[fano,fseas]=RemoveSeas(f,month,3);
[fano,ftrend]=dtrend2d(fano);
favg=sq(meanNaN( meanNaN( fano,1), 2));

forcd.mean=mean(fseas,3);
forcd.seas=fseas;
forcd.ano=fano;
forcd.trend=ftrend;
forcd.avg=favg;

if nargin == 3
  year_range = varargin{1};

  ind=find(year>= year_range(1) & year <= year_range(2));
  for imon=1:12
    in=find( month(ind) == imon);
    forcd.anom(:,:,:,imon) = forcd.ano(:,:, ind(in) );
  end
end


