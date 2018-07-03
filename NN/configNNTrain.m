%initNN:
% initialize and Config the architecture of the neural netork
%  
%INPUT:
%   trainFcn    - train function
%   divideFcn   - divide function
%   trainRatio  -
%   valRatio    -
%   testRatio   -
%
%OUTPUT: 
%   net = neural network

function net = configNNTrain(net, trainFcn, divideFcn, trainRatio, valRatio, testRatio)

    net.trainFcn = trainFcn;
    
    if isempty(divideFcn)
        net.divideFcn = divideFcn;
    else
        net.divideFcn = divideFcn;
        net.divideParam.trainRatio   = trainRatio;
        net.divideParam.valRatio     = valRatio;
        net.divideParam.testRatio    = testRatio;
    end
end

