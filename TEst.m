

trainOrTest = false;
expType = 'subspeci';
dataSet = 1;
expID = 1;
accuracyPred = 0;
accuracyTest = 0;

    reportN = 1;
    maxReports = 100;
    reportName = ['report', num2str(reportN)];
    filename = ['Results\',reportName, '.xlsx'];
    
    for i = 1 : maxReports
        if exist(filename, 'file') == 2
             reportN = reportN + 1;         
             reportName = ['report', num2str(reportN)];
             filename = ['Results\',reportName, '.xlsx'];
        end
    end
    
    if exist(filename, 'file') == 0
        col_header={'ID','Dataset','Dataset Size','expType','Target Size',...
            'numLayers','Layer1Size','Layer1Fcn','Layer2Size','Layer2Fcn',...
            'Layer3Size','Layer3Fcn','Layer4Size','Layer4Fnc','trainFcn',...
            'lr','lr_inc','lr_dec','mc','divideFcn','trainRatio','trainVal',...
            'testRatio','num_epochs','best_epoch','time','best_perf','best_vperf','best_tperf','accuracyPred','accuracyTest'}; 
    
        xlswrite(filename,col_header);
    end

    numL = net.numLayers;
    tLayerFcn = "";
    tLayerSize = zeros(4);
    for i = 1 : numL
        tLayerFcn(i)  = net.layers{i}.transferFcn;
        tLayerSize(i) = net.layers{i}.size;
    end
    
    data = [expID,dataSet, size(dataSet,2), {expType}, size(dataTarget,1), net.numLayers,...
            checkLayerFcn(net,1), tLayerSize(1),checkLayerFcn(net,2), tLayerSize(2),checkLayerFcn(net,3), tLayerSize(3),...
            checkLayerFcn(net,4), tLayerSize(4),{tr.trainFcn}, tr.trainParam.lr, tr.trainParam.lr_inc, tr.trainParam.lr_dec,...
            tr.trainParam.mc, {tr.divideFcn},tr.divideParam.trainRatio, tr.divideParam.valRatio, tr.divideParam.testRatio,...
            tr.num_epochs, tr.best_epoch, (tr.time(tr.num_epochs)*1000), tr.best_perf, tr.best_vperf, tr.best_tperf,...
            accuracyPred, accuracyTest];
    
    xlswrite(filename,data,1,['A', num2str(expID + 1)]);

function val = checkLayerFcn(net, index)
        
    if index <= net.numLayers
       val = net.layers{index}.transferFcn;
    else
        val= 'none';
    end
end