function rgrd_SubGridEx(grd,sub_I,sub_J,filename)

%==========================================================
% extracting sub-grid
%==========================================================


%==========================================================
% smaller grid
%==========================================================
%sub_I=1:132;
%sub_J=355:480;
sub_Iu=sub_I(1):sub_I(end-1);
sub_Ju=sub_J;
sub_Iv=sub_I;
sub_Jv=sub_J(1):sub_J(end-1);

Lp=length(sub_I);
Mp=length(sub_J);
L=Lp-1;
M=Mp-1;
N=grd.N;
rgrd_CreateEmptyGridFile(Lp,Mp,filename);

%==========================================================

%%%    feval('gm-grid_cdl');

ncnew = netcdf(filename,'w');
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

grd_pos=[sub_I(1) sub_I(end) sub_J(1) sub_J(end)];
ncnew{'grd_pos'}(:)=grd_pos;

close(ncold); close(ncnew);



return

%ls -1  | grep -i grid
%ln -s  rgrd_ex_grid_nested.m rgrd_ExtractGrid.m
%rgrd_ExtractGrid.m~
%rgrd_ExtractGrids.m
%rgrd_FindGridCorners.m
%rgrd_FindGridCorners-v1.m
%rgrd_ForcingGrid2Grid.m
%rgrd_PlotGridCorners.m
%rgrd_RefineGrid.m
%rgrd_smoothgrid.m
%rgrd_SubGridEx.m
%rgrd_SubGrid.m
%/drive/edl/matlib-master/nesting_tools/connect_topo.m
%rgrd_ex_topo_nested.m 

%rgrd_ex_init_nested_oa.ms



