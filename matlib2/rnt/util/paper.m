function tmp=paper(gcf,opt,varargin)

if nargin > 2
  string = varargin{1};

if strcmp(string,'jpof1')   %  
  set(gcf,'PaperPosition',[1.79 3.22 4.92 4.56]);
end

else

if opt == 0   %  predictability 2 plots vertical
  set(gcf,'PaperPosition',[1.8556      3.8556      4.7778         3.3]);
end


if opt == 202   %  predictability 2 plots vertical
  set(gcf,'PaperPosition',[1.8092 2.8554 4.92 6.84]);
end

if opt == 200   % standard size Bruce
  set(gcf,'PaperPosition',[0.2492 2.7046 6.6 5.76]);
  disp ('PaperPosition [0.2492 2.7046 6.6 5.76]');
end

if opt == 101
  set(gcf,'PaperPosition',[0.2492 5.2246 3.36 3.24]);
  disp ('PaperPosition [0.2492 4.6246 3.84 3.84]');
end


if opt == 100
  set(gcf,'PaperPosition',[0.2492 5.9446 2.52 2.52]);
  disp ('PaperPosition [0.2492 4.6246 3.84 3.84]');
end

if opt == 1
  set(gcf,'PaperPosition',[0.2492 4.6246 3.84 3.84]);
  disp ('PaperPosition [0.2492 4.6246 3.84 3.84]');
end

% 4x3 plot big page
if opt == 23
  set(gcf,'PaperPosition',[0.2492 1.8646 5.76 8.76]);
end

% web option square
if opt == 22
  set(gcf,'PaperPosition',[0.2492 6.0646 2.64 2.4]);
end

if opt == 2
  set(gcf,'PaperPosition',[0.4892 1.9846 4.92 6.84]);
end

if opt == 3
  set(gcf,'PaperPosition',[0.2492 1.2646 4.68 7.2]);
end

if opt == 4
  set(gcf,'PaperPosition',[0.2492 4.7446 3.6 3.72]);
end

if opt == 5
  set(gcf,'PaperPosition',[0.2492 5.7046 2.76 2.76]);
end


if opt == 6    % two vertical plots
  set(gcf,'PaperPosition',[0.8492 3.5446 3.6 6.36]);
end

if opt == 7    % EOF plots of winds and currents
  set(gcf,'PaperPosition',[1.0892 3.1846 4.0 6.12]);
end

end
