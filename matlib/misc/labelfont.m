function [label_courier]=label_courier(x,y,tit,fnsize,fnname);


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

%col=colorbar;
%set(col,'FontName',fnname)
%set(col,'FontSize',fnsize)


