
function rm = init(filename)

nc=netcdf(filename,'w');

nc{'v'}(:)=0;
nc{'u'}(:)=0;
nc{'vbar'}(:)=0;
nc{'ubar'}(:)=0;
nc{'zeta'}(:)=0;

close(nc)


