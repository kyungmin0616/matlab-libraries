function WriteCornerFileFromAX(ax,savefile)
% convert to lon/lat, using ROMS corner numbering convention


%[lon_1,lat_1] = m_xy2ll(xnw,ynw);
%[lon_2,lat_2] = m_xy2ll(xsw,ysw);
%[lon_3,lat_3] = m_xy2ll(xse,yse);
%[lon_4,lat_4] = m_xy2ll(xne,yne);
corners.lon = [ax(1) ax(1) ax(2) ax(2)]';
corners.lat = [ax(4) ax(3) ax(3) ax(4)]';


% create a corners files for seagrid
if min(corners.lon)>180
  corners.lon = corners.lon-360;
end
if max(corners.lon>180)
  warning([ 'Range of longitudes is ' mat2str(range(corners.lon))])
end
corners_data = [corners.lon corners.lat ones([4 1])];

  save(savefile,'corners_data','-ascii')
  disp([ 'Wrote ' savefile])

% save the boundary.dat file for seagrid
%savefile = [ 'Boundary' location '.dat'];
return
if exist(savefile)==2
  reply = input([savefile ' exists. Overwrite? (y/n) '],'s');
  if strcmp(lower(reply),'y')
    save(savefile,'corners_data','-ascii')
    disp([ 'Wrote ' savefile])
  end
else
  save(savefile,'corners_data','-ascii')
  disp([ 'Wrote ' savefile])
end
