%RNT_EXTR_TIMESERIES
% function [sa,sm, so, i, j]=rnt_extr_timeseries(varib, ctl, xlim, ylim, grd, it, klev)
%

function [sa,sm, so, i, j]=rnt_extr_timeseries(varib, ctl, xlim, ylim, grd, it, klev)

i=find (grd.lonr(:,1) > xlim(1) & grd.lonr(:,1) < xlim(2));
j=find (grd.latr(1,:) > ylim(1) & grd.latr(1,:) < ylim(2));


T=length(it);
s=rnt_loadvar_segp(ctl,it,varib,i,j,klev);
so=s;
[I,J,K]=size(s);
smask=repmat(grd.maskr(i,j), [1 1 K]);
s=s.*smask;
s(s< -99) =nan;
s=sq(meanNaN(meanNaN(s,1),2));
[sa,sm]=RemoveSeas1D(s,ctl.month(it),1);


return
xlim=[-145         -130]; ylim=[31.0075 32.8982];
klev=8;
grd=rnt_gridload('nepd');
varib='salt';
