function  DisplayMerra2PolarTAUHGHRev1(nowFile,titlestr,itype,lowlim,iAddToReport,iNewChapter,iCloseChapter)
% Display the cloud optical thickness for high clouds
% The intent is to just plot the polar region (i.e. 55N to the pole)
% The polar plots were not satisfactory using geoshow so try patchesm
% instead
% Written By: Stephen Forczyk
% Created: Aug 22,2023
% Revised: ------
% Classification: Unclassified

global LonS LatS TimeS ;
global YearMonthDayStr1 YearMonthDayStr2 YearMonthStr;
global TAUHGHS TAULOWS TAUMIDS TAUTOTS;
global minLat maxLat minLon maxLon numlats numlons;
global RasterAreas RadiusCalc LatSpacing LonSpacing;
global RasterLats RasterLons RasterLons2 Rpix RasterAreaGrid;
global TAUHGHSum1 TAUHGHSum2 TAUHGHSum3 TAUHGHSum4 TAUHGHSum5;
global cscale framecounter;

global RptGenPresent iCreatePDFReport pdffilename rpt chapter;
global RasterLats RasterLons Rpix;
global Merra2FileName Merra2ShortFileName Merra2FileNames;
global WorldCityFileName World200TopCities;
global iCityPlot maxCities maxnumpatches;

global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2 fid;
global idirector mov izoom iwindow;
global matpath jpegpath moviepath excelpath;
global ipowerpoint PowerPointFile scaling stretching padding;
global ichartnum iLogo LogoFileName1;
global isaveJpeg;
% additional paths needed for mapping
global gridpath govjpegpath;
global matpath1 mappath;
global vTemp TempMovieName iMovie iFast;


if((iCreatePDFReport==1) && (RptGenPresent==1))
    import mlreportgen.dom.*;
    import mlreportgen.report.*;
    import mlreportgen.utils.*
end
% Get the year and month of the data from the file name
Yearstr=YearMonthStr(1:4);
Monthstr=YearMonthStr(6:7);
monthnum=str2double(Monthstr);
[monthstr] = ConvertMonthNumToStr(monthnum);
LatVals=LatS.values;
LonVals=LonS.values;
TAUVAL=TAUHGHS.values;
desc='TAU High Clouds';
units='Optical Thickness-Dimensionless';
%% Plot the Cloud Optical Thickness -removevalues that are less than lowlim and 
% replace with NaN values-this can be used to generate transparency
[nrows,ncols]=size(TAUVAL);
numpts=nrows*ncols;
TAUVALAdj=TAUVAL;
TAUVALNaN=TAUVAL;
% Define a second array that is different from the first by the replacement
% of values less than lowlin with NaN. This will be used to generate
% transparency in plotting
ioverlimit=0;
iNaN=0;
maxVal=0;
for ii=1:nrows
    for jj=1:ncols
        nowVal=TAUVAL(ii,jj);
        if(nowVal<lowlim)
            TAUVALNaN(ii,jj)=NaN;
            iNaN=iNaN+1;
        else
            ioverlimit=ioverlimit+1;
            if(nowVal>maxVal)
                maxVal=nowVal;
            end
        end
    end
