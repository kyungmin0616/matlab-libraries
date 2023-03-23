function if3da=ctana_explcorr(fplt, f3d,forcd,dt)

%ct_ana_explcorr(SSTa.clm(:,:,1),SSTa)


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

subplot1(1,3)
subplot1(1)
ctplt_pmap(fplt,forcd);
shading interp
hold on
gradsmap4;
colorbar('horiz');
world_coast('color','k','linewidth',2);shg
fix_vis_prob
axis([min(forcd.lon(:)) max(forcd.lon(:)) min(forcd.lat(:)) max(forcd.lat(:))])
set(gca,'color',[.7 .7 .7])


% nfig= uicontrol('position',[500 20 60 20],'style','pushbutton','string','nfig', ... 
%    'background','white','callback',@ctana_explcorr); 


pause
[i,j]=rgrd_FindIJ(forcd.lon,forcd.lat);
axis([min(forcd.lon(:)) max(forcd.lon(:)) min(forcd.lat(:)) max(forcd.lat(:))])
% change it with ginput!

% make index

if3da=(sq(nanmean(nanmean(f3d(i,j,:),1),2)));
if3da=if3da(:);
if3da=if3da';


[f2d]=ConvertXYT_into_ZT(f3d,forcd.mask);

o=ctana_corr2d(forcd.datenum,f3d, forcd.mask, forcd.datenum, if3da, dt);
    
%subplot(1,2,1)
subplot1(2)
ctplt_pmap(o.corr,forcd)
axis([min(forcd.lon(:)) max(forcd.lon(:)) min(forcd.lat(:)) max(forcd.lat(:))])
set(gca,'color',[.7 .7 .7])
hold on
caxis([-1 1])

[xM,xm]=minmax(forcd.lon(i,j));
[yM,ym]=minmax(forcd.lat(i,j));

plot([xm,xM,xM,xm,xm],[ym,ym,yM,yM,ym],'b-')

%subplot(1,2,2)
subplot1(3)
ctplt_pmap(o.regress,forcd)
%caxis([-1 1])
plot([xm,xM,xM,xm,xm],[ym,ym,yM,yM,ym],'b-')
axis([min(forcd.lon(:)) max(forcd.lon(:)) min(forcd.lat(:)) max(forcd.lat(:))])
set(gca,'color',[.7 .7 .7])
gradsmap4
fix_vis_prob
shg

stop = uicontrol('position',[43 343 83 37],'style','toggle','string','Stop', 'background','white');
nfig = uicontrol('position',[43 443 83 37],'style','toggle','string','New fig.','background','white');

set(stop,'fontsize',14)
set(nfig,'fontsize',14)

while ~get(stop,'value')
pause(1/2)
%disp('wait')

if get(nfig,'value')
    set(stop,'value',1)
ctana_explcorr(fplt, f3d,forcd,dt)
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

