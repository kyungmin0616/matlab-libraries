function [f,PS,Rlag1,rspec_finite,rspec_finite_95,VarBands,nn_a]=ctana_spectrum(y,n_smooth,makeplot,bands);
%% ctana_spectrum: Compute and plot the power spectrum....  
%  [f,PS,Rlag1,rspec_finite,rspec_finite_95,VarBands]=ctana_spectrum(y,n_smooth,makeplot,bands);
%   
%  Add description 
%
%
%
%  INPUTS: 
%       y, time series     
%       n_smooth, number of data to use for the moving average 
%       makeplot, set this switch to 1 if you want a plot     
%       bands(optional),   
%
%  OUTPUTS:
%       f, frequency in cycle / time series time units
%       PS, Normalized power spectrum 
%       Rlag1, lag-1 auto-correlation 
%       rspec_finite, 
%       rspec_finite_95,
%       VarBands,
%
%  Example: 
%                      
%   See also CT_ANA_CORRCOEFF.
% =========================================================================
%  This function is part of the Climate toolbox for Matlab (CliMat toolbox). 
%  CliMat is a collection of matlab functions for processing and analyzing 
%  climate related data (www.oceanography.eas.gatech.edu/gianni/climat/). 
%                           Giovanni Liguori, 2014 (@GATECH)
%
%  Every function follows this naming convection ct[type]_[fucntionname]   
% 
%  [Type] may be one of the follow strings:
%  ext: Extracting data (like NOOA SST, NCEP, etc, cmip5) from any server 
%       (mostly our server) to  matlab workspace 
%  ana: Any kind of analysis. For ex. Correlations, EOFs, Time_series, 
%       Time and spatial Filtering, Hovmuller, Statistics,...
%  plt: Visualization and plotting functions
%  rnc: Creanting files for ROMS (Grid, Input frc files from extracted data)
%  rnt: Working with ROMS input/output files 
%  
%  [Functionname] is the name of the fucntion  
% =========================================================================

N=length(y); DT=1; Fs=1/DT;
t=0:N-1;
h1=0;
%%%%%%%%%%%%%%%%%%%% DIRECT SPECTRUM 2 Dof 
%%%%% COMPUTE POWER SPECTRUM 
k=1:N/2; % k=wavenumber;
w=(2*pi*k)/N; % angular frequency in rad/s

f=w./(2*pi); % frequency in s-1
f=f(:);
Nsp=numel(f); %number of spectral estimates 
Df=0.5/Nsp; %spectral resolution

pws0=abs(fft(y));

aa=(-1)^numel(pws0);

if aa==1
pws=pws0(1:end/2).^2;
else
pws=pws0(1:(end-1)/2).^2;
end


nn_a=Df*sum(pws); %normalize by area
nnpws=pws/(nn_a); 



nnpws_mavg5=smooth(nnpws,n_smooth); % smoothing 5 points
PS=nnpws_mavg5;

% Add red noise significance 
%cc1=corr(y(1:end-1)',y(2:end)'); % compute leg-1 autocorrelation 

y=y(:);%make sure y is a column vector 
Rlag1=corr(y(1:end-1),y(2:end),'rows','pairwise');


%red noise spectrum (page160)
T_efol=(-DT)/log(Rlag1);
rspec_theor=(2*T_efol)./(1+w.^2*T_efol^2);
clear rspec_finite
 rho=Rlag1; 
% for i=1:N/2
%  rspec_finite(i)=(1-rho*rho)/(1-2*rho*cos(pi*(i-1)/(N/2))+rho*rho);
% end
 
i=1:N/2;
 rspec_finite(i)=(1-rho*rho)./(1-2*rho*cos(pi*(i-1)./(N/2))+rho*rho);


rspec_finite=rspec_finite*2;
rspec_theor=rspec_theor*2;


Fs=finv(0.95,2*n_smooth,N); % this gives 0.95;
rspec_finite_95=rspec_finite*Fs;

if nargin < 3
     makeplot=0;
end
if makeplot

    

     figure
     h1=plot(f,PS,'color','k','linewidth',2);
     hold on
     plot(f,rspec_finite,'--r',f,rspec_finite_95,'m--');

%      p=(1./f)./12;
%      figure
%      h1=plot(p,PS,'color','k','linewidth',2)
%      hold on
%      plot(p,rspec_finite,'--r',p,rspec_finite_95,'m--');
     
     
     %if nargin > 3
     
    %     xtick=get(gca,'xtick');
    %     set(gca,'XTickLabel',[(1./xtick)/fac])
     %end
         
         
         %xtick=0;
     %end
     %if xtick
         %xtick=1./[32*12 8*12 4*12 2*12 1*12];
%         %xtick=1./(2.^[5:-1:0]*12);
%         
%         %xtick=[24*12 12*12 8*12];
         %set(gca,'xtick',xtick)
         %set(gca,'XTickLabel',[(1./xtick)/12])
%         xlim([min(xtick),max(xtick)]) 
     %end  
%         hl2=plot(f,rspec,'--r',f,rspec_95,'b--');
%         axl2=gca;
%         set(hl2,'linewidth',2)
%         %set(axl1,'fontsize',16,'fontname','times')
%         %title ('EL NINO4 Time Series [Degree of freedom 2]','fontsize',16,'fontname','times');
%         %xlabel(axl2,'Period [years]','fontsize',16,'fontname','times');
%         %ylabel(axl2,'Power Spectrum','fontsize',16,'fontname','times')
%         %legend('data','red-noise','significance level at 95%')
        
legend('PS','Red-noise PS','95% Sign. Level ')

end

if nargin > 3 
%val=[(1/(3*12)),(1/(8*12)),1/(30*12)];


for i=1:numel(bands);
tmp = abs(f-bands(i));
[idx idx] = min(tmp); %index of closest value
ff(i) = f(idx); %closest value
ffidx(i)=idx;
end

if makeplot
   plot(f(ffidx),PS(ffidx),'g.','Marker','.','Markersize',24);
   for j=1:numel(bands)
   plot([f(ffidx(j)),f(ffidx(j))],[0,PS(ffidx(j))],'g--');
   end
end


VarBands(1)=trapz( f(1:ffidx(end)),PS(1:ffidx(end)) );

for j=1:numel(bands)-1
VarBands(j+1)=trapz( f(ffidx(end+1-j):ffidx(end-j)),PS(ffidx(end+1-j):ffidx(end-j)) );
end

VarBands(j+2)=trapz( f(ffidx(1):end),PS(ffidx(1):end) );

else

VarBands=0;
end


