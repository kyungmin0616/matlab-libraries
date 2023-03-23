

function rnc_SubBryEx(ctl,grd,grdo,timeind_range,bryfile,sub_I,sub_J, varargin);

   opt.npzd=1;
   opt.tracer=2;
   opt.time=0;
   opt.ptracer=0;

% user defined options to be overwritten
if nargin == 8
   optnew = varargin{1};
   f=fieldnames(optnew);
   for i=1:length(f)
     eval(['opt.',f{i},'=optnew.',f{i},';']);
   end
end      

    sub_Iu=sub_I(1):sub_I(end-1);
    sub_Ju=sub_J;
    sub_Iv=sub_I;
    sub_Jv=sub_J(1):sub_J(end-1);
    
    ctlo=rnt_ctl(bryfile,'bry_time');
    in=netcdf(bryfile,'w');
    V={'temp' 'salt'  'u' 'v' 'zeta' 'ubar' 'vbar'};
    type={'r' 'r' 'u' 'v' 'r' 'u' 'v' };
    
    for ivar=1:4
     disp(V{ivar});
     if type{ivar} == 'r', I=sub_I; J=sub_J; end
     if type{ivar} == 'u', I=sub_Iu; J=sub_Ju; end
     if type{ivar} == 'v', I=sub_Iv; J=sub_Jv; end

      k=0;
      for it=timeind_range
	k=k+1;
	disp([V{ivar},'  INDEX ',num2str(k),' / ',num2str(length(timeind_range))]);	
      field=rnt_loadvar_segp(ctl,it,V{ivar},I,J(end),1:grd.N);
      in{[V{ivar},'_north']}(k,:,:)=perm(field);
      field=rnt_loadvar_segp(ctl,it,V{ivar},I,J(1),1:grd.N);
      in{[V{ivar},'_south']}(k,:,:)=perm(field);
      field=rnt_loadvar_segp(ctl,it,V{ivar},I(1),J,1:grd.N);
      in{[V{ivar},'_west']}(k,:,:)=perm(field);
      field=rnt_loadvar_segp(ctl,it,V{ivar},I(end),J,1:grd.N);
      in{[V{ivar},'_east']}(k,:,:)=perm(field);
	end
	
    end


    for ivar=5:7
     disp(V{ivar});
     if type{ivar} == 'r', I=sub_I; J=sub_J; end
     if type{ivar} == 'u', I=sub_Iu; J=sub_Ju; end
     if type{ivar} == 'v', I=sub_Iv; J=sub_Jv; end
      field=rnt_loadvar_segp(ctl,timeind_range,V{ivar},I,J(end),1);
      in{[V{ivar},'_north']}(:,:)=perm(field);
      field=rnt_loadvar_segp(ctl,timeind_range,V{ivar},I,J(1),1);
      in{[V{ivar},'_south']}(:,:)=perm(field);
      field=rnt_loadvar_segp(ctl,timeind_range,V{ivar},I(1),J,1);
      in{[V{ivar},'_west']}(:,:)=perm(field);
      field=rnt_loadvar_segp(ctl,timeind_range,V{ivar},I(end),J,1);
      in{[V{ivar},'_east']}(:,:)=perm(field);
    end

    if opt.npzd==1 
V={'phytoplankton' 'NO3' 'zooplankton' 'detritus'};
Vb={'phyt' 'NO3' 'zoop' 'detritus'};
    for ivar=1:4
     disp(V{ivar});
     k=0;
      for it=timeind_range
	k=k+1;
	disp([V{ivar},'  INDEX ',num2str(k),' / ',num2str(length(timeind_range))]);	
      field=rnt_loadvar_segp(ctl,it,V{ivar},sub_I,sub_J(end),1:grd.N);
      in{[Vb{ivar},'_north']}(k,:,:)=perm(field);
      field=rnt_loadvar_segp(ctl,it,V{ivar},sub_I,sub_J(1),1:grd.N);
      in{[Vb{ivar},'_south']}(k,:,:)=perm(field);
      field=rnt_loadvar_segp(ctl,it,V{ivar},sub_I(1),sub_J,1:grd.N);
      in{[Vb{ivar},'_west']}(k,:,:)=perm(field);
      field=rnt_loadvar_segp(ctl,it,V{ivar},sub_I(end),sub_J,1:grd.N);
      in{[Vb{ivar},'_east']}(k,:,:)=perm(field);
	end
    end
    end



    
    close(in); 
