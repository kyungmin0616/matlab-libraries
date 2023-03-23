
function rout_links (ctl, name, direc)

direc=[direc, '/'];
I=length(ctl.file)
for i=1:I
  num=num2str(i);
  if length(num) == 1, num=['00',num]; end
  if length(num) == 2, num=['0',num]; end

  str=[direc,name,'_',num,'.nc'];
  unix(['ln -s ',ctl.file{i},'  ', str]);
  display(['ln -s ',ctl.file{i},'  ', str]);
end
