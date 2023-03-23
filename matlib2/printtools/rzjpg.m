function  rzpjpg(fignum,resnum,filename)

% function rzpjpg(fignum,resnum,filename)
% writes jpeg file of figure fignum using zbuffer renderer
% with resolution 'resnum'  (set to 0 for screen resolution)

figure(fignum);
sprintf('%s%d%s%s%s', 'print -zbuffer -djpeg -r',resnum,' ',filename,'.jpg')
eval(sprintf('%s%d%s%s%s', 'print -zbuffer -djpeg -r',resnum,' ',filename,'.jpg'));
