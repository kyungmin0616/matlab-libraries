

function [ncepd] = rnc_reconstructNCEP_add_daily(lonr,latr,mydatenum,ncepR);

vars=    {'sustr' 'svstr'};
qscb = rnc_ExtractNCEP_QSCATT(lonr,latr,datenum(2002,10,10), 'monthly');  
ncepd = rnc_Extract_SurfFluxes_NCEP(qscb.lon,qscb.lat, mydatenum, 'daily',vars);

[I,J,T]=size(ncepR.lon);
T=length(mydatenum);

sustr=zeros(I,J,T)*nan;
svstr=sustr;

disp('Doing interp ...');
for it=1:length(ncepd.datenum);
  disp(it)
   sustr(:,:,it)=interp2(ncepd.lon',ncepd.lat',ncepd.sustr(:,:,it)', ncepR.lon,ncepR.lat,'cubic');
   svstr(:,:,it)=interp2(ncepd.lon',ncepd.lat',ncepd.svstr(:,:,it)', ncepR.lon,ncepR.lat,'cubic');
end   
disp('DONE. - interp');

ncepd.sustr=sustr;
ncepd.svstr=svstr;
ncepd.lon=ncepR.lon;
ncepd.lat=ncepR.lat;
ncepd.mask=ncepR.mask;


for year = ncepd.year(1): ncepd.year(end);
for mon=1:12
    in=find( ncepd.month == mon & ncepd.year == year);
    it=find( ncepR.month == mon & ncepR.year == year);

    if length(in) > 0    
    tmpMean = mean( ncepd.sustr(:,:,in),3);
    tmpMean = repmat(tmpMean, [ 1 1 length(in)]);
    tmpMean2= repmat(mean(ncepR.sustr(:,:,it),3), [ 1 1 length(in)]);
    ncepd.sustr(:,:,in) = ncepd.sustr(:,:,in) - tmpMean + tmpMean2;
    
    tmpMean = mean( ncepd.svstr(:,:,in),3);
    tmpMean = repmat(tmpMean, [ 1 1 length(in)]);
    tmpMean2= repmat(mean(ncepR.svstr(:,:,it),3), [ 1 1 length(in)]);
    ncepd.svstr(:,:,in) = ncepd.svstr(:,:,in) - tmpMean + tmpMean2;
    
    end
    
end
end