end
maxtauvalue=max(max(TAUVAL));
%% now create a series of patches for just those points over the lowlim value
cscale=colormap('jet');
inc=34;
close('all');
patlat=zeros(ioverlimit,5);
patlon=zeros(ioverlimit,5);
patcolor=zeros(ioverlimit,3);
nowColor2=zeros(ioverlimit,3);
ibig=0;
minval=0;
maxvalTau=0;
maxcindex=0;
BigVals=zeros(ioverlimit,1);
for ii=1:ncols
    for jj=1:nrows
        nowVal=TAUVAL(jj,ii);
        if(nowVal>=lowlim)
            ibig=ibig+1;
            BigVals(ibig,1)=nowVal;
            centerlat=LatVals(ii,1);
            centerlon=LonVals(jj,1);
            patchval=nowVal;
            cindex=inc+floor((nowVal)*inc);
            if(cindex>238)
                cindex=238;
            end
            if(cindex<5)
                cindex=5;
            end
            if(nowVal>maxvalTau)
                maxvalTau=nowVal;
            end
            if(cindex>maxcindex)
                maxcindex=cindex;
            end
            rcolor=cscale(cindex,1);
            gcolor=cscale(cindex,2);
            bcolor=cscale(cindex,3);
            patcolor(ibig,1)=rcolor;
            patcolor(ibig,2)=gcolor;
            patcolor(ibig,3)=bcolor;
            nowColor2(ibig,1)=rcolor;
            nowColor2(ibig,2)=gcolor;
            nowColor2(ibig,3)=bcolor;
            patlat(ibig,1)=centerlat-LatSpacing/2;
            patlat(ibig,2)=patlat(ibig,1);
            patlat(ibig,3)=patlat(ibig,2)+LatSpacing;
            patlat(ibig,4)=patlat(ibig,3);
            patlat(ibig,5)=patlat(ibig,1);
            patlon(ibig,1)=centerlon-LonSpacing/2;
            patlon(ibig,2)=centerlon+LonSpacing/2;
            patlon(ibig,3)=patlon(ibig,2);
            patlon(ibig,4)=patlon(ibig,1);
            patlon(ibig,5)=patlon(ibig,1);
        end
    end
end

% Calculate some stats
TAUVAL1D=reshape(TAUVALAdj,nrows*ncols,1);
TAUVAL1DS=sort(TAUVAL1D);
num01=floor(.01*numpts);
num25=floor(.25*numpts);
num50=floor(.50*numpts);
num75=floor(.75*numpts);
num99=floor(.99*numpts);
val01=TAUVAL1DS(num01,1);
val25=TAUVAL1DS(num25,1);
val50=TAUVAL1DS(num50,1);
val75=TAUVAL1DS(num75,1);
val99=TAUVAL1DS(num99,1);

%fprintf(fid,'%s\n',' Basic Stats follow for Cloud Optical Thickness Data with Mean');
ptc1str= strcat('01 % Ptile Cloud Optical Thickness=',num2str(val01,6));
%fprintf(fid,'%s\n',ptc1str);
ptc25str=strcat('25 % Ptile Cloud Optical Thickness=',num2str(val25,6));
%fprintf(fid,'%s\n',ptc25str);
ptc50str=strcat('50 % Ptile Cloud Optical Thickness=',num2str(val50,6));
%fprintf(fid,'%s\n',ptc50str);
ptc75str=strcat('75 % Ptile Cloud Optical Thickness=',num2str(val75,6));
%fprintf(fid,'%s\n',ptc75str);
ptc99str=strcat('99 % Ptile Cloud Optical Thickness=',num2str(val99,6));
%fprintf(fid,'%s\n',ptc99str);
%fprintf(fid,'%s\n',' End Stats follow for Cloud Optical Thickness Data');
maxCOD=max(TAUVAL1DS);
nowareakm3=TAUHGHSum3(framecounter,1);
nowareakm5=TAUHGHSum5(framecounter,1);
if(framecounter==1)
    headerstr='---File----------Frame----COD 1%----COD 25%-----COD 50%----COD75%-----COD99%----COD Max----COD>3 Areakm^2----COD>5 Areakm^2';
    fprintf(fid,'%s\n',headerstr);
end
fprintf(fid,'%s',nowFile);
fprintf(fid,'%10d %10.3f %10.3f %10.3f %10.3f %10.3f  %10.3f %12.0f %12.0f\n',framecounter,val01,val25,val50,val75,val99,maxCOD,...
    nowareakm3,nowareakm5);
minval=val01;
maxval=val99;
maxval2=maxval+10;
maxval2=.1;
incsize=(maxval-minval)/64;

%% Fetch the map limits
westEdge=minLon;
eastEdge=maxLon;
southEdge=minLat;
northEdge=maxLat;
maplimitstr1='****Map Limits Follow*****';
%fprintf(fid,'%s\n',maplimitstr1);
maplimitstr2=strcat('WestEdge=',num2str(westEdge,7),'-EastEdge=',num2str(eastEdge));
%fprintf(fid,'%s\n',maplimitstr2);
maplimitstr3=strcat('SouthEdge=',num2str(southEdge,7),'-NorthEdge=',num2str(northEdge));
%fprintf(fid,'%s\n',maplimitstr3);
maplimitstr4='****Map Limits End*****';
%fprintf(fid,'%s\n',maplimitstr4);
% Now create patches for those regions that have values above 1;

