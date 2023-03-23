
function [sigavg, years]=rnc_yearavg(time, sig)

[year, month]=dates_datenum(time);

% Compute how big is sig
[I,J,K]=size(sig);
% Compute how long is sig yearly avg
years=year(1):year(end);
T=length(years);

if J>1
% Initialize the matrix
sigavg=zeros(I,J,T);
k=0;
for yr=year(1):year(end)
  in=find(year == yr);
  k=k+1;
  sigavg(:,:,k)=mean(sig(:,:,in),3);
end
end

if J == 1
% Initialize the matrix
sigavg=zeros(T,1);
k=0;
for yr=year(1):year(end)
  in=find(year == yr);
  k=k+1;
  sigavg(k)=mean(sig(in));
end
end
