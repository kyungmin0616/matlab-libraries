function [freq,E_1s,Navg] = ener_spec_avg_ol(x,del_x,N,win_val);
% ENER_SPEC_AVG_OL Computes the normalized energy density spectrum of a time series or data vector.
% The usage is [freq,E_1s] = ener_spec_avg_ol(x,del_x,N);
% INPUT The time series or vector is x. The sampling interval is del_x. N is the length of each block, overlapping by half.
%       win_val is 1 for windowing, 0 for no windowing. The windowing is a Hanning window.
% OUTPUT freq is the vector of frequencies or reciprocal wavelength, etc. E_1s is the one-sided spectrum.   

% make sure vector is long enough
if length(x) < N
   error('Input vector is too short.');    
end

%set up matrix where each column is a half overlapping block
Navg = floor(length(x)/N) + floor((length(x)-N/2)/N);
x_rsh = NaN*ones(N,Navg);
for q = 1:Navg
   x_rsh(:,q) = x((q-1)*N/2+1:(q-1)*N/2+N);    
end

%remove mean and trend from eaqch row
x_rsh = x_rsh - ones(size(x_rsh,1),1)*mean(x_rsh);
x_rsh = detrend(x_rsh);

%window if chosen
if win_val == 1
   %define window
   %Hanning window parameters
   hann = hanning(N,'periodic');
   norm = sqrt(sum(hann.*hann)/N); %i'm not totally happy with this method of normalization to preserve variance (check it out)
   hann_norm = hann./norm; 
   %apply window
   x_rsh = x_rsh.*(hann_norm*ones(1,Navg));    
end

%compute periodogram for each column
fft_x = fft(x_rsh);
E_2s = del_x/(size(x_rsh,1)) * (conj(fft_x) .* fft_x);
if mod(size(E_2s,1),2) == 0
E_1s = [2*E_2s(1:size(fft_x,1)/2,:); E_2s(size(fft_x,1)/2+1,:)];
freq = [0:1/del_x/(size(x_rsh,1)):size(x_rsh,1)/2/del_x/(size(x_rsh,1))]';
else
E_1s = 2*E_2s(1:(size(fft_x,1)+1)/2,:);
freq = [0:1/del_x/(size(x_rsh,1)):(size(x_rsh,1)-1)/2/del_x/(size(x_rsh,1))]';
end

%average to compute spectrum
E_1s = (sum(E_1s')/Navg)';
