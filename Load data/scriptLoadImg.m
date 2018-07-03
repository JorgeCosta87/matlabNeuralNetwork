pathToImgSet1 = '.\DataSet\Folhas_1';
pathToImgSet2 = '.\DataSet\Folhas_2';
pathToImgSet3 = '.\DataSet\Folhas_3';

pathToXls = '.\DataSet\ClassificaccaoFolhas.xlsx';

sheetNum = 1;
xlsRange = 'A2:B991';

disp('Loading the XLS');
[leafIds, leafNames] =xlsread(pathToXls, sheetNum, xlsRange);

uniqueSpecies = uniqueSpeciesInVector(leafNames);

% disp('Loading the image set ')
% imgSet = LoadImages(pathToImgSet1 , leafIds, leafNames, uniqueSpecies);

% 
disp('Loading the image set ')
imgSet = LoadImages(pathToImgSet2 , leafIds, leafNames, uniqueSpecies);

disp('Loading the image set ')
imgSet3 = LoadImages(pathToImgSet3 , leafIds, leafNames, uniqueSpecies);
%  
