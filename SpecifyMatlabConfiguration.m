function SpecifyMatlabConfiguration(CodeFileName)
%This function will specify the current matlab code configuration
% Written By: Stepthen Forczyk
% Created: Feb 28,2022
% Revised: May 24,2022 cahnged some variable to globals to allow
% a PDF writer routine access to thes items to store compuet environment
% data
% Classification: Unclassified
global fid;
global FileNameInventory ReqToolBoxList AvailToolBoxList FileNameTable;
global ComputerMemoryList ComputerMemoryTable;
global ReqToolBoxTable AvailToolBoxTable1 AvailToolBoxTable2 AT1 AT2 AT3;
global flist plist totalLOC;

FileNameInventory=cell(1,1);
FileNameInventory{1,1}='Item #';
FileNameInventory{1,2}='M File';
FileNameInventory{1,3}='LOC';
AvailToolBoxList=cell(1,1);
AvailToolBoxList{1,1}='Toolbox';
AvailToolBoxList{1,2}='Version';
AvailToolBoxList{1,3}='Release';
AvailToolBoxList{1,4}='Date';
ReqToolBoxList=cell(1,2);
ReqToolBoxList{1,1}='Toolbox';
ReqToolBoxList{1,2}='Version';
ComputerMemoryList=cell(3,3);
ComputerMemoryList{1,1}='Item';
ComputerMemoryList{1,2}='Value';
ComputerMemoryList{1,3}='Units';
ComputerMemoryList{2,1}='Computer Physical Memory';
ComputerMemoryList{2,3}='GB';
ComputerMemoryList{3,1}='Computer Available Memory';
ComputerMemoryList{3,3}='GB';
ComputerMemoryList{4,1}='Matlab Used Memory';
ComputerMemoryList{4,3}='GB';
ComputerMemoryList{5,1}='Max Size Java Heap';
ComputerMemoryList{5,3}='GB';
pattern='.mat';
% Now write data on the Matlab version used
matlabver=ver;
fprintf(fid,'\n');
fprintf(fid,'%s\n','------------- User Matlab Version Info ------------');
numver=length(matlabver);
fprintf(fid,'%s\n','                           Name                        Version         Release          Date');
for kk=1:numver
    matverval1=matlabver(kk).Name;
    matverval2=matlabver(kk).Version;
    matverval3=matlabver(kk).Release;
    matverval4=matlabver(kk).Date;
    AvailToolBoxList{1+kk,1}=matverval1;
    AvailToolBoxList{1+kk,2}=matverval2;
    AvailToolBoxList{1+kk,3}=matverval3;
    AvailToolBoxList{1+kk,4}=matverval4;
    fprintf(fid,'%-45s %15s  %15s  %15s\n',matverval1,matverval2,matverval3,matverval4); 
end
fprintf(fid,'%s\n','------------- End User Matlab Toolbox List --------');
if(numver<=25)
    AT1 = AvailToolBoxList(2:end,:);
    AvailToolBoxTable1 = cell2table(AT1,...
         'VariableNames',{'ToolBox' 'Version' 'Release' 'Date'});
else
    AT1 = AvailToolBoxList(2:25,:);
    AvailToolBoxTable1 = cell2table(AT1,...
         'VariableNames',{'ToolBox' 'Version' 'Release' 'Date'}); 
    AT2 = AvailToolBoxList(26:end,:);
    AvailToolBoxTable2 = cell2table(AT2,...
         'VariableNames',{'ToolBox' 'Version' 'Release' 'Date'}); 
     
end

% Get some info on the required files and the Matlab version used
[flist,plist] = matlab.codetools.requiredFilesAndProducts(CodeFileName);
flist=flist';
plist=plist';
flistlen=length(flist);
plistlen=length(plist);
% Now write data of required files
ireqfiles=0;
totalLOC=0;
hdrstr=strcat('------------- Required File List to Execute-',CodeFileName,'------------');
fprintf(fid,'%s\n',hdrstr);
fprintf(fid,'%s\n','      Number               FileName');
for kk=1:flistlen
    fstr2=char(flist{kk,1});
    lenfstr2=length(fstr2);
    fstr1=num2str(kk);
    [iper]=strfind(fstr2,'.');
    numper=length(iper);
    is=(iper(numper))+1;
    ie=lenfstr2;
    ext=fstr2(is:ie);
    fprintf(fid,'%10s\t\t %-30s\n',fstr1,fstr2);
    TF = contains(fstr2,pattern,'IgnoreCase',true);
    if(TF==0)
        ireqfiles=ireqfiles+1;
        [ filelines ] = file2cell(fstr2,0);
        nowLOC=length(filelines);
        FileNameInventory{1+ireqfiles,1}=ireqfiles;
        FileNameInventory{1+ireqfiles,2}=fstr2;
        a1=strcmp(ext,'m');
        if(a1==1)
            FileNameInventory{1+ireqfiles,3}=nowLOC;
        else
            FileNameInventory{1+ireqfiles,3}=0;
            nowLOC=0;
        end
        totalLOC=totalLOC+nowLOC;
    end
