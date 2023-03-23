
function [skill,t1]=varexp(s1, maxlag)

s1=nn(s1);
k=1;
skill(1)=1;
t1(1)=0;
for i=2:2:maxlag
  s1l= nn(ndnanfilter(s1,'blackman',i));
  k=k+1;
  skill(k) = 1 - var(s1-s1l)/var(s1);
  skill(k) = correlation(1:length(s1), s1, 1:length(s1), s1l,1);
  t1(k)=i;
end  
