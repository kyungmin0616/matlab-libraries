function theResult = copyright

% copyright -- Emit the copyright message.
%  copyright (no arguments) displays the
%   copyright message.

% Copyright (C) 1997 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without written explicit consent from the
%    copyright owner does not constitute publication.
 
% Version of 18-Jun-1999 17:12:56.
% Updated    18-Jun-1999 17:12:56.

theClock = clock;
theYear = int2str(theClock(1));

disp([' '])
disp(['% Copyright (C) ' theYear ' Dr. Charles R. Denham, ZYDECO.'])
disp(['%  All Rights Reserved.'])
disp(['%   Disclosure without explicit written consent from the'])
disp(['%    copyright owner does not constitute publication.'])
disp([' '])
theDate = datestr(now);
disp(['% Version of ' theDate '.'])
disp(['% Updated    ' theDate '.'])
disp([' '])
disp(['% Improved   ' theDate '.'])
disp(['% Modified   ' theDate '.'])
disp(['% Revised    ' theDate '.'])
disp(['% Started    ' theDate '.'])
disp(['% Touched    ' theDate '.'])
disp(['% Updated    ' theDate '.'])
disp([' '])

if nargout > 0, theResult = []; end
