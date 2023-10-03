function [NewFileList] = SortMonthlyFilesInTimeOrder(FileList)
% The purpose of this function is to sort the monthly files in ascending
% time order. This routine is needed because the operating system order in
% the folder can be disprupted by small name changes. This method will read
% the file data date to get around this limitation
% 
% Written By: Stephen Forczyk
% Created: April 14,2023
% Revised:-----
% Classification: Public Domain

numFiles=length(FileList);
NewFileList=cell(numFiles,1);
DateNums=zeros(numFiles,1);
%MERRA2_400.tavgM_2d_rad_Nx.201501.nc4
% Now calculate the datetime for each file
for n=1:numFiles
    nowFile=FileList{n,1};
    [iper]=strfind(nowFile,'.');
    is=iper(2)+1;
    ie=iper(3)-1;
    dstr=nowFile(is:ie);
    yd=str2double(dstr(1:4));
    mm=str2double(dstr(5:6));
    dd=15;
    DateNums(n,1) = datenum(yd,mm,dd);
end
[SortDate,index]=sort(DateNums);
for n=1:numFiles
    nowInd=index(n,1);
    NewFileList{n,1}=FileList{nowInd,1};
end

end