function o=Correlation2D(t2, field2d, mask, t1, s1)

DEBUG_FLAG=0;
% t2=sstn.time(10:end);
% pdo=rout_pdo;
% t1=pdo.datenum;
% s1=pdo.index;
% field2d=sstn.ano(:,:,10:end);
% mask=sstn.mask;

% tic; o2=rnc_corr2(t2, field2d, t1, s1,30);; toc
% mfig; clf; rnc_map(o2.corr, sstn);
% mfig; clf; rnc_map(o.corr, sstn);

% Clear NaN values
s2=squeeze(nanmean(nanmean(field2d,1),2));
in=find(~isnan(s1)); s1=s1(in); t1=t1(in);
in=find(~isnan(s2)); s2=s2(in); t2=t2(in);



% align time series so that the begin and end at the same time
t_start= max(t1(1), t2(1));
t_end  =min(t1(end), t2(end));

istr=find(t2>=t_start); iend=find(t2<=t_end);
istr=istr(1); iend=iend(end);
time=t2(istr:iend);

% create a new time array and interpolate the timeseries so
% that they have the exact times.
s1=interp1(t1,s1,time,'linear');

% Assign variables to matrices X(x,t) and Y(1,t)
X=ConvertXYT_into_ZT(field2d(:,:,istr:iend), mask);
Y=zeros(1,length(s1)); Y(:)=s1(:);
n=size(Y,2)-1;

if DEBUG_FLAG==1
    disp('Size of arrays')
    size(X)
    size(Y)
end


filter=0;
if filter==0
    tic
    % Compute Standard Deviation of Signal
    stdX=stdNaN(X,2);
    stdY= sqrt((Y*Y')/n);
    Cxy=(X*Y')/n;
    o.r1=ConvertZT_into_XYT(Cxy,mask);
    Cxy=(X*Y')/n./stdX./stdY;
    o.corr=ConvertZT_into_XYT(Cxy,mask);
    toc
else
    disp('EOF decomp ..');
    tic
    [E,P,VEXP]=rnt_doEof(field2d, mask);
    P=P';
    E=ConvertXYT_into_ZT(E, mask);
    kmodes=2;
    E=E(:,1:kmodes); P=P(1:kmodes,:);
    X=E*P;
    fieldn=ConvertZT_into_XYT(X,mask);
    stdX=stdNaN(fieldn,3);
    stdX=ConvertXYT_into_ZT(stdX, mask);
    Y=s1;
    alfa=inv(P*P')*P*Y';
    Yhat=(P'*alfa)';
    corrcoef(Y,Yhat)
    clf;plot(Yhat)
    hold on; plot(Y, 'r');
    Y=Yhat;
    n=size(X,2)-1;
    stdY= sqrt((Y*Y')/n);
    Cxy=(X*Y')/n;
    o.r1=ConvertZT_into_XYT(Cxy,mask);
    Cxy=(X*Y')/n./stdX./stdY;
    o.corr=ConvertZT_into_XYT(Cxy,mask);
    toc    
end