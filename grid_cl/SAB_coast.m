function SAB_coast

load('/Users/kpark350/Ga_tech/Projects/SAB/SAB_coast.mat');

C_lon = lon-360;
C_lat = lat;

plot(C_lon, C_lat, 'k')