end
fprintf(fid,'%s\n','------------- End File List to Script ------------');
% Create a Table from this cell
F1 = FileNameInventory(2:end,:);
FileNameTable = cell2table(F1,...
     'VariableNames',{'File#' 'FileName' 'LOC'});
% Detail how many lines of Code needed in just the required files
hdrstr=strcat('------------- Required File Lines Of Code to Execute-',CodeFileName,'------------');
fprintf(fid,'%s\n',hdrstr);
fprintf(fid,'%s\n',' Number                      FileName                                  Lines Of Code');
for kk=1:ireqfiles
    fstr2=char(FileNameInventory{1+kk,2});
    nowLOC=FileNameInventory{1+kk,3};
%    fprintf(fid,'%3d\t\t %-50s\t  %10d\n',kk,fstr2,nowLOC);
    fprintf(fid,'%8d %-60s\t  %10d\n',kk,fstr2,nowLOC);

end
totalstr=strcat('Total LOC Required=',num2str(totalLOC));
fprintf(fid,'%s\n',totalstr);
tailstr=strcat('------------- End Required File Lines Of Code to Execute-',CodeFileName,'------------');
fprintf(fid,'%s\n',tailstr);

% Now write data of used toolboxes
fprintf(fid,'%s\n','------------- Required Toolbox List to Execute Script ------------');
fprintf(fid,'%s\n','       Name                                   Version');
for kk=1:plistlen
    pstr1=char(plist(kk).Name);
    pstr2=char(plist(kk).Version);
    ReqToolBoxList{1+kk,1}=pstr1;
    ReqToolBoxList{1+kk,2}=pstr2;
    fprintf(fid,'%-40s\t\t %-10s\n',pstr1,pstr2);
end
fprintf(fid,'%s\n','------------- End Required Toolbox List to Execute Script ------------');
% Create a Table from this cell
R1 = ReqToolBoxList(2:end,:);
ReqToolBoxTable = cell2table(R1,...
     'VariableNames',{'ToolBox' 'Version'});

fprintf(fid,'%s\n','------------- System Memory Data ------------');
[userview,systemview] = memory;
ComputerPhysicalMemGB=systemview.PhysicalMemory.Total/1E9;
ComputerAvailableMemGB=systemview.PhysicalMemory.Available/1E9;
MatlabMemoryUsedGB=userview.MemUsedMATLAB/1E9;
ComputerPhysicalMemGBstr=num2str(ComputerPhysicalMemGB,5);
ComputerAvailableMemGBstr=num2str(ComputerAvailableMemGB,5);
MatlabMemoryUsedGBstr=num2str(MatlabMemoryUsedGB,5);
maxJava = java.lang.Runtime.getRuntime.maxMemory;
JavaHeapGBstr=num2str(maxJava/1E9,5);
ComputerMemoryList{2,2}=ComputerPhysicalMemGBstr;
ComputerMemoryList{3,2}=ComputerAvailableMemGBstr;
ComputerMemoryList{4,2}=MatlabMemoryUsedGBstr;
ComputerMemoryList{5,2}=JavaHeapGBstr;
% Create a Table from this cell
C1 = ComputerMemoryList(2:end,:);
ComputerMemoryTable = cell2table(C1,...
     'VariableNames',{'Item' 'Value' 'Units'});
str1=strcat('Computer Physical Memory-GB=',ComputerPhysicalMemGBstr);
str2=strcat('Computer Available Memory-GB=',ComputerAvailableMemGBstr);
str3=strcat('Memory Used By Matlab-GB=',MatlabMemoryUsedGBstr);

fprintf(fid,'%s\n',str1);
fprintf(fid,'%s\n',str2);
fprintf(fid,'%s\n',str3);
fprintf(fid,'%s\n','------------- End System Memory Data ------------');
ab=1;
% Create Required Toolbox Table
end

