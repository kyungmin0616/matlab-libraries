function [iter,cost]=cost_function(fname);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2002 Rutgers University.                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                           %
% function [iter,cost]=cost_function(fname)                                 %
%                                                                           %
% This function reads and plots 4DVAR cost function.                        %
%                                                                           %
% On Input:                                                                 %
%                                                                           %
%    fname       NetCDF initial file name (character string).               %
%                                                                           %
% On Output:                                                                %
%                                                                           %
%    iter        Iteration (matrix).                                        %
%    cost        cost function per state variable and total (matrix).       %
%                                                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%  Read in cost function an extract valid data.

spval=1.0e+30;

cost=nc_read(fname,'cost_function');

if (length(cost(:,1)) > 4),
  state={'Total','zeta','ubar','vbar','u','v','temp'};
else,
  state={'Total','zeta','ubar','vbar'};
end,

%  Remove fill values and reshape matrix size.

i=find(cost(:,1) == 0);
if (~isempty(i)),
  cost(i,:)=[];
  state(i)=[];
end,
[m,n]=size(cost);

i=find(cost > spval );
if (~isempty(i)),
  cost(i)=[];
  n=fix(length(cost)/m);
  cost=reshape(cost,m,n);
end,

%  Set default color order.

Corder=[0.00 0.00 0.00; ...  % black
        1.00 0.00 0.00; ...  % red
        0.00 1.00 1.00; ...  % cyan
        0.00 1.00 0.00; ...  % green
        0.00 0.00 1.00; ...  % blue
        1.00 0.00 1.00; ...  % magenta
        1.00 0.75 0.00; ...  % orange
        1.00 0.50 0.25];     % pink

set(0,'DefaultAxesColorOrder',Corder);

% Plot cost function.

figure;

x=1:n;
iter=repmat(x,[m,1]);

iter=iter';
cost=cost';

set(gcf,'Units','Normalized',...
        'Position',[0.2 0.1 0.6 0.8],...
	'PaperUnits','Normalized',...
	'PaperPosition',[0.2 0.1 0.6 0.8]);

semilogy(iter,cost,'.-')
legend(state,1);
xlabel('Iteration');
title('4DVAR Model-Observations Misfit Cost Function');

return

