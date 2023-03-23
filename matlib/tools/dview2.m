function [y]=dview2(unit,npp);

%  Read in variable name.

fid=fopen('fort.10');
for n=1:unit
  vname=fgetl(fid);
end,
fclose(fid);
vname=strrep(vname,'_','\_');

for n=1:npp,
  
%  Read in non-overlaping field (no ghost-points).
  
  yfile=['fort.' num2str(unit+1000*n)];
  a=load(yfile);

  LBi=a(1); UBi=a(2); LBj=a(3); UBj=a(4); LBk=a(5); UBk=a(6);
  Ioff=a(7); Joff=a(8); Imin=a(9); Imax=a(10); Jmin=a(11); Jmax=a(12);

  LBi=LBi+Ioff;
  UBi=UBi+Ioff;
  Imin=Imin+Ioff;
  Imax=Imax+Ioff;

  LBj=LBj+Joff;
  UBj=UBj+Joff;
  Jmin=Jmin+Joff;
  Jmax=Jmax+Joff;

  Im=UBi-LBi+1;
  Jm=UBj-LBj+1;
  Km=UBk-LBk+1;

  b=a(13:end);
  if ((UBk-LBk) == 0),
    c=reshape(b,Im,Jm);
    jj=0;
    for j=LBj:UBj,
      jj=jj+1;
      ii=0;
      for i=LBi:UBi,
        ii=ii+1;
        y(i,j)=c(ii,jj);
      end,
    end,
    Ymin=min(min(y));
    Ymax=max(max(y));
  else,
    c=reshape(b,Im,Jm,Km);
    for k=LBk:UBk,
      jj=0;
      for j=LBj:UBj,
        jj=jj+1;
        ii=0;
        for i=LBi:UBi,
          ii=ii+1;
          y(i,j,k)=c(ii,jj,k);
	end,
      end,
    end,
    Ymin=min(min(min(y)));
    Ymax=max(max(max(y)));
  end,
  clear a
  clear b
  clear c
end,

if ((UBk-LBk) == 0),
  figure(1);
  pcolor(y'); shading interp; colorbar;
  title([vname ',  non-overlapping']);
  xlabel(['Min=',sprintf('%12.5e',Ymin),...
          '   Max=',sprintf('%12.5e',Ymax)]);
else  
  figure(1);
  pcolor(y(:,:,UBk)'); shading interp; colorbar;
  title([vname ',  non-overlapping']);
  xlabel(['Min=',sprintf('%12.5e',Ymin),...
          '   Max=',sprintf('%12.5e',Ymax)]);
end,  

return




