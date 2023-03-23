function [label_courier]=label_courier(x,y,tit,fnsize,fnname,varagin);


if nargin < 6
  yescol=0;
else
  yescol=1;
end

myfont='courier';
mysize=5;

set(gca,'FontName',fnname)
set(gca,'FontSize',fnsize)

col=ylabel(y);
set(col,'FontName',fnname)
set(col,'FontSize',fnsize)

col=title(tit);
set(col,'FontName',fnname)
set(col,'FontSize',fnsize)

col=xlabel(x);
set(col,'FontName',fnname)
set(col,'FontSize',fnsize)

if yescol == 1
col=colorbar;
set(col,'FontName',fnname)
set(col,'FontSize',fnsize)
end


