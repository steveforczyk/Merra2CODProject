function [monthstr] = ConvertMonthNumToStr(monthnum)
% This function will convert a number of the month to a 3 charcater string
% Written By: Stephen Forczyk
% Created: Aug 27,2022
% Revised: -----
% Classification: Unclassified

monthstr='Jan';
    if(monthnum==1)
        monthstr='Jan';
    elseif(monthnum==2)
        monthstr='Feb';
    elseif(monthnum==3)
        monthstr='Mar';
    elseif(monthnum==4)
        monthstr='Apr';
    elseif(monthnum==5)
        monthstr='May'; 
    elseif(monthnum==6)
        monthstr='Jun'; 
    elseif(monthnum==7)
        monthstr='Jul'; 
    elseif(monthnum==8)
        monthstr='Aug'; 
    elseif(monthnum==9)
        monthstr='Sep'; 
    elseif(monthnum==10)
        monthstr='Oct';
    elseif(monthnum==11)
        monthstr='Nov'; 
    elseif(monthnum==12)
        monthstr='Dec'; 
    end
end

