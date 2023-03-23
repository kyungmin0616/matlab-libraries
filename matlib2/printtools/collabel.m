function hh = xlabel(string,varargin)
%XLABEL X-axis label.
%   XLABEL('text') adds text beside the X-axis on the current axis.
%
%   XLABEL('text','Property1',PropertyValue1,'Property2',PropertyValue2,...)
%   sets the values of the specified properties of the xlabel.
%
%   H = XLABEL(...) returns the handle to the text object used as the label.
%
%   See also YLABEL, ZLABEL, TITLE, TEXT.

%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 5.7 $  $Date: 1997/11/21 23:33:16 $

ax = colorbar;
h = get(ax,'ylabel');

if nargin > 1 & (nargin-1)/2-fix((nargin-1)/2),
  error('Incorrect number of input arguments')
end

%Over-ride text objects default font attributes with
%the Axes' default font attributes.
%set(h, 'FontAngle',  get(gca, 'FontAngle'), ...
%       'FontName',   get(gca, 'FontName'), ...
%       'FontSize',   get(gca, 'FontSize'), ...
%       'FontWeight', get(gca, 'FontWeight'), ...
%       'string',     string,varargin{:});

set(h, 'FontName',   get(gca, 'FontName'), ...
       'FontSize',   get(gca, 'FontSize'), ...
       'string',     string,varargin{:});
	 
set(ax, 'FontName',   get(gca, 'FontName'), ...
       'FontSize',   get(gca, 'FontSize') );


if nargout > 0
  hh = h;
end
