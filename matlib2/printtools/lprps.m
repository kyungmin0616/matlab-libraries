%

function lprps (varargin)

if nargin > 0
  filename = varargin{1};
else
  filename ='/d2/emanuele/web/tmp.eps';
end

in=findstr(filename,'.eps');
filename1=filename(1:in-1);
filename=[filename1,'-P.eps'];

p=fix(clock);

tempfile=['/tmp/',num2str(p(4)),num2str(p(5)),num2str(p(6))];

fileeps=[tempfile,'.eps'];
filetif=[tempfile,'.tiff'];
print ('-depsc2', '-painters', '-loose', '-r1200' , fileeps);
print ('-dtiff' ,'-painters', '-r165' , filetif);

disp(' ...adding TIFF preview');
catpreview_manu(fileeps,filetif,filename)

disp(['JPEG file ...  ',filename1,'.jpg']);
p=['convert  ',filetif,' ',filename1,'.jpg'];
unix(p);

%print -djpeg100  /tmp/mat01tmp.jpg
%p=['mv /tmp/mat01tmp.jpg ',filename1,'.jpg'];
%unix(p);

disp(['PDF file ...  ',filename1,'.PDF']);
p=['ps2pdf  ',fileeps,' ',filename1,'.pdf'];
unix(p);

disp(['TIF file ...  ',filename1,'.tif']);
p=['mv ',filetif,' ',filename1,'.tif'];
unix(p);

disp(['EPS file no preview ...  ',filename1,'.eps']);
p=['mv ',fileeps,' ',filename1,'.eps'];
unix(p);


%print -depsc2 -painters -r1200 -tiff  TMP2.EPS

%-tiff
