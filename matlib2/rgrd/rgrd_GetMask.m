% function maskr2=rgrd_GetMask(grd1,grd2);
%    get the mask from grid GRD1 and interpolated to GRD2
%
%  E. Di Lorenzo (edl@ucsd.edu)


function maskout=rgrd_GetMask(grd1,grd2);

maskr1=grd1.maskr;

maskr1(isnan(maskr1))=0;

maskr2=rnt_griddata(grd1.lonr,grd1.latr,maskr1, ...
                    grd2.lonr,grd2.latr, 'linear');

maskout=maskr2*0+1;
maskout(maskr2<=0.5)=0;

