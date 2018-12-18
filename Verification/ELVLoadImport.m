function Loadprofile = ELVLoadImport(filename, startRow, endRow)
%ELVLoadImport Import numeric data from a text file as a matrix.
%   LOADPROFILE = ELVLoadImport(FILENAME) Reads data from text file FILENAME
%   for the default selection.
%
%   LOADPROFILE = ELVLoadImport(FILENAME, STARTROW, ENDROW) Reads data from
%   rows STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   Loadprofile = ELVLoadImport('Load_profile_1.csv', 2, 1441);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2018/12/18 15:05:40 (with modifications by BanjoBiceps 2018/12/18

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Format for each line of text:
formatSpec = '%*s%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    dataArray{1} = [dataArray{1};dataArrayBlock{1}];
end

%% Close the text file.
fclose(fileID);

%% Create output variable
Loadprofile = [dataArray{1:end-1}];