function [datapathstr] = CreateDataPathStr(inputpath)
% The purpose of this function is to get a string of the inputdata path
% to create am datapathstr that can be used to add pr remove paths from the
% pathdef function
% Written By: Stephen Forczyk
% Created: Aug 26,2023
% Revised: ------
% Classification: Unclassified/Public Domain
workingpath=inputpath;
datapathstr=workingpath;
[ibkslash]=strfind(workingpath,'\');
numbackslash=length(ibkslash);
for n=1:numbackslash-1
    is=ibkslash(n);
    ie=is;
    datapathstr(is:ie)='/';

end
is=ibkslash(numbackslash);
ie=is;
datapathstr(is:ie)=[];
end