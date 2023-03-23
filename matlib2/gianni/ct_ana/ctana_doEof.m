function [eofs,eofs_coeff,varexp]=ctana_doEof(d2,varargin)
%% ctana_doEof: compute the EOF decomposition of a x-y-time array of ANOMALIES    
% [eofs,pcs,varexp]=ctana_doEof(2dfield,mask,norm)
%  
%
%  INPUTS: 
%       2dfield,      x-y-time field    
%       mask,         *Optional
%       norm,         *Optional
%
%  OUTPUTS:
%       eofs,    
%       pcs,       
%       varexp,     
%   
%
%  Example: If 2dfield: 2dfield(170,64,480), lon,lat,time
%      
%       then [eofs,pcs,varexp]=ctana_doEof(2dfield)   gives:
%
%
%                eofs: [170,64,480]
%                 pcs: [480,480]
%              varexp: [480x1]    
%                      
%   See also 
% =========================================================================
%  This function is part of the Climate toolbox for Matlab (CliMat toolbox). 
%  CliMat is a collection of matlab functions for processing and analyzing 
%  climate related data (www.oceanography.eas.gatech.edu/gianni/climat/).
%                           Giovanni Liguori, 2014 (@GATECH)
%
%  Every function follows this naming convection ct[type]_[fucntionname]   
% 
%  [Type] may be one of the follow strings:
%  ext: Extracting data (like NOOA SST, NCEP, etc, cmip5) from any server 
%       (mostly our server) to  matlab workspace 
%  ana: Any kind of analysis. For ex. Correlations, EOFs, Time_series, 
%       Time and spatial Filtering, Statistics,...
%  plt: Visualization and plotting functions
%  rnc: Creanting files for ROMS (Grid, Input frc files from extracted data)
%  rnt: Working with ROMS input/output files 
%  
%  [Functionname] is the name of the fucntion  
% =========================================================================


[I,J,imons]=size(d2);

if nargin > 1
   mask=varargin{1};
   d2=d2.*repmat(mask,[ 1 1 imons]);
end

  clear eofs eofs_coeff
  [I,J,T]=size(d2);
  eofs=zeros(I,J);
  dnew=reshape(d2,[I*J,T]);
  in=find(isnan(dnew(:,1)) == 0);
  dnew=dnew(in,:);
  
  dd=dnew'*dnew;
  % compute EOFs  
  %normalize
  %dd=dd./max(diag(dd));
  [A,D] = eig(dd);
  E=dnew*A;
  %size(E)
  %size(dnew)
  %size(A)
  %A=E*dnew;
  lambda=diag(D);
  modes=lambda/sum(lambda)*100;
  im=find(modes > -1);
  
  for i=length(im):-1:1
    m1=zeros(I,J); m1(:)=NaN;
    m1(in)=E(:,im(i));
    eofs(:,:,-i+1+length(im))=m1;
    eofs_coeff(:,-i+1+length(im))=A(:,im(i));
    varexp(-i+1+length(im))=modes(im(i));
  end
  
  if nargin > 2
      
      % Renormalize the EOFs so that the PC are in units of STD and the EOFs are
      % in units of regression.
      K=length(eofs_coeff(1,:)); % number of EOF modes
      for k=1:K
          fac(k)=std(eofs_coeff(:,k));
          eofs(:,:,k)=eofs(:,:,k)*fac(k);
          eofs_coeff(:,k)=eofs_coeff(:,k)/fac(k);
      end
      
  end
  
  

