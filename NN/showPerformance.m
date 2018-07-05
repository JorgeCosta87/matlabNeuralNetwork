function showPerformance(net, simOutput, filename, reportN, numRep, inputs, targets, tr, train, dataSetName, expType, expid, exprep)

      
  

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
    outTest = 0;
    TTargets = 0;
    
    if train
        % Test
        TInput = inputs(:, tr.testInd);
        TTargets = targets(:, tr.testInd);

        outTest = sim(net, TInput);

        %Calcula e mostra a percentagem de classificacoes corretas no conjunto de teste
        r=0;
        for i=1:size(tr.testInd,2)              % Para cada classificacao  
          [a b] = max(outTest(:,i));                %b guarda a linha onde encontrou valor mais alto da saida obtida
          [c d] = max(TTargets(:,i));           %d guarda a linha onde encontrou valor mais alto da saida desejada
          if b == d                             % se estao na mesma linha, a classificacao foi correta (incrementa 1)
              r = r+1;
          end
        end
        accuracyTrain = r/size(tr.testInd,2)*100;
        ERR = outTest - TTargets;
        err_test = mse(ERR);
        perf_test = perform(net, TTargets, outTest); 
    end
    
   [id] = saveToXls(net, tr, filename, reportN, numRep, expid, exprep, dataSetName, size(inputs,2), expType, targets, accuracyPred, accuracyTrain)

    graphName = [id, num2str(reportN)];
    filename = ['Results\',graphName, '.png'];
    
    %plotconfusion(targets, simOutput) % Matriz de confusao
    
    

    plotperf(tr) % Grafico com o desempenho da rede nos 3 conjuntos    
    graphName = [num2str(reportN), '_',id, '_perf'];
    filename = ['Results\Graphs\',graphName, '.png'];
    saveas(gcf,filename);
    close(gcf);
    
    plottrainstate(tr);
    graphName = [num2str(reportN), '_',id,'_state'];
    filename = ['Results\Graphs\',graphName, '.png'];
    saveas(gcf,filename);
    close(gcf);

    ploterrhist(err);
    graphName = [num2str(reportN), '_',id,'_hist_train'];
    filename = ['Results\Graphs\',graphName, '.png'];
    saveas(gcf,filename);
    close(gcf);
    
    if  ~isnan(err_test)
        ploterrhist(err_test);
        graphName = [num2str(reportN), '_',id,'_hist_test'];
        filename = ['Results\Graphs\',graphName, '.png'];
        saveas(gcf,filename);
        close(gcf);
    end
    
    plotroc(targets, simOutput)
    graphName = [num2str(reportN), '_',id,'_roc_train'];
    filename = ['Results\Graphs\',graphName, '.png'];
    saveas(gcf,filename);
    close(gcf);
    if  ~isnan(err_test)
        plotroc(TTargets, outTest)
        graphName = [num2str(reportN), '_',id,'_roc_test'];
        filename = ['Results\Graphs\',graphName, '.png'];
        saveas(gcf,filename);
        close(gcf);
    end
        
    fprintf('\nResults:\n');
    fprintf('\tperformance %f\n', perf)
    fprintf('\taccuracy prediction %f\n', accuracyPred)
    
    if train
        fprintf('\n Test set results:\n');
        fprintf('\tperformance %f\n', perf_test)
        fprintf('\taccuracy test  %f\n', accuracyTrain)
    end
end