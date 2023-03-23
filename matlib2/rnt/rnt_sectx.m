%RNT_SECTX
% function [ix,iz,ifield] = rnt_sectx(field,iind,grd);
% Make a vertical section along the i row for 
% j index =jind.
% Input:
%    field(x,y,s)  the field from which to extract the section
%    iind          the index y
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
% salt=rnt_loadvar(ctl,1,'salt');
% j=30; mfig; % Plot section along index 
% [ix,iz,ifield] = rnt_sectx(salt,j,grd);
%

function [ix,iz,ifield]=rnt_sectx(field,jind,grd);
%function ieh_sect(field,jind,grd);
%   Makes a section in y
%   field(x,y,s), jind = index in the j, grd = grid file
%   field(x,y,z), jind = index in the j, grd = grid file (CalCOFI)
%   ieh_sect(salt,43,grd);

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
        ll=repmat(lonv,[1 1 K]);
        
    elseif I == grd.L & J == grd.Mp
        masku=repmat(masku,[1 1 K]);
        field=field.*masku;
        zz=rnt_setdepth(0,grd);
        zz=rnt_2grid(zz,'r','u');
        ll=repmat(lonu,[1 1 K]);        

    elseif I == grd.L & J == grd.M
        maskp=repmat(maskp,[1 1 K]);
        field=field.*maskp;
        zz=rnt_setdepth(0,grd);
        zz=rnt_2grid(zz,'r','p');
        ll=repmat(lonp,[1 1 K]);

    else
        maskr=repmat(maskr,[1 1 K]);
        field=field.*maskr;
        zz=rnt_setdepth(0,grd);
        if strcmp(grd.id,'line90')
          depths=-[0    10    20    30    50    75   100   125   ...
                150   200   250   300   400   500]';
          zz=zz(:,:,1:14);
          for ik=1:14
              zz(:,:,ik)=depths(ik);
          end
        end
        ll=repmat(lonr,[1 1 K]);
    end
if K < grd.N
  zz=0.5*(zz(:,:,1:end-1) + zz(:,:,1:end-1));
end
p1=squeeze(field(:,jind,:));
p2=squeeze(zz(:,jind,:));
p3=squeeze(ll(:,jind,:));
%rgb=getpmap(5);colormap(rgb);
rnt_contourfill(p3,p2,p1,50);  colorbar
%pcolor(p3,p2,p1);  shading interp; colorbar
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

