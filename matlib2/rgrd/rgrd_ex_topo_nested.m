function [grdc] = rgrd_ex_topo_nested(grdc, hmin, rfac, buffer_pts);

  hchild=grdc.h;  
  [topo,lat,lon] = topex_extract_h(grdc.lonr, grdc.latr,1);
  hold on
  rnt_gridbox(grdc,'k');
  
  % still need to do some work to make this better and more
  % efficient. May take long.
  tic;  hraw=rnt_griddata(lon,lat,topo,grdc.lonr,grdc.latr,'cubic');toc;
  
  tmp=hchild.*grdc.maskr; tmp=tmp(~isnan(tmp));
  hmax=max(abs(tmp(:)));  
  
  hraw(hraw>0) = 0;
  hraw = abs(hraw); % need to be positive for ROMS convention.
  hraw(hraw< hmin) = hmin;
  hraw(hraw> hmax) = hmax;
  
  grdc.hraw=hraw;
  
  hnew = smoothgrid(hraw,hmin,rfac);
  disp(' ')
  disp(' Connect the topography...')  
  [hnew,alpha]=connect_topo(hnew,hchild,buffer_pts);
  nc=netcdf(grdc.grdfile,'w');
  nc{'h'}(:,:)=hnew';
  close(nc);  
  grdc.h=hnew;
