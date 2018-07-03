function [perf accuracyPred accuracyTrain] = showPerformance(net, simOutput, inputs, targets, tr, train)

    plotconfusion(targets, simOutput) % Matriz de confusao
    plotperf(tr)         % Grafico com o desempenho da rede nos 3 conjuntos          
  

    %simOutput = round(simOutput);

    %Calcula e mostra a percentagem de classificacoes corretas no total dos exemplos
    r=0;
    for i=1:size(simOutput,2)               % Para cada classificacao  
       %runs   
      [a b] = max(simOutput(:,i));          %b guarda a linha onde encontrou valor mais alto da saida obtida
      [c d] = max(targets(:,i));  %d guarda a linha onde encontrou valor mais alto da saida desejada
      if b == d                       % se estao na mesma linha, a classificacao foi correta (incrementa 1)
          r = r+1;
      end
    end

    accuracyPred = r/size(simOutput,2)*100;
    perf = perform(net, targets, simOutput); 
    ERR = simOutput - targets;
    err = mse(ERR);
    
    err_test = 0;
    accuracyTrain = 0;
    perf_test = 0;
    if train
        % SIMULAR A REDE APENAS NO CONJUNTO DE TESTE
        TInput = inputs(:, tr.testInd);
        TTargets = targets(:, tr.testInd);

        out = sim(net, TInput);

        %Calcula e mostra a percentagem de classificacoes corretas no conjunto de teste
        r=0;
        for i=1:size(tr.testInd,2)              % Para cada classificacao  
          [a b] = max(out(:,i));                %b guarda a linha onde encontrou valor mais alto da saida obtida
          [c d] = max(TTargets(:,i));           %d guarda a linha onde encontrou valor mais alto da saida desejada
          if b == d                             % se estao na mesma linha, a classificacao foi correta (incrementa 1)
              r = r+1;
          end
        end
        accuracyTrain = r/size(tr.testInd,2)*100;
        ERR = out - TTargets;
        err_test = mse(ERR);
        perf_test = perform(net, TTargets, out); 
    end

    fprintf('\nResults:\n');
    fprintf('\tperformance %f\n', perf)
    fprintf('\tError (mse) %f\n', err)
    fprintf('\taccuracy prediction %f\n', accuracyPred)
    
    if train
        fprintf('\n Test set results:\n');
        fprintf('\tperformance %f\n', perf_test)
        fprintf('\tError (mse) %f\n', err_test)
        fprintf('\taccuracy test  %f\n', accuracyTrain)
    end
end