function pdo=rout_pdo(varagin)

data=load('pdo.txt');

if nargin == 1
  yrange=varargin{1};
else
 yrange=1949;
end

iy=0; k=0;
for yr=data(1,1):data(end,1)
iy=iy+1;
for imon=1:12
   k=k+1;
   pdo.index(k)=data(iy, imon+1);
   pdo.datenum(k)=datenum(yr,imon, 15);
   pdo.month(k)=imon;
   pdo.year(k)=yr;
end
end

in=find(pdo.year > yrange(1) & ~isnan(pdo.index) );
pdo.index=pdo.index(in)';
pdo.datenum=pdo.datenum(in)';
pdo.month=pdo.month(in)';
pdo.year=pdo.year(in)';
