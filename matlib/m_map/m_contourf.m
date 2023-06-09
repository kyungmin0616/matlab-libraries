function [cs,h,cf]=m_contourf(long,lat,data,varargin);
%  M_CONTOURF Adds filled contours to a map
%    M_CONTOURF(LONG,LAT,DATA,...) is the same as M_CONTOUR except
%    that contours are filled. Areas of data above a given level are
%    filled, areas below are left blank or are filled by a lower level.
%    NaN's in the data leave holes in the filled plot/
%
%    [CS,H] = M_CONTOURF(...) returns contour matrix C as described in 
%    CONTOURC and a vector H of handles to PATCH objects (for use by
%    CLABEL).
%
%    See also M_CONTOUR, CONTOURF

% Rich Pawlowicz (rich@ocgy.ubc.ca) 17/Jan/1998
%
% This software is provided "as is" without warranty of any kind. But
% it's mine, so you can't sell it.

% 19/02/98 - type - should have been 'clip','patch', rather than 'off'.
%  9/12/98 - handle all-NaN plots without letting contour crash.


global MAP_PROJECTION 

% Have to have initialized a map first

if isempty(MAP_PROJECTION),
  disp('No Map Projection initialized - call M_PROJ first!');
  return;
end;

if min(size(long))==1 & min(size(lat))==1,
 [long,lat]=meshgrid(long,lat);
end;

[X,Y]=m_ll2xy(long,lat,'clip','on');  %First find the points outside

i=isnan(X);      % For these we set the *data* to NaN...
data(i)=NaN;

                 % And then recompute positions without clipping. THis
                 % is necessary otherwise contouring fails (X/Y with NaN
                 % is a no-no. Note that this only clips properly down
                 % columns of long/lat - not across rows. In general this
                 % means patches may nto line up properly a right/left edges.
if any(i(:)), [X,Y]=m_ll2xy(long,lat,'clip','patch'); end;  

if any(~i(:)),
 [cs,h]=contourf(X,Y,data,varargin{:});
 set(h,'tag','m_contourf');
else
  cs=[];h=[];
end;
