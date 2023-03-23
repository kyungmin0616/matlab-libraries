%RNT_PLCM
% function rnt_plcm ( field, grd, OPT )
% Plot horizzontal 2D variable using M_MAP Toolbox
%
% INPUT
% FIELD  the 2D field to plot on rho, u, v or psi grid
% GRD    structure array of grid
% OPT    is an optional structure array containing the 
%        field COLORMAP, CAXIS, SHADING, LINEWIDTH
% 
% EXAMPLE1:
% grd=rnt_gridload('nena8km');  % requires rnt_examples
% rnt_plcm(grd.h, grd) % plot topography
%
% EXAMPLE2:
% opt.colormap=getpmap(5);
% opt.shading='flat';
% opt.linewidth=1.5; % thickness of coastline
% rnt_plcm(grd.h, grd, opt)
%


function rnt_plc(field,grd,varargin)

% default options
opt.colormap=getpmap(7);
opt.shading='flat';
opt.caxis='auto';
opt.linewidth=2;

% user defined options to be overwritten
if nargin > 2
   optnew = varargin{1};
   f=fieldnames(optnew);
   for i=1:length(f)
     eval(['opt.',f{i},'=optnew.',f{i},';']);
   end
end      

% determine the grid
[I,J]=size(field);
grtype='r';
if (I == grd.L & J == grd.M) , grtype ='p'; end
if (I == grd.Lp & J == grd.M) , grtype ='v'; end
if (I == grd.L & J == grd.Mp) , grtype ='u'; end

if grtype == 'r'; lonr=grd.lonr; latr=grd.latr; maskr=grd.maskr; end 
if grtype == 'p'; lonr=grd.lonp; latr=grd.latp; maskr=grd.maskp; end 
if grtype == 'v'; lonr=grd.lonv; latr=grd.latv; maskr=grd.maskv; end
if grtype == 'u'; lonr=grd.lonu; latr=grd.latu; maskr=grd.masku; end

ax(1)=min(lonr(:)); ax(2)=max(lonr(:)); ax(3)=min(latr(:)); ax(4)=max(latr(:));
m_proj('mercator','lon',ax(1:2),'lat',ax(3:4));
[x,y]=m_ll2xy(lonr,latr);
[xlim,ylim]=m_ll2xy(ax(1:2),ax(3:4));

colormap(opt.colormap);
if strcmp(opt.shading, 'faceted') | strcmp(opt.shading, 'flat')
   pcolorjw(x,y,field.*maskr); shading (opt.shading);
end
if strcmp(opt.shading, 'interp')
   pcolor(x,y,field.*maskr); shading (opt.shading);
end
if strcmp(opt.shading, 'contour')
   rnt_contourfill(x,y,field.*maskr,30); 
end


caxis   (opt.caxis); colorbar
%load(grd.cstfile); han=m_line(lon,lat); set(han,'color','k');
%m_grid('box','fancy');
m_grid;
m_coast('patch',[.5 .5 .5],'edgecolor','k','linewidth',opt.linewidth);
%set(gca,'xlim',xlim,'ylim',ylim);

return

lonr=grd.lonr; latr=grd.latr; maskr=grd.maskr;
ax(1)=min(lonr(:)); ax(2)=max(lonr(:)); ax(3)=min(latr(:)); ax(4)=max(latr(:));
X=[ax(1) ax(2) ax(2) ax(1) ax(1)];
Y=[ax(3) ax(3) ax(4) ax(4) ax(3)];

patch('xdata',X(:),'ydata',Y(:),'facecolor','k',...
      'edgecolor','k','linest','none','tag','m_grid_color');

	load coast.dat
	[X,Y]=m_ll2xy(lon(:,1),lat(:,1),'clip','patch');
	k=[find(isnan(X(:,1)))];
	for i=1:length(k)-1,
	    x=lon([k(i)+1:(k(i+1)-1) k(i)+1],1);
	    y=lat([k(i)+1:(k(i+1)-1) k(i)+1],1);
	    patch(x,y,'r');
	end;

% rnt_contourfill(x,y,field.*maskr,100); colorbar;
% m_grid('box','fancy','tickdir','out')
% m_grid;
    
