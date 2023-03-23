
function plot_myspec (sigh2, sigh2_AR1, sigh2_AR1_90, freq,varargin)

sigh2(1)=nan; fac=1/sum(sigh2(2:end))*100;
pp = plot(log(freq), log(sigh2*fac), 'k', ...
          log(freq), log(sigh2_AR1*fac), 'k', ...
          log(freq), log(sigh2_AR1_90*fac), '--k');
set(pp(1), 'linewidth', 2);
xaxis=[ 2.^[7:-1:1] 1 0.5 0.25 0.1];
set(gca, 'XTick', log(1./xaxis), 'XTickLabel', xaxis);

yaxis=[0.1 1 2 4 8 16 32];
set(gca, 'YTick', log(yaxis), 'YTickLabel', yaxis);

xl = xlabel('Period YEARS', 'fontsize', 10);
yl = ylabel('Variance %', 'fontsize', 10);

