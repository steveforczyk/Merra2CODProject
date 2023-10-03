function [ filelines ] = file2cell(filename,comments_removed)
% Reads a text file and puts content in a celltable
% Revised: Feb 20,2017 code clean up
fid = fopen(filename,'r');
if fid < 0
    error(horzcat('Error opening ',filename));
end

if comments_removed
    C = textscan(fid,'%s','delimiter','\n','commentstyle','%');
else
    C = textscan(fid,'%s','delimiter','\n');
end

filelines = C{1};

fclose(fid);






