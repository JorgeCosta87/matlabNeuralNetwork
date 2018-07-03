function [net, tr] = trainNN(dataInput, dataTarget)

    net = feedforwardnet(10);
    
   net.trainFcn = 'traingdx'; %'trainscg';
   net.trainParam.epochs  = 5000;
   net.trainParam.goal = 1e-5;
   net.trainParam.max_fail = 5000;
%  net.divideFcn = '';  
%  net.layers{1}.transferFcn = 'tansig';
%  net.performFcn = 'crossentropy';
   net.divideFcn = 'dividerand';
   net.divideParam.trainRatio  = 0.70;
   net.divideParam.valRatio    = 0.15;
   net.divideParam.testRatio   = 0.15;
%   
    [net, tr]  = train(net, dataInput, dataTarget); 
    
    view(net);
    %disp(tr);

 