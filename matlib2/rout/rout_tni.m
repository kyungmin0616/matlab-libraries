function tni=rout_tni;

tmp=load('tni.txt');

years=tmp(:,1);

k=0; clear tni
for i=1:length(years)
for imon=1:12
  k=k+1;
  tni.index(k)=tmp(i,1+imon);
  tni.time(k)=datenum(years(i), imon, 15);
  tni.year(k)=years(i);
  tni.month(k)=imon;
end
end
 
tni.index=nn(tni.index);

return

[time, npgo, pdo]=rout_npgo;

load /drive/edl/NEPD/process_data/SalinityMODE/ENSO_NPGO/V1_rectwin_EOFs4.mat PC TIME

red_signi(tni.time, tni.index, time, npgo, 30, 2000);
red_signi(tni.time, tni.index, TIME, PC(:,2), 30, 2000);
