function rntp_MakeClima(grd,ctl,vars,prefix,varagin)
% function rntp_MakeClima(grd,ctl,vars,prefix,varagin)
%    Make a climatology from CTL and for variables VARS
%    each month will be stored in a separate file.
%
%  04/2005 E. Di Lorenzo, edl@eas.gatech.edu



%vars={'salt' 'temp' 'u' 'v' 'ubar' 'vbar' 'zeta'};

disp('vers 1.0')


for imon=1:12
filename=[prefix,'-',num2str(imon),'.nc'];
%rnc_CreateIniFile(grd,filename);
rntp_CreateNCfile(filename,grd.Lp,grd.Mp,grd.N,1,vars)
disp(['Created ... ',filename]);
nc=netcdf(filename,'w');
nc{'ocean_time'}(1)=(imon*30-15)*24*60*60;
nc{'scrum_time'}(1)=(imon*30-15)*24*60*60;
for ivar=1:length(vars);
	tic
	string=['   - ',vars{ivar},'  @ month ',num2str(imon)];
	disp(string); 
	in=find(ctl.month == imon);
	clear tmpsum
	tmp=rnt_loadvar(ctl,1,vars{ivar});
	[I,J,K]=size(tmp);	
	tmpsum=zeros(I,J,K);
	for k=1:length(in)
	   tmp=rnt_loadvar(ctl,in(k),vars{ivar});
	   tmpsum= tmpsum + tmp/length(in);
	end
	
	if K > 1
		nc{vars{ivar}}(1,:,:,:)=perm(tmpsum);
	else
		nc{vars{ivar}}(1,:,:)=perm(tmpsum);
	end
      toc
end
close(nc);
end

