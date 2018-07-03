
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% NN TESTS

 dataInput  = [imgSet.binData];
 dataTarget = [imgSet.speciesId];
 
 m = length(dataTarget);
 num_labels = max(dataTarget);
 
 y_vec = zeros(m, num_labels);
 
 idx = sub2ind(size(y_vec), 1:m, dataTarget);
 
 y_vec(idx) = 1;
 
 dataTarget = y_vec';

[net, train] = trainNN(dataInput, dataTarget);
 y = sim(net, dataInput  );
 y = round(y);
 
 x = size(y);
 k = 0;
 for i = 1 : x(2)
    if(y(i) == dataTarget(i))
    k = k + 1;
    end
 end
 
 sprintf('sifeof x = %d , k = %d, % =  ', x(2), k  )
 
   k*100/x(2) 
 plotconfusion(dataTarget, round(y) );
% 
% disp('NN TESTS')
% 
%   net = feedforwardnet;
%   net.trainFcn = 'traingdx';
%   net.trainParam.epochs  = 5000;
%   net.trainParam.goal = 1e-5;
%    net.trainParam.max_fail = 5000;
%  % net.divideFcn = '';  
% %  net.layers{1}.transferFcn = 'tansig';
%  net.divideFcn = 'dividerand';
%  net.divideParam.trainRatio = 0.70;
%  net.divideParam.valRatio = 0.15;
%  net.divideParam.testRatio = 0.15;
% 
% 
%   dataInput  = [imgSet2.binData];
%   dataTarget = [imgSet2.speciesId];
%   [net, tr]  = train(net, dataInput, dataTarget);
% 
% 
%   view(net);
%   disp(tr);
%   
%   
% y = sim(net, dataInput  );
% y = round(y);
% Mostrar resultado
%y = (y >= 0.5);
% fprintf('Saida da RN para  ');
% disp(round(y));
% fprintf('Saida desejada para ');
% disp(dataTarget);
 

% plotconfusion(dataTarget, round(y) );
