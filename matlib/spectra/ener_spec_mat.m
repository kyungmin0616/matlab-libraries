function [freq,E_1s] = ener_spec_mat(x,del_x);
% ENER_SPEC Computes the normalized energy density spectrum of a time series.
% The usage is [freq,E_1s] = ener_spec(x,del_x);
% INPUT The time series is x. The sampling interval is del_x.
% OUTPUT freq is the vector of frequencies or wavenumbers. 
%        E_1s is the one-sided spectrum which when integrated equals the data variance.   
% if x is a matrix, each column is taken to be a time series and the spectrum of each is returned in matrix E_1s

fft_x = fft(x);
E_2s = del_x/(size(x,1)) * (conj(fft_x) .* fft_x);
if mod(size(E_2s,1),2) == 0
E_1s = [2*E_2s(1:size(x,1)/2,:); E_2s(size(x,1)/2+1,:)];
else
E_1s = 2*E_2s(1:(size(x,1)+1)/2,:);
end
freq = [0:1/del_x/(size(x,1)):size(x,1)/2/del_x/(size(x,1))]';
