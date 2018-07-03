function [ dataSet ] = loadDataSets(dataSetPath, xlsPath, xlsheetNum, xlsRange)
%SETPATHS Summary of this function goes here
%   Detailed explanation goes here

fprintf('Loading the XLS sheet %d, range %s on path: %s\n',xlsheetNum, xlsRange, xlsPath);

[leafIds, leafNames] =xlsread(xlsPath, xlsheetNum, xlsRange);
uniqueSpecies = uniqueSpeciesInVector(leafNames);

fprintf('Loading dataSet on path: %s\n\n', dataSetPath);
dataSet = LoadImages(dataSetPath , leafIds, leafNames, uniqueSpecies);

end

