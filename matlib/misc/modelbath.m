

load  /d1/manu/matlib/misc/modelbath.mat 
figure;
pcolor(lon,lat,h.*mask);shading flat; colorbar;
hold on
plot(clon,clat,'xw')

