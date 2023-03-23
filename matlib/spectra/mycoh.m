function [sigh2, fft_sig, phase,freq , period, sigh2_AR1, sigh2_AR1_90 ] = mycoh(sig,dt,nchunk);
% ENER_SPEC Computes the normalized energy density spectrum of a time series.
% The usage is [freq,E_1s] = ener_spec(sig,dt);
% INPUT The time series is sig. The sampling interval is dt.
% OUTPUT freq is the vector of frequencies or wavenumbers.
%        E_1s is the one-sided spectrum which when integrated equals the data variance.
% example: load ../yt.mat
% x=yt; dt=1;
% [freq,E_1s] = ener_spec(yt,1);
% sum(yt.^2)
% sum(E_1s)

N=length(sig);
sig=reshape(sig,[N 1]);
dof=2*nchunk;
dN=N/nchunk;

for i=0:nchunk-1
   chunk=[1:dN]+dN*i;	
   sig1=sig(chunk);
   [fft_sig_tmp, phase_tmp,sigh2_tmp, freq , period, sigh2_AR1_tmp, sigh2_AR1_90_tmp ] = local_spec(sig1,dt,dof);	
   if i==0  
	  sigh2=sigh2_tmp;
	  sigh2_AR1=sigh2_AR1_tmp;
	  sigh2_AR1_90=sigh2_AR1_90_tmp;
	  fft_sig=fft_sig_tmp;
	  phase=phase_tmp;
   else 
	  sigh2_AR1=sigh2_AR1+sigh2_AR1_tmp;
	  sigh2_AR1_90=sigh2_AR1_90+sigh2_AR1_90_tmp;
      sigh2=sigh2+sigh2_tmp;
      fft_sig=fft_sig+ fft_sig_tmp;
	phase=phase+phase_tmp;
   end
end
sigh2=sigh2/nchunk;
sigh2_AR1=sigh2_AR1/nchunk;
sigh2_AR1_90=sigh2_AR1_90/nchunk;
fft_sig=fft_sig/nchunk;
phase=phase/nchunk;





function [fft_sig, phase,sigh2, freq , period, sigh2_AR1, sigh2_AR1_90 ] = local_spec(sig,dt,dof);
N=length(sig);
sig=reshape(sig,[N 1]);

fft_sig = fft(sig.*hanning(N));
%fft_sig = fft(sig);

E_2s = dt/(N) * (conj(fft_sig) .* fft_sig);
phase=atan(imag(fft_sig)./real(fft_sig));

if mod(length(E_2s),2) == 0    
    sigh2 = [ 2*E_2s(1:(N  )/2);  E_2s(N/2+1)  ];
    phase = [ phase(1:(N  )/2);  phase(N/2+1)  ];
else
    sigh2 = [ 2*E_2s(1:(N+1)/2)                ];
    phase = [ phase(1:(N+1)/2)                ];    
end

% Compute Freq. and Periods
freq = [0:1/dt/N: N/2/dt/N]';
w=2*pi/(N-1);
n=1:length(freq);
period=2*pi./(w*n)*dt;

% Compute AR-1 coef
t1=1:N-1; t2=2:N;
a0=sig'*sig/(N);
a1=sig(t1)'*sig(t2)/(N-1);
a1=a1/a0;
time_decorr=-dt/log(a1);
rho=a1;  

%  Now, construct theoretical AR1 spectrum
nfft=N;
sigh2_AR1 = 0.5./(1+rho^2-2*rho*cos(2*pi*[0:1/nfft:0.5]));
sigh2_AR1=sigh2_AR1';
sigh2_AR1=sigh2_AR1/sum(sigh2_AR1)*sum(sigh2);

siglev=.9;
sigh2_AR1_90= sigh2_AR1*chi2inv(siglev, dof)/(dof-1);

