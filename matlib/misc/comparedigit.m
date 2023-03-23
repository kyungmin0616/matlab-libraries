function digits=CompareDigits(elem1,elem2)

str1=num2str(abs(elem1),16);
str2=num2str(elem2,16);
digits=0; dig=0; k=0; cont=0;
for i=1:length(str1)
   
   if str1(i) ~= '.'
      k=k+1;
        p(k)=str1(i);
   end
end
for i=1:length(p)
   
   if p(i) == '0' & cont == 0
      dig=dig+1;
   else
      cont=1;
   end
end


%   if str1(i) == str2(i)
%      if str1(i) ~= '.', digits=digits+1; end
%   end
      
   % p, dig
   elem1=elem1*10^dig;
   elem2=elem2*10^dig;
     digits=elem1-elem2;

