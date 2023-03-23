function [wnum_z,wnum_x,E_1s] = ener_spec_2d(A,del_z,del_x);
% ENER_SPEC_2D Computes the normalized 2d energy density spectrum of a two 
% dimensional space field. (This could also be used for a time-space field.)
% The usage is [wnum_z,wnum_x,E_1s] = ener_spec_2d(A,del_z,del_x);
% INPUT The space field is A. The sampling interval in the horizontal (columns) is del_x.
% The sampling interval in the vertical (rows) is del_z.
% OUTPUT wnum_x is the vector of horizontal wavenumbers. wnum_z is the vector of
% vertical wavenumbers. (These are cyclical.) 
% E_1s is the one-sided spectrum. (This is one half of the two dimensional spectrum.)


N=size(A,1);
M=size(A,2);

if sum(sum(isfinite(A))) ~= N*M
  error('Missing data.');
end
if N*M == 1
  error('Only one data point. No spectrum computed.')
end

A_fft2 = fft2(A);
A_fft2_sh = fftshift(A_fft2);
%real used to get rid of nonzero numerical error in imaginary part
if N == 1
E_2s = real((del_x/M)*conj(A_fft2_sh).*A_fft2_sh);
elseif M == 1
E_2s = real((del_z/N)*conj(A_fft2_sh).*A_fft2_sh);
else
%E_2s = real((del_x/M)*(del_z/N)/(4*pi^2)*conj(A_fft2_sh).*A_fft2_sh);
E_2s = real((del_x/M)*(del_z/N)*conj(A_fft2_sh).*A_fft2_sh);
end

%odd-odd case (mean at ((N_z+1)/2,(N_x+1)/2), no non-repeated values)
if(mod(N,2) == 1 & mod(M,2) == 1)
  E_1s = 2*E_2s(:,((M+1)/2):end);
  E_1s(1:((N+1)/2-1),1) = NaN;

%these next three could be changed a little. I'm not sure of the exact conventions
%with regards to the Nyquist lines and the mean lines which have symmetric parts.
%I tried to generalize from the 1-d case.

%odd-even case (mean at ((N_z+1)/2,N_x/2+1), non-repeated value at ((N_z+1)/2,1))
elseif(mod(N,2) == 1 & mod(M,2) == 0)
  E_1s = NaN*ones(N,M/2+1);
  E_1s(:,1:M/2) = 2*E_2s(:,M/2+1:end);
  %move first column to last
  E_1s(:,end) = E_2s(:,1);
  E_1s(1:((N+1)/2-1),end) = 2*E_1s(1:((N+1)/2-1),end);
  E_1s(1:((N+1)/2-1),1) = NaN;
  E_1s(((N+1)/2+1):end,end) = NaN;

%even-odd case (mean at (N_z/2+1,(N_x+1)/2), non-repeated value at (1,(N_x+1)/2))
elseif(mod(N,2) == 0 & mod(M,2) == 1)
  E_1s = NaN*ones(N,(M+1)/2);
  E_1s(1:end-1,:) = 2*E_2s(2:end,((M+1)/2):end);
  %move first row to last
  E_1s(end,:) = E_2s(1,((M+1)/2):end);
  E_1s(end,2:end) = 2*E_1s(end,2:end);
  E_1s(1:(N/2-1),1) = NaN;

%even-even case (mean at (N_z/2+1,N_x/2+1), non-repeated values at (1,1) , (N_z/2+1,1) , (1,N_x/2+1))
else
  E_1s = NaN*ones(N,M/2+1);
  E_1s(1:end-1,1:end-1) = 2*E_2s(2:end,M/2+1:end);
  E_1s(1:end-1,end) = E_2s(2:end,1);
  E_1s(1:N/2-1,end) = 2*E_1s(1:N/2-1,end);
  E_1s(end,1:M/2) = E_2s(1,M/2+1:end);
  E_1s(end,2:end) = 2*E_1s(end,2:end);
  E_1s(end,end) = E_2s(1,1);
 
  E_1s(1:(N/2-1),1) = NaN;
  E_1s(N/2+1:end-1,end) = NaN;

end

%z wavenumber
if N == 1
   wnum_z = NaN;
elseif mod(N,2) == 0
   wnum_z = [-(N/2/del_z/(N/2) - 1/del_z/(N/2)):1/del_z/(N/2):N/2/del_z/(N/2)]';
else
   wnum_z = [-(N-1)/2/del_z/(N/2):1/del_z/(N/2):(N-1)/2/del_z/(N/2)]'; 
end

%x wavenumber
if M == 1
   wnum_x = NaN;
elseif mod(M,2) == 0
   wnum_x = [0:1/del_x/(M/2):M/2/del_x/(M/2)];
else
   wnum_x = [0:1/del_x/(M/2):(M-1)/2/del_x/(M/2)];
end

wnum_z = wnum_z*ones(1,length(wnum_x));
wnum_x = ones(length(wnum_z),1)*wnum_x;


%variance/normalization check
%sum E_1s (leave out mean point which is in middle or just before middle of the first column)
%multiply by wavenumber differences in both directions
%this is your variance (second moment)
%sum( E_1s ) * (1/M)*(1/N)
