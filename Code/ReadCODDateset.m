function ReadCODDateset()
% Modified: This function will read in the the Merra-2 COT dataset
% this is a special purpose dataset created by Joydeb that just has the 
% months TAUHGH dataset as well as the lat lon data
% Written By: Stephen Forczyk
% Created: Aug 19,2023
% Revised: ------
% Classification: Unclassified

global BandDataS MetaDataS;

global Merra2FileName Merra2ShortFileName Merra2Dat;

global idebug;
global LonS LatS TimeS ;
global YearMonthDayStr1 YearMonthDayStr2;
global EFLUXICES TAUXWTRS SWGNTICES TSKINICES LWGNTICES;
global TAUYWTRS Var_LWGNTWTRS Var_QV10MS Var_U10MS;
global HFLUXICES Var_EFLUXWTRS Var_EFLUXICES Var_V10MS;
global EFLUXWTRS Var_TSKINICES SWGNTWTRS Var_TAUYWTRS;
global TAUYICES TSKINWTRS T10MS TAUHGHS;
global ChoiceList;
% additional paths needed for mapping
global matpath1 mappath GOES16path;
global jpegpath savepath;

global fid isavefiles;

% ChoiceList=cell(1,1);
% ChoiceList{1,1}='EFLUXICS-sea ice latent energy flux';
% ChoiceList{2,1}='TAUXWTRS-easterwar stress over water';
% ChoiceList{3,1}='SWGNTICE-sea_ice_net_downward_shortwave_flux';
% ChoiceList{4,1}='TSKINICES-sea ice skin temp';
% ChoiceList{5,1}='LWGNTICE-sea_ice_net_downward_longwave_flux';
% ChoiceList{6,1}='TAUYWTRS-northward_stress_over_water';
% ChoiceList{7,1}='Var_LWGNTWTRS-Variance_of_LWGNTWTR';
% ChoiceList{8,1}='Var_QV10MS-var of 10 meter specific humidity';
% ChoiceList{9,1}='Var_U10MS-var of 10 meter northward wind';
% ChoiceList{10,1}='HFLUXICES-sea_ice_upward_sensible_heat_flux';
% ChoiceList{11,1}='Var_EFLUXWTRS-var of EFULWTR';
% ChoiceList{12,1}='Var_EFLUXICE-var of EFLUXICS';
% ChoiceList{13,1}='Var_V10MS-var of 10 meter north wind';
% ChoiceList{14,1}='EFLUXWTR-open_water_latent_energy_flux';
% ChoiceList{15,1}='Var_TSKINICE-variance of TSKINICE';
% ChoiceList{16,1}='SWGNTWTRS-open_water_net_downward_shortwave_flux';
% ChoiceList{17,1}='Var_TAUYWTR-var of northward stress over water';
% ChoiceList{18,1}='TAUYICE-northward_stress_over_ice';
% ChoiceList{19,1}='TSKINWTRS open water skin temp';
% ChoiceList{20,1}='T10MS 10 meter air temp;';
% ChoiceList{21,1}='SWGDN-Surface SWIR Incoming Flux';
% ChoiceList{22,1}='SWGDNCLR-Surface SWIR Incoming Flux Clear Sky';
% ChoiceList{23,1}='SWGNT-surface net downward shortwave flux';
% ChoiceList{24,1}='SWGNTCLN-surface net downward shortwave flux no/aerosol';
% ChoiceList{25,1}='SWGNTCLN-surface net downward shortwave flux no/aerosol Clr Sky';
% ChoiceList{26,1}='SWTDNS-TOA-incoming-SWIR-flux';
% ChoiceList{27,1}='SWTNTS-TOA-Net-Downward-flux';
% ChoiceList{28,1}='SWTNTCLN-TOA-Net-Downward-NoAero-flux';
% ChoiceList{29,1}='SWTNTCLR-TOA-Net-Downward-ClearSky-flux';
% ChoiceList{30,1}='SWTNTCLRCLN-TOA-Net-Downward-Flux-ClrSkyNoAero';
% ChoiceList{31,1}='TAUHGH-cloud-optical-thickness-highclouds';
% ChoiceList{32,1}='TAUHGH-cloud-optical-thickness-lowclouds';
% ChoiceList{33,1}='TAUHGH-cloud-optical-thickness-midclouds';
% ChoiceList{34,1}='TAUHGH-cloud-optical-thickness-midclouds';
% ChoiceList{35,1}='Surface-Temp-TSkin';
% ChoiceList{36,1}='VarAlbedo-variance in albedo';
% ChoiceList{37,1}='VarALBNIRDF-variance surface-albedo-nir-diffuse';
% ChoiceList{38,1}='VarALBNIRDR-variance surface-albedo-nir-beam';
% ChoiceList{39,1}='VarALBVISDF-variance surface-albedo-vis-diffuse';
% ChoiceList{40,1}='VarALBVISDR-variance surface-albedo-vis-beam';
% ChoiceList{41,1}='VarCLDHGH-variance in cloud fraction-high clouds';
% ChoiceList{42,1}='VarCLDLOW-variance in cloud fraction-low clouds';
% ChoiceList{43,1}='VarCLDMID-variance in cloud fraction-mid clouds';
% ChoiceList{44,1}='VarCLDTOT-variance in cloud fraction-total clouds';
% ChoiceList{45,1}='VarEMIS-variance in surface emissivity';
fprintf(fid,'\n');
fprintf(fid,'%s\n','**************Start reading dataset 04 data***************');

[nc_filenamesuf,path]=uigetfile('*nc4','Select One Data File');% SMF Modification
GOESFileName=nc_filenamesuf;
Merra2FileName=RemoveUnderScores(GOESFileName);
nc_filename=strcat(path,nc_filenamesuf);
ncid=netcdf.open(nc_filename,'nowrite');
openfilestr=strcat('Opening file-',Merra2FileName,'-for reading');
fprintf(fid,'%s\n',openfilestr);
[iper]=strfind(Merra2FileName,'.');
numper=length(iper);
is=1;
ie=iper(numper)-1;
Merra2ShortFileName=Merra2FileName(is:ie);
EFLUXICES=struct('values',[],'long_name',[],'FillValue',[],'units',[],...
    'missing_value',[],'fmissing_value',[],'vmax',[],'vmin',[],'valid_range',[],...
    'orig_name',[],'fullnamepath',[]);
