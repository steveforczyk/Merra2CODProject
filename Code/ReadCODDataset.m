function ReadCODDataset(nowFile,nowpath)
% Modified: This function will read in the the Merra-2 COT dataset
% this is a special purpose dataset created by Joydeb that just has the 
% months TAUHGH dataset as well as the lat lon data
% Written By: Stephen Forczyk
% Created: Aug 19,2023
% Revised: ------
% Classification: Unclassified


global Merra2FileName Merra2ShortFileName Merra2Dat;
global RasterLats RasterLons Rpix RasterAreaGrid;
global idebug framecounter numSelectedFiles;
global LonS LatS TAUHGHS TAUHGHVals TimeS Longitudes Latitudes;
global YearMonthDayStr1 YearMonthDayStr2 YearMonthStr;
global minLat maxLat minLon maxLon numlats numlons;
global RasterAreas RadiusCalc LatSpacing LonSpacing;
global nc nr nowFileList;
global TAUHGHSum1 TAUHGHSum2 TAUHGHSum3 TAUHGHSum4 TAUHGHSum5;
global ExcelExportFile CODReport TabName iExcelFile;
% additional paths needed for mapping
global matpath1 mappath ;
global jpegpath savepath excelpath;

global fid isavefiles iPrintAll ;

%% Initial selected arrays
if(framecounter==1)
    TAUHGHSum1=zeros(numSelectedFiles,1);
    TAUHGHSum2=zeros(numSelectedFiles,1);
    TAUHGHSum3=zeros(numSelectedFiles,1);
    TAUHGHSum4=zeros(numSelectedFiles,1);
    TAUHGHSum5=zeros(numSelectedFiles,1);
    nowFileList=cell(numSelectedFiles,1);
end
%% Star Decoding the data the data note that the dataset being read is a shortened version of the typical file
% in order the save space only the TAUHGH and a few other variables are
% decoded. This fiile was created primarily by shortening up the full scale
% decoder routine which is ReadDataset02.m
nc_filenamesuf=nowFile;
path=nowpath;
Merra2FileName=RemoveUnderScores(nc_filenamesuf);
nc_filename=strcat(path,nc_filenamesuf);
ncid=netcdf.open(nc_filename,'nowrite');% Open the file
openfilestr=strcat('Opening file-',Merra2FileName,'-for reading');
[iper]=strfind(Merra2FileName,'.');
numper=length(iper);
is=1;
ie=iper(numper)-1;
Merra2ShortFileName=Merra2FileName(is:ie);
LonS=struct('values',[],'origname',[],'units',[],'vmax',[],'vmin',[],...
    'fullnamepath',[],'standard_name',[]);
LatS=LonS;
TimeS=struct('values',[],'long_name',[],'units',[],'time_increment',[],...
    'begin_date',[],'begin_time',[],'vmax',[],'vmin',[],'valid_range',[]);
% The TimeS variable is not used as the data was taken at monthly intervals

TAUHGHS=struct('values',[],'fullnamepath',[],'missing_value',[],'origname',[],...
    'vmax',[],'vmin',[],'standard_name',[],'quantity_type',[],'product_short_name',[],...
    'product_version',[],'long_name',[],'coordinates',[],'units',[],'cell_methods',[],...
    'latitude_resolution',[],'longitude_resolution',[]);
% Get information about the contents of the file.
[~, numvars, ~, ~] = netcdf.inq(ncid);
numvarstr=strcat('The number of variables read from the Cloud Top Data file=',num2str(numvars));
idebug=0;    
if(idebug==1)
    disp(' '),disp(' '),disp(' ')
    disp('________________________________________________________')
    disp('^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~')
    disp(['VARIABLES CONTAINED IN THE netCDF FILE: ' nc_filename ])
    dispstr=strcat('VARIABLES CONTAINED IN THE netCDF FILE:',GOESFileName);
    disp(' ')
    fprintf(fid,'%s\n','________________________________________________________');
    fprintf(fid,'%s\n','^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~');
    fprintf(fid,'%s\n',dispstr);
    variablestr=strcat('Number of variables in file=',num2str(numvars));
    disp(variablestr);
    fprintf(fid,'%s\n',variablestr);
    fprintf(fid,'\n');
