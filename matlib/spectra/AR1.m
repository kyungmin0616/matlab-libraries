
SIG=sa2;

N=size(SIG,3);
% Compute AR-1 coef
t1=1:N-1; t2=2:N;


[I,J,T]=size(SIG);
SIG_AR1=zeros(I,J);
for i=1:I
i
for j=1:J
j
sig=sq(SIG(i,j,:));
a0=sig'*sig/(N);
a1=sig(t1)'*sig(t2)/(N-1);
a1=a1/a0;
SIG_AR1(i,j)=a1;
end
end

sa2_AR1=SIG_AR1;


time_decorr=-dt/log(a1);
rho=a1;  
beta=(1-a1)/dt;
1/beta;
