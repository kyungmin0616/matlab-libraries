function [x,x1,x2]=dviewbry(ncbry,ncrec,unit,npp,lev);

%---------------------------------------------------------------------
%  Read in input files.
%---------------------------------------------------------------------

% Read in variable name from ASCII file.

fid=fopen('fort.10');
for n=1:unit
  vname=fgetl(fid);
end,
fclose(fid);

% Read in NetCDF boundary data snapshots records.

i=findstr(':',vname);
ncvar=deblank(vname(i+2:end));

x1=nc_read(ncbry,ncvar,ncrec);
x2=nc_read(ncbry,ncvar,ncrec+1);

% Read in boundary data from ASCII file.

for n=1:npp,

%  Read in field including ghost-points.

  xfile=['fort.' num2str(unit+1000*n)];
  a=load(xfile);

  LBi=a(1); UBi=a(2); LBj=a(3); UBj=a(4); LBk=a(5); UBk=a(6);
  Ioff=a(7); Joff=a(8); Imin=a(9); Imax=a(10); Jmin=a(11); Jmax=a(12);

  LBi=LBi+Ioff;
  UBi=UBi+Ioff;
  Imin=Imin+Ioff;
  Imax=Imax+Ioff;

  Im=UBi-LBi+1;
  Jm=UBj-LBj+1;

  b=a(13:end);
  if ((UBj-LBj) == 0),
    x(:,n)=b';
    Xmin=min(x(:,n));
    Xmax=max(x(:,n));
  else,
    c=reshape(b,Im,Jm);
    x(:,:,n)=c;
    Xmin=min(min(min(x(:,:,n))));
    Xmax=max(max(max(x(:,:,n))));
  end,
  clear a
  clear b
  clear c

end,

%---------------------------------------------------------------------
%  Plot boundary data.
%---------------------------------------------------------------------

vname=strrep(vname,'_','\_');

if ((UBj-LBj) == 0),
  figure;
  plot(x(:,1),'k+');
  hold on
  plot(x1,'r-');
  plot(x2,'b-');
  title([vname ',  full']);
  xlabel(['Min=',sprintf('%12.5e',Xmin),...
          '   Max=',sprintf('%12.5e',Xmax)]);
else  

  if (nargin < 5),
    lev=UBj;
  end,

  figure;
  plot(x(:,lev,1),'k+');
  hold on
  plot(x1(:,lev),'r-');
  plot(x2(:,lev),'b-');
  title([vname ',  full,  level = ', num2str(lev)]);
  xlabel(['Min=',sprintf('%12.5e',Xmin),...
          '   Max=',sprintf('%12.5e',Xmax)]);

end,  

return




