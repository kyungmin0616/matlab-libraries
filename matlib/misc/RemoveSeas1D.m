function [field2, fieldm] = RemoveSeas(field,month,varargin);  


   for imon =1:12
      in=find(month == imon);
	fieldm(imon) = mean(field(in));
   end
   
   for it = 1 : length(field)
      imon = month(it);
	field2(it) = field(it) - fieldm(imon);
   end

