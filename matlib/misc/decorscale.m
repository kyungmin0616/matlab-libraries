function [Decorr,lag] = decorscale(signal,time);



N=length(signal);

for i=1:N
for j=1:N
  C(i,j) = signal(i)*signal(j)/N;
end
end  

C(1,:)

mid=72*5;
del=mid-1;
Decorr=zeros(mid+del,1);
lag=zeros(mid+del,1);
lag(mid+1:mid+del)=1:del;
lag(mid-del:mid-1)=-del:-1;
for i=mid:N-mid


Decorr(mid) = Decorr(mid)+ C(i,i);
Decorr(mid+1:mid+del)    = Decorr(mid+1:mid+del) + C(i+1:i+del,i);
Decorr(mid-del:mid-1) = Decorr(mid-del:mid-1)+ C(i-del:i-1,i);

end

max(Decorr)
Decorr = Decorr/max(Decorr);

