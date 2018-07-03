function binTargets =targetToBinary(dataTarget)

 % target to binary
 m = length(dataTarget);
 num_labels = max(dataTarget);
 y_vec = zeros(m, num_labels);
 idx = sub2ind(size(y_vec), 1:m, dataTarget);
 y_vec(idx) = 1;
 binTargets = y_vec';

end