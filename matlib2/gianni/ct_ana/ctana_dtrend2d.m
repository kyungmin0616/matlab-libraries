function [fd, ftrend] = ctana_dtrend2d(f,method)
%% ctana_dtrend2d: Detrend multi-dimentional data using different methods  
%  [fd, ftrend] = ctana_dtrend2d(f,varargin);
%   
%  Add description 
%

%
%
%  INPUTS: 
%       f,                multidimensional array having the time in the 
%                         last dimension:f(dim1,dim2,...,dim5,month);     
%       method(optional), This define the function to use to compute the trend. 
%                         method could be: 'lin', 'qua', or 'exp'    
%
%  OUTPUTS:
%       ftrend, trend
%       fd, detrended data (f-ftrend) 
%
%  Example: 
%                      
%   See also CT_ANA_CORRCOEFF.
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
%       Time and spatial Filtering, Hovmuller, Statistics,...
%  plt: Visualization and plotting functions
%  rnc: Creanting files for ROMS (Grid, Input frc files from extracted data)
%  rnt: Working with ROMS input/output files 
%  
%  [Functionname] is the name of the fucntion  
% =========================================================================




% does not work if the data are not 

if nargin<2
    method ='lin'; 
else
    method =method(1:3);
end


if isvector(f)
    
    switch lower(method)
        
        case 'lin'      
                    p=f;
                    pd=detrend(p);
                    fd=pd;
                    diff=p-pd;
                    ftrend=diff(end)-diff(1);
        case 'qua'
                    y=f;
                    
                    x=[1:numel(y)]';
                    A=[x.^2,x,ones(numel(y),1)];
                    b=inv(A'*A)*A'*y;
                    
                    yhat=A*b;
                    fd=y-yhat;
                    diff=yhat;
                    ftrend=diff(end)-diff(1);
            
        case 'exp'
                    y=f;
                    logy=log(y);
                    x=[1:numel(y)]';
                    A=[x,ones(numel(y),1)];
                    b=inv(A'*A)*A'*logy;
                    logyhat=A*b;
                    yhat=exp(logyhat);
                    fd=y-yhat;
                    diff=yhat;
                    ftrend=diff(end)-diff(1);
            
    end
else


[I,J,T]=size(f);
fd=zeros(I,J,T);
ftrend=zeros(I,J);

switch lower(method)
    
    case 'lin'
        
        for i=1:I
            for j=1:J
                p=sq(f(i,j,:));
                pd=detrend(p);
                fd(i,j,:)=pd;
                diff=p-pd;
                ftrend(i,j)=diff(end)-diff(1);
            end
        end
        
    case 'qua'
        
        for i=1:I
            for j=1:J
                y=sq(f(i,j,:));
                
                x=[1:numel(y)]';
                A=[x.^2,x,ones(numel(y),1)];
                b=inv(A'*A)*A'*y;
                
                yhat=A*b;
                fd(i,j,:)=y-yhat;
                diff=yhat;
                ftrend(i,j)=diff(end)-diff(1);
            end
        end
        
    case 'exp'
        
        for i=1:I
            for j=1:J
                y=sq(f(i,j,:));
                logy=log(y);
                x=[1:numel(y)]';
                A=[x,ones(numel(y),1)];
                b=inv(A'*A)*A'*logy;
                logyhat=A*b;
                yhat=exp(logyhat);
                fd(i,j,:)=y-yhat;
                diff=yhat;
                ftrend(i,j)=diff(end)-diff(1);
            end
        end
        %disp('need to be implemented')
        
end


end
















