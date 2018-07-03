function [perf accuracyPred accuracyTrain] = showPerformance(net, simOutput, inputs, targets, tr)

    plotconfusion(targets, simOutput) % Matriz de confusao

    plotperf(tr)         % Grafico com o desempenho da rede nos 3 conjuntos          
    perf = perform(net, targets, simOutput) 

%     simOutput = round(simOutput);

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
%     fprintf('Precisao total %f\n', accuracyPred)


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
%     fprintf('Precisao teste %f\n', accuracyTrain)
end