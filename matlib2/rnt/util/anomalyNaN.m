% function [Manomaly, Mmean] = meanNaN(matrix,n,[opt])
%
% Take the anomlay for the index N in MATRIX	, where
% MATRIX can contain NaN values. These will be treated
% as giving zero contribution to the mean.
% OPT is optional. If assigned instead of computing the mean
% it will just compute the sum.
% NUM returns the numbers of elements found in the mean (or sum
% if OPT is defined).

function [Mmatrix, Mymean] = stdNaN(matrix,n,varargin)

[MyMean, Num] = meanNaN(matrix,n);
isize=size(matrix);
isize2=isize(n);
isize(:)=1; isize(n)=isize2;


Mmatrix=matrix-repmat(MyMean,isize);

