
function S = sw_salt(cndr,T,P)

% SW_SALT    Salinity from cndr, T, P
%=========================================================================
% SW_SALT  $Revision: 1.3 $  $Date: 1994/10/10 05:49:53 $
%          Copyright (C) CSIRO, Phil Morgan 1993.
%
% USAGE: S = sw_salt(cndr,T,P)
%
% DESCRIPTION:
%   Calculates Salinity from conductivity ratio. UNESCO 1983 polynomial.
%
% INPUT:
%   cndr = Conductivity ratio     R =  C(S,T,P)/C(35,15,0) [no units]
%   T    = temperature [degree C (IPTS-68)]
%   P    = pressure    [db]
%
% OUTPUT:
%   S    = salinity    [psu      (PSS-78)]
% 
% AUTHOR:  Phil Morgan 93-04-17  (morgan@ml.csiro.au)
%
% DISCLAIMER:
%   This software is provided "as is" without warranty of any kind.  
%   See the file sw_copy.m for conditions of use and licence.
%
% REFERENCES:
%    Fofonoff, P. and Millard, R.C. Jr
%    Unesco 1983. Algorithms for computation of fundamental properties of 
%    seawater, 1983. _Unesco Tech. Pap. in Mar. Sci._, No. 44, 53 pp.
%=========================================================================

% CALLER: general purpose
% CALLEE: sw_sals.m sw_salrt.m sw_salrp.m

  
%----------------------------------
% CHECK INPUTS ARE SAME DIMENSIONS
%----------------------------------
[mc,nc] = size(cndr);
[mt,nt] = size(T);
[mp,np] = size(P);

if ~(mc==mt | mc==mp | nc==nt | nc==np)
  error('sw_salt.m: cndr,T,P must all have the same dimensions')
end %if

%-------
% BEGIN
%-------
R  = cndr;
rt = sw_salrt(T);
Rp = sw_salrp(R,T,P);
Rt = R./(Rp.*rt);
S  = sw_sals(Rt,T);

return
%--------------------------------------------------------------------

