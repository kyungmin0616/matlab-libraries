%RNT_GETFRAME
% Equivalent of MATLAB getframe command but saves
% ppm files instead to use later in makeing movie
% with rnt_makemove.m
%
function rnt_getframe(it,varargin)

  eval(['print -djpeg100 ',num2str(it),'.jpg']);
  p1=['convert ',num2str(it),'.jpg .',num2str(it),'.ppm'];
  unix(p1);
  p1=['rm ',num2str(it),'.jpg'];
  unix(p1);
