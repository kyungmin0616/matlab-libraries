

function pic_tif2jpg
  
   
    ! chmod -x *.tif *.TIF
    ! ls -rt1 *.tif *.TIF > tmp
    file = textread('tmp','%s','delimiter','\n','whitespace','');
    
    
    
    for i=1:length(file)
      istr= istr + 1;
      space=' ';
      
      str=['convert ',file{i},space,file{i}(1:end-4),'.jpg'];
      disp(str);
      unix(str);
    end
    
    
    !rm tmp
