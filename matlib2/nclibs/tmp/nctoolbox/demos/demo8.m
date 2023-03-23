% DEMO8

echo('on')
% Demonstration of subsetting a CF convention dataset

url='http://blackburn.whoi.edu:8081/thredds/dodsC/coawst/fmrc/coawst_2_best.ncd';
ds = cfdataset(url);

% Grab the variable of interest. No data is being read yet.
v = ds.variable('temp');
sz= size(v);

% Grab a subset of the data. Data is now being pulled across the network
t = v.data([sz(1) sz(2) 1 1], [sz(1) sz(2) sz(3) sz(4)]);

% Make a pretty plot
surf(t.lon_rho, t.lat_rho, double(squeeze(t.temp)))
shading('interp');
view(2)
axis('equal')

xatt = ds.attributes('lon_rho');
xname = value4key(xatt, 'long_name');
xunits = value4key(xatt, 'units');
xlabel([xname ' [' xunits ']']);

yatt = ds.attributes('lat_rho');
yname = value4key(yatt, 'long_name');
yunits = value4key(yatt, 'units'); 
ylabel([yname ' [' yunits ']']);

zatt = ds.attributes('temp');
zname = value4key(zatt, 'long_name');
zunits = value4key(zatt, 'units'); 
ztime = ds.time('ocean_time', t.ocean_time);
title([zname ' [' zunits '] on ' datestr(ztime)]);

colorbar