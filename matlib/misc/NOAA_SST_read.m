file=which('noaa-sst.mnmean.nc');
[fout,lon,lat] = cdc_readvar (file, 'sst','time',1:1812);

n=0;
clear time;
for yr=1854:2004
for imon=1:12
n=n+1;
time(n)=datenum(yr,imon,15);
end
end
mask = fout(:,:,1)*0 +1;


lonmin=-340;
lonmax=-255;
latmax=10;
latmin=-10;

 i=find ( squeeze(lon(:,1)) > lonmin & squeeze(lon(:,1)) < lonmax);
  j=find ( squeeze(lat(1,:)) > latmin & squeeze(lat(1,:)) <latmax);

  lon=lon(i,j);
  lat=lat(i,j);
 fout=fout(i,j,:);
 mask=fout(:,:,1);
 mask(~isnan(mask))=1;
 
 month = str2num(datestr(time,5));
 year=str2num(datestr(time,10));
 [ssta, sstm] = RemoveSeas(fout,month,3);
 
 rnt_contourfill(lon,lat,sstm(:,:,7),30); 
 colormap(getpmap(7));
 
 in = find(year > 1950); 
[eofs,coef,varex]=rnt_doEof(ssta(:,:,in),mask);
in1 = find( year > 1950 & month == 1);
[eofs1,coef1,varex1]=rnt_doEof(ssta(:,:,in1),mask);

k=2;
mfig;
colormap(getpmap(7));
subplot(2,1,1)
rnt_contourfill(lon,lat,eofs(:,:,k),30); 
subplot(2,1,2)
plot(time(in), coef(:,k),'color',[ .6 .6 .6]);
datetick
rnt_font

lprps trop_sst_eof1.eps

