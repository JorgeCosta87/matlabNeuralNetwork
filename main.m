
loadImageSet1 = false;
loadImageSet2 = true;
loadImageSet3 = true;


pathToXls = '.\DataSet\ClassificaccaoFolhas.xlsx';

%estes dados têm de existir na main, e não faz sentido tar a carregar a mesma informação 3 vezes dentro do loadDataSets;

uniqueSpecies = uniqueSpeciesInVector(leafNames); 
uniqueSpeciesAndSubSpecies = uniqueSubSpeciesInVector(leafNames); 

if loadImageSet1
    imgSet = loadDataSets('.\DataSet\Folhas_1', pathToXls, 1, 'A2:B991');
    divide = false;
elseif loadImageSet2
    imgSet = loadDataSets('.\DataSet\Folhas_2', pathToXls, 1, 'A2:B991');
    divide = true;
end

dataInput  = [imgSet.binData]; 
dataTarget = [imgSet.speciesId];
%dataTarget = [imgSet.leaf_specie_subspecie];
dataTargetBin = targetToBinary (dataTarget);

if loadImageSet3
    imgSet3 = loadDataSets('.\DataSet\Folhas_3', pathToXls, 1, 'A2:B991');
    
    dataInput_3  = [imgSet3.binData]; 
    dataTarget_3 = [imgSet3.speciesId];
    dataTargetBin_3 = targetToBinary(dataTarget_3);
end
 

%********************* init and configure network ************************

%Configure net architecture
net = initNN({'logsig', 'tansig'}, [40]);

if divide == true
    net = configNNTrain(net, 'traingdx', 'dividerand', 0.70, 0.15, 0.15);
else
    net = configNNTrain(net, 'traingdx', '', 0, 0, 0);
end

%Config performance function
net.performFcn  = 'mse';

%config advance parms
net.trainParam.epochs         = 5000;
net.trainParam.goal           = 0;
net.trainParam.lr             = 0.001; % Learning rate % good results 0.0001;
net.trainParam.lr_inc         = 1.05;   %1.05 Ratio to increase learning rate
net.trainParam.lr_dec         = 0.7;    %0.7 Ratio to decrease learning rate
net.trainParam.max_fail       = 1000000;
net.trainParam.max_perf_inc   = 1.04;   % 1.04 Maximum performance increase
net.trainParam.mc             = 0.7;
net.trainParam.min_grad       = 1e-200;
net.trainParam.show           = 25;
net.trainParam.showCommandLine= false; 
net.trainParam.showWindow     = true;
net.trainParam.time           = inf;


%train the network
[net,tr] = train(net, dataInput, dataTargetBin);

view(net);
disp(tr)

% simulation
simOut = sim(net, dataInput);

% Show net performance and store info
showPerformance(net, simOut, dataInput, dataTargetBin, tr, true);

if loadImageSet3
    fprintf('\n******Testing data set 3*******\n');
    simOut = sim(net, dataInput_3);
    showPerformance(net, simOut, dataInput_3, dataTargetBin_3, tr, false);
end