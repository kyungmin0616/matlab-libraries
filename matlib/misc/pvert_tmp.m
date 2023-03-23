function pvert = pvert(x,z,var)
  
  var=squeeze(var(20,:,:));
  z=squeeze(z(20,:,:));
  
  [ix,iz]=size(var);
  for i=1:iz
    x(:,:,i)=x(:,:,1);
  end
  
  x=squeeze(x(20,:,:));
  size(x)
  size(var)
  
  pcolor(x,z,var); set(gca,'ylim',[-200 0]); colorbar

