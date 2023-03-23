
function [time, npgoi, pdoi ] = rout_npgo

% older version of index load
%load /drive/edl/NEPD/process_data/SalinityMODE/SSH_PCs.mat
%npgo=PC(:,2);
%pdo=PC(:,1);

% new version
load npgo_index.mat
time=npgo.time;


istr=find(pdo.datenum == time(1));
iend=find(pdo.datenum(end) == time);

time=time(1:iend)
npgoi=npgo.index(1:iend);
pdoi=nn(pdo.index(istr:end));

