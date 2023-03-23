

function pic_Rename(ctl)
% function pic_Rename(ctl)
% rename pictures in a subdirectory.
%ctl.dir      = '/d6/jais/Photo/Wedding/roll1';
%ctl.prefix   = 'ROLL1-';
%ctl.istr     = 10;  % starting index for picture
  
%  ctl.alldir = {'BrideAtHouse' ...
%     'Church' ...
%     'ChurchOutside' ...
%     'FrontShots' ...
%     'PreparingForChurch' ...
%     'Reception' ...
%     'daniel1' ...
%     'daniel2' ...
%     'misc' ...
%     'no'}
  
%  for j=8 %1:length(ctl.alldir)
 %   ctl.dir=['/d6/jais/Photo/Wedding/',ctl.alldir{j}];
 %   ctl.prefix = [ctl.alldir{j},'-'];
 %   ctl.istr=1;
    
    eval(['cd ',ctl.dir]);
    
    
    pwd1 = pwd;
    
    
    ! chmod -x *.JPG *.jpg
    ! ls -rt1 *.JPG *.jpg > tmp
    file = textread('tmp','%s','delimiter','\n','whitespace','');
    
    istr=ctl.istr-1;
    
    for i=1:length(file)
      istr= istr + 1;
      space=' ';
      
      str=['mv "',file{i},'"',space,ctl.prefix,num2str(istr),'.jpg'];
      disp(str);
      unix(str);
    end
    
    
    !rm tmp
    eval(['cd ',pwd1]);
    
 % end
