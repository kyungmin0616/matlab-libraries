function rnc_map(f, forcd, varargin)


%pcolorjw(forcd.lon,forcd.lat, f.*forcd.mask);
hold on
contour(forcd.lon.*forcd.mask,forcd.lat.*forcd.mask, f.*forcd.mask,'k');
hold on
colormap(getpmap(7));
colorbar('horiz');

if nargin > 2
 ln=varargin{1};
else
 ln=2;
end
world_coast('color','k','linewidth',ln);
