function FindGridCorners(ax,seagridCoastline,varargin);
%  FUNCTION FindGridCorners(ax,seagridCoastline);
%    Helps you find the corners points of your grid
%    so that the resulting grid is othogonal.
%    AX = [lonmin lonmax latmin latmax] which include
%    your domain. Use for a Mercator projection.
%    seagridCoastline  is the name of the coastline 
%    file .mat in the seagrid format.
%    OUPUT is the name of the file to write the corner
%    points. Optional, it will ask you if not specified.
%
%    John Wilkins and E. Di Lorenzo - edl@ucsd.edu
%
%    For Queen Island application 
%      seagridCoastline='ga8_COAST.mat';
%      ax = [-142 -124 42 59];



    % projection
    m_proj('mercator','lon',ax(1:2),'lat',ax(3:4));
    figure; 
    m_grid;
     

    load(seagridCoastline);
    cst.lon=lon;cst.lat=lat;
    han = m_line(cst.lon,cst.lat);
    set(han,'color','r');
    daspect([1 1 1]);
    set(gca,'position',[0.0393    0.0619    0.9250    0.6619],'color','w');
    title({'\bfRRR - Rotating Rubber Rectangle\rm',...
      'First, drag a rectangle. Then adjust it. You can:',...
      '1) Drag the rectangle around',...
      '2) Scale it, grabbing by the corners',...
      '3) Rotate it, dragging while pressing [CTRL]',...
      'Finally, double click to get the coordinates'});

    [x,y] = rgrd_rrr;
    [lon,lat] = m_xy2ll(x,y);
    fprintf('Rectangle coordinates [x,y], in map units:\n');
    fprintf('x = [%f %f %f %f];\n',x);
    fprintf('y = [%f %f %f %f];\n',y);
    fprintf('\n');
    fprintf('Rectangle coordinates [lon,lat]:\n');
    fprintf('lon = [%f %f %f %f];\n',lon);
    fprintf('lat = [%f %f %f %f];\n',lat);

    save tmp x y lon lat
% convert to lon/lat, using ROMS corner numbering convention
  % specify nw corner
    disp('Select North-West corner (approximately is ok)');
    [xnw,ynw]=ginput(1);
    dist = (xnw-x).^2 + (ynw-y).^2;
    IND(1) = find( dist == min(dist));
    
    
    % fit a line through nw point and akl: y=m*x+c
    disp('Select South-West corner (approximately is ok)');
    [xnw,ynw]=ginput(1);
    dist = (xnw-x).^2 + (ynw-y).^2;
    IND(2) = find( dist == min(dist));
   
   disp('Select South-East corner (approximately is ok)');
    [xnw,ynw]=ginput(1);
    dist = (xnw-x).^2 + (ynw-y).^2;
    IND(3) = find( dist == min(dist));

   disp('Select North-East corner (approximately is ok)');
    [xnw,ynw]=ginput(1);
    dist = (xnw-x).^2 + (ynw-y).^2;
    IND(4) = find( dist == min(dist));

%[lon_1,lat_1] = m_xy2ll(xnw,ynw);
%[lon_2,lat_2] = m_xy2ll(xsw,ysw);
%[lon_3,lat_3] = m_xy2ll(xse,yse);
%[lon_4,lat_4] = m_xy2ll(xne,yne);
%corners.lon = [lon_1 lon_2 lon_3 lon_4]';
%corners.lat = [lat_1 lat_2 lat_3 lat_4]';

corners.lon = [lon(IND(1)) lon(IND(2)) lon(IND(3)) lon(IND(4))]';
corners.lat = [lat(IND(1)) lat(IND(2)) lat(IND(3)) lat(IND(4))]';


% create a corners files for seagrid
if min(corners.lon)>180
  corners.lon = corners.lon-360;
end
if max(corners.lon>180)
  warning([ 'Range of longitudes is ' mat2str(range(corners.lon))])
end
corners_data = [corners.lon corners.lat ones([4 1])];


% save the boundary.dat file for seagrid
%savefile = [ 'Boundary' location '.dat'];
if nargin > 2 
   savefile = varargin{1};
else   
   savefile=input('Name of output Boundary.dat file : ');
end
%if exist(savefile)==2
%  reply = input([savefile ' exists. Overwrite? (y/n) '],'s');
%  if strcmp(lower(reply),'y')
%    save(savefile,'corners_data','-ascii')
%    disp([ 'Wrote ' savefile])
%  end
%else
  save(savefile,'corners_data','-ascii')
  disp([ 'Wrote ' savefile])
%end


%rgrd_PlotGridCorners(ax,savefile,seagridCoastline);


