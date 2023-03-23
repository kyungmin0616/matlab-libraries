function getpos

a=get(gcf,'pos');
%disp([,'[',n2s(a(1)),' ',n2s(a(2)),' ',n2s(a(3)),' ',n2s(a(4)),']',])
disp([,'set(gcf,''pos'',[',n2s(a(1)),' ',n2s(a(2)),' ',n2s(a(3)),' ',n2s(a(4)),'])',])
disp([,'figure(''pos'',[',n2s(a(1)),' ',n2s(a(2)),' ',n2s(a(3)),' ',n2s(a(4)),'])',])