%RNT_SECTX
% function [iy,iz,ifield] = rnt_secty(field,jind,grd);
% Make a vertical section along the j row for 
% j index =jind.
% Input:
%    field(x,y,s)  the field from which to extract the section
%    jind          the index y
%    grd           grid controll array
%
%    the output is the arrays to plot the section
%    pcolor(ix,iz,ifield); shading interp; colorbar
%    This routine will make a plot.
%
% EXAMPLE:
% % Load test data
% grd=rnt_gridload('nena8km');
% w=what('rnt_examples'); % find the test data directory
% files=rnt_getfilenames( w.path, 'nena8km-his'); % get all file names
% ctl=rnt_timectl(files,'ocean_time','r');
% temp=rnt_loadvar(ctl,1,'temp');
% i=200; mfig; % Plot section along index 
% [iy,iz,ifield] = rnt_secty(temp,i,grd);
%

function [ix,iz,ifield]=rnt_sectx(field,jind,grd);

gridid=grd.id;
maskv=grd.maskv; masku=grd.masku; maskp=grd.maskp; maskr=grd.maskr;
lonv=grd.lonv; lonu=grd.lonu; lonp=grd.lonp; lonr=grd.lonr;
latv=grd.latv; latu=grd.latu; latp=grd.latp; latr=grd.latr;


[I,J,K]=size(field);
    if J == grd.M & I == grd.Lp 
        maskv=repmat(maskv,[1 1 K]);
        field=field.*maskv;
        zz=rnt_setdepth(0,grd);
        zz=rnt_2grid(zz,'r','v');
        ll=repmat(latv,[1 1 K]);
        
    elseif I == grd.L & J == grd.Mp
        masku=repmat(masku,[1 1 K]);
        field=field.*masku;
        zz=rnt_setdepth(0,grd);
        zz=rnt_2grid(zz,'r','u');
        ll=repmat(latu,[1 1 K]);        
    else
        maskr=repmat(maskr,[1 1 K]);
        field=field.*maskr;
        zz=rnt_setdepth(0,grd);
        ll=repmat(latr,[1 1 K]);
    end

p1=squeeze(field(jind,:,:));
p2=squeeze(zz(jind,:,:));
p3=squeeze(ll(jind,:,:));
%rgb=getpmap(5);colormap(rgb);
%rnt_contourfill(p3,p2,p1,50);  colorbar
pcolor(p3,p2,p1);  shading interp; colorbar


iz=p2;
ix=p3;
ifield=p1;
hold on
h_bottom =iz(:,1)';
x_coord  =ix(:,1)';
xr=x_coord;

x_coord = [x_coord , x_coord(end) , x_coord(1) ,               x_coord(1)];
h_bottom = [h_bottom , min(h_bottom(:))-10, min(h_bottom(:))-10, h_bottom(1) ];
fill(x_coord,h_bottom,'k')
%plot(x_coord,h_bottom,'k')


%set(gca, 'color', [ 0.423 0.4033587 0.254646 ] );
%set(gcf, 'color', 'w' );
%set(gca,'ylim',[-150 0]); caxis([0 1.4]); colorbar
%label_courier('Longitude','Depth [m]','none',5,'Helvetica',1)
%disp('set(gca,''ylim'',[-400 0]);');

