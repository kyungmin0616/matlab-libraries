%RNT_LOADSTATE
% function state = rnt_loadState(ctl,index,vars);
% Load a structure array with the ROMS full state
%
% EXAMPLE
% vars={'temp' 'salt' 'u' 'v' 'zeta' 'ubar' 'vbar'};
% state = rnt_loadState(ctl,38,vars); % load time index 38 
%
% SEE rnt_timectl.m to generate a the CTL struct. array 
%      (it is easy ..no worry ok!)
%

function state = rnt_loadState(ctl,index,vars);
%function state = rnt_loadState(ctl,index,vars);

% vars={'temp' 'salt' 'u' 'v' 'zeta' 'ubar' 'vbar'};

for iv=1:length(vars)
   disp(['Loading ...', vars{iv}]);
   tmp=rnt_loadvar(ctl,index,vars{iv});
   eval(['state.',vars{iv},' = tmp;']);
end   
state.time = ctl.time(index);
state.ocean_time = ctl.time(index);
state.scrum_time = ctl.time(index);
