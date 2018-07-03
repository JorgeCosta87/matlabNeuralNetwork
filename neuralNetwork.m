function [rNet, tr, perf, accuracyPred, accuracyTrain] = neuralNetwork(inputs, targets, divide)


% layers = [imageInputLayer([28 28 1]), 10]
%convnet = trainNetwork(trainDigitData,layers,options);     
%    dividerand
    net = iniNN({'logsig', 'logsig', 'tansig'}, [34, 34]);   
    if divide == true
        net = configNNTrain(net, 'traingdx', 'dividerand', 0.70, 0.15, 0.15);
    else
         net = configNNTrain(net, 'traingdx', '', 0, 0, 0);
    end
    
%net.trainFcn = 'traingdx';
  
    net.trainParam.epochs         = 20000;
    net.trainParam.goal           = 0;
    net.trainParam.lr             = 0.0001; % Learning rate
    net.trainParam.lr_inc         = 1.05;   %1.05 Ratio to increase learning rate
    net.trainParam.lr_dec         = 0.7;    %0.7 Ratio to decrease learning rate
    net.trainParam.max_fail       = 5000;
    net.trainParam.max_perf_inc   = 1.04;   % 1.04 Maximum performance increase
    net.trainParam.mc             = 0.9;
    net.trainParam.min_grad       = 1e-200;
    net.trainParam.show           = 25;
    net.trainParam.showCommandLine= false; 
    net.trainParam.showWindow     = true;
    net.trainParam.time           = inf;
    
    
    disp(net.performFcn);
    %net.performFcn  = 'crossentropy';	
    
    %options = trainingOptions('sgdm',...
    %'LearnRateSchedule','piecewise',...
    %'LearnRateDropFactor',0.2,...
    %'LearnRateDropPeriod',5,...
    %'MaxEpochs',20,...
    %'MiniBatchSize',64,...
    %'Plots','training-progress')
    
    %train the network
    [net,tr] = train(net, inputs, targets);

    view(net);

    
    
    % simulation
    simOut = sim(net, inputs);

    [perf accuracyPred, accuracyTrain] = showPerformance(net, simOut, inputs, targets, tr);

    rNet = net;
end

function rNet = iniNN(layersFCN, layersSize)

%Funções de ativação das camadas escondidas e da camada de saída. Para alterar a função de
%ativação da camada y na rede net deve utilizar-se a instrução:

    net = feedforwardnet(layersSize);
    net.numLayers = length(layersFCN);

    disp(net.outputs);
    
    for i = 1 : length(layersFCN)
        net.layers{i}.transferFcn =  char(layersFCN(i)); %layersFCN(i);
    end

%This property defines the function used to initialize 
%the network's weight matrices and bias vectors. . The initialization function is used to initialize the network whenever init is called:
% net = init(net);

    rNet = net;
end

 function rNet = configNNTrain(net, trainFcn, divideFcn, trainRatio, valRatio, testRatio)

%Função de treino da rede neuronal. A função de treino da rede net pode ser indicada na
%criação da rede ou através da instrução: net.trainFcn = trainFcn
    net.trainFcn = trainFcn;
    
%Divisão dos exemplos. A função de divisão por defeito (dividerand) cria os 3 conjuntos de
%treino, validação e teste, respetivamente, com 70%, 15% e 15% dos exemplos. Estes valores
%podem ser alterados através das variáveis pertencentes ao objeto net.divideParam.

    if isempty(divideFcn)
        net.divideFcn = divideFcn;
    else
        net.divideFcn = divideFcn;
        net.divideParam.trainRatio   = trainRatio;
        net.divideParam.valRatio     = valRatio;
        net.divideParam.testRatio    = testRatio;
    end
   
   rNet = net;
 end

 function rNet = configureAdvanceOptions(net, epochs, goal, max_fail, min_grad, mu, mu_dec, mu_inc, mu_max, show,...
                                  showCommandLine, showWindow, time)
                              
    net.trainParam.epochs   = epochs;   % Maximum number of epochs to train
    net.trainParam.goal     = goal;     %Performance goal
    net.trainParam.max_fail = max_fail; %Maximum validation failures
    net.trainParam.min_grad = min_grad; %Minimum performance gradient
    net.trainParam.mu       = mu;       %Initial Mu
    net.trainParam.mu_dec   = mu_dec;   %Mu decrease factor
    net.trainParam.mu_inc   = mu_inc;   %Mu increase factor
   % net.trainParam.mu_max   = mu_max;   %Maximum Mu
    net.trainParam.show     = show;     %Epochs between displays
    net.trainParam.showCommandLine  = showCommandLine;  %Generate command-line output
    net.trainParam.showWindow       = showWindow;       %Show training GUI
    net.trainParam.time             = time;             %Maximum time to train in seconds)
    
    rNet = net;
 end