TAUXWTRS=EFLUXICES;
SWGNTICES=EFLUXICES;
TSKINICES=EFLUXICES;
LWGNTICES=EFLUXICES;
TAUYWTRS=EFLUXICES;
Var_LWGNTWTRS=EFLUXICES;
Var_QV10MS=EFLUXICES;
Var_U10MS=EFLUXICES;
HFLUXICES=EFLUXICES;
Var_EFLUXWTRS=EFLUXICES;
Var_EFLUXICES=EFLUXICES;
Var_V10MS=EFLUXICES;
EFLUXWTRS=EFLUXICES;
Var_TSKINICES=EFLUXICES;
SWGNTWTRS=EFLUXICES;
Var_TAUYWTRS=EFLUXICES;
TAUYICES=EFLUXICES;
T10MS=EFLUXICES;
LonS=struct('values',[],'long_name',[],'units',[],'vmax',[],'vmin',[],'valid_range',[]);
LatS=LonS;
TimeS=struct('values',[],'long_name',[],'units',[],'time_increment',[],...
    'begin_date',[],'begin_time',[],'vmax',[],'vmin',[],'valid_range',[]);


% Get information about the contents of the file.
[numdims, numvars, numglobalatts, unlimdimID] = netcdf.inq(ncid);
numvarstr=strcat('The number of variables read from the Cloud Top Data file=',num2str(numvars));
fprintf(fid,'%s\n',numvarstr);
    
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
iPrintAll=1;
if(iPrintAll==1)
    for jj=0:numvars-1
        [varname, xtype, dimids, numatts] = netcdf.inqVar(ncid,jj);
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
    [varname, xtype, dimids, numatts] = netcdf.inqVar(ncid,i);
    if(idebug==1)
        disp(['--------------------< ' varname ' >---------------------'])
        dispstr=strcat('--------------',varname,'--------------');
        fprintf(fid,'\n');
        fprintf(fid,'%s\n',dispstr);
    end
    flag = 0;
    for j = 0:numatts - 1
       a10=strcmp(varname,'EFLUXICE');
       a20=strcmp(varname,'TAUXWTR');
       a30=strcmp(varname,'SWGNTICE');
       a40=strcmp(varname,'TSKINICE');
       a50=strcmp(varname,'LWGNTICE');
       a60=strcmp(varname,'TAUYWTR');
       a70=strcmp(varname,'Var_LWGNTWTR');
       a80=strcmp(varname,'Var_QV10M');
       a90=strcmp(varname,'Var_U10M');
       a100=strcmp(varname,'HFLUXICE');
       a110=strcmp(varname,'Var_EFLUXWTR');
       a120=strcmp(varname,'Var_EFLUXICE');
       a130=strcmp(varname,'Var_V10M');
       a140=strcmp(varname,'EFLUXWTR');
       a150=strcmp(varname,'Var_TSKINICE');
       a160=strcmp(varname,'SWGNTWTR');
       a170=strcmp(varname,'Var_TAUYWTR');
       a180=strcmp(varname,'TAUYICE');
       a190=strcmp(varname,'TSKINWTR');
       a200=strcmp(varname,'T10M');
       a210=strcmp(varname,'LWTUP');
       a220=strcmp(varname,'SWGDN');
       a230=strcmp(varname,'SWGDNCLR');
       a240=strcmp(varname,'SWGNTCLN');
       a250=strcmp(varname,'SWGNTCLR');
       a260=strcmp(varname,'SWGNTCLRCLN');
       a270=strcmp(varname,'SWTDN');
       a280=strcmp(varname,'SWTNT');
       a290=strcmp(varname,'SWTNTCLN');
       a300=strcmp(varname,'SWTNTCLR');
       a310=strcmp(varname,'SWTNTCLRCLN');
       a340=strcmp(varname,'TAUHGH');
       a350=strcmp(varname,'TAULOW');
       a360=strcmp(varname,'TAUMID');
       a370=strcmp(varname,'TAUTOT');
       a380=strcmp(varname,'TS');
       a390=strcmp(varname,'LWTUPCLR');
       a400=strcmp(varname,'LWTUPCLRCLN');
       a410=strcmp(varname,'SWGNT');
       a420=strcmp(varname,'Var_ALBEDO');
       a430=strcmp(varname,'Var_ALBNIRDF');
       a440=strcmp(varname,'Var_ALBNIRDR');
       a450=strcmp(varname,'Var_ALBVISDF');
       a460=strcmp(varname,'Var_ALBVISDR');
       a470=strcmp(varname,'Var_CLDHGH');
       a480=strcmp(varname,'Var_CLDLOW');
       a490=strcmp(varname,'Var_CLDMID');
       a500=strcmp(varname,'Var_CLDTOT');
       a510=strcmp(varname,'Var_EMIS');
       if (a10==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                 EFLUXICES.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                 EFLUXICES.units=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                 EFLUXICES.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                 EFLUXICES.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                 EFLUXICES.valid_range=attname2;
            end
            a1=strcmp(attname1,'origname');
            if(a1==1)
                 EFLUXICES.orig_name=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                 EFLUXICES.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                 EFLUXICES.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'fullnamepath');
            if(a1==1)
                 EFLUXICES.fullnamepath=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                 EFLUXICES.FillValue=attname2;
            end
        elseif (a20==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                 TAUXWTRS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                 TAUXWTRS.units=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                 TAUXWTRS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                 TAUXWTRS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                 TAUXWTRS.valid_range=attname2;
            end
            a1=strcmp(attname1,'origname');
            if(a1==1)
                 TAUXWTRS.orig_name=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                 TAUXWTRS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                 TAUXWTRS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'fullnamepath');
            if(a1==1)
                 TAUXWTRS.fullnamepath=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                 TAUXWTRS.FillValue=attname2;
            end
        elseif (a30==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                 SWGNTICES.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                 SWGNTICES.units=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                 SWGNTICES.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                 SWGNTICES.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                 SWGNTICES.valid_range=attname2;
            end
            a1=strcmp(attname1,'origname');
            if(a1==1)
                 SWGNTICES.orig_name=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                 SWGNTICES.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                 SWGNTICES.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'fullnamepath');
            if(a1==1)
                 SWGNTICES.fullnamepath=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                 SWGNTICES.FillValue=attname2;
            end
        elseif (a40==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                 TSKINICES.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                 TSKINICES.units=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                 TSKINICES.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                 TSKINICES.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                 TSKINICES.valid_range=attname2;
            end
            a1=strcmp(attname1,'origname');
            if(a1==1)
                 TSKINICES.orig_name=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                 TSKINICES.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                 TSKINICES.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'fullnamepath');
            if(a1==1)
                 TSKINICES.fullnamepath=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                 TSKINICES.FillValue=attname2;
            end
        elseif (a50==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                 LWGNTICES.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                 LWGNTICES.units=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                 LWGNTICES.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                 LWGNTICES.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                 LWGNTICES.valid_range=attname2;
            end
            a1=strcmp(attname1,'origname');
            if(a1==1)
                 LWGNTICES.orig_name=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                 LWGNTICES.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                 LWGNTICES.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'fullnamepath');
            if(a1==1)
                 LWGNTICES.fullnamepath=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                 LWGNTICES.FillValue=attname2;
            end
        elseif (a60==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                 TAUYWTRS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                 TAUYWTRS.units=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                 TAUYWTRS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                 TAUYWTRS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                 TAUYWTRS.valid_range=attname2;
            end
            a1=strcmp(attname1,'origname');
            if(a1==1)
                 TAUYWTRS.orig_name=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                 TAUYWTRS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                 TAUYWTRS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'fullnamepath');
            if(a1==1)
                 TAUYWTRS.fullnamepath=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                 TAUYWTRS.FillValue=attname2;
            end
        elseif (a70==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                 Var_LWGNTWTRS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                 Var_LWGNTWTRS.units=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                 Var_LWGNTWTRS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                 Var_LWGNTWTRS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                 Var_LWGNTWTRS.valid_range=attname2;
            end
            a1=strcmp(attname1,'origname');
            if(a1==1)
                 Var_LWGNTWTRS.orig_name=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                 Var_LWGNTWTRS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                 Var_LWGNTWTRS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'fullnamepath');
            if(a1==1)
                 Var_LWGNTWTRS.fullnamepath=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                 Var_LWGNTWTRS.FillValue=attname2;
            end
        elseif (a80==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                 Var_QV10MS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                 Var_QV10MS.units=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                 Var_QV10MS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                 Var_QV10MS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                 Var_QV10MS.valid_range=attname2;
            end
            a1=strcmp(attname1,'origname');
            if(a1==1)
                 Var_QV10MS.orig_name=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                 Var_QV10MS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                 Var_QV10MS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'fullnamepath');
            if(a1==1)
                 Var_QV10MS.fullnamepath=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                 Var_QV10MS.FillValue=attname2;
            end
        elseif (a90==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                 Var_U10MS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                 Var_U10MS.units=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                 Var_U10MS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                 Var_U10MS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                 Var_U10MS.valid_range=attname2;
            end
            a1=strcmp(attname1,'origname');
            if(a1==1)
                 Var_U10MS.orig_name=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                 Var_U10MS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                 Var_U10MS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'fullnamepath');
            if(a1==1)
                 Var_U10MS.fullnamepath=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                 Var_U10MS.FillValue=attname2;
            end
        elseif (a100==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                 HFLUXICES.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                  HFLUXICES.units=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                  HFLUXICES.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                  HFLUXICES.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                  HFLUXICES.valid_range=attname2;
            end
            a1=strcmp(attname1,'origname');
            if(a1==1)
                  HFLUXICES.orig_name=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                  HFLUXICES.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                  HFLUXICES.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'fullnamepath');
            if(a1==1)
                  HFLUXICES.fullnamepath=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                  HFLUXICES.FillValue=attname2;
            end
        elseif (a110==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                 Var_EFLUXWTRS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                  Var_EFLUXWTRS.units=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                  Var_EFLUXWTRS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                  Var_EFLUXWTRS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                  Var_EFLUXWTRS.valid_range=attname2;
            end
            a1=strcmp(attname1,'origname');
            if(a1==1)
                  Var_EFLUXWTRS.orig_name=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                  Var_EFLUXWTRS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                  Var_EFLUXWTRS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'fullnamepath');
            if(a1==1)
                  Var_EFLUXWTRS.fullnamepath=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                  Var_EFLUXWTRS.FillValue=attname2;
            end
        elseif (a120==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                 Var_EFLUXICES.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                 Var_EFLUXICES.units=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                  Var_EFLUXICES.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                  Var_EFLUXICES.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                  Var_EFLUXICES.valid_range=attname2;
            end
            a1=strcmp(attname1,'origname');
            if(a1==1)
                  Var_EFLUXICES.orig_name=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                  Var_EFLUXICES.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                  Var_EFLUXICES.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'fullnamepath');
            if(a1==1)
                  Var_EFLUXICES.fullnamepath=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                  Var_EFLUXICES.FillValue=attname2;
            end
        elseif (a130==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                 Var_V10MS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                 Var_V10MS.units=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                  Var_V10MS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                  Var_V10MS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                  Var_V10MS.valid_range=attname2;
            end
            a1=strcmp(attname1,'origname');
            if(a1==1)
                  Var_V10MS.orig_name=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                  Var_V10MS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                  Var_V10MS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'fullnamepath');
            if(a1==1)
                  Var_V10MS.fullnamepath=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                  Var_V10MS.FillValue=attname2;
            end
        elseif (a140==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                 EFLUXWTRS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                 EFLUXWTRS.units=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                  EFLUXWTRS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                  EFLUXWTRS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                  EFLUXWTRS.valid_range=attname2;
            end
            a1=strcmp(attname1,'origname');
            if(a1==1)
                  EFLUXWTRS.orig_name=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                  EFLUXWTRS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                  EFLUXWTRS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'fullnamepath');
            if(a1==1)
                  EFLUXWTRS.fullnamepath=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                  EFLUXWTRS.FillValue=attname2;
            end
        elseif (a150==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                 Var_TSKINICES.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                 Var_TSKINICES.units=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                  Var_TSKINICES.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                  Var_TSKINICES.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                  Var_TSKINICES.valid_range=attname2;
            end
            a1=strcmp(attname1,'origname');
            if(a1==1)
                  Var_TSKINICES.orig_name=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                  Var_TSKINICES.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                  Var_TSKINICES.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'fullnamepath');
            if(a1==1)
                  Var_TSKINICES.fullnamepath=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                  Var_TSKINICES.FillValue=attname2;
            end
        elseif (a160==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                 SWGNTWTRS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                 SWGNTWTRS.units=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                  SWGNTWTRS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                  SWGNTWTRS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                  SWGNTWTRS.valid_range=attname2;
            end
            a1=strcmp(attname1,'origname');
            if(a1==1)
                  SWGNTWTRS.orig_name=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                  SWGNTWTRS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                  SWGNTWTRS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'fullnamepath');
            if(a1==1)
                  SWGNTWTRS.fullnamepath=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                  SWGNTWTRS.FillValue=attname2;
            end
        elseif (a170==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                 Var_TAUYWTRS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                 Var_TAUYWTRS.units=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                  Var_TAUYWTRS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                  Var_TAUYWTRS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                  Var_TAUYWTRS.valid_range=attname2;
            end
            a1=strcmp(attname1,'origname');
            if(a1==1)
                  Var_TAUYWTRS.orig_name=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                  Var_TAUYWTRS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                  Var_TAUYWTRS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'fullnamepath');
            if(a1==1)
                  Var_TAUYWTRS.fullnamepath=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                  Var_TAUYWTRS.FillValue=attname2;
            end
        elseif (a180==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                 TAUYICES.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                 TAUYICES.units=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                 TAUYICES.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                 TAUYICES.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                TAUYICES.valid_range=attname2;
            end
            a1=strcmp(attname1,'origname');
            if(a1==1)
                TAUYICES.orig_name=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                TAUYICES.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                TAUYICES.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'fullnamepath');
            if(a1==1)
                TAUYICES.fullnamepath=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                TAUYICES.FillValue=attname2;
            end
        elseif (a190==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                 TSKINWTRS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                 TSKINWTRS.units=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                 TSKINWTRS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                 TSKINWTRS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                TSKINWTRS.valid_range=attname2;
            end
            a1=strcmp(attname1,'origname');
            if(a1==1)
                TSKINWTRS.orig_name=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                TSKINWTRS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                TSKINWTRS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'fullnamepath');
            if(a1==1)
                TSKINWTRS.fullnamepath=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                TSKINWTRS.FillValue=attname2;
            end
        elseif (a200==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                 T10MS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                 T10MS.units=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                 T10MS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                 T10MS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                T10MS.valid_range=attname2;
            end
            a1=strcmp(attname1,'origname');
            if(a1==1)
                T10MS.orig_name=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                T10MS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                T10MS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'fullnamepath');
            if(a1==1)
                T10MS.fullnamepath=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                T10MS.FillValue=attname2;
            end
        elseif (a210==1)

        elseif (a220==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                SWGDNS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SWGDNS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                SWGDNS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                SWGDNS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                SWGDNS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                SWGDNS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                SWGDNS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                SWGDNS.valid_range=attname2;
            end
        elseif (a230==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                SWGDNCLRS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SWGDNCLRS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                SWGDNCLRS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                SWGDNCLRS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                SWGDNCLRS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                SWGDNCLRS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                SWGDNCLRS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                SWGDNCLRS.valid_range=attname2;
            end
        elseif (a240==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                SWGNTCLNS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SWGNTCLNS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                SWGNTCLNS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                SWGNTCLNS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                SWGNTCLNS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                SWGNTCLNS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                SWGNTCLNS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                SWGNTCLNS.valid_range=attname2;
            end
        elseif (a250==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                SWGNTCLRS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SWGNTCLRS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                SWGNTCLRS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                SWGNTCLRS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                SWGNTCLRS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                SWGNTCLRS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                SWGNTCLRS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                SWGNTCLRS.valid_range=attname2;
            end
        elseif (a260==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                SWGNTCLRCLNS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SWGNTCLRCLNS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                SWGNTCLRCLNS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                SWGNTCLRCLNS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                SWGNTCLRCLNS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                SWGNTCLRCLNS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                SWGNTCLRCLNS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                SWGNTCLRCLNS.valid_range=attname2;
            end
        elseif (a270==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                SWTDNS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SWTDNS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                SWTDNS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                SWTDNS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                SWTDNS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                SWTDNS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                SWTDNS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                SWTDNS.valid_range=attname2;
            end
        elseif (a280==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                SWTNTS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SWTNTS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                SWTNTS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                SWTNTS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                SWTNTS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                SWTNTS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                SWTNTS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                SWTNTS.valid_range=attname2;
            end
        elseif (a290==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                SWTNTCLNS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SWTNTCLNS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                SWTNTCLNS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                SWTNTCLNS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                SWTNTCLNS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                SWTNTCLNS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                SWTNTCLNS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                SWTNTCLNS.valid_range=attname2;
            end
        elseif (a300==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                SWTNTCLRS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SWTNTCLRS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                SWTNTCLRS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                SWTNTCLRS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                SWTNTCLRS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                SWTNTCLRS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                SWTNTCLRS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                SWTNTCLRS.valid_range=attname2;
            end
        elseif (a310==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                SWTNTCLRCLNS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SWTNTCLRCLNS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                SWTNTCLRCLNS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                SWTNTCLRCLNS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                SWTNTCLRCLNS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                SWTNTCLRCLNS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                SWTNTCLRCLNS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                SWTNTCLRCLNS.valid_range=attname2;
            end 
        elseif (a340==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                TAUHGHS.long_name=attname2;
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
        elseif (a350==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                TAULOWS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                TAULOWS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                TAULOWS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                TAULOWS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                TAULOWS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                TAULOWS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                TAULOWS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                TAULOWS.valid_range=attname2;
            end
        elseif (a360==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                TAUMIDS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                TAUMIDS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                TAUMIDS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                TAUMIDS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                TAUMIDS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                TAUMIDS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                TAUMIDS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                TAUMIDS.valid_range=attname2;
            end 
        elseif (a370==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                TAUTOTS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                TAUTOTS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                TAUTOTS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                TAUTOTS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                TAUTOTS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                TAUTOTS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                TAUTOTS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                TAUTOTS.valid_range=attname2;
            end 
        elseif (a380==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                TSS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                TSS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                TSS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                TSS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                TSS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                TSS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                TSS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                TSS.valid_range=attname2;
            end 
        elseif (a390==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LWTUPCLRS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LWTUPCLRS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LWTUPCLRS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                LWTUPCLRS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                LWTUPCLRS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                LWTUPCLRS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                LWTUPCLRS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                LWTUPCLRS.valid_range=attname2;
            end
        elseif (a400==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                LWTUPCLRCLNS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                LWTUPCLRCLNS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                LWTUPCLRCLNS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                LWTUPCLRCLNS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                LWTUPCLRCLNS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                LWTUPCLRCLNS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                LWTUPCLRCLNS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                LWTUPCLRCLNS.valid_range=attname2;
            end
        elseif (a410==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                SWGNTS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                SWGNTS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                SWGNTS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                SWGNTS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                SWGNTS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                SWGNTS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                SWGNTS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                SWGNTS.valid_range=attname2;
            end
        elseif (a420==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                VarALBEDOS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                VarALBEDOS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                VarALBEDOS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                VarALBEDOS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                VarALBEDOS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                VarALBEDOS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                VarALBEDOS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                VarALBEDOS.valid_range=attname2;
            end
        elseif (a430==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                VarALBNIRDFS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                VarALBNIRDFS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                VarALBNIRDFS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                VarALBNIRDFS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                VarALBNIRDFS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                VarALBNIRDFS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                VarALBNIRDFS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                VarALBNIRDFS.valid_range=attname2;
            end
        elseif (a440==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                VarALBNIRDRS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                VarALBNIRDRS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                VarALBNIRDRS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                VarALBNIRDRS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                VarALBNIRDRS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                VarALBNIRDRS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                VarALBNIRDRS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                VarALBNIRDRS.valid_range=attname2;
            end
        elseif (a450==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                VarALBVISDFS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                VarALBVISDFS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                VarALBVISDFS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                VarALBVISDFS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                VarALBVISDFS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                VarALBVISDFS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                VarALBVISDFS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                VarALBVISDFS.valid_range=attname2;
            end
        elseif (a460==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                VarALBVISDRS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                VarALBVISDRS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                VarALBVISDRS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                VarALBVISDRS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                VarALBVISDRS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                VarALBVISDRS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                VarALBVISDRS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                VarALBVISDRS.valid_range=attname2;
            end
        elseif (a470==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                VarCLDHGHS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                VarCLDHGHS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                VarCLDHGHS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                VarCLDHGHS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                VarCLDHGHS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                VarCLDHGHS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                VarCLDHGHS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                VarCLDHGHS.valid_range=attname2;
            end
        elseif (a480==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                VarCLDLOWS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                VarCLDLOWS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                VarCLDLOWS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                VarCLDLOWS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                VarCLDLOWS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                VarCLDLOWS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                VarCLDLOWS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                VarCLDLOWS.valid_range=attname2;
            end
         elseif (a490==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                VarCLDMIDS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                VarCLDMIDS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                VarCLDMIDS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                VarCLDMIDS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                VarCLDMIDS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                VarCLDMIDS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                VarCLDMIDS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                VarCLDMIDS.valid_range=attname2;
            end 
         elseif (a500==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                VarCLDTOTS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                VarCLDTOTS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                VarCLDTOTS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                VarCLDTOTS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                VarCLDTOTS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                VarCLDTOTS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                VarCLDTOTS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                VarCLDTOTS.valid_range=attname2;
            end 
            
         elseif (a510==1)
            attname1 = netcdf.inqAttName(ncid,i,j);
            attname2 = netcdf.getAtt(ncid,i,attname1);
            if(idebug==1)
                disp([attname1 ':  ' num2str(attname2)])
                dispstr=strcat(attname1,': ',num2str(attname2));
                fprintf(fid,'%s\n',dispstr);
            end
            a1=strcmp(attname1,'long_name');
            if(a1==1)
                VarEMISS.long_name=attname2;
            end
            a1=strcmp(attname1,'units');
            if(a1==1)
                VarEMISS.units=attname2;
            end
            a1=strcmp(attname1,'_FillValue');
            if(a1==1)
                VarEMISS.FillValue=attname2;
            end
            a1=strcmp(attname1,'missing_value');
            if(a1==1)
                VarEMISS.missing_value=attname2;
            end
            a1=strcmp(attname1,'fmissing_value');
            if(a1==1)
                VarEMISS.fmissing_value=attname2;
            end
            a1=strcmp(attname1,'vmax');
            if(a1==1)
                VarEMISS.vmax=attname2;
            end
            a1=strcmp(attname1,'vmin');
            if(a1==1)
                VarEMISS.vmin=attname2;
            end
            a1=strcmp(attname1,'valid_range');
            if(a1==1)
                VarEMISS.valid_range=attname2;
            end       
        end
    end
    if(idebug==1)
        disp(' ')
    end
    
    if flag
        if(varname=='AIRX3STD_006_RelHumid_AS')
            eval([varname '=( double(double(netcdf.getVar(ncid,i))-0));'])
            FillValue=AIRX3STD_006_RelHumid_AS.FillValue;
            CT=AIRX3STD_006_RelHumid_AS;
            [CT,numnanvals] = ReplaceFillValues(CT,FillValue);
               [nrows,ncols]=size(CT);
               level=(2^15)-1;
               for ik=1:nrows
                   for jk=1:ncols
                      value=CT(ik,jk);
                      if(value<0)
                           diff=level-abs(value);
                           corval=level+diff;
                           CT(ik,jk)=corval;
                      end
                   end
               end
               CTT=CT;
               scale2=double(scale);
               offset2=double(offset);
               CTT2=CTT'*scale2+offset2;
               AIRX3STD_006_RelHumid_AS.values=CTT2;
               clear CT
               ab=1;
        end

    else
        eval([varname '= double(netcdf.getVar(ncid,i));'])   
        if(a10==1)
            EFLUXICES.values=EFLUXICE;
        end
        if(a20==1)
            TAUXWTRS.values=TAUXWTR;
        end
        if(a30==1)
            SWGNTICES.values=SWGNTICE;
        end
        if(a40==1)
            TSKINICES.values=TSKINICE;
        end
        if(a50==1)
            LWGNTICES.values=LWGNTICE;
        end
        if(a60==1)
            TAUYWTRS.values=TAUYWTR;
        end
        if(a70==1)
            Var_LWGNTWTRS.values=Var_LWGNTWTR;
        end
        if(a80==1)
            Var_QV10MS.values=Var_QV10M;
        end
        if(a90==1)
            Var_U10MS.values=Var_U10M;
        end
        if(a100==1)
             HFLUXICES.values= HFLUXICE;
        end
        if(a110==1)
            Var_EFLUXWTRS.values=Var_EFLUXWTR;
        end
        if(a120==1)
            Var_EFLUXICES.values=Var_EFLUXICE;
        end
        if(a130==1)
            Var_V10MS.values=Var_V10M;
        end
        if(a140==1)
            EFLUXWTRS.values=EFLUXWTR;
        end
        if(a150==1)
            Var_TSKINICES.values=Var_TSKINICE;
        end
        if(a160==1)
            SWGNTWTRS.values=SWGNTWTR;

        end
        if(a170==1)
            Var_TAUYWTRS.values=Var_TAUYWTR;
        end
        if(a180==1)
            TAUYICES.values=TAUYICE;
        end
        if(a190==1)
            TSKINWTRS.values=TSKINWTR;
        end
        if(a200==1)
            T10MS.values=T10M;
            ab=1;
        end
        if(a210==1)
            LWTUPS.values=LWTUP;
        end
        if(a220==1)
            SWGDNS.values=SWGDN;
        end
        if(a230==1)
            SWGDNCLRS.values=SWGDNCLR;
        end
        if(a240==1)
            SWGNTCLNS.values=SWGNTCLN;
        end
        if(a250==1)
            SWGNTCLRS.values=SWGNTCLR;
        end
        if(a260==1)
            SWGNTCLRCLNS.values=SWGNTCLRCLN;
        end
        if(a270==1)
            SWTDNS.values=SWTDN;
        end
        if(a280==1)
            SWTNTS.values=SWTNT;
        end
        if(a290==1)
            SWTNTCLNS.values=SWTNTCLN;
        end
        if(a300==1)
            SWTNTCLRS.values=SWTNTCLR;
        end
        if(a310==1)
            SWTNTCLRCLNS.values=SWTNTCLRCLN;
        end
        if(a340==1)
            TAUHGHS.values=TAUHGH;
        end
        if(a350==1)
            TAULOWS.values=TAULOW;
        end
        if(a360==1)
            TAUMIDS.values=TAUMID;
        end
        if(a370==1)
            TAUTOTS.values=TAUTOT;
        end
        if(a380==1)
            TSS.values=TS;
        end
        if(a390==1)
            LWTUPCLRS.values=LWTUPCLR;
        end
        if(a400==1)
            LWTUPCLRCLNS.values=LWTUPCLRCLN;
        end
        if(a410==1)
            SWGNTS.values=SWGNT;
        end
        if(a420==1)
            VarALBEDOS.values=Var_ALBEDO;
        end
        if(a430==1)
            VarALBNIRDFS.values=Var_ALBNIRDF;
        end
        if(a440==1)
            VarALBNIRDRS.values=Var_ALBNIRDR;
        end
        if(a450==1)
            VarALBVISDFS.values=Var_ALBVISDF;
        end
        if(a460==1)
            VarALBVISDRS.values=Var_ALBVISDR;
        end
        if(a470==1)
            VarCLDHGHS.values=Var_CLDHGH;
        end
        if(a480==1)
            VarCLDLOWS.values=Var_CLDLOW;
        end
        if(a490==1)
            VarCLDMIDS.values=Var_CLDMID;
        end
        if(a500==1)
            VarCLDTOTS.values=Var_CLDTOT;
        end
        if(a510==1)
            VarEMISS.values=Var_EMIS;
        end
    end
end
if(idebug==1)
    disp('^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~')
    disp('________________________________________________________')
    disp(' '),disp(' ')
end
netcdf.close(ncid);
fprintf(fid,'%s\n','Finished reading netCDF data file');
%Now write a Matlab file containing the decoded data
%use the original file name with a .mat extension
ab=1;
MatFileName=strcat(Merra2ShortFileName,'.mat');
if(isavefiles==1)
    eval(['cd ' savepath(1:length(savepath)-1)]);
    actionstr='save';
    varstr1='LonS LatS TimeS Merra2FileName Merra2ShortFileName';
    varstr2=' AlbedoS ALBNIRDFS ALBNIRDRS ALBVISDFS ALBVISDRS';
    varstr3=' CLDHGHS CLDLOWS CLDMIDS CLDTOTS';
    varstr4=' VarCLDHGHS VarCLDLOWS VarCLDMIDS VarCLDTOTS VarEMISS';
    varstr5=' EMISS LWGABS LWGABCLRS LWGABCLRCLNS LWTUPS';
    varstr6=' LWGEMS LWGNTS LWGNTCLRS LWGNTCLRCLNS LWTUPCLRS LWTUPCLRCLNS';
    varstr7=' SWGDNS SWGDNCLRS SWGNTS SWGNTCLNS SWGNTCLRS SWGNTCLRCLNS';
    varstr8=' SWTDNS SWTNTS SWTNTCLNS SWTNTCLRS SWTNTCLRCLNS';
    varstr9=' TAUHGHS TAULOWS TAUMIDS TAUTOTS TSS';
    varstr10=' VarALBEDOS VarALBNIRDFS VarALBNIRDRS VarALBVISDFS VarALBVISDRS';
    varstr=strcat(varstr1,varstr2,varstr3,varstr4,varstr5);
    varstr=strcat(varstr,varstr6,varstr7,varstr8,varstr9,varstr10);
    qualstr='-v7.3';
    [cmdString]=MyStrcatV73(actionstr,MatFileName,varstr,qualstr);
    eval(cmdString)
    dispstr=strcat('Wrote Matlab File-',MatFileName);
    disp(dispstr);
    savestr=strcat('Saved Decode Data to File=',MatFileName);
    fprintf(fid,'%s\n',savestr);
    disp(savestr)
else
    dispstr=strcat('Did Not save Decided Data to File-',MatFileName);
    disp(dispstr);
    fprintf(fid,'%s\n',dispstr);
end
% Make a variable selection from the list
[indx2,~] = listdlg('PromptString',{'Select type of data to plot'},...
'SelectionMode','single','ListString',ChoiceList,'ListSize',[480,700]);
[iper]=strfind(Merra2FileName,'.');
numper=length(iper);
is=iper(2)+1;
ie=iper(3)-1;
YearMonthDayStr1=Merra2FileName(is:ie);
[iper]=strfind(Merra2FileName,'.');
numper=length(iper);
is=1;
iper=iper';
ie=iper(numper,1)-1;
Merra2ShortFileName=Merra2FileName(is:ie);
% Display the selected variable on the correct plot
if(indx2==1) %Ok
    titlestr=strcat('SurfaceAlbedo-',Merra2ShortFileName);
    ikind=1;
    DisplayMerra2Albedo(ikind,titlestr)   
end
if(indx2==2) %Ok
    titlestr=strcat('SurfaceAlbedo-Diffuse-NIR-',Merra2ShortFileName);
    ikind=2;
    DisplayMerra2Albedo(ikind,titlestr)      
end
if(indx2==3)%Ok
    titlestr=strcat('SurfaceAlbedo-Beam-NIR-',Merra2ShortFileName);
    ikind=3;
    DisplayMerra2Albedo(ikind,titlestr)      
end
if(indx2==4)%Ok
    titlestr=strcat('SurfaceAlbedo-Diffuse-VIS-',Merra2ShortFileName);
    ikind=4;
    DisplayMerra2Albedo(ikind,titlestr)      
end
if(indx2==5)%Ok
    titlestr=strcat('SurfaceAlbedo-Beam-VIS-',Merra2ShortFileName);
    ikind=5;
    DisplayMerra2Albedo(ikind,titlestr)      
end
if(indx2==6)%Ok
    titlestr=strcat('CloudAreaFrac-HighClouds-',Merra2ShortFileName);
    ikind=1;
    DisplayMerra2CLDHGHS(ikind,titlestr)
end
if(indx2==7)%Ok
    titlestr=strcat('CloudAreaFrac-LowClouds-',Merra2ShortFileName);
    ikind=2;
    DisplayMerra2CLDHGHS(ikind,titlestr)
end
if(indx2==8)%Ok
    titlestr=strcat('CloudAreaFrac-MidClouds-',Merra2ShortFileName);
    ikind=3;
    DisplayMerra2CLDHGHS(ikind,titlestr)
end
if(indx2==9)%Ok
    titlestr=strcat('CloudAreaFrac-TotClouds-',Merra2ShortFileName);
    ikind=4;
    DisplayMerra2CLDHGHS(ikind,titlestr)
end
if(indx2==10)%Ok
    titlestr=strcat('SurfaceEmissivity-',Merra2ShortFileName);
    DisplayMerra2EMISS(titlestr)
end
if(indx2==11)%Ok
    titlestr=strcat('SurfaceAbsorbedLWIRRad-',Merra2ShortFileName);
    ikind=1;
    DisplayMerra2LWFlux(ikind,titlestr)
end
if(indx2==12)%Ok
    titlestr=strcat('SurfaceAbsorbedLWIRRadClearSky-',Merra2ShortFileName);
    ikind=2;
    DisplayMerra2LWFlux(ikind,titlestr)
end
if(indx2==13)%Ok
    titlestr=strcat('SurfaceAbsorbedLWIRRadClearSkyNoAero-',Merra2ShortFileName);
    ikind=3;
    DisplayMerra2LWFlux(ikind,titlestr)
end
if(indx2==14)%Ok
    titlestr=strcat('LWIR-Flux-From-Surface-',Merra2ShortFileName);
    ikind=4;
    DisplayMerra2LWFlux(ikind,titlestr)
end
if(indx2==15)%Ok
    titlestr=strcat('LWIR-Surface-Net-Downflux-',Merra2ShortFileName);
    ikind=5;
    DisplayMerra2LWFlux(ikind,titlestr)
end
if(indx2==16)% Ok
    titlestr=strcat('LWIR-Surface-Net-Downflux-Clear',Merra2ShortFileName);
    ikind=6;
    DisplayMerra2LWFlux(ikind,titlestr)
end
if(indx2==17)% Ok
    titlestr=strcat('LWIR-Surface-Net-Downflux-Clear-NoAero',Merra2ShortFileName);
    ikind=7;
    DisplayMerra2LWFlux(ikind,titlestr)
end
if(indx2==18)% Ok
    titlestr=strcat('LWIR-Flux-At-TOA',Merra2ShortFileName);
    ikind=8;
    DisplayMerra2LWFlux(ikind,titlestr)
end
if(indx2==19)%Ok
    titlestr=strcat('LWIR-Flux-At-TOA-ClearSky',Merra2ShortFileName);
    ikind=9;
    DisplayMerra2LWFlux(ikind,titlestr)
end
if(indx2==20)%Ok
    titlestr=strcat('LWIR-Flux-At-TOA-ClearSky-NoAero',Merra2ShortFileName);
    ikind=10;
    DisplayMerra2LWFlux(ikind,titlestr)
end
if(indx2==21)%Ok
    titlestr=strcat('Surface-Shortwave-IncomingFlux',Merra2ShortFileName);
    ikind=11;
    DisplayMerra2LWFlux(ikind,titlestr)
end
if(indx2==22)%Ok
    titlestr=strcat('Surface-Shortwave-IncomingFlux-ClearSky',Merra2ShortFileName);
    ikind=12;
    DisplayMerra2LWFlux(ikind,titlestr)
end
if(indx2==23)%Ok
    titlestr=strcat('Surface-DownwardShortwave-Flux',Merra2ShortFileName);
    ikind=13;
    DisplayMerra2LWFlux(ikind,titlestr)
end
if(indx2==24)%Ok
    titlestr=strcat('Surface-DownwardShortwave-Flux-NoAero',Merra2ShortFileName);
    ikind=14;
    DisplayMerra2LWFlux(ikind,titlestr)
end
if(indx2==25)%Ok
    titlestr=strcat('Surface-DownwardShortwave-Flux-NoAeroClearSky',Merra2ShortFileName);
    ikind=15;
    DisplayMerra2LWFlux(ikind,titlestr)
end
if(indx2==26)%Ok
    titlestr=strcat('SWIR-Flux-TOA',Merra2ShortFileName);
    ikind=16;
    DisplayMerra2LWFlux(ikind,titlestr)
end
if(indx2==27)%Ok
    titlestr=strcat('SWIR-NetDownwards-Flux-TOA',Merra2ShortFileName);
    ikind=17;
    DisplayMerra2LWFlux(ikind,titlestr)
end
if(indx2==28)%Ok
    titlestr=strcat('SWIR-NetDownNoAero-Flux-TOA',Merra2ShortFileName);
    ikind=18;
    DisplayMerra2LWFlux(ikind,titlestr)
end
if(indx2==29)%Ok
    titlestr=strcat('SWIR-NetDownClearSky-Flux-TOA',Merra2ShortFileName);
    ikind=19;
    DisplayMerra2LWFlux(ikind,titlestr)
end
if(indx2==30)%Ok
    titlestr=strcat('SWIR-NetDownClearSkyNoAero-Flux-TOA',Merra2ShortFileName);
    ikind=20;
    DisplayMerra2LWFlux(ikind,titlestr)
end
if(indx2==31)%Ok
    ikind=1;
    titlestr=strcat('CloudOpticalThickness-HighClouds-',Merra2ShortFileName);
    DisplayMerra2TAUHGH(ikind,titlestr)
end
if(indx2==32)%Ok
    ikind=2;
    titlestr=strcat('CloudOpticalThickness-LowClouds-',Merra2FileName);
    DisplayMerra2TAUHGH(ikind,titlestr)
end
if(indx2==33)%Ok
    ikind=3;
    titlestr=strcat('CloudOpticalThickness-MidClouds-',Merra2FileName);
    DisplayMerra2TAUHGH(ikind,titlestr)
end
if(indx2==34)%Ok
    ikind=4;
    titlestr=strcat('CloudOpticalThickness-TotClouds-',Merra2FileName);
    DisplayMerra2TAUHGH(ikind,titlestr)
end
if(indx2==35)%Ok
    titlestr=strcat('Surface-Skin-Temp-',Merra2FileName);
    DisplayMerra2TSS(titlestr)
end
if(indx2==36)
    ikind=1;
    titlestr=strcat('VarAlbedo-',Merra2FileName);
    DisplayMerra2Var_ALBEDO(ikind,titlestr)
end
if(indx2==37)
    ikind=2;
    titlestr=strcat('VarALBNIRDF-',Merra2FileName);
    DisplayMerra2Var_ALBEDO(ikind,titlestr)
end
if(indx2==38)
    ikind=3;
    titlestr=strcat('VarALBNIRDR-',Merra2FileName);
    DisplayMerra2Var_ALBEDO(ikind,titlestr)
end
if(indx2==39)
    ikind=4;
    titlestr=strcat('VarALBVISDF-',Merra2FileName);
    DisplayMerra2Var_ALBEDO(ikind,titlestr)
end
if(indx2==40)
    ikind=5;
    titlestr=strcat('VarALBVISDR-',Merra2FileName);
    DisplayMerra2Var_ALBEDO(ikind,titlestr)
end
if(indx2==41)
    ikind=1;
    titlestr=strcat('VarCLDHGH-',Merra2FileName);
    DisplayMerra2Var_CLDHGH(ikind,titlestr)
end
if(indx2==42)
    ikind=2;
    titlestr=strcat('VarCLDLOW-',Merra2FileName);
    DisplayMerra2Var_CLDHGH(ikind,titlestr)
end
if(indx2==43)
    ikind=3;
    titlestr=strcat('VarCLDMID-',Merra2FileName);
    DisplayMerra2Var_CLDHGH(ikind,titlestr)
end
if(indx2==44)
    ikind=4;
    titlestr=strcat('VarCLDTOT-',Merra2FileName);
    DisplayMerra2Var_CLDHGH(ikind,titlestr)
end
if(indx2==45)
    titlestr=strcat('VarEMIS-',Merra2FileName);
    DisplayMerra2EMISS_Var(titlestr)
end

end

