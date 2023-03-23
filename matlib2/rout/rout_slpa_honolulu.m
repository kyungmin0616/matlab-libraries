function slpah = rout_slpa_honolulu

file = which('HonoluluSLP2.txt');
SLP = load(file);

tmpindex = reshape(SLP(:,4:15)',[size(SLP,1)*12 1]);

missing = find(tmpindex > 1100 | tmpindex < 950);
tmpindex(missing) = NaN;

n=0;
for yr=min(SLP(:,2)):max(SLP(:,2))
    for imon=1:12
        n=n+1;
        time(n)=datenum(yr,imon,15);
    end
end

[year,month] = dates_datenum(time);

inSLP = 1:length(year);

y = tmpindex(inSLP);
year = year(inSLP); month = month(inSLP); time = time(inSLP);

slpah.time=time;
slpah.month=month;
slpah.index=y;
slpah.year=year;

return
end
