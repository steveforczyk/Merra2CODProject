% This script will rename some COD  datafiles to match a specified pattern
% Goal is to take a long downloaded filename into a format of 
% YYYYMM.nc
% Written By: Stephen Forcyk
% Created: August 21,2023
% Revised:----
% Classification: Unclassified Public domain
global FileNames FileNames2;
global sourcepath destpath;

sourcepath='H:\COD_Data2\';
destpath='K:\Merra-2\Joydeb\COD_Data3\';
FileNames=cell(1,1);
FileNames2=cell(1,1);
% Get a list of files to rename in the source folder
eval(['cd ' sourcepath(1:length(sourcepath)-1)]);
dirlis=dir;
lengthdirlis=length(dirlis);
numFiles=lengthdirlis-2;

ab=1;
ifile=0;
for n=3:lengthdirlis
    ifile=ifile+1;
    nowFile=strcat(sourcepath,dirlis(n).name);
    FileNames{ifile,1}=nowFile;
    [iper]=strfind(nowFile,'.');
    iper=iper';
    numper=length(iper);
    is=iper(2)+1;
    ie=iper(3)-1;
    prefix=nowFile(is:ie);
    shortName=strcat(prefix,'.nc4');
    newName=strcat(destpath,prefix,'.nc4');
    FileNames2{ifile,1}=newName;
    sourcefile=nowFile;
    destfile=newName;
    [status,msg,msgID]=movefile(sourcefile,destfile);
    ab=3;
    dispstr=strcat('Creating file-',shortName,'-in folder-',destpath);
    disp(dispstr)
end
ab=2;