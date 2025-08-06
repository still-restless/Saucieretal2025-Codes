%% CC23_2

% Permeability grid
opts = spreadsheetImportOptions("NumVariables", 9);
opts.Sheet = "CC23_2";
opts.DataRange = "A2:I7";
opts.VariableNames = ["Var1", "VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9"];
opts.SelectedVariableNames = ["VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9"];
opts.VariableTypes = ["char", "double", "double", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, "Var1", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "Var1", "EmptyFieldRule", "auto");
Grids = readtable("Grids.xlsx", opts, "UseExcel", false);
CC23_2 = table2array(Grids);
clear opts Grids

% Coordinates
opts = delimitedTextImportOptions("NumVariables", 2);
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["X", "Y"];
opts.VariableTypes = ["double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
tbl = readtable("CC23_2_9550_Coordinates.csv", opts);
x = tbl.X;
y = tbl.Y;
X = reshape(x,size(CC23_2'));
CC23_2_X = X';
Y = reshape(y,size(CC23_2'));
CC23_2_Y = Y';
clear opts tbl x y X Y

%% LV23_1

% Permeability grid
opts = spreadsheetImportOptions("NumVariables", 8);
opts.Sheet = "LV23_1";
opts.DataRange = "A2:H6";
opts.VariableNames = ["Var1", "VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8"];
opts.SelectedVariableNames = ["VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8"];
opts.VariableTypes = ["char", "double", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, "Var1", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "Var1", "EmptyFieldRule", "auto");
GridsS2 = readtable("Grids.xlsx", opts, "UseExcel", false);
LV23_1 = table2array(GridsS2);
clear opts GridsS2

% Coordinates
opts = delimitedTextImportOptions("NumVariables", 2);
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["X", "Y"];
opts.VariableTypes = ["double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
tbl = readtable("LV23_1_9615_Coordinates.csv", opts);
x = tbl.X;
y = tbl.Y;
X = reshape(x,size(LV23_1'));
LV23_1_X = X';
Y = reshape(y,size(LV23_1'));
LV23_1_Y = Y';
clear opts tbl x y X Y

%% CC23_4

% Permeability grid
opts = spreadsheetImportOptions("NumVariables", 8);
opts.Sheet = "CC23_4";
opts.DataRange = "A2:H6";
opts.VariableNames = ["Var1", "VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8"];
opts.SelectedVariableNames = ["VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8"];
opts.VariableTypes = ["char", "double", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, "Var1", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "Var1", "EmptyFieldRule", "auto");
GridsS3 = readtable("Grids.xlsx", opts, "UseExcel", false);
CC23_4 = table2array(GridsS3);
clear opts GridsS3

% Coordinates
opts = delimitedTextImportOptions("NumVariables", 2);
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["X", "Y"];
opts.VariableTypes = ["double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
tbl = readtable("CC23_4_9618_Coordinates.csv", opts);
x = tbl.X;
y = tbl.Y;
X = reshape(x,size(CC23_4'));
CC23_4_X = X';
Y = reshape(y,size(CC23_4'));
CC23_4_Y = Y';
clear opts tbl x y X Y

%% LV23_2

% Permeability grid
opts = spreadsheetImportOptions("NumVariables", 7);
opts.Sheet = "LV23_2";
opts.DataRange = "A5:G9";
opts.VariableNames = ["Var1", "VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7"];
opts.SelectedVariableNames = ["VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7"];
opts.VariableTypes = ["char", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, "Var1", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "Var1", "EmptyFieldRule", "auto");
GridsS4 = readtable("Grids.xlsx", opts, "UseExcel", false);
LV23_2 = table2array(GridsS4);
clear opts GridsS4

% Coordinates
opts = delimitedTextImportOptions("NumVariables", 2);
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["X", "Y"];
opts.VariableTypes = ["double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
tbl = readtable("LV23_2_9626_Coordinates.csv", opts);
x = tbl.X;
y = tbl.Y;
X = reshape(x,size(LV23_2'));
LV23_2_X = X';
Y = reshape(y,size(LV23_2'));
LV23_2_Y = Y';
clear opts tbl x y X Y

%% CC23_3

% Coordinates and Permeability vectors
opts = delimitedTextImportOptions("NumVariables", 4);
opts.DataLines = [2, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["X", "Y", "grid_ID", "Perm"];
opts.VariableTypes = ["double", "double", "string", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts = setvaropts(opts, "grid_ID", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "grid_ID", "EmptyFieldRule", "auto");
tbl = readtable("CC23_3_9567_Coordinates.csv", opts);
CC23_3_X = tbl.X;
CC23_3_Y = tbl.Y;
CC23_3_grid_ID = tbl.grid_ID;
CC23_3 = tbl.Perm;
clear opts tbl

%% Small Grids
opts = spreadsheetImportOptions("NumVariables", 5);
opts.Sheet = "cm";
opts.DataRange = "A2:E6";
opts.VariableNames = ["Var1", "VarName2", "VarName3", "VarName4", "VarName5"];
opts.SelectedVariableNames = ["VarName2", "VarName3", "VarName4", "VarName5"];
opts.VariableTypes = ["char", "double", "double", "double", "double"];
opts = setvaropts(opts, "Var1", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "Var1", "EmptyFieldRule", "auto");
GridsS5 = readtable("Grids.xlsx", opts, "UseExcel", false);
cm = table2array(GridsS5);
clear opts


opts = delimitedTextImportOptions("NumVariables", 2);
opts.DataLines = [1, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["X", "Y"];
opts.VariableTypes = ["double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
tbl = readtable("SmallGrid_Coordinates.csv", opts);
x = tbl.X;
y = tbl.Y;
X = reshape(x,size(cm'));
cm_X = X';
Y = reshape(y,size(cm'));
cm_Y = Y';
clear opts tbl x y X Y