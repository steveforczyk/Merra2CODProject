% This executive script is a single purpose designed to read Merra2 COD
% Data that was complied in monthly increments
% Created: Aug 19,2022
% Written By: Stephen Forczyk
% Revised: Aug 22,2023
% Revised: Aug 26,2023 made numerous changes to clean up the code and
% add capability to modify the pathdef list based on user selections
% Revised: Aug 28,2023 added a set of print statements concerning system
% flags
% Revised: Sep 6,2023 Recent Windows Update changed security settings for
% macros-until this issue can be adequately dealt with a macro used to
% format output data has been commented out. It is still possible for the
% user to create the Excel File first and import the macro file and run it
% manually. The issue has to do with trusted locations.
% Classification: Unclassified/Public Domain
%% Set Up Globals
global LatSpacing LonSpacing RasterAreas;
global RasterLats RasterLons COThighlimit;
global minTauValue framecounter nowFileList;
global ExcelExportFile CODReport TabName iExcelFile CODHeaders;
global MaskList;
global Merra2FileName Merra2FileNames ;
global TAUHGHSum1 TAUHGHSum2 TAUHGHSum3 TAUHGHSum4 TAUHGHSum5;
global TAUHGHTable TAUHGHTT;

global Merra2DataPaths Merra2Path MerraDataCollectionTimes;

global idebug isavefiles;
global NumProcFiles ProcFileList iPrintTimingInfo iSkipReportFrames;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter tocc lof lot;
global JpegCounter JpegFileList;
global ImageProcessPresent ;
global iReport ;
global iCheckConfig isaveJpeg maxnumpatches;
global MovieFlags iPrintAll cscale iRunExcelMacro;
global MonthDayStr MonthDayYearStr YearMonthStr YearMonthStrStart YearMonthStrEnd;
global YearStart YearEnd MonthStart MonthEnd;
global WorldCityFileName World200TopCities;
global iCityPlot maxCities;
global PressureFileName;
global SelectedFiles numSelectedFiles path1;
global iLogo LogoFileName1 LogoFileName2 TextFileName;
global yd md dd;

global fid;
global widd2 lend2;
global initialtimestr igrid ;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2;
global idirector mov izoom iwindow;
global vTemp TempMovieName iMovie iFast;


global matpath datapath maskpath savepath;
global jpegpath tiffpath moviepath ;
global excelpath citypath tablepath;
global ipowerpoint PowerPointFile scaling stretching padding;
global ichartnum;
global ColorList RGBVals ColorList2 xkcdVals LandColors;
global orange bubblegum brown brightblue;
% additional paths needed for mapping and other purposes
global matpath1 mappath matlabpath ;
global logpath pdfpath govjpegpath;
global datapathstr logpathstr jpegpathstr pdfpathstr;
global excelpathstr savepathstr moviepathstr matlabpathstr;
global mappathstr govjpegpathstr maskpathstr citypathstr

