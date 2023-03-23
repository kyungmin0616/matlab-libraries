function assign(theName, theValue)

% assign -- Assign a value to a name.
%  assign('theName', theValue) assigns theValue
%   to 'theName' in the caller's workspace. It
%   avoids the need to construct an explicit
%   assignment statement to be eval-ed.
 
% Copyright (C) 1997 Dr. Charles R. Denham, ZYDECO.
%  All Rights Reserved.
%   Disclosure without explicit written consent from the
%    copyright owner does not constitute publication.
 
% Version of 28-May-1998 00:43:58.

if nargin < 2, help(mfilename), return, end

% The following scheme permits the assignment
%  of items that have complicated subscripts,
%  such as "a{1}(2).b{3}.c = pi".

hasAns = (evalin('base', 'exist(''ans'', ''var'')') == 1);
if hasAns
	ans = evalin('caller', 'ans');   % Save.
end
assignin('caller', 'ans', theValue)
evalin('caller', [theName ' = ans;'])
evalin('caller', 'clear(''ans'')')
if hasAns
	assignin('caller', 'ans', ans)   % Restore.
end
