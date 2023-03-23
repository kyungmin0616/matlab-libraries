function [time]=mjd2greg(mjd) 

% This method will not give dates accurately on the Gregorian Proleptic Calendar,
% i.e., the calendar you get by extending the Gregorian calendar backwards to
% years earlier than 1582. using the Gregorian leap year rules. In particular,
% the method fails if Y<400.


MONTH=['Jan'; 'Feb'; 'Mar'; 'Apr'; 'May'; 'Jun'; ... 
       'Jul'; 'Aug'; 'Sep'; 'Oct'; 'Nov'; 'Dec'];


 JA=mjd+2400001;
 IGREG=2299161;
	
 if (JA>=IGREG), 
   JALPHA=fix(((JA-1867216)-0.25)/36524.25);              
            JA=JA+1+JALPHA-fix(0.25*JALPHA);                       
 end,            
      
 JB=JA+1524;                           
 JC=fix(6680.0+((JB-2439870)-122.1)/365.25);                  
 JD=365*JC+fix(0.25*JC);                                       
 JE=fix((JB-JD)/30.6001);                                        
 ID=JB-JD-fix(30.6001*JE);                                     
 MM=JE-1;                                                              
 if (MM>12),
    MM=MM-12;
 end,
       
 IYYY=JC-4715;                                                         
 if (MM>2), IYYY=IYYY-1; end;                                            
 if (IYYY<=0), IYYY=IYYY-1; end;
  
 time=[num2str(ID),'-',MONTH(MM,1:3),'-',num2str(IYYY)];
 
return
