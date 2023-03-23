
function [fd, ftrend] = dtrend2d(f)

[I,J,T]=size(f);

fd=zeros(I,J,T);
ftrend=zeros(I,J);
for i=1:I
for j=1:J
  p=sq(f(i,j,:));
  pd=detrend(p);
  fd(i,j,:)=pd;
  diff=p-pd;
  ftrend(i,j)=diff(end)-diff(1);
end
end
