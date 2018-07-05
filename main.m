


loadImageSet1 = true;
loadImageSet2 = false;
loadImageSet3 = false;
species = true;         %species(true) or supspcieces(false)
loadNN = false;
imageFeatures = false;


%uniqueSpecies = uniqueSpeciesInVector(leafNames); 
%uniqueSpeciesAndSubSpecies = uniqueSubSpeciesInVector(leafNames); 

reportN = 1;
maxReports = 100;
reportName = ['report', num2str(reportN)];
filename = ['Results\',reportName, '.xlsx'];

for i = 1 : maxReports
    if exist(filename, 'file') == 2
         reportN = reportN + 1;         
         reportName = ['report', num2str(reportN)];
         filename = ['Results\',reportName, '.xlsx'];
         break;
    end
end



id = 1;
dataSetName = '';
expType = '';
pathToXls = '.\DataSet\ClassificaccaoFolhas.xlsx';

if loadImageSet1
    imgSet = loadDataSets('.\DataSet\Folhas_1', pathToXls, 1, 'A2:B991');
    divide = false;
    dataSetName = 'Folhas_1';
elseif loadImageSet2
    imgSet = loadDataSets('.\DataSet\Folhas_2', pathToXls, 1, 'A2:B991');
    divide = true;
    dataSetName = 'Folhas_2';
end

if loadImageSet3
    imgSet = loadDataSets('.\DataSet\Folhas_3', pathToXls, 1, 'A2:B991');
    dataSetName = 'Folhas_3';
    divide = false;
    
    %dataTargetBin_3 = targetToBinary(dataTarget);
end

if species
    dataTarget = [imgSet.speciesId];
    expType = 'species';
else
     dataTarget = [imgSet.subSpeciesId];
     expType = 'subSpecies';
end

if imageFeatures
    dataInput  = [imgSet.charcAsVec];
else
    dataInput  = [imgSet.binData];
end

dataTargetBin = targetToBinary (dataTarget);


%LOAD exp parms

pathToXlsExp = '.\nnTestParms_2.xlsx';

sheetNum = 1;
xlsRange = 'A2:O78';

disp('Loading the XLS');
[num, text, raw] = xlsread(pathToXlsExp, sheetNum, xlsRange);


numExps = size(raw,1);
numRep  = 3;
layerFnc = "";
layerSize = 10;

for i = 1 : numExps
    
    %load exp parms
    layerFnc(1)     = raw{i,2};
    layerSize(1)    = raw{i,3};
    layerFnc(2) = raw{i,4};
    
    if~isnan(raw{i,5})
        layerSize(2)    = raw{i,5};
    end
    if~isnan(raw{i,6})
        layerFnc(3) = raw{i,6};
    end
    
    if  ~isnan(raw{i,7})
        layerSize(3)    = raw{i,7};
    end
    
    if~isnan(raw{i,8})
      layerFnc(4) = raw{i,8};
    end
    
    if~isnan(raw{i,9})
          layerSize(4)    = raw{i,9};
    end

    trainFcn = raw{i,10};
    epochs   = raw{i,11};
    lr       = raw{i,12};
    mc       = raw{i,13};
    sigma    = raw{i,14};
    lambda   = raw{i,15};


    
    for j = 1 : numRep
    
        %********************* init and configure network ************************

        if loadNN
            
        else
            %Configure net architecture
            %{'logsig', 'tansig'}
            net = initNN(layerFnc, layerSize);

            if divide == true
                net = configNNTrain(net, trainFcn, 'dividerand', 0.70, 0.15, 0.15);
            else
                net = configNNTrain(net, trainFcn, '', 0, 0, 0);
            end

            %Config performance function
            net.performFcn  = 'mse';

            %These properties define the algorithms to use when a network is to adapt,
            %is to be initialized, is to have its performance measured, or is to be trained.
           % disp(net.adaptFcn)
           
            %config advance parms
            net.trainParam.epochs         = epochs;
            net.trainParam.goal           = 0;
            net.trainParam.lr             = lr; % Learning rate % good results 0.0001;
            net.trainParam.lr_inc         = 1.05;   %1.05 Ratio to increase learning rate
            net.trainParam.lr_dec         = 0.7;    %0.7 Ratio to decrease learning rate
            net.trainParam.max_fail       = 1000000;
            net.trainParam.max_perf_inc   = 1.04;   % 1.04 Maximum performance increase
            net.trainParam.mc             = mc;
            net.trainParam.min_grad       = 1e-200;
            net.trainParam.show           = 25;
            net.trainParam.showCommandLine= false; 
            net.trainParam.showWindow     = true;
            net.trainParam.time           = inf;
            net.trainParam.sigma          = sigma; % 5.0e-5
            net.trainParam.lambda         = lambda; % 5.0e-7
           
        end

        %train the network
        [net,tr] = train(net, dataInput, dataTargetBin);
        %view(net);
        
        % simulation
        simOut = sim(net, dataInput);

        % Show and save net performance results
        showPerformance(net, simOut, filename, reportN, numRep, dataInput, dataTargetBin, tr, true, dataSetName, expType,  i, j);
    end
end

if loadImageSet3
    fprintf('\n******Testing data set 3*******\n');
    simOut = sim(net, dataInput_3);
    showPerformance(net, simOut, dataInput_3, dataTargetBin_3, tr, false, dataSetName);
end