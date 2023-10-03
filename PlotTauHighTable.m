function PlotTauHighTable(titlestr,ikind,iAddToReport,iNewChapter,iCloseChapter)
% This function is plots the TAUGHGH variable which is the high cloud extinction data
% 
% Written By: Stephen Forczyk
% Created: Aug 20,2023
% Revised: ----

% Classification: Public Domain
global YearMonthStr YearStr MonthStr framecounter numSelectedFiles;
global ROIArea ROIPts ROIFracPts numgridpts Merra2WorkingMask;
global Merra2FileName Merra2ShortFileName Merra2Dat;
global RasterLats RasterLons Rpix RasterAreaGrid;
global idebug iframecounter numSelectedFiles;
global LonS LatS TAUHGHS TAUHGHVals TimeS Longitudes Latitudes;
global YearMonthDayStr1 YearMonthDayStr2 YearMonthStr;
global TAUHGHSum1 TAUHGHSum2 TAUHGHSum3 TAUHGHSum4 TAUHGHSum5;
global TAUHGHTable TAUHGHTT;
global iLogo LogoFileName1 LogoFileName2;
global Years Months Days;

global fid;
global widd2 lend2;
global initialtimestr igrid ijpeg ilog imovie;
global vert1 hor1 widd lend;
global vert2 hor2 machine;
global chart_time;
global Fz1 Fz2;
global idirector mov izoom iwindow;
global vTemp TempMovieName iMovie;
global RptGenPresent iCreatePDFReport pdffilename rpt chapter tocc lof lot;

global matpath datapath;
global jpegpath tiffpath moviepath savepath;
global excelpath ascpath citypath tablepath;
global ipowerpoint PowerPointFile scaling stretching padding;
global ichartnum;
global ColorList RGBVals ColorList2 xkcdVals LandColors;
global orange bubblegum brown brightblue;
% additional paths that might be needed for mapping
global matpath1 mappath matlabpath USshapefilepath;
global northamericalakespath logpath pdfpath govjpegpath;
global mappath ;
global DayMonthNonLeapYear DayMonthLeapYear CalendarFileName;

if((iCreatePDFReport==1) && (RptGenPresent==1))
    import mlreportgen.dom.*;
    import mlreportgen.report.*;
end
% Move the focus to the jpegpath 
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
movie_figure1=figure('position',[hor1 vert1 widd lend]);
set(gcf,'MenuBar','none');
if(ikind==1)
    plot(TAUHGHTT.Time,TAUHGHTT.TAUHGHSum1,'b',TAUHGHTT.Time,TAUHGHTT.TAUHGHSum2,'g',...
        TAUHGHTT.Time,TAUHGHTT.TAUHGHSum3,'k',TAUHGHTT.Time,TAUHGHTT.TAUHGHSum4,'c',...
        TAUHGHTT.Time,TAUHGHTT.TAUHGHSum5,'r'); 

end
set(gcf,'Position',[hor1 vert1 widd lend])
set(gca,'FontWeight','bold');
set(gca,'XGrid','on','YGrid','on');
if(ikind==1)
    hl=legend('COD>1','COD>2','COD>3','COD>4','COD>5');
end

ht=title(titlestr);
xlabel('Date','FontWeight','bold','FontSize',12);
if(ikind==1)
    ylabel('TAUHGH-km^2','FontWeight','bold','FontSize',12); 

end
% Add a logo
if(iLogo==1)
    eval(['cd ' govjpegpath(1:length(govjpegpath)-1)]);
    ha =gca;
    uistack(ha,'bottom');
    haPos = get(ha,'position');
    ha2=axes('position',[haPos(1)+.7,haPos(2)-.10, .1,.04,]);
    [x, ~]=imread(LogoFileName1);
    imshow(x);
    set(ha2,'handlevisibility','off','visible','off')
end
figstr=strcat(titlestr,'.jpg');
eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
actionstr='print';
typestr='-djpeg';
[cmdString]=MyStrcat2(actionstr,typestr,figstr);
eval(cmdString);
%% This section not functional-Do Not Use
if((iCreatePDFReport==1) && (RptGenPresent==1)  && (iAddToReport==1)) % Do not Run this-NOT Ready!!!!
    if(iNewChapter)
        headingstr1=strcat('Tabular Analysis Results For  Dust Data For-',DustROICountry);
        chapter = Chapter("Title",headingstr1);
    end
    if(ikind==1)
        sectionstr=strcat('Dust Emission-',DustROICountry,'-Map');

    end    
    add(chapter,Section(sectionstr));
    eval(['cd ' jpegpath(1:length(jpegpath)-1)]);
    imdata = imread(figstr);
    [nhigh,nwid,~]=size(imdata);
    image = mlreportgen.report.FormalImage();
    image.Image = which(figstr);
    pdftxtstr=strcat(' Dust Emission All Bins-',Merra2ShortFileName);
    pdftext = Text(pdftxtstr);
    pdftext.Color = 'red';
    image.Caption = pdftext;
    nhighs=floor(nhigh/2.5);
    nwids=floor(nwid/2.5);
    heightstr=strcat(num2str(nhighs),'px');
    widthstr=strcat(num2str(nwids),'px');
    image.Height = heightstr;
    image.Width = widthstr;
    image.ScaleToFit=0;
    add(chapter,image);
