%

function lprps (varargin)

if nargin > 0
  filename = varargin{1};
else
  filename ='/d2/emanuele/web/tmp.eps';
end

set(gca,'Linewidth', 1)
set(gca,'Layer', 'top')



print ('-depsc2', '-painters', '-loose', '-r1200' , filename);

