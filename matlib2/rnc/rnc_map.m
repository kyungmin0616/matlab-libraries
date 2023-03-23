function rnc_map(f, forcd, varargin)


rnt_contourfill(forcd.lon,forcd.lat, f.*forcd.mask, 40);
hold on
colormap(getpmap(7));
colorbar('horiz');

if nargin > 2
 ln=varargin{1};
else
 ln=2;
end
world_coast('color','k','linewidth',ln);
