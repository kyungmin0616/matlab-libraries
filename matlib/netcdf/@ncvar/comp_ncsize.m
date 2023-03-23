% FUNCTION comp_ncsize(comp_ncvar)
%
%  Returns the sizes of a composite ncvar variable object
%
% SEE ALSO:  comp_vars
function [comp_size]=comp_ncsize(comp_ncvar)


% take the content of the last pointer, which is a cell, and compute
%its diemnsions.
dimensions=length(comp_ncvar.itsDstsubs{end});

% now assign to mydim the cell array in question
mydim=comp_ncvar.itsDstsubs{end};

for i=1:dimensions
   % the last element of each of the cell array element is the size
   comp_size(i) = mydim{i}(end);
end

