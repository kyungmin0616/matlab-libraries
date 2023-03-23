function vnew=nonan(x,y,z)

warning off;
D=isnan(z);
z0=z; x0=x; y0=y; 
z0(D)=[]; x0(D)=[]; y0(D)=[];
z01=griddata(x0,y0,z0,x,y,'nearest');
vnew=z; vnew(D)=z01(D);
warning on;

return
