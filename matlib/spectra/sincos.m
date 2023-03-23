function [an, bn, period, sighat, sig_filter, E] = sincos(signal,dt, varargin)


E=[];
if nargin > 2
   E = varargin{1};
end

signal = signal - mean(signal);
T = length(signal);
sig=zeros(T,1);
sig(:,1)=signal(:);


w=2*pi/(T-1);
t=0:T-1;
ishift=T/2;


if isempty(E) == 1
  E=zeros(T,T/2*2);
  disp('Computing E ..');
icos=0;
for n=1:T/2
    icos=icos+1;
    E(:,icos) = cos(w*n*t);
    isin = ishift + icos;
    E(:,isin) = sin(w*n*t);
end
end


W = diag( ones(T,1)*1.0e-10 );
CME = inv(E'*E + W);
amp = CME*E'*sig;
sighat = E*amp;

an = amp(1:ishift);
bn = amp(ishift+1:end);

n=[1:T/2];
period=2*pi./(w*n)*dt;


in = find( period > 60 & period < 120 );

anhat = an*0;
bnhat = bn*0;

anhat(in) = an(in);
bnhat(in) = bn(in);
amp = [anhat; bnhat];

sig_filter = E*amp;





