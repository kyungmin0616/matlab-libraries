%==========================================================
% extracting sub-grid
%==========================================================

grd=rnt_gridload('natl');

%==========================================================
% smaller grid
%==========================================================
sub_I=1:132;
sub_J=355:480;
sub_Iu=1:131;
sub_Ju=355:480;
sub_Iv=1:132;
sub_Jv=355:479;

Lp=length(sub_I);
Mp=length(sub_J);
L=Lp-1;
M=Mp-1;
N=30;

% gm-grid_cdl.m
nc('xi_rho') = Lp;
nc('xi_u') = L;
nc('xi_v') = Lp;
nc('xi_psi') = L;
nc('eta_rho') = Mp;
nc('eta_u') = Mp;
nc('eta_v') = M;
nc('s_rho') = N;
nc('eta_psi') = M;
nc('s_w') = N+1;

 
 %%%    feval('gm-coads_cdl');

ncnew = netcdf('gm-coads.nc','w');
ncold=netcdf('NATL_coads_1c.nc');

myvar= var(ncold);
[tmp,I]=size(myvar);
for i=1:I
  %get their actual name
  varname=ncnames(myvar(i));
  varname2=char(varname);
  
  mysize=ncsize(ncold{char(varname)});
  if length(mysize) > 1
  mysize=mysize(2:end);
    if (mysize(1) == grd.Mp & mysize(2) == grd.Lp)
      %rho-grid
	disp(['Assigning   ',varname2,'   at RHO']);
	tmp=ncold{char(varname)}(:);
	ncnew{char(varname)}(:,:,:)=tmp(:,sub_J,sub_I);
    end
    
    if (mysize(1) == grd.Mp & mysize(2) == grd.L)
      %u-grid
	disp(['Assigning   ',varname2,'   at U']);
	tmp=ncold{char(varname)}(:);
	ncnew{char(varname)}(:,:,:)=tmp(:,sub_Ju,sub_Iu);
    end
    
    if (mysize(1) == grd.M & mysize(2) == grd.Lp)
      %v-grid
	disp(['Assigning   ',varname2,'   at V']);
	tmp=ncold{char(varname)}(:);
	ncnew{char(varname)}(:,:,:)=tmp(:,sub_Jv,sub_Iv);
    end
    
    if (mysize(1) == grd.M & mysize(2) == grd.L)
      %psi-grid
	disp(['Assigning   ',varname2,'   at PSI']);
	tmp=ncold{char(varname)}(:);
	ncnew{char(varname)}(:,:,:)=tmp(:,sub_Jv,sub_Iu);
    end
    
  else 
    disp(['Assigning   ',varname2,'   at CONST']);
    ncnew{char(varname)}(:)=ncold{char(varname)}(:);
  end
  
  
end

close(ncold); close(ncnew);


