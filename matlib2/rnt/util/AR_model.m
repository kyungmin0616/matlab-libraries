function s=AR_model(time,f,gamma)


f=f-mean(f);

f=detrend(f);

T=length(f);

sig=zeros(T,1);
sig(1)=0;

for t=1:T
  sig(t+1) = sig(t) *(1-gamma) + f(t);
end

raw=(sig(2:end)+sig(1:end-1))/2;;
sig=detrend(sig);
sig=nn(sig-mean(sig));

s.sig=(sig(2:end)+sig(1:end-1))/2;
s.time=time;
s.raw=raw;

