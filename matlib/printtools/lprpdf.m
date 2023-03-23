
function lprpdf (varargin)

if nargin > 0
  filename = varargin{1};
else
  filename ='/d2/emanuele/web/tmp.eps';
end

in=findstr(filename,'.eps');
filename1=filename(1:in-1);
filename=[filename1,'-P.eps'];


print -depsc2 -painters -loose -r1200  /tmp/mat01tmp.eps

disp(['PDF file ...  ',filename1,'.PDF']);
p=['ps2pdf  /tmp/mat01tmp.eps ',filename1,'.pdf'];
unix(p);


disp(['EPS file no preview ...  ',filename1,'.eps']);
p=['mv /tmp/mat01tmp.eps ',filename1,'.eps'];
unix(p);

print -djpeg100  -painters   /tmp/mat01tmp.jpg
disp(['JPG file no preview ...  ',filename1,'.jpg']);
p=['mv /tmp/mat01tmp.jpg ',filename1,'.jpg'];
unix(p);



%print -depsc2 -painters -r1200 -tiff  TMP2.EPS

%-tiff
