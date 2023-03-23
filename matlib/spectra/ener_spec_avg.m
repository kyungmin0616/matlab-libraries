function [freq,E_1s] = ener_spec_avg(x,del_x,N);
% ENER_SPEC Computes the normalized energy density spectrum of a time series or data vector.
% The usage is [freq,E_1s] = ener_spec(x,del_x);
% INPUT The time series or vector is x. The sampling interval is del_x. N is the length of each non-overlapping block.
% OUTPUT freq is the vector of frequencies or reciprocal wavelength, etc. E_1s is the one-sided spectrum.   

Navg = floor(length(x)/N);
x = x(1:(Navg*N),1);
x_rsh = reshape(x,N,Navg);

fft_x = fft(x_rsh);
E_2s = del_x/(size(x_rsh,1)) * (conj(fft_x) .* fft_x);
if mod(size(E_2s,1),2) == 0
E_1s = [2*E_2s(1:size(fft_x,1)/2,:); E_2s(size(fft_x,1)/2+1,:)];
freq = [0:1/del_x/(size(x_rsh,1)):size(x_rsh,1)/2/del_x/(size(x_rsh,1))]';
else
E_1s = 2*E_2s(1:(size(fft_x,1)+1)/2,:);
freq = [0:1/del_x/(size(x_rsh,1)):(size(x_rsh,1)-1)/2/del_x/(size(x_rsh,1))]';
end
if Navg ~= 1
E_1s = (sum(E_1s')/Navg)';
end
