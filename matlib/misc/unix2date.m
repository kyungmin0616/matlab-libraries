function [jd,TS] = jdtime(arg1,arg2)
% jdtime - converts UNIX time value to Julian day and time.
%
% JDTIME(X), where X is a scalar, returns a string containing the Julian
%     day and time in the format 'JD HH:MM:SS'.
% JDTIME(X), where X is a row or column vector, returns a column vector
%     of strings containing the Julian day and time in the format
%     'JD HH:MM:SS'.
% JDTIME(X,'years') returns a string or strings containing the year
%     Julian day and time in the format 'YEAR JD HH:MM:SS'.
%
% NOTES: This function does _NOT_ operate on matices!
%  See the TIME(3V) man page for the format of the input time
%  value.
%  A timestring of NaN's (ie. NaN NaN:NaN:NaN) will be
%  returned for values which are out of range.
%
% example...
%
% times = [0 816643733 2147483647 2147483648];
% times_noyear = jdtime(times)
% times_withyear = jdtime(times,'years')
%
  
% Author: Trevor Cooper, Marine Life Research Group/SIO
%  tcooper@ucsd.edu
%  November 20, 1995.
  
  time_t=arg1;
  do_years=0;
  
  for ii = 1:nargin,
    arg=eval(['arg' int2str(ii)]);
    if (isstr(arg)),
      xarg=[arg '       '];
      if (lower(xarg(1:4))=='year'),
        do_years=1;
        end;
        end;
        end;
        
        % Create a vector containing cumulative seconds/year since time_t = 0.
        % The second last element of the vector is one greater than the maximum
        % possible value of time_t. Values larger than this will return a timestring
        % composed of NaN's.
        yearbases = zeros(71,2);
        yearbases(:,1) = [70:1:140]';
        for j = 2:69,
          if rem(j,4) == 0
            if j == 80  % 2020 is NOT a leap year!
              yearbases(j,2)=yearbases(j-1,2)+31536000;
            else
              yearbases(j,2)=yearbases(j-1,2)+31622400;
            end
          else
            yearbases(j,2)=yearbases(j-1,2)+31536000;
          end
        end
        yearbases(70,2)=2147483648;
        yearbases(71,2)=realmax;
        
        
        
        % Determine whether we are dealing with scalar, vector or matrix input.
        % Columnize vector if necessary.
        [m,n] = size(time_t);
        if m == 1
          if n > 1
            m = n;
            time_t = time_t';
          end
        else
          if n > 1
            disp('This function doesn''t operate on matrices!');
            return;
          end
        end
        
        % Determine the year and yearbase for each input value.
        yearbase = ones(m,1);
        year = ones(m,1);
        for j = 1:m
          match = find((yearbases(:,2)>time_t(j)));
          if match(1) == 71
            yearbase(j) = NaN;
            year(j) = NaN;
          else
            yearbase(j) = yearbases(match(1)-1,2);
            year(j) =  yearbases(match(1)-1,1) + 1900;
            end;
          end
          
          % Determine the day(s), hour(s), minute(s) and second(s) for each input value.
          day = ones(m,1).*fix((time_t-yearbase)/86400)+1;
          hour = ones(m,1).*fix(rem((time_t-yearbase),86400)/3600);
          minute = ones(m,1).*fix(rem(rem((time_t-yearbase), 86400),3600)/60);
          second = ones(m,1).*fix(rem(rem(rem((time_t-yearbase), 86400),3600),60));
          
          
          % Create the output string(s)...
          if do_years == 1
            time = [year'; day'; hour';  minute'; second'];
            jd = day;
            for j = 1:m
              TS(j,:) = sprintf('%4d %03d %02d:%02d:%02d', time(:,j));
              end;
            else
              time = [day'; hour';  minute'; second'];
              jd = day;
              for j = 1:m
                TS(j,:) = sprintf('%03d %02d:%02d:%02d', time(:,j));
                end;
                end;

