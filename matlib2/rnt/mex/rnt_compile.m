%RNT_COMPILE
% Compile RNT Mex-files
% Type rnt_compile on the MATLAB prompt
%
w=what('rnt');
str=[w.path,'/mex'];
disp(['Changing to directory ',str]);
cd (str);
warning off
disp('Compiling ... ')

% Vertical coordinate transformations
mex rnt_2sigma_mex.F
mex rnt_2s_mex.F
mex rnt_2s_mex_linear.F
mex rnt_2z_mex.F

% Extrapolations
mex rnt_fillab_mex.F
mex rnt_fill_mex.F
mex rnt_fill_time_mex.F

% Objective Mapping
mex rnt_oa2d_mex.F
mex rnt_oa3d_bruce_version_mex.F
mex rnt_oa3d_mex.F

% Triangulation routine
mex rnt_hindicesTRI_mex.F

% ROMS denisty equation
mex rnt_rho_eos_mex.F

% move binaries
if ~exist('binaries')
	mkdir binaries
end
unix('mv *.mex* binaries');
ls binaries
disp('DONE.')
return

% Obsolete
%mex rnt_2s_mexV2.F
%mex rnt_oa3d_v2_mex.F
%mex rnt_oa2d_tile_mex.F
%mex rnt_2z_mex_linux.F
%mex rnt_fill3ab_mex.F
