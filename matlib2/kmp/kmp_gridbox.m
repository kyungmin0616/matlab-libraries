
function kmp_gridbox(grd)


p1=[sq(grd.lonr(1,:))'; sq(grd.lonr(:,end)); sq(grd.lonr(end,end:-1:1))' ;sq(grd.lonr(end:-1:1,1));];
p2=[sq(grd.latr(1,:))'; sq(grd.latr(:,end)); sq(grd.latr(end,end:-1:1))';sq(grd.latr(end:-1:1,1));];

plot(p1,p2,'k', 'linewidth', 4)



