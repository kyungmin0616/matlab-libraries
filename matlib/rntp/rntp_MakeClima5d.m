function rntp_MakeClima5d(grd,ctl,vars,prefix,IDAY,varagin)
% function rntp_MakeClima5d(grd,ctl,vars,prefix,IDAY,varagin)
%    Make a climatology from CTL and for variables VARS
%    each month will be stored in a separate file.
%
%  04/2005 E. Di Lorenzo, edl@eas.gatech.edu



%vars={'salt' 'temp' 'u' 'v' 'ubar' 'vbar' 'zeta'};

disp('vers 1.0')


for iday=IDAY(:)'
filename=[prefix,'-',num2str(floor(iday)),'.nc'];
rntp_CreateNCfile(filename,grd.Lp,grd.Mp,grd.N,1,vars)
disp(['Created ... ',filename]);
nc=netcdf(filename,'w');
nc{'ocean_time'}(1)=iday;
nc{'scrum_time'}(1)=iday;
for ivar=1:length(vars);
	tic
	string=['   - ',vars{ivar},'  @ day ',num2str(iday)];
	disp(string); 
	in=find(ctl.iday == iday);
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

