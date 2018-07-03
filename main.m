
 scriptLoadImg

 dataInput  = [imgSet.binData];
 dataTarget = [imgSet.speciesId];
 
 
 % target to binary
 m = length(dataTarget);
 num_labels = max(dataTarget);
 y_vec = zeros(m, num_labels);
 idx = sub2ind(size(y_vec), 1:m, dataTarget);
 y_vec(idx) = 1;
 dataTarget = y_vec';
 
% run NN
[net, tr, perf_1, accuracyPred_1, accuracyTrain_1]  = neuralNetwork(dataInput, dataTarget, true);
disp(tr)

% dataInput  = [imgSet3.binData];
% dataTarget = [imgSet3.speciesId];
% 
% % target to binary
% m = length(dataTarget);
% num_labels = max(dataTarget);
% y_vec = zeros(m, num_labels);
% idx = sub2ind(size(y_vec), 1:m, dataTarget);
% y_vec(idx) = 1;
% dataTarget = y_vec';
% 
% [net_2, tr_2, perf_2, accuracyPred_2, accuracyTrain_2]  = neuralNetwork(dataInput, dataTarget, false);
% disp(tr_2)

fprintf('pref 1 %f\n', perf_1)
fprintf('accuracy pred 1 %f\n', accuracyPred_1)
fprintf('accuracy total 1 %f\n', accuracyTrain_1)
% fprintf('Perf: 2 %f\n', perf_2)
% fprintf('accuracy total 2 %f\n', accuracyPred_2)
% fprintf('accuracy total 2 %f\n', accuracyTrain_2)