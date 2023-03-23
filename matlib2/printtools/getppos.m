
function pp=getppos()
pp=get(gcf, 'paperposition');
disp('   ')
disp(['p=[', num2str(pp),'];']);
disp('set(gcf, ''paperposition'',p);');
disp('    ')

