function [monthnum] = ConvertMonthStrToNumber(MonthStr)
% This function will convert a month str to a number ranging from 1 thru 12
% Written By: Stephen Forczyk
% Created: Jun 18,2023
% Revised: -----
% Classification: Unclassified


a1=strcmp(MonthStr,'Jan');
a2=strcmp(MonthStr,'Feb');
a3=strcmp(MonthStr,'Mar');
a4=strcmp(MonthStr,'Apr');
a5=strcmp(MonthStr,'May');
a6=strcmp(MonthStr,'Jun');
a7=strcmp(MonthStr,'Jul');
a8=strcmp(MonthStr,'Aug');
a9=strcmp(MonthStr,'Sep');
a10=strcmp(MonthStr,'Oct');
a11=strcmp(MonthStr,'Nov');
a12=strcmp(MonthStr,'Dec');
if(a1==1)
    monthnum=1;
elseif(a2==1)
    monthnum=2;
elseif(a3==1)
    monthnum=3;
elseif(a4==1)
    monthnum=4;
elseif(a5==1)
    monthnum=5; 
elseif(a6==1)
    monthnum=6; 
elseif(a7==1)
    monthnum=7; 
elseif(a8==1)
    monthnum=8; 
elseif(a9==1)
    monthnum=9; 
elseif(a10==1)
    monthnum=10;
elseif(a11==1)
    monthnum=11; 
elseif(a12==1)
    monthnum=12;
end
end

