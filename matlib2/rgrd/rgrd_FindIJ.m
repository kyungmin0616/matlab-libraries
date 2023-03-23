function [i,j]=rgrd_FindIJ ( lonr, latr, varargin )

if nargin > 2
  xlim=varargin{1};
  ylim=varargin{2};
else
xlim=get(gca,'xlim');
ylim=get(gca,'ylim');
end
i=find (lonr(:,1) > xlim(1) & lonr(:,1) < xlim(2));
j=find (latr(1,:) > ylim(1) & latr(1,:) < ylim(2));

disp('Works only for rectangular grid');

