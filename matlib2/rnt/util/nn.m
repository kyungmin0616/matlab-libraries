function sig1=nn(sig,varargin)

if nargin > 1
  sig2=varargin{1};
  std2=stdNaN(sig2(:),1);
else
  std2=1;
end

sig1=sig/stdNaN(sig(:),1)*std2;

  
