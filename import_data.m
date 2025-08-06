clear all
close all
clc

%% import pycnometer data
cd Pycometer/
filesinfolder = ls('*.XLS');
for n = 1:length(filesinfolder)
    filename = filesinfolder(n,:);
    file = char(filename);
    try
    Pycnometer.(file(1:7)).rawdata = importfile(file, "Sheet1", [28, 37]);
    catch
        file
    end
end

clear file filename filesinfolder n

cd ..

%% import permeamter data
cd Permeameter\

filesinfolder = ls('*.xlsx');
for n = 1:length(filesinfolder)
    filename = filesinfolder(n,:);
    file = char(filename);
    try
    Permeameter.(file(1:7)).rawdata = importfile2(file, "Sheet1", [2, Inf]);
    catch
        file
    end
end
clear file filename filesinfolder n

%% import weight and dimension data
cd ..
opts = spreadsheetImportOptions("NumVariables", 5);
opts.Sheet = "Sheet1";
opts.DataRange = "A1:E15";
opts.VariableNames = ["sampleId", "weightg", "lengthmm", "diametermm", "geometricVolumecm3"];
opts.VariableTypes = ["string", "double", "double", "double", "double"];
opts = setvaropts(opts, "sampleId", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "sampleId", "EmptyFieldRule", "auto");
Weight_and_Size = readtable("CC_Samples_m_l_r.xlsx", opts, "UseExcel", false);
clear opts

% 
%% Local Function
function [Helium1] = importfile(workbookFile, sheetName, dataLines)
    if nargin == 1 || isempty(sheetName)
        sheetName = 1;
    end
    if nargin <= 2
        dataLines = [28, 37];
    end
    opts = spreadsheetImportOptions("NumVariables", 1);
    opts.Sheet = sheetName;
    opts.DataRange = "G" + dataLines(1, 1) + ":G" + dataLines(1, 2);
    opts.VariableNames = "Helium1";
    opts.VariableTypes = "string";
    opts = setvaropts(opts, "Helium1", "WhitespaceRule", "preserve");
    opts = setvaropts(opts, "Helium1", "EmptyFieldRule", "auto");
    tbl = readtable(workbookFile, opts, "UseExcel", false);
    for idx = 2:size(dataLines, 1)
        opts.DataRange = "G" + dataLines(idx, 1) + ":G" + dataLines(idx, 2);
        tb = readtable(workbookFile, opts, "UseExcel", false);
        tbl = [tbl; tb]; %#ok<AGROW>
    end
    Helium1 = str2num(char(tbl.Helium1));
end

function CC232a = importfile2(workbookFile, sheetName, dataLines)
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end
if nargin <= 2
    dataLines = [2, Inf];
end
opts = spreadsheetImportOptions("NumVariables", 7);
opts.Sheet = sheetName;
opts.DataRange = dataLines(1, :);
opts.VariableNames = ["Timesec", "Flow_Rate_2L", "Flow_Rate_50ml", "ConfiningPressureMPa", "Upstream_Pressure_MPa", "ConfiningPressurepsi", "UpstreamPressure_psi"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double"];
CC232a = readtable(workbookFile, opts, "UseExcel", false);
for idx = 2:size(dataLines, 1)
    opts.DataRange = dataLines(idx, :);
    tb = readtable(workbookFile, opts, "UseExcel", false);
    CC232a = [CC232a; tb]; %#ok<AGROW>
end
end