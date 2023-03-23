function [xo,yo] = rgrd_rrr(c,v)
% RRR - Rotating Rubber Rectangle
%  [x,y] = rgrd_rrr allows selection of an arbitrary rectangular region of a plot.
%  The rectangle can be dragged, scaled and rotated with a mouse.
%  Double click exits. 
%	NB! DASPECT of the plot is set to [1 1 1].

% April 6, 2004 ashcherbina@ucsd.edu
persistent vis h rot done
if nargin==0,
   set(gcf,'pointer','fullcrosshair');
   disp('Drag a rectangle...')
   k = waitforbuttonpress;
   point1 = get(gca,'CurrentPoint');    % button down detected
   finalRect = rbbox;                   % return figure units
   point2 = get(gca,'CurrentPoint');    % button up detected
   set(gcf,'pointer','arrow');
   point1 = point1(1,1:2);              % extract x and y
   point2 = point2(1,1:2);
   p1 = min(point1,point2);             % calculate locations
   offset = abs(point1-point2);         % and dimensions
   x = [p1(1) p1(1)+offset(1) p1(1)+offset(1) p1(1) p1(1)];
   y = [p1(2) p1(2) p1(2)+offset(2) p1(2)+offset(2) p1(2)];
   hold on
   axis manual
   h = plot(x,y);
   rdata.oldpt = [];
   set(h,'tag','rgrd_RRR','userdata',rdata,'DeleteFcn','rgrd_rrr(''delete'')','linewidth',2,'color','r');
   set(gcf,'WindowButtonDownFcn','rgrd_rrr(''down'')');
   set(gcf,'WindowButtonUpFcn','rgrd_rrr(''up'')');
   set(gcf,'WindowButtonMotionFcn','rgrd_rrr(''idle'')');
   set(gcf,'doublebuffer','on');
   daspect([1 1 1]);
   vis = 0;
   fprintf('Adjust the rectangle. You can:\n');
   fprintf('1) Drag the rectangle\n');
   fprintf('2) Scale it, grabbing by the corners\n');
   fprintf('3) Rotate it, grabbing by the corners while pressing CTRL\n');
   fprintf('Double click to get the coordinates.\n');
   fprintf('\n');
   done = 0;
   while(~done) % wait for the user action
      pause(.1);
   end
   rgrd_rrr('delete');
   if nargout>0,
      xo = get(h,'xdata');
      yo = get(h,'ydata');
      xo = xo(1:4);
      yo = yo(1:4);      
   end
else
   switch c   
   case 'delete'
      % clean up
      set(gcf,'WindowButtonDownFcn','');
      set(gcf,'WindowButtonUpFcn','');
      set(gcf,'WindowButtonMotionFcn','');
      set(gcf,'pointer','arrow');
   case 'down'
      % mouse button click - initiate transform
      rdata.oldpt = get(gca,'CurrentPoint');;
      rdata.x0 = get(h,'xdata');
      rdata.y0 = get(h,'ydata');
      if strcmp(get(gcf,'SelectionType'),'open')
         % double click = exit
         done = 1;
      else
         set(gcf,'WindowButtonMotionFcn','rgrd_rrr(''move'')');
         set(h,'userdata',rdata);      
         rot = strcmp(get(gcf,'SelectionType'),'alt'); % rotate or scale?
         % change the pointer
         if rot
            set(gcf,'pointer','topl');
         elseif vis>0,
            set(gcf,'pointer','right');
         end
      end
   case 'up',
      % button up - stop transform
      set(gcf,'WindowButtonMotionFcn','rgrd_rrr(''idle'')');   
      set(gcf,'pointer','arrow');
   case 'move',
      % transform 
      rdata = get(h,'userdata');
      oldpt = rdata.oldpt;
      newpt = get(gca,'CurrentPoint');;
      xy1 = oldpt(1,1)+i*oldpt(1,2);
      xy2 = newpt(1,1)+i*newpt(1,2);
      dxy = xy2-xy1;
      xy0 = rdata.x0 +i*rdata.y0;
      if vis<1,
         % no corners selected - move/rotate the whole thing
         if rot
            % rotate relative to the center
            xyc = (xy0(1)+xy0(3))/2;
            r2 = xy2-xyc; 
            r0 = xy1-xyc; 
            
            r1 = (xy0-xyc)*r2/r0;
            xy = xyc + r1;
            xy(5) = xy(1);
         else
            % move all
            xy = xy0+dxy;
         end
      elseif vis>0
         % a corner was selected - scale/rotate relative to the opposite corner
         xy = xy0+dxy;
         % get corner indicies, so that 1st - selected one, 3rd - the opposite, etc.
         i1 = vis;
         i2 = mod(vis,4)+1;
         i3 = mod(vis+1,4)+1;
         i4 = mod(vis+2,4)+1;
         % relative to 3rd corner:
         r = xy-xy0(i3); 
         r0 = xy0-xy0(i3);
         r1 = r;
         if rot
            % rotate
            r1(i2) = r0(i2)*r(i1)/r0(i1);
            r1(i4) = r0(i4)*r(i1)/r0(i1);
            r1(i3) = 0;         
         else
            %scale
            r1(i2) = r0(i2)*real(r(i1)*r0(i2)')/real(r0(i1)*r0(i2)');
            r1(i4) = r0(i4)*real(r(i1)*r0(i4)')/real(r0(i1)*r0(i4)');
            r1(i3) = 0;
         end   
         xy = xy0(i3) + r1;
         xy(5) = xy(1);
      end
      set(h,'xdata',real(xy),'ydata',imag(xy));
   case 'idle',
      % watch if the pointer gets inside the rectangle or close to a corner
      x = get(h,'xdata');
      y = get(h,'ydata');
      pos = get(gca,'CurrentPoint');
      xc = pos(1,1);
      yc = pos(1,2);
      d = abs((x-xc)+i*(y-yc));
      % get the diagonal as a reference
      D = abs(x(1)-x(3)+i*(y(1)-y(3)));
      tres = D*.05; % target area - 5% of the diagonal
      if any(d<tres),
         % the pointer is close to one of the corners - assume it selected
         set(gcf,'pointer','cross');
         vis = min(find(d<tres));
         if vis>4, 
            vis = 1;
         end
      elseif inpolygon(xc,yc,x,y),
         % the pointer is inside the rectangle
         set(gcf,'pointer','fleur');
         vis = 0;
      else
         set(gcf,'pointer','arrow');
         vis = -1;
      end
   end
end