global mappath ;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;
global yd md dd;
global pwd;
clc;
%% Set Up Fixed Paths
% Set up some fixed paths for the data. Set the present working directory
% to where the this code is located
pret=which('ProcessCODData.m');
[islash]=strfind(pret,'\');
numslash=length(islash);
is=1;
ie=islash(2);
pwd=pret(is:ie);
datapath='K:\Merra-2\Joydeb\COD_Data3\';
[datapathstr] = CreateDataPathStr(datapath);
logpath='K:\Merra-2\Joydeb\Log_Files\';
[logpathstr] = CreateDataPathStr(logpath);
jpegpath='K:\Merra-2\Joydeb\Jpeg_Files\';
[jpegpathstr] = CreateDataPathStr(jpegpath);
pdfpath='K:\Merra-2\Joydeb\PDF_Files\';
[pdfpathstr] = CreateDataPathStr(pdfpath);
excelpath='K:\Merra-2\Joydeb\Excel_Files\';
[excelpathstr] = CreateDataPathStr(excelpath);
savepath='K:\Merra-2\Joydeb\Saved_Files\';
[savepathstr] = CreateDataPathStr(savepath);
moviepath='K:\Merra-2\Joydeb\Movies\';
[moviepathstr] = CreateDataPathStr(moviepath);
matlabpath='K:\Merra-2\Joydeb\Matlab_Data\';
[matlabpathstr] = CreateDataPathStr(matlabpath);
mappath='K:\Merra-2\Joydeb\Map_Data\Matlab_Maps\';
[mappathstr] = CreateDataPathStr(mappath);
govjpegpath='K:\Merra-2\Joydeb\gov_jpeg\';
[govjpegpathstr] = CreateDataPathStr(govjpegpath);
maskpath='K:\Merra-2\Joydeb\Masks\';
[maskpathstr] = CreateDataPathStr(maskpath);
citypath='K:\Merra-2\Joydeb\Map_Data\World_Cities\';
[citypathstr] = CreateDataPathStr(citypath);
WorldCityFileName='WorldTopCitiesList.mat';
CalendarFileName='CalendarDays.mat';
PressureFileName='Merra2PressureData.mat';
maskpath='K:\Merra-2\Masks';
ExcelExportFile='TauHighData1980-2000.xlsm';
TabName='data-1980-2000';
%% Add paths to pathdef-this is actually just a safety feature-not really
% needed
addpath(datapathstr); 
addpath(logpathstr); 
addpath(jpegpathstr);
addpath(pdfpathstr);
addpath(excelpathstr);
addpath(pdfpathstr);
addpath(savepathstr);
addpath(moviepathstr);
addpath(matlabpathstr);
addpath(mappathstr);
addpath(govjpegpath);
addpath(maskpathstr);
addpath(citypathstr);

%% Set Flags ,default values and System Adjustable Parameters (SAP)
% Set some flags to control program execution
iCreatePDFReport=0;         % This will create a PDF report-do not use not activated
iSkipReportFrames=3;        % This will reduce size of PDF-do not use not activated
iPrintAll=0;                % This printsome debug data from ReadCODDataset.m - leave at zero
JpegCounter=0;              % This counts jpegs created-not needed
isavefiles=0;               % Flag will save selected data in a matlab file for each frame-leave at 0
idebug=0;                   % Debug decoder in ReadCODDataset.m - leave at zero
isaveJpeg=2;                % Set to 0 to not save jpegs (not recommended),1=print to save (slow)
                            % value set to 2 will use screen grab which is faster
maxnumpatches=600;          % This is the max number of patches that will be displayed in Polar Data plot
                            % full data is retained in memory but drawing patches
                            % in DisplayMerra2PolarTAUHGHRev1.m can be time
                            % consuming
iPrintTimingInfo=0;         % Gets timing info for development purposes leave at 0
iMovie=0;                   % 0= will not create a movie,1= will create a single movie
iFast=1;                    % 0=Fast mode not used,1=Fast mode reduces num of polygons drawn in polar plot
iCityPlot=1;                %0 =Do not draw cities in polar plot,1 will draw-deactivated in this script
maxCities=30;               % Max number of cities to be plotted if iCityPlot=1
minTauValue=3;              % Not used at present
COThighlimit=3;             % Not used at present
framecounter=0;             % Counter for the frame being processed
iCheckConfig=1;             % Activates routine to print computer config in log file
iLogo=1;                    % Add logo to charts to acknowledge source of data
iExcelFile=1;               % Create an Excel file with selected run results
iRunExcelMacro=1;           % Run an Excel Macro to Format the data sheet (0=No,1=Yes);
LogoFileName1='Merra2-LogoB.jpg';% Name of fie that contains desired Logo
%% Set up some initial data-Generally not used for this script
NumProcFiles=0;
ProcFileList=cell(1,4);
ProcFileList{1,1}='File Name';
ProcFileList{1,2}='Saved Directory';
ProcFileList{1,3}='Creation Time';
ProcFileList{1,4}='Save Method';
%% Set Up Log File
% Start writing a log file and Also look at the current stored image paths
% file
eval(['cd ' logpath(1:length(logpath)-1)]);
startruntime=deblank(datestr(now));
startrunstr=strcat('Start Run Merra2 Run at-',startruntime);
logfilename=startruntime;
logfiledbl=double(logfilename);
% find the blank space in the date and replace it with a '-' to make a
% legalfilename
[iblank]=find(logfiledbl==32);
numblank=length(iblank);
for n=1:numblank
    is=iblank(n);
    ie=is;
    logfilename(is:ie)='-';
end
[icolon]=strfind(logfilename,':');
numcolon=length(icolon);
for n=1:numcolon
    is=icolon(n);
    ie=is;
    logfilename(is:ie)='-';
end
datetimestr=logfilename;
eval(['cd ' logpath(1:length(logpath)-1)]);
logfilename=strcat(logfilename,'.txt');
pdffilename=strcat('Merra2-',datetimestr);
%% Read Some needed data files related to calendar data and selected shape file names as well as pressure levels
% The load world cities option was commented out because the generate maps
% are optimized for the North Pole regions-few cities there
% Set up some colors that will be used in later plots
SetUpExtraColors()
% Load in the List of World Cities
% eval(['cd ' citypath(1:length(citypath)-1)]);
% load(WorldCityFileName);
%% Call some routines that will create nice plot window sizes and locations
% Establish selected run parameters
imachine=2;
if(imachine==1)
    widd=720;
    lend=580;
    widd2=1000;
    lend2=700;
elseif(imachine==2)
    widd=1080;
    lend=812;
    widd2=1000;
    lend2=700;
elseif(imachine==3)
    widd=1296;
    lend=974;
    widd2=1200;
    lend2=840;
end
% Set a specific color order
set(0,'DefaultAxesColorOrder',[1 0 0;
    1 1 0;0 1 0;0 0 1;0.75 0.50 0.25;
    0.5 0.75 0.25; 0.25 1 0.25;0 .50 .75]);
% Set up some defaults for a PowerPoint presentationwhos
scaling='true';
stretching='false';
padding=[75 75 75 75];
igrid=1;
% Set up parameters for graphs that will center them on the screen
[hor1,vert1,Fz1,Fz2,machine]=SetScreenCoordinates(widd,lend);
[hor2,vert2,Fz1,Fz2,machine]=SetScreenCoordinates(widd2,lend2);
chart_time=5;
idirector=1;
initialtimestr=datestr(now);
igo=1;
NumProcFiles=0;
%% Set Up Log File-text based file to store critical data about run for analysis purposes
% Start writing a log file and Also look at the current stored image paths
% file
startruntime=deblank(datestr(now));
startrunstr=strcat('Start ReadMerra2 COD Processing Run at-',startruntime);
logfilename=startruntime;
logfiledbl=double(logfilename);
% find the blank space in the date and replace it with a '-' to make a
% legalfilename
[iblank]=find(logfiledbl==32);
numblank=length(iblank);
for n=1:numblank
    is=iblank(n);
    ie=is;
    logfilename(is:ie)='-';
end
[icolon]=strfind(logfilename,':');
numcolon=length(icolon);
for n=1:numcolon
    is=icolon(n);
    ie=is;
    logfilename(is:ie)='-';
end
datetimestr=logfilename;
toolbox='MATLAB Report Generator';
[RptGenPresent] = ToolboxChecker(toolbox);
toolbox='Image Processing Toolbox';
[ImageProcessPresent]=ToolboxChecker(toolbox);
%% This is the main executive loop of the routine
logfilename=strcat('Merra2CODProcessingLog File-',logfilename,'.txt');
pdffilename=strcat('Merra2-',datetimestr);
eval(['cd ' logpath(1:length(logpath)-1)]);
fid=fopen(logfilename,'w');
dispstr=strcat('Opened Log file-',logfilename,'-for writing');
disp(dispstr);
fprintf(fid,'%50s\n',startrunstr);
%% Start a PDF report if requested by user and user has the Matlab Report-Not active at this time
% Generator Package Installed
    if((iCreatePDFReport==1) && (RptGenPresent==1))
        import mlreportgen.dom.*;
        import mlreportgen.report.*;
        import mlreportgen.utils.*
        CreateMerra2ReportHeaderRev1;
    else

    end
%% Get the Run Configuration Data
if(iCheckConfig==1)
    SpecifyMatlabConfiguration('ProcessCODData.m');
end
%% Print Flags to Logfile
fprintf(fid,'%s\n','--------------------------List of Program Flags -----------------');
liststr='----Flag ID-----------Flag Value--------------------------Use--------------------------';
fprintf(fid,'%s\n',liststr);
flag1astr='iCreatePFReport';
flag1bstr='Create PDF Formatted Report 0=No,1=Yes-used only if user has Report Generator Toolbox ';
fprintf(fid,'%-20s     %1d     %-s\n',flag1astr,iCreatePDFReport,flag1bstr);
flag2astr='iSkipReportFrames';
flag2bstr='# Frames To Skip in PDF Report 0=NoSkip,>0=#Frames to Skip-not active if PDF report is not being created';
fprintf(fid,'%-20s     %1d     %-s\n',flag2astr,iSkipReportFrames,flag2bstr);
flag3astr='iPrintAll';
flag3bstr=' 0=NoPrint,1=Print All variables being decoded in ReadCODataSet';
fprintf(fid,'%-20s     %1d     %-s\n',flag3astr,iPrintAll,flag3bstr);
flag4astr='JpegCounter';
flag4bstr=' Counter that keeps track of how many Jpeg files were created';
fprintf(fid,'%-20s     %1d     %-s\n',flag4astr,JpegCounter,flag4bstr);
flag5astr='isavefiles';
flag5bstr='0=do not save,1=save decoded dataset for each frame';
fprintf(fid,'%-20s     %1d     %-s\n',flag5astr,isavefiles,flag5bstr);
flag6astr='idebug';
flag6bstr='0=do not print debg info,1=print debug info in decoder routine';
fprintf(fid,'%-20s     %1d     %-s\n',flag6astr,idebug,flag6bstr);
flag7astr='isaveJpeg';
flag7bstr='0=do not save jpeg files,1=save jpeg files,2=save as screengrab';
fprintf(fid,'%-20s     %1d     %-s\n',flag7astr,isaveJpeg,flag7bstr);
flag8astr='iPrintTimingInfo';
flag8bstr='0=do not print timing info,1=print timing info';
fprintf(fid,'%-20s     %1d     %-s\n',flag8astr,iPrintTimingInfo,flag8bstr);
flag9astr='iMovie';
flag9bstr='0=do not create COD Movie,1=Create COD Movie';
fprintf(fid,'%-20s     %1d     %-s\n',flag9astr,iMovie,flag9bstr);
flag10astr='iFast';
flag10bstr='0=plot all high TauHGH Values,1=Plot Only the highest TAUHGH Values';
fprintf(fid,'%-20s     %1d     %-s\n',flag10astr,iFast,flag10bstr);
flag11astr='iCityPlot';
flag11bstr='0=do not add cities to plot,1=Add large cities to plot';
fprintf(fid,'%-20s     %1d     %-s\n',flag11astr,iCityPlot,flag11bstr);
flag12astr='iCheckConfig';
flag12bstr='0=do not HW/SW config info to log file,1=Config data to logfile';
fprintf(fid,'%-20s     %1d     %-s\n',flag12astr,iCheckConfig,flag12bstr);
flag13astr='iLogo';
flag13bstr='0=do not Merra2 logo to plots,1=add logo to plots';
fprintf(fid,'%-20s     %1d     %-s\n',flag13astr,iLogo,flag13bstr);
flag14astr='iExcelFile';
flag14bstr='0=do not create an Excel File,1=Create Excel File for results';
fprintf(fid,'%-20s     %1d     %-s\n',flag14astr,iExcelFile,flag14bstr);
flag15astr='iRunExcelMacro';
flag15bstr='0=do not run macro,1=run macro to format sheet';
fprintf(fid,'%-20s     %1d     %-s\n',flag15astr,iRunExcelMacro,flag15bstr);
fprintf(fid,'%s\n','-----------------------------End List Of Program Flags------------------');
%% Choose the datafiles to process-must pick AT Least 2 files
% Go to the expected path
eval(['cd ' datapath(1:length(datapath)-1)]);
[Merra2FileNames,nowpath] = uigetfile({'*.nc4';'*.nc'},'Select Multiple Files', ...
'MultiSelect', 'on');
Merra2FileNames=Merra2FileNames';
numSelectedFiles=length(Merra2FileNames);
fprintf(fid,'\n');
fprintf(fid,'%s\n','----- List of Files to Be processed-----');
for nn=1:numSelectedFiles
    nowFile=Merra2FileNames{nn,1};
    filestr='File Num';
    fprintf(fid,'%s\n',nowFile);
end
fprintf(fid,'%s\n','----- End List of Files to Be processed-----');
testFile=Merra2FileNames{1,1};
testFileEnd=Merra2FileNames{numSelectedFiles,1};
% Get the dates of the first and last files to be processed
YearMonthStr=strcat(testFile(1:4),'-',testFile(5:6));
YearMonthStrStart=YearMonthStr;
YearMonthStrEnd=strcat(testFileEnd(1:4),'-',testFileEnd(5:6));
yd=str2double(YearMonthStr(1:4));
md=str2double(YearMonthStr(6:7));
dd=15;
stime=datetime(yd,md,dd);
timestep = calmonths(1);
cscale=colormap('jet');
close('all')
%% Set up names for a Movie file and an Excel File
YearMonthStr=testFile(1:6);
YearMonthStrStart=YearMonthStr;
YearMonthStrEnd=testFileEnd(1:6);
YearStart=testFile(1:4);
YearEnd=testFileEnd(1:4);
monthstartstr=YearMonthStrStart(5:6);
monthendstr=YearMonthStrEnd(5:6);
monthnums=str2double(monthstartstr);
monthnume=str2double(monthendstr);
[MonthStart] = ConvertMonthNumToStr(monthnums);
[MonthEnd] = ConvertMonthNumToStr(monthnume);
TempMovieName=strcat('TauHigh-',MonthStart,'-',YearStart,'-',MonthEnd,'-',YearEnd,'.mp4');% Movie File Name
ExcelExportFile=strcat('TauHighData-',MonthStart,'-',YearStart,'-',MonthEnd,'-',YearEnd,'.xlsm');
TabName=strcat('data-',YearStart,'-',YearEnd);
TabName='Sheet1';
TextFileName=strcat('TauHighData-',MonthStart,'-',YearStart,'-',MonthEnd,'-',YearEnd,'.txt');
%% Set up a movie file if requested
framecounter=0;
igo=1;
if(iMovie>0)
    eval(['cd ' moviepath(1:length(moviepath)-1)]);
    vTemp = VideoWriter(TempMovieName,'MPEG-4');
    vTemp.Quality=100;
    vTemp.FrameRate=3;
    open(vTemp);         
end
%% Loop through the selected files for processing
for n=1:numSelectedFiles
    framecounter=framecounter+1;
    nowFile=Merra2FileNames{n,1};
    YearMonthStr=strcat(nowFile(1:4),'-',nowFile(5:6));  
    ReadCODDataset(nowFile,nowpath)% Decode the original data file
    dispstr=strcat('Finished Decoding File-',nowFile,'-which is file-',num2str(n),...
        '-of-',num2str(numSelectedFiles),'-Files');
    disp(dispstr)
    itype=7;
    iAddToReport=0;
    iNewChapter=0;
    iCloseChapter=0;
    lowlim=1;
    titlestr=strcat('TauHgh-Polar-Plot-For-Frame-',num2str(framecounter));
% Plot the TAUHGH value of a map of the North Pole
    DisplayMerra2PolarTAUHGHRev1(nowFile,titlestr,itype,lowlim,iAddToReport,iNewChapter,iCloseChapter)
    dispstr=strcat('Finished Plotting File-',nowFile,'-which is file-',num2str(n),...
        '-of-',num2str(numSelectedFiles),'-Files');
    disp(dispstr)
end
% Close the movie file now if one was opened
if((iMovie>0))
    close(vTemp);
end
%% Now create a table to the TAUHGH results-this will be saved to a mat file and plotted later 
% in a timeseries plot
  TAUHGHTable=table(TAUHGHSum1(:,1),TAUHGHSum2(:,1),TAUHGHSum3(:,1),TAUHGHSum4(:,1),...
       TAUHGHSum5(:,1),...
            'VariableNames',{'TAUHGHSum1','TAUHGHSum2','TAUHGHSum3',...
            'TAUHGHSum4','TAUHGHSum5'});
  TAUHGHTT = table2timetable(TAUHGHTable,'TimeStep',timestep,'StartTime',stime);
  eval(['cd ' savepath(1:length(savepath)-1)]);
  actionstr='save';
  varstr1='TAUHGHTable TAUHGHTT YearMonthStr ';
  MatFileName=strcat('TAUHGHTable',YearMonthStr,'.mat');
  qualstr='-v7.3';
  [cmdString]=MyStrcatV73(actionstr,MatFileName,varstr1,qualstr);
  eval(cmdString)
  taustr=strcat('Created TAUGHTTable-','Contains TAUHGH Exceedances');
  fprintf(fid,'%s\n',taustr);
igo=0;

%% Plot Selected TimeTables
titlestr='TauHighData-1980';
ikind=1;
iAddToReport=0;
iNewChapter=0;
iCloseChapter=0;
PlotTauHighTable(titlestr,ikind,iAddToReport,iNewChapter,iCloseChapter)
% Print this table to the command window
TAUHGHTT
%% Create an Excel Version of the Data if the option was selected
eval(['cd ' excelpath(1:length(excelpath)-1)])
CODHeaders=cell(1,6);
CODHeaders{1,1}='FileName';
CODHeaders{1,2}='TauHGH>1-area-km^2';
CODHeaders{1,3}='TauHGH>2-area-km^2';
CODHeaders{1,4}='TauHGH>3-area-km^2';
CODHeaders{1,5}='TauHGH>4-area-km^2';
CODHeaders{1,6}='TauHGH>5-area-km^2';
%copyfile TauHGHTemplate.xlsm 

if(iExcelFile==1)
    [status1,msg1]=xlswrite(ExcelExportFile,CODHeaders,TabName,'a1');
end
for k=1:numSelectedFiles
    CODReport{k,1}=nowFileList{k,1};
    CODReport{k,2}=TAUHGHSum1(k,1);
    CODReport{k,3}=TAUHGHSum2(k,1);
    CODReport{k,4}=TAUHGHSum3(k,1);
    CODReport{k,5}=TAUHGHSum4(k,1);
    CODReport{k,6}=TAUHGHSum5(k,1);
end
if(iExcelFile==1)
    [status2,msg2]=xlswrite(ExcelExportFile,CODReport,TabName,'a2');
end
% save this data
eval(['cd ' savepath(1:length(savepath)-1)]);
actionstr='save';
varstr1='CODReport ExcelExportFile';
MatFileName=strcat('CODData',YearMonthStr,'.mat');
qualstr='-v7.3';
[cmdString]=MyStrcatV73(actionstr,MatFileName,varstr1,qualstr);
eval(cmdString)
%% Format the Excel Export File- Option is commented out because of security issues
% User can import macro file Merra2Formatter.bas which is in the Excel
% folder to manually format the output using the macro.
% if(iRunExcelMacro>0)
%     eval(['cd ' excelpath(1:length(excelpath)-1)])
%     % copy the template file to the named Export file
%     [status,message,messageId] = copyfile('TauHGHTemplate.xlsm',ExcelExportFile);
%     % Create object.
%     ExcelApp = actxserver('Excel.Application');
%     %Show window (optional).
%     ExcelApp.Visible = 1;
%     % Open file located in the current folder.
%     fullName=fullfile(excelpath,ExcelExportFile);
%     ExcelApp.Workbooks.Open(fullName);
%     % Run Macro1, defined in "ThisWorkBook" with one parameter. A return value cannot be retrieved.
%     ExcelApp.Run('Format_TAUHGH_Report');
%     %ExcelApp.Workbook.SaveAs ExcelExportFile;
%     % Quit application and release object.
%     ExcelApp.Quit;
%     ExcelApp.release;  
% end
%% Write the timetable to a comma delimited text file-this might be useful

eval(['cd ' logpath(1:length(logpath)-1)]);
writetimetable(TAUHGHTT,TextFileName);
%% Run closeout activities
endruntime=deblank(datestr(now));
endrunstr=strcat('Finished Merra 2 TAUHGH Run at-',endruntime);
fprintf(fid,'%s\n',endrunstr);
fclose(fid);
% Close a PDF report if one is created
a1=exist('rpt','var');
% profile off
% profile viewer
if((iCreatePDFReport==1) && (RptGenPresent==1))
    close(rpt);
    rptview(rpt)
    dispstr=strcat('Closed PDF Report-',pdffilename);
    disp(dispstr)
else
    disp('No pdf report generated by this run');
end
eval(['cd ' excelpath(1:length(excelpath)-1)])
winopen(ExcelExportFile);
