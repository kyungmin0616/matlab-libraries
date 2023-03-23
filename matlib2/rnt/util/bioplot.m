function [achl] = bioplot(var);

% load depth of each layer
  z_w=carica('z_w');

% check size
  sz = size(z_w);
  if ( sz ~= size(var) )
    disp(['Size of input variables must be ',num2str(sz)]);
  end

% integral of CHLA
% Smith, MEPS 5, 359-361, 1981
  gz_int=zeros(sz(2),sz(3));
  k_int=gz_int;
  kw=0.04;
  kchla=0.025;
  in=find(var < 0); var(in)=0;

  achl=zeros(sz(2),sz(3));
  for k=20:-1:2
    delz=abs(z_w(k,:,:) - z_w(k-1,:,:));
    %achl=achl + squeeze(var(k,:,:).*delz);  
    chlor = squeeze(var(k,:,:));
    attn = kw + kchla * chlor;
    k_int = k_int + attn .* squeeze(delz);
    gz = exp(-2.0 * k_int);
    achl = achl + chlor.*gz .* squeeze(delz);
    gz_int = gz_int + gz.* squeeze(delz);

  end
  k=1;
     h=carica('h');
     delz(1,:,:)=abs(squeeze(z_w(k,:,:)) + h );
     %achl=achl + squeeze(var(k,:,:).*delz);
    chlor = squeeze(var(k,:,:));
    attn = kw + kchla * chlor;
    k_int = k_int + attn .* squeeze(delz);
    gz = exp(-2.0 * k_int);
    achl = achl + chlor.*gz .* squeeze(delz);
    gz_int = gz_int + gz.* squeeze(delz);


     achl = achl ./ gz_int;
     achl = (log10( achl + 0.01 ) + 2.0 ) /0.015;

mask=carica('mask_rho');
mask(mask == 0) = NaN;
mask=mask';
      achl=achl.*mask;
