function [field2, fieldm] = RemoveSeas(field,month,varargin);  

if nargin > 2
  n = varargin{1}
else
n=length(size(field));
end
field2=field*nan;

if n == 1
   for imon =1:60
      in=find(month == imon);
	fieldm(imon) = meanNaN(field(in),1);
   end
   
   for it = 1 : length(field)
      imon = month(it);
	field2(it) = field(it) - fieldm(imon);
   end
end


if n == 2
   for imon =1:60
      in=find(month == imon);
	fieldm(:,imon) = meanNaN(field(:,in),2);
   end
   
   for it = 1 : size(field,2)
      imon = month(it);
	field2(:,it) = field(:,it) - fieldm(:,imon);
   end
end

if n == 3
   for imon =1:60
      in=find(month == imon);
	fieldm(:,:,imon) = meanNaN(field(:,:,in),3);
   end
   
   for it = 1 : size(field,3)
      imon = month(it);
	field2(:,:,it) = field(:,:,it) - fieldm(:,:,imon);
   end
end

if n == 4
   for imon =1:60
      in=find(month == imon);
        fieldm(:,:,:,imon) = meanNaN(field(:,:,:,in),4);
   end

   for it = 1 : size(field,n)
      imon = month(it);
        field2(:,:,:,it) = field(:,:,:,it) - fieldm(:,:,:,imon);
   end
end
