function [freq,E_1s, period] = ener_spec(x,del_x);
% ENER_SPEC Computes the normalized energy density spectrum of a time series.
% The usage is [freq,E_1s] = ener_spec(x,del_x);
% INPUT The time series is x. The sampling interval is del_x.
% OUTPUT freq is the vector of frequencies or wavenumbers.
%        E_1s is the one-sided spectrum which when integrated equals the data variance.
% example: load ../yt.mat
% x=yt; del_x=1;
% [freq,E_1s] = ener_spec(yt,1);
% sum(yt.^2)
% sum(E_1s)
  fft_x = fft(x);
  E_2s = del_x/(length(x)) * (conj(fft_x) .* fft_x);
  
  if mod(length(E_2s),2) == 0
    
    
    E_1s = [ 2 * E_2s(1:length(fft_x)/2,1); E_2s(length(fft_x)/2+1,1)];
    
    
  else


    E_1s = 2*E_2s(1:(length(fft_x)+1)/2,1);


  end
  freq = [0:1/del_x/(length(x)):length(x)/2/del_x/(length(x))]';
  w=2*pi/(del_x*length(x));
  n=1:length(x)/2;
  period=2*pi*n/w;
  

