function [outString]=MyStrcat2(actionstr,typestr,filestr)
spacestr=char(32);
actionlen=length(actionstr);
typelen=length(typestr);
filelen=length(filestr);
cmdlen=actionlen+filelen+typelen+2;
outString(1:actionlen)=actionstr;
nowpos=actionlen+1;
outString(nowpos)=spacestr;
nowpos=nowpos+1;
outString(nowpos:nowpos+typelen-1)=typestr;
nowpos=nowpos+typelen;
outString(nowpos:nowpos)=spacestr;
nowpos=nowpos+1;
outString(nowpos:cmdlen)=filestr;
