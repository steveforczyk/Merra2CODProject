% This script will test the Excel Formatted file operation 
% Written By: Stephen Forczyk
% Created On: Aug 31,2023
% Revised: ------
% Classification: Unclassified/Public Domain
global excelpath templateFileName ExcelExportFile ExcelExportFile2 ResultsFile;
global backuptemplateFileName;
global savepath backuppath;
savepath='K:\Merra-2\Joydeb\Saved_Files\';
excelpath='K:\Merra-2\Joydeb\Excel_Files\';
templateFileName='K:\Merra-2\Joydeb\Excel_Files\TauHGHTemplate.xlsm';
backuptemplateFileName='K:\Merra2\Joydeb\TauHGHTemplate.xlsm';
backuppath='K:\Merra2\Joydeb';
ExcelExportFile='TauHighData-Jan-1987-Dec-1987.xlsm';
ExcelExportFile2=ExcelExportFile;
ResultsFile='CODData1987-12.mat';
eval(['cd ' excelpath(1:length(excelpath)-1)])
% copy the template file to the named Export file
[status,message,messageId] = copyfile('TauHGHTemplate.xlsm',ExcelExportFile);

ab=1;
% Load in the COD data
eval(['cd ' savepath(1:length(savepath)-1)])
load(ResultsFile);
%% Create an Excel Version of the Data if the option was selected
eval(['cd ' excelpath(1:length(excelpath)-1)])
CODHeaders=cell(1,6);
CODHeaders{1,1}='FileName';
CODHeaders{1,2}='TauHGH>1-area-km^2';
CODHeaders{1,3}='TauHGH>2-area-km^2';
CODHeaders{1,4}='TauHGH>3-area-km^2';
CODHeaders{1,5}='TauHGH>4-area-km^2';
CODHeaders{1,6}='TauHGH>5-area-km^2';
TabName='Sheet1';
iExcelFile=1;
if(iExcelFile==1)
    [status1,msg1]=xlswrite(ExcelExportFile,CODHeaders,TabName,'a1');
end
% for k=1:numSelectedFiles
%     CODReport{k,1}=nowFileList{k,1};
%     CODReport{k,2}=TAUHGHSum1(k,1);
%     CODReport{k,3}=TAUHGHSum2(k,1);
%     CODReport{k,4}=TAUHGHSum3(k,1);
%     CODReport{k,5}=TAUHGHSum4(k,1);
%     CODReport{k,6}=TAUHGHSum5(k,1);
% end
if(iExcelFile==1)
    [status2,msg2]=xlswrite(ExcelExportFile,CODReport,TabName,'a2');
end
% Create object.
ExcelApp = actxserver('Excel.Application');
% Show window (optional).
ExcelApp.Visible = 1;
% Open file located in the current folder.
fullName=fullfile(excelpath,ExcelExportFile);
ExcelApp.Workbooks.Open(fullName);
% Run Macro1, defined in "ThisWorkBook" with one parameter. A return value cannot be retrieved.
ExcelApp.Run('Format_TAUHGH_Report');
%ExcelApp.Workbook.SaveAs ExcelExportFile;

% Quit application and release object.
ExcelApp.Quit;
ExcelApp.release;    