% Now add some text -start by decribing the with a basic description of the
% variable being plotted
    parastr1=strcat('The data for this chart was taken from file-',Merra2ShortFileName,'.');
    if(ikind==1)
        parastr2='This is the sum of Dust Emissions over the study period.';
        parastr3=' Each of the 5 bins are treated separately with the particle size increasing from Bin 1 thru Bin 5.';
        parastr4=' The Emission values are for the selected country.';
        parastr5=' Dust Emission affects the energy balance of the earth.';

    end
    parastr9=strcat(parastr1,parastr2,parastr3,parastr4,parastr5);
    p1 = Paragraph(parastr9);
    p1.Style = {OuterMargin("0pt", "0pt","10pt","10pt")};
    add(chapter,p1);
     if(ikind==1)
        br = PageBreak(); 
        add(chapter,br);
        LeftCol= char(DustEmissionAllTT.Properties.RowTimes);
% Now convert the Left Column to a cell
        [nrows,ncols]=size(LeftCol);
% Now convert this to Year Month Day format in 3 columns
        Years=zeros(nrows,1);
        Months=zeros(nrows,1);
        Days=zeros(nrows,1);
        for n=1:nrows
            nowStr=LeftCol(n,1:ncols);
            daystr=nowStr(1:2);
            monthstr=nowStr(4:6);
            yearstr=nowStr(8:11);
            daynum=str2double(daystr);
            [monthnum] = ConvertMonthStrToNumber(monthstr);
            yearnum=str2double(yearstr);
            Years(n,1)=yearnum;
            Months(n,1)=monthnum;
            Days(n,1)=daynum;
        end
        Hdrs=cell(1,9);
        Hdrs{1,1}='Years';
        Hdrs{1,2}='Months';
        Hdrs{1,3}='Days';
        Hdrs{1,4}='Bin001';
        Hdrs{1,5}='Bin002';
        Hdrs{1,6}='Bin003';
        Hdrs{1,7}='Bin004';
        Hdrs{1,8}='Bin005';
        Hdrs{1,9}='SUM';
        Col1=DustEmissionAllTable.Bin001;
        Col2=DustEmissionAllTable.Bin002;
        Col3=DustEmissionAllTable.Bin003;
        Col4=DustEmissionAllTable.Bin004;
        Col5=DustEmissionAllTable.Bin005;
        Col6=DustEmissionAllTable.Sum;
        myCellArray=cell(nrows,6);
        myArray=[Years,Months,Days,Col1,Col2,Col3,Col4,Col5,Col6];
        for i=1:nrows
            myCellArray{i,1}=Years(i,1);
            myCellArray{i,2}=Months(i,1);
            myCellArray{i,3}=Days(i,1);
            for j=1:6
                myCellArray{i,j+3}=myArray(i,j+3);
                
            end
        end
        T1=[Hdrs;myCellArray];
        tbl1=Table(T1);
        tbl1.Style = [tbl1.Style {Border('solid','black','3px'),...
            NumberFormat("%4.3f")}];
        tbl1.TableEntriesHAlign = 'center';
        tbl1.HAlign='center';
        tbl1.ColSep = 'single';
        tbl1.RowSep = 'single';
        r = row(tbl1,1);
        r.Style = [r.Style {Color('red'),Bold(true)}];
        bt1 = BaseTable(tbl1);
        tabletitlestr=strcat('Merra2 Daily Dust Emission For-',DustROICountry);
        tabletitle = Text(tabletitlestr);
        tabletitle.Bold = false;
        bt1.Title = tabletitle;
        bt1.TableWidth="7in";
        add(chapter,bt1);
        parastr601='The table above shows the distribution of the DustEmissionAllTable over the selected date range.';
        parastr602=strcat(' DustEmissionAll is the sum for a single country-',DustROICountry,'-over the specified time period of the files ');
        parastr603=strcat(' Typical values are on the order of TGrams/day and the country in question has-',num2str(ROIFracPts,4),'-of all grid points.');
        parastr604=' A diurnal cycle is generally observed for these emissions.';
        parastr605=' The current table shows the summation for each day using the 24 - 1 hour time slices.';
        parastr606=' Last column of the table displays the sum of all emissions in all 5 bins.';
        parastr609=strcat(parastr601,parastr602,parastr603,parastr604,parastr605,parastr606);
        p609= Paragraph(parastr609);
        p609.Style = {OuterMargin("0pt", "0pt","20pt","10pt")};
        add(chapter,p609);

     end

    if(iCloseChapter==1)
        add(rpt,chapter);
    end
    
end
close('all');
end