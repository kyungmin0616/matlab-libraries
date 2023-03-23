function [ out] = dates_clima (days)

% function [datestr, gday] = dates_clima (days)
[num,ttmp]=size(days(:));

%for i=1:num
years=floor(days/360) ;
gday=days - 360*(years) +1;
mon = floor((gday-1)/30) + 1;
mday = (gday-1) - (mon-1)*30 +1;
mday=round(mday);
monii=(mon-1)*3 +1;
months=['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul','Aug', 'Sep', 'Oct',  'Nov', 'Dec'];
%datestr=[num2str(mday),[' '],months(monii:monii+2),[' (yr='],num2str(years),')'];
%end
out=[ mday mon years gday ];