end
if(iPrintAll==1)
    for jj=0:numvars-1
        [varname, ~, ~, numatts] = netcdf.inqVar(ncid,jj);
        dispstr=strcat(num2str(jj),'-','varname=',num2str(varname),'-numatts=',num2str(numatts));
        disp(dispstr)
        for kk=0:numatts-1
            attname1 = netcdf.inqAttName(ncid,jj,kk);
            attname2 = netcdf.getAtt(ncid,jj,attname1);
            dispstr=strcat(attname1,'-',attname2);
            disp(dispstr)
        end
    end
end
for i = 0:numvars-1
    [varname, ~, ~, numatts] = netcdf.inqVar(ncid,i);
    if(idebug==1)
        disp(['--------------------< ' varname ' >---------------------'])
        dispstr=strcat('--------------',varname,'--------------');
        fprintf(fid,'\n');
        fprintf(fid,'%s\n',dispstr);
    end
    flag = 0;
    for j = 0:numatts - 1
        a10=-1;
        a340=strcmp(varname,'M2TMNXRAD_5_12_4_TAUHGH');
        a350=strcmp(varname,'TAUHGH');
        a520=strcmp(varname,'lat');
        a530=strcmp(varname,'lon');
       if (a10==1)

        elseif (a340==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'origname');
            if(a1==1)
                TAUHGHS.origname=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                TAUHGHS.standard_name=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                TAUHGHS.long_name=attname2;
            end
            a1=strcmp(attname1,'fullnamepath');
            if(a1==1)
                TAUHGHS.fullnamepath=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                TAUHGHS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                TAUHGHS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                TAUHGHS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                TAUHGHS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                TAUHGHS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                TAUHGHS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                TAUHGHS.valid_range=attname2;
            end 
            a1=strcmp(attname1,'quantity_type');
            if(a1==1)
                TAUHGHS.quantity_type=attname2;
            end 
            a1=strcmp(attname1,'product_short_name');
            if(a1==1)
                TAUHGHS.product_short_name=attname2;
            end 
            a1=strcmp(attname1,'product_version');
            if(a1==1)
                TAUHGHS.product_version=attname2;
            end 
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                TAUHGHS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                TAUHGHS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'latitude_resolution');
            if(a1==1)
                TAUHGHS.latitude_resolution=attname2;
            end
            a1=strcmp(attname1,'longitude_resolution');
            if(a1==1)
                TAUHGHS.longitude_resolution=attname2;
            end
        elseif (a350==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'origname');
            if(a1==1)
                TAUHGHS.origname=attname2;
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                TAUHGHS.standard_name=attname2;
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                TAUHGHS.long_name=attname2;
            end
            a1=strcmp(attname1,'fullnamepath');
            if(a1==1)
                TAUHGHS.fullnamepath=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                TAUHGHS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                TAUHGHS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                TAUHGHS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                TAUHGHS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                TAUHGHS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                TAUHGHS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                TAUHGHS.valid_range=attname2;
            end 
            a1=strcmp(attname1,'quantity_type');
            if(a1==1)
                TAUHGHS.quantity_type=attname2;
            end 
            a1=strcmp(attname1,'product_short_name');
            if(a1==1)
                TAUHGHS.product_short_name=attname2;
            end 
            a1=strcmp(attname1,'product_version');
            if(a1==1)
                TAUHGHS.product_version=attname2;
            end 
            a1=strcmp(attname1,'coordinates');
            if(a1==1)
                TAUHGHS.coordinates=attname2;
            end
            a1=strcmp(attname1,'cell_methods');
            if(a1==1)
                TAUHGHS.cell_methods=attname2;
            end
            a1=strcmp(attname1,'latitude_resolution');
            if(a1==1)
                TAUHGHS.latitude_resolution=attname2;
            end
            a1=strcmp(attname1,'longitude_resolution');
            if(a1==1)
                TAUHGHS.longitude_resolution=attname2;
            end

        elseif (a520==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LatS.standard_name=attname2;
            end
            a1=strcmp(attname1,'origname');
            if(a1==1)
                LatS.origname=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LatS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LatS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                LatS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                LatS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                LatS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                LatS.vmin=attname2;
            end
            a1=strcmp(attname1,'fullnamepath');
            if(a1==1)
                LatS.fullnamepath=attname2;
            end 
         elseif (a530==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'standard_name');
            if(a1==1)
                LonS.standard_name=attname2;
            end
            a1=strcmp(attname1,'origname');
            if(a1==1)
                LonS.origname=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LonS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LonS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                LonS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                LonS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                LonS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                LonS.vmin=attname2;
            end
            a1=strcmp(attname1,'fullnamepath');
            if(a1==1)
                LonS.fullnamepath=attname2;
            end             
       end % End loop through variables
    end
    if(idebug==1)
        disp(' ')
    end
    
    if flag


    else
        eval([varname '= double(netcdf.getVar(ncid,i));'])   
        if(a340==1)
            TAUHGHS.values=M2TMNXRAD_5_12_4_TAUHGH;
            TAUHGHVals=TAUHGHS.values;
        end
        if(a350==1)
            TAUHGHS.values=TAUHGH;
            TAUHGHVals=TAUHGHS.values;
        end
      
       if(a520==1)
           LatS.values=lat;
           Latitudes=LatS.values;
       end
       if(a530==1)
           LonS.values=lon;
           Longitudes=LonS.values;
       end
    end
end
if(idebug==1)
    disp('^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~')
    disp('________________________________________________________')
    disp(' '),disp(' ')
end
netcdf.close(ncid);

MatFileName=strcat(Merra2ShortFileName,'.mat');
if(isavefiles==1)% generally there is no good reason to save this file
    eval(['cd ' savepath(1:length(savepath)-1)]);
    actionstr='save';
    varstr1='LonS LatS TAUHGHS Merra2FileName Merra2ShortFileName';
    varstr2=' YearMonthStr';
    varstr=strcat(varstr1,varstr2);
    qualstr='-v7.3';
    [cmdString]=MyStrcatV73(actionstr,MatFileName,varstr,qualstr);
    eval(cmdString)
    dispstr=strcat('Wrote Matlab File-',MatFileName);
    disp(dispstr);
    savestr=strcat('Saved Decode Data to File=',MatFileName);
    fprintf(fid,'%s\n',savestr);
    disp(savestr)
else

end
%% Create Georeference object Rpix-create once per run
if(framecounter==1)
    minLat=min(Latitudes);
    maxLat=max(Latitudes);
    minLon=min(Longitudes);
    maxLon=max(Longitudes);
    numlats=length(Latitudes);
    numlons=length(Longitudes);
    latlim=[minLat maxLat];
    lonlim=[minLon maxLon];
    rasterSize=[numlats numlons];
    Rpix = georefcells(latlim,lonlim,rasterSize,'ColumnsStartFrom','south');
    for i=1:numlons
        for j=1:numlats
            RasterLons(i,j)=Longitudes(j,1);
        end
    end
    for i=1:numlons
        for j=1:numlats
            RasterLats(i,j)=Latitudes(j,1);
        end
    end
    [nc,nr]=size(RasterLats);
    RasterAreaGrid=zeros(nc,nr);
end
ab=1;
%% Now calculate the area of each Raster point. This on varies by latitude-this operation need only be done once per run
if(framecounter==1)
    % Get the area of each cell based on the latitude
    nlats=numlats;
    nlons=numlons;
    RadiusCalc=zeros(nlats,1);
    LatSpacing=abs(Latitudes(2,1)-Latitudes(1,1));
    LonSpacing=abs(Longitudes(2,1)-Longitudes(1,1));
    lon1=10;% Earth radius does not depend on longitude so lon1 and lon2 dont matter
    lon2=lon1+LonSpacing;
    deg2rad=pi/180;
    areakmlast=0;
    for k=1:nlats
        lat1=Latitudes(k,1);
        lat2=Latitudes(k,1)+LatSpacing;
        [arclen1,~]=distance(lat1,lon1,lat2,lon1);
        radius = geocradius(lat1);
        distlat=radius*arclen1*deg2rad;
        [arclen2,~]=distance(lat1,lon1,lat1,lon2);
        distlon=radius*arclen2*deg2rad;
        areakm=distlat*distlon/1E6;
        if(areakm<1)
            areaused=1;
            areaused=areakmlast/2;
        else
            areaused=areakm;
            areakmlast=areaused;
        end
        RasterAreas(k,1)=areaused;
        RadiusCalc(k,1)=radius;
    end
% Now make an area grid that will have the same values of Area for each
% latitude point regardless 
    for ii=1:nr
        nowArea=RasterAreas(ii,1);
        for jj=1:nc
            RasterAreaGrid(jj,ii)=nowArea;
        end
    end
    ab=1;
end
% Now find out how many points have a TAUHGHVal higher than 1,2,3,4, 5
[ihigh1,jhigh1]=find(TAUHGHVals>=1);
[ihigh2,jhigh2]=find(TAUHGHVals>=2);
[ihigh3,jhigh3]=find(TAUHGHVals>=3);% This is the baseline value of interest
[ihigh4,jhigh4]=find(TAUHGHVals>=4);
[ihigh5,jhigh5]=find(TAUHGHVals>=5);
numhigh1=0;
numhigh2=0;
numhigh3=0;
numhigh4=0;
numhigh5=0;
a1=isempty(ihigh1);
a2=isempty(ihigh2);
a3=isempty(ihigh3);
a4=isempty(ihigh4);
a5=isempty(ihigh5);

if(a1==0)
    numhigh1=length(ihigh1);
end
if(a2==0)
    numhigh2=length(ihigh2);
end
if(a3==0)
    numhigh3=length(ihigh3);
end
if(a4==0)
    numhigh4=length(ihigh4);
end
if(a5==0)
    numhigh5=length(ihigh5);
end
ab=1;
%% Now get the area of any exceedances
TVal=TAUHGHVals';
nowFileList{framecounter,1}=nowFile;
% Start with a TAUHGH values over 1
if(numhigh1>0)
    [ihigh1f,jhigh1f]=find(TVal>=1);
    numhigh1f=length(ihigh1f);
    sum=0.0;
    for kk=1:numhigh1f
        iy=ihigh1f(kk);
        ix=jhigh1f(kk);
        nowArea=RasterAreas(iy,1);
        sum=sum+nowArea;
    end
    TAUHGHSum1(framecounter,1)=sum;
end
% Continue with  TAUHGH values over 2
if(numhigh2>0)
    [ihigh2f,jhigh2f]=find(TVal>=2);
    numhigh2f=length(ihigh2f);
    sum=0.0;
    for kk=1:numhigh2f
        iy=ihigh2f(kk);
        ix=jhigh2f(kk);
        nowArea=RasterAreas(iy,1);
        sum=sum+nowArea;
    end
    TAUHGHSum2(framecounter,1)=sum;
end
% Continue with  TAUHGH values over 3
if(numhigh3>0)
    [ihigh3f,jhigh3f]=find(TVal>=3);
    numhigh3f=length(ihigh3f);
    sum=0.0;
    for kk=1:numhigh3f
        iy=ihigh3f(kk);
        ix=jhigh3f(kk);
        nowArea=RasterAreas(iy,1);
        sum=sum+nowArea;
    end
    TAUHGHSum3(framecounter,1)=sum;
end
% Continue with  TAUHGH values over 4
if(numhigh4>0)
    [ihigh4f,jhigh4f]=find(TVal>=4);
    numhigh4f=length(ihigh4f);
    sum=0.0;
    for kk=1:numhigh4f
        iy=ihigh4f(kk);
        ix=jhigh4f(kk);
        nowArea=RasterAreas(iy,1);
        sum=sum+nowArea;
    end
    TAUHGHSum4(framecounter,1)=sum;
end
% Continue with  TAUHGH values over 5
if(numhigh5>0)
    [ihigh5f,jhigh5f]=find(TVal>=5);
    numhigh5f=length(ihigh5f);
    sum=0.0;
    for kk=1:numhigh5f
        iy=ihigh5f(kk);
        ix=jhigh5f(kk);
        nowArea=RasterAreas(iy,1);
        sum=sum+nowArea;
    end
    TAUHGHSum5(framecounter,1)=sum;
end


end

