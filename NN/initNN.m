%initNN:
% initialize and Config the architecture of the neural netork
%  
%INPUT:
%   [layersFCN] - activation functions
%   [layersSize] - hidden layers neurons
%
%OUTPUT: 
%   rNet = neural network
%

function net = initNN(layersFCN, layersSize)

    net = feedforwardnet(layersSize);
    net.numLayers = length(layersFCN);
    
    for i = 1 : length(layersFCN)
        net.layers{i}.transferFcn =  char(layersFCN(i)); %layersFCN(i);
    end

%This property defines the function used to initialize 
%the network's weight matrices and bias vectors. . The initialization function is used to initialize the network whenever init is called:
    net = init(net);

end