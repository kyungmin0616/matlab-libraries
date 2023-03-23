%RNT_SAVESTATE
% function state = rnt_saveState(ctl,index,vars,state);
% Load a structure array with the ROMS full state
%
% Assume you have a model state structure array
%state = 
%
%          temp: [386x130x30 double]
%          salt: [386x130x30 double]
%             u: [385x130x30 double]
%             v: [386x129x30 double]
%          zeta: [386x130 double]
%          ubar: [385x130 double]
%          vbar: [386x129 double]
%          time: 155422838.880845
%    ocean_time: 155422838.880845
%    scrum_time: 155422838.880845
%
% EXAMPLE
% vars={'temp' 'salt' 'u' 'v' 'zeta' 'ubar' 'vbar'};
% rnt_saveState(ctl,38,vars,state); % save in time index 38 
%
% SEE rnt_timectl.m to generate a the CTL struct. array 
%      (it is easy ..no worry ok!)
%
function state = rnt_saveState(ctl,index,vars,state);
%function state = rnt_saveState(ctl,index,vars,state);

% vars={'temp' 'salt' 'u' 'v' 'zeta' 'ubar' 'vbar'};

for iv=1:length(vars)
   disp(['Saving ...', vars{iv}]);
   eval(['myval=state.',vars{iv},';']);
   rnt_savevar(ctl,index,vars{iv},myval);
end   
%state.time = ctl.time(index);
