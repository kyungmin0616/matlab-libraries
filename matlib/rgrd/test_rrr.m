% test RRR function
cll;
m_proj('mercator','lon',[130 170],'lat',[45 65]);
m_coast;
m_grid;
daspect([1 1 1]);
set(gca,'position',[0.0393    0.0619    0.9250    0.6619],'color','w');
title({'\bfRRR - Rotating Rubber Rectangle\rm',...
      'First, drag a rectangle. Then adjust it. You can:',...
      '1) Drag the rectangle around',...
      '2) Scale it, grabbing by the corners',...
      '3) Rotate it, dragging while pressing [CTRL]',...
      'Finally, double click to get the coordinates'});
[x,y] = rrr;
[lon,lat] = m_xy2ll(x,y);
% report the results:
fprintf('Rectangle coordinates [x,y], in map units:\n');
fprintf('x = [%f %f %f %f];\n',x);
fprintf('y = [%f %f %f %f];\n',y);
fprintf('\n');
fprintf('Rectangle coordinates [lon,lat]:\n');
fprintf('lon = [%f %f %f %f];\n',lon);
fprintf('lat = [%f %f %f %f];\n',lat);
hold on
m_plot(lon,lat,'ko');