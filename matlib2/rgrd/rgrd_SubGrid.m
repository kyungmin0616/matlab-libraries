%==========================================================
% extracting sub-grid
%==========================================================
function rgrd_SubGrid(grd,newfile, I,J,TheTitle);

%grd=rnt_gridload('natl');


%==========================================================
% smaller grid
%==========================================================

sub_I=I;
sub_J=J;

sub_Iu=sub_I(1):sub_I(end)-1;
sub_Ju=sub_J;
sub_Iv=sub_I;
sub_Jv=sub_J(1):sub_J(end)-1;


Lp=length(sub_I);
Mp=length(sub_J);
L=Lp-1;
M=Mp-1;
%N=30;
Lp
Mp
newfile
rgrd_CreateEmptyGridFile(Lp,Mp,newfile)
ncnew = netcdf(newfile,'w');

ncnew.title = ncchar(TheTitle);
ncnew.date = ncchar(datestr(now));
ncnew.parent_grid = ncchar(grd.grdfile);
ncnew.generated = ncchar('RGRD - edl@eas.gatech.edu');
%==========================================================
% done
%==========================================================

%%%    feval('gm-grid_cdl');

ncold=netcdf(grd.grdfile);

myvar= var(ncold);
[tmp,I]=size(myvar);
for i=1:I
  %get their actual name
  varname=ncnames(myvar(i));
  varname2=char(varname);
  
  mysize=ncsize(ncold{char(varname)});
  if length(mysize) > 1
    if (mysize(1) == grd.Mp & mysize(2) == grd.Lp)
      %rho
	disp(['Assigning   ',varname2,'   at RHO']);
	tmp=ncold{char(varname)}(:);
	ncnew{char(varname)}(:,:)=tmp(sub_J,sub_I);
    end
    
    if (mysize(1) == grd.Mp & mysize(2) == grd.L)
      %u
	disp(['Assigning   ',varname2,'   at U']);
	tmp=ncold{char(varname)}(:);
	ncnew{char(varname)}(:,:)=tmp(sub_Ju,sub_Iu);
    end
    
    if (mysize(1) == grd.M & mysize(2) == grd.Lp)
      %v
	disp(['Assigning   ',varname2,'   at V']);
	tmp=ncold{char(varname)}(:);
	ncnew{char(varname)}(:,:)=tmp(sub_Jv,sub_Iv);
    end
    
    if (mysize(1) == grd.M & mysize(2) == grd.L)
      %psi
	disp(['Assigning   ',varname2,'   at PSI']);
	tmp=ncold{char(varname)}(:);
	ncnew{char(varname)}(:,:)=tmp(sub_Jv,sub_Iu);
    end
    
  elseif   strcmp(varname,'hraw')
	disp(['Assigning   ',varname2,'   at PSI']);
	tmp=ncold{char(varname)}(:);
	ncnew{char(varname)}(:,:)=tmp(:,sub_J,sub_I);
  
  else 
    disp(['Assigning   ',varname2,'   at CONST']);
    ncnew{char(varname)}(:)=ncold{char(varname)}(:);
  end
  
  
end

close(ncold); close(ncnew);