%% Set up the map axis
itype=7;
if(itype==1)
    axesm ('globe','Frame','on','Grid','on','meridianlabel','off','parallellabel','on',...
        'plabellocation',[-60 -50 -40 -30 -20 -10 0 10 20 30 40 50 60],'mlabellocation',[]);
elseif(itype==2)
    axesm ('pcarree','Frame','on','Grid','on','MapLatLimit',[southEdge northEdge],...
     'MapLonLimit',[westEdge eastEdge],'meridianlabel','on','parallellabel','on','plabellocation',20,'mlabellocation',30,...
     'MLabelParallel','south');    
elseif(itype==3)
    axesm ('pcarree','Frame','on','Grid','on','MapLatLimit',[southEdge northEdge],...
     'MapLonLimit',[westEdge eastEdge],'meridianlabel','on','parallellabel','on','plabellocation',10,'mlabellocation',20,...
     'MLabelParallel','south');
elseif(itype==7) % Use this option for North Pole
    ha=axesm('eqaazim','MapLatLimit',[65 90],'FontSize',10,'FontWeight','bold','plabellocation',10,'mlabellocation',20,...
        'Grid','on','GColor',[0 1 0],'GLineWidth',1,'MLineLocation',20,'PLineLocation',10,'FontColor','r');
    mlabel on
    plabel on;
    setm(gca,'MLabelParallel',5);
    Proj='equazim';
