
function [sig, siga, sigm, sigstd]= GetTimeSeries(ctl,variable,i,j,k,varargin);
%function [sig, siga, sigm, sigstd]= GetTimeSeries(ctl,variable,i,j,k,[t]);


if nargin == 6
  t=varargin{1};
else
  t=1:length(ctl.time);
end
salt=rnt_loadvar_segp(ctl,t,variable,i,j,k);     
salt=mean(mean(salt,1),2); sig=sq(salt); 
[siga, sigm]=RemoveSeas(sig,ctl.month(t),1);
sigstd=std(siga);
