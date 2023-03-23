%RNT_FILTER3D
% function fsmooth=rnt_filter3d(field, mask, N, winname)
% Filter 2D time-dependent field in time using a running mean
% EXAMPLE:
% N=12;
% winname='blackman';
% fsmooth=rnt_filter3d(field, mask, N, winname)
%



function f1_sm=rnt_filter3d(f1, mask1, N, winname)

if length(size(f1)) == 1
      f1_sm=ndnanfilter(f1,winname,N);
      return
%      f1_sm(1:N)=nan;
%      f1_sm(end-N:end)=nan;

elseif length(size(f1)) == 2
      [I,T]=size(f1);
      x1=reshape(f1',[I*T 1]);
      sig=ndnanfilter(x1,winname,N);
      f1_sm=reshape(sig,[T I])';
      f1_sm(:,1:N)=nan;
      f1_sm(:,end-N:end)=nan;
elseif length(size(f1)) == 3

x2=ConvertXYT_into_ZT(f1,mask1);
[I,T]=size(x2);
x1=reshape(x2',[I*T 1]);
sig=ndnanfilter(x1,winname,N);
x2=reshape(sig,[T I])';
f1_sm=ConvertZT_into_XYT(x2,mask1);

f1_sm(:,:,1:N)=nan;
f1_sm(:,:,end-N:end)=nan;

else

  disp('rnt_filter.m - invalid arguments');
  
end

return


N=12;
winname='blackman';

f1_sm=rnt_filter3D(f1, mask1, N, winname);

clf;
plot(t1(12:end-12), sq(f11(1,1,:)), t1,  sq(f1_sm(1,1,:))   )
plot(t1, sq(f1(1,1,:)), t1,  sq(f1_sm(1,1,:))   )
