%RNT_LOADVAR
% [fieldout]=rnt_loadvar(ctl,ind,field)
% Extract the variable FIELD for the indicies specified
% in the array IND from a composite netcdf file/variable which is defined 
% in the time controll arrays CTL.
%
%  example [fieldout]=rnt_loadvar(ctl,[38],'zeta');
%  load index 38 and variabe 'zeta'
%
% SEE rnt_timectl.m to generate a the CTL struct. array 
%      (it is easy ..no worry ok!)
%
% INPUT: example
%     ctl = rnt_timectl(files,timevar);
%     ind = [ 1:6 ] (get time indiceis 1:6 from composite field
%     field = 'temp'
% 
% OUTPUT:
%   fieldout(x,y,z,1:length(ind)) = theCompositeField(x,y,z,ind) 
%


function [tmp1]=rnt_loadvar(ctl,ind,field)


  tmp1=0;
  % find info about the variabe and initialize arrays
    nc=netcdf(ctl.file{1});
    [s]=ncsize(nc{field});
    close(nc)
    s(1)=length(ind);
    tmp1=zeros(s);
    len=length(s);

  if isempty(ind)
    disp(['rnt_loadvarsum - no time index match for ',field]);
    [s] = size(tmp1); order = [length(s) :-1:1];
    tmp1=permute(tmp1,order);
    tmp1(:)=NaN;
    return
  end
  
  j=0;
  % load array
  for istep=1:length(ctl.segm)-1
    in = find ( ind > ctl.segm(istep) & ind <= ctl.segm(istep+1));
    in_extr = ctl.ind(ind(in));
    
    if ~isempty(in_extr)
      jstart=j(end)+1;
	jend=j(end)+length(in_extr);
      nc=netcdf(ctl.file{istep});
      tmp2=nc{field}(in_extr,:) ;
      close(nc)
	size(tmp2);
	size(tmp1);
	
	if len==4, tmp1(jstart:jend,:,:,:)=tmp2(:,:,:,:); end
	if len==3, tmp1(jstart:jend,:,:)=tmp2(:,:,:); end
      j=jend;
	end
    
  end
  
  tmpmean=tmp1/length(ind);
  [s] = size(tmp1); order = [length(s) :-1:1];
  tmp1=permute(tmp1,order);
  
  return
