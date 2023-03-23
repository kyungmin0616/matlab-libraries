%RNT_PLOT_SIGMA
% Plot the sigma coordinates
% function rnt_plot_sigma(depths, dist , i_range, j_range, s_range, varargin)
%
% EXAMPLE:
% grd=rnt_gridload('nena8km')  % requires rnt_examples
% zeta=0; % set to zero if you wnat to assume a constant 0 zeta
% [z_r,z_w,Hz] = rnt_setdepth(zeta,grd);
% mfig; i=1:grd.Lp; j=10; k=1:grd.N
% rnt_plot_sigma(z_r, grd.lonr(i,j) ,i, j, k, 'k')

function rnt_plot_sigma(depths, dist , i_range, j_range, s_range,  varargin)

for s=s_range
plot(dist, sq(depths(i_range, j_range, s_range)), varargin{:} ); hold on
end

