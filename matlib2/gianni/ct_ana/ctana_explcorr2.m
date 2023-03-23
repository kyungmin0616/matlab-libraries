function ctana_explcorr2(fplt, f3d1,forcd1,f3d2,forcd2,dt,lag)

%ct_ana_explcorr(SSTa.clm(:,:,1),SSTa)

if nargin<7
    lag=0;
end


[status,pcname]=system('hostname');
if strcmp(pcname(1:end-1),'eas-est-311603')
    set(gcf,'render','zbuffer')
    figure('pos',[30  89  1866   889])
else
%figure('pos',[30  89  1866   889]) %EAS screen 
figure('pos',[-285 869 1888 900]) %Home screen
end


% stop = uicontrol('style','toggle','string','ferma', ... 
%    'background','white');

subplot1(2,3,'Gap',[0.01 0.04])
subplot1(1)
ctplt_pmap(fplt,forcd1);
shading interp
hold on
gradsmap4;
colorbar('horiz');
world_coast('color','k','linewidth',2);shg
fix_vis_prob
axis([min(forcd1.lon(:)) max(forcd1.lon(:)) min(forcd1.lat(:)) max(forcd1.lat(:))])
set(gca,'color',[.7 .7 .7])
title(['LAG ',num2str(lag)],'fontsize',14)

% nfig= uicontrol('position',[500 20 60 20],'style','pushbutton','string','nfig', ... 
%    'background','white','callback',@ctana_explcorr); 


pause
[i,j]=rgrd_FindIJ(forcd1.lon,forcd1.lat);
axis([min(forcd1.lon(:)) max(forcd1.lon(:)) min(forcd1.lat(:)) max(forcd1.lat(:))])
% change it with ginput!

% make index

if3da=(sq(nanmean(nanmean(f3d1(i,j,:),1),2)));
if3da=if3da(:);
if3da=if3da';


%[f2d]=ConvertXYT_into_ZT(f3d,forcd.mask);

o=ctana_corr2d(forcd1.datenum-lag,f3d1, forcd1.mask, forcd1.datenum, if3da, dt);
o2=ctana_corr2d(forcd1.datenum-lag,f3d2, forcd1.mask, forcd1.datenum, if3da, dt);

    
%subplot(1,2,1)
subplot1(2)
ctplt_pmap2(o.corr,forcd1)
axis([min(forcd1.lon(:)) max(forcd1.lon(:)) min(forcd1.lat(:)) max(forcd1.lat(:))])
set(gca,'color',[.7 .7 .7])
hold on
caxis([-1 1])
title('Corr(FLD1idx,FLD1)','fontsize',14)

[xM,xm]=minmax(forcd1.lon(i,j));
[yM,ym]=minmax(forcd1.lat(i,j));
plot([xm,xM,xM,xm,xm],[ym,ym,yM,yM,ym],'b-')
colorbar('vert');

%subplot(1,2,2)
subplot1(3)
ctplt_pmap2(o.regress,forcd1)
%caxis([-1 1])
plot([xm,xM,xM,xm,xm],[ym,ym,yM,yM,ym],'b-')
axis([min(forcd1.lon(:)) max(forcd1.lon(:)) min(forcd1.lat(:)) max(forcd1.lat(:))])
cbound=max(abs(o.regress(:)));
set(gca,'color',[.7 .7 .7],'clim',0.8.*[-cbound cbound])
title('Reg(FLD1idx,FLD1) [FLD1 units / std units of FLD1idx]','fontsize',14)
colorbar('vert');


subplot1(4)
set(gca,'visible','off')

subplot1(5)
ctplt_pmap2(o2.corr,forcd2)
axis([min(forcd2.lon(:)) max(forcd2.lon(:)) min(forcd2.lat(:)) max(forcd2.lat(:))])
set(gca,'color',[.7 .7 .7])
hold on
caxis([-1 1])
title('Corr(FLD1idx,FLD2)','fontsize',14)
plot([xm,xM,xM,xm,xm],[ym,ym,yM,yM,ym],'b-')
colorbar('vert');

%subplot(1,2,2)
subplot1(6)
ctplt_pmap2(o2.regress,forcd2)
%caxis([-1 1])
plot([xm,xM,xM,xm,xm],[ym,ym,yM,yM,ym],'b-')
axis([min(forcd2.lon(:)) max(forcd2.lon(:)) min(forcd2.lat(:)) max(forcd2.lat(:))])
cbound=max(abs(o.regress(:)));
set(gca,'color',[.7 .7 .7],'clim',0.8.*[-cbound cbound])
title('Reg(FLD1idx,FLD2) [FLD2 units / std units of FLD1idx]','fontsize',14)
colorbar('vert');

gradsmap4
fix_vis_prob
shg

stop = uicontrol('position',[43 343 83 37],'style','toggle','string','exit', 'background','white');
nfig = uicontrol('position',[43 443 83 37],'style','toggle','string','recompute','background','white');
lagtag = uicontrol('position',[43 243 83 37],'style','edit','string',num2str(lag),'background','white');

set(stop,'fontsize',14)
set(nfig,'fontsize',12)
set(lagtag,'fontsize',14)

%lag=str2num(get(lagtag,'string'));

while ~get(stop,'value')
pause(1/2)
%disp('wait')

if get(nfig,'value')
    set(stop,'value',1)
    lag=str2num(get(lagtag,'string'));
ctana_explcorr2(fplt, f3d1,forcd1,f3d2,forcd2,dt,lag)
end

end

 

return

% 
% function funtest
% 
% disp('here')
% 
% end
% pause
% 
% 
% 
% subplot(2,1,1)