end
set(gcf,'MenuBar','none');
set(gcf,'Position',[hor1 vert1 widd lend])
set(gca,'Color',[0.1 0.1 0.1]);
%% Plot the cloud area fraction on the map
if(itype<7)
    geoshow(TAUVALNaN',Rpix,'DisplayType','surface');
    demcmap('inc',[maxval minval],incsize);
    hc=colorbar;
    ylabel(hc,units,'FontWeight','bold');
    tightmap
    hold on
    % load the country borders and plot them
    eval(['cd ' mappath(1:length(mappath)-1)]);
    load('USAHiResBoundaries.mat','USALat','USALon');
    plot3m(USALat,USALon,maxval2,'r');
    load('CanadaBoundaries.mat','CanadaLat','CanadaLon');
    plot3m(CanadaLat,CanadaLon,maxval2,'r');
    load('MexicoBoundaries.mat','MexicoLat','MexicoLon');
    plot3m(MexicoLat,MexicoLon,maxval2,'r');
    load('CubaBoundaries.mat','CubaLat','CubaLon');
    plot3m(CubaLat,CubaLon,maxval2,'r');
    load('DominicanRepublicBoundaries.mat','DRLat','DRLon');
    plot3m(DRLat,DRLon,maxval2,'r');
    load('HaitiBoundaries.mat','HaitiLat','HaitiLon');
    plot3m(HaitiLat,HaitiLon,maxval2,'r');
    load('BelizeBoundaries.mat','BelizeLat','BelizeLon');
    plot3m(BelizeLat,BelizeLon,maxval2,'r');
    load('GautemalaBoundaries.mat','GautemalaLat','GautemalaLon');
    plot3m(GautemalaLat,GautemalaLon,maxval2,'r')
    load('JamaicaBoundaries.mat','JamaicaLat','JamaicaLon');
    plot3m(JamaicaLat,JamaicaLon,maxval2,'r');
    load('NicaraguaBoundaries.mat','NicaraguaLat','NicaraguaLon');
    plot3m(NicaraguaLat,NicaraguaLon,maxval2,'r')
    load('HondurasBoundaries.mat','HondurasLat','HondurasLon');
    plot3m(HondurasLat,HondurasLon,maxval2,'r')
    load('ElSalvadorBoundaries.mat','ElSalvadorLat','ElSalvadorLon');
    plot3m(ElSalvadorLat,ElSalvadorLon,maxval2,'r');
    load('PanamaBoundaries.mat','PanamaLat','PanamaLon');
    plot3m(PanamaLat,PanamaLon,maxval2,'r');
    load('ColumbiaBoundaries.mat','ColumbiaLat','ColumbiaLon');
    plot3m(ColumbiaLat,ColumbiaLon,maxval2,'r');
    load('VenezuelaBoundaries.mat','VenezuelaLat','VenezuelaLon');
    plot3m(VenezuelaLat,VenezuelaLon,maxval2,'r')
    load('PeruBoundaries.mat','PeruLat','PeruLon');
    plot3m(PeruLat,PeruLon,maxval2,'r');
    load('EcuadorBoundaries.mat','EcuadorLat','EcuadorLon');
    plot3m(EcuadorLat,EcuadorLon,maxval2,'r')
    load('BrazilBoundaries.mat','BrazilLat','BrazilLon');
    plot3m(BrazilLat,BrazilLon,maxval2,'r');
    load('BoliviaBoundaries.mat','BoliviaLat','BoliviaLon');
    plot3m(BoliviaLat,BoliviaLon,maxval2,'r')
    load('ChileBoundaries.mat','ChileLat','ChileLon');
    plot3m(ChileLat,ChileLon,maxval2,'r');
    load('ArgentinaBoundaries.mat','ArgentinaLat','ArgentinaLon');
    plot3m(ArgentinaLat,ArgentinaLon,maxval2,'r');
    load('UruguayBoundaries.mat','UruguayLat','UruguayLon');
    plot3m(UruguayLat,UruguayLon,maxval2,'r');
    load('CostaRicaBoundaries.mat','CostaRicaLat','CostaRicaLon');
    plot3m(CostaRicaLat,CostaRicaLon,maxval2,'r');
    load('FrenchGuianaBoundaries.mat','FrenchGuianaLat','FrenchGuianaLon');
    plot3m(FrenchGuianaLat,FrenchGuianaLon,maxval2,'r');
    load('GuyanaBoundaries.mat','GuyanaLat','GuyanaLon');
    plot3m(GuyanaLat,GuyanaLon,maxval2,'r');
    load('SurinameBoundaries.mat','SurinameLat','SurinameLon');
    plot3m(SurinameLat,SurinameLon,maxval2,'r');
    load('AfricaHiResBoundaries','AfricaLat','AfricaLon');
    plot3m(AfricaLat,AfricaLon,maxval2,'r');
    load('AsiaHiResBoundaries.mat','AsiaLat','AsiaLon');
    plot3m(AsiaLat,AsiaLon,maxval2,'r');
    load('EuropeHiResBoundaries.mat','EuropeLat','EuropeLon');
    plot3m(EuropeLat,EuropeLon,maxval2,'r');
    load('AustraliaBoundaries.mat','AustraliaLat','AustraliaLon');
    plot3m(AustraliaLat,AustraliaLon,maxval2,'r');
elseif(itype==7)
    z=100;
    ibig2=ibig;
    iclipped=0;
    if(iFast==1)
        if(ibig2>maxnumpatches)
            ibig2=maxnumpatches;
            [~,isort] = sort(BigVals,'descend');
            iclipped=1;
            ab=1;
        end
    end
    for kk=1:ibig2
        if(iclipped==1)
            ind=isort(kk);
        else
            ind=kk;
        end
        nowColor=[patcolor(ind,1) patcolor(ind,2) patcolor(ind,3)];
        patchesm(patlat(ind,:),patlon(ind,:),z,nowColor);
    end

    hc=colorbar('Limits',[0 7]);
    hc.Label.String='TAUHGH Value';
    hc.Label.FontWeight='bold';
    hc.Limits=[0 7];
    hc.Ticks=[0 1 2 3 4 5 6 7];
    clim([0, 7]);
    set(hc,'FontWeight','bold')
    load('USAHiResBoundaries.mat','USALat','USALon');
    plot3m(USALat,USALon,maxval2,'r');
    load('CanadaBoundaries.mat','CanadaLat','CanadaLon');
    plot3m(CanadaLat,CanadaLon,maxval2,'r');
    load('AsiaHiResBoundaries.mat','AsiaLat','AsiaLon');
    plot3m(AsiaLat,AsiaLon,maxval2,'r');
    load('EuropeHiResBoundaries.mat','EuropeLat','EuropeLon');
    plot3m(EuropeLat,EuropeLon,maxval2,'r');  
end
%% Add Cities to the plot is desired
% if((iCityPlot>0) && (iSubMean*iSubMean1>0))
%     for k=1:maxCities
%         nowLat=World200TopCities{1+k,2};
%         nowLon=World200TopCities{1+k,3};
%         nowName=char(World200TopCities{1+k,1});
%         plot3m(nowLat,nowLon,11,'w+');
%         textm(nowLat,nowLon+3,11,nowName,'Color','white','FontSize',8);
%     end
% else
%     for k=1:maxCities
%         nowLat=World200TopCities{1+k,2};
%         nowLon=World200TopCities{1+k,3};
%         nowName=char(World200TopCities{1+k,1});
%         plot3m(nowLat,nowLon,11,'b+');
%         textm(nowLat,nowLon+3,11,nowName,'Color','blue','FontSize',8);
%     end
% end
title(titlestr)
hold off
% Add a logo
if(iLogo==1)
    eval(['cd ' govjpegpath(1:length(govjpegpath)-1)]);
    ha =gca;
    uistack(ha,'bottom');
    haPos = get(ha,'position');
    %ha2=axes('position',[haPos(1:2), .1,.04,]);
    ha2=axes('position',[haPos(1)+.7,haPos(2)-.08, .1,.04,]);
    [x, ~]=imread(LogoFileName1);
    imshow(x);
    set(ha2,'handlevisibility','off','visible','off')
end
% Set up an axis for writing text at the bottom of the chart
newaxesh=axes('Position',[0 0 1 1]);
set(newaxesh,'XLim',[0 1],'YLim',[0 1]);
tx1=.10;
ty1=.09;
nowareakm3=TAUHGHSum3(framecounter,1);
nowareakm5=TAUHGHSum5(framecounter,1);
txtstr1=strcat('Date-',monthstr,'-',Yearstr,'-Area where COD>3 in km^2=',num2str(nowareakm3),...
    '-Area where COD>5 in km^2=',num2str(nowareakm5));
txt1=text(tx1,ty1,txtstr1,'FontWeight','bold','FontSize',10);
tx2=.10;
ty2=.06;
txtstr2=strcat('50 th ptile COD-',num2str(val50,3),...
    '-/99 ptile=',num2str(val99,3),'-max Tau=',num2str(maxtauvalue),'-for cloud type-',desc);
txt2=text(tx2,ty2,txtstr2,'FontWeight','bold','FontSize',10);
tx3=.10;
ty3=.03;
if(iFast==0)
    txtstr3=strcat('Number of grid points-',num2str(ibig),'-that exceeded min value of-',num2str(lowlim),'-all pts plotted');
else
    txtstr3=strcat('Number of grid points-',num2str(ibig),'-that exceeded min value of-',num2str(lowlim),...
        '-only-',num2str(ibig2),'-of-',num2str(ibig),'-total pts plotted to save time');
end
txt3=text(tx3,ty3,txtstr3,'FontWeight','bold','FontSize',10,'Color',[0 0 0]);
set(newaxesh,'Visible','Off');
pause(chart_time);
if(iMovie==1)
    frame=getframe(gcf);
    writeVideo(vTemp,frame);
end
% Save this chart is the user opts to 0=No save,1 save as a jpeg,2=perform
% a screen capture
figstr=strcat(titlestr,'.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
if(isaveJpeg==0)

elseif(isaveJpeg==1)
    actionstr='print';
    typestr='-djpeg';
    [cmdString]=MyStrcat2(actionstr,typestr,figstr);
    eval(cmdString);
elseif(isaveJpeg==2)
    imagedata=screencapture(gcf,[]);
    imwrite(imagedata,figstr)
end
%fprintf(fid,'%s\n','------- Finished Plotting Cloud Opacity High Clouds ------');
close('all');
end

