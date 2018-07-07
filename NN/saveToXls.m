function [id] = saveToXls(net, tr, filename, reportN, numRep, expid, exprep, dataSetName, dataSetSize, expType, dataTarget, accuracyPred, accuracyTest)

    id = [num2str(expid),'_' num2str(exprep)]; 

    
    if exist(filename, 'file') == 0
        col_header={'ID', 'Report','Dataset','Dataset Size','expType','Target Size',...
            'numLayers','Layer1Size','Layer1Fcn','Layer2Size','Layer2Fcn',...
            'Layer3Size','Layer3Fcn','Layer4Size','Layer4Fnc','trainFcn',...
            'lr','lr_inc','lr_dec','mc','divideFcn','trainRatio','trainVal',...
            'testRatio','num_epochs','best_epoch','time','best_perf','best_vperf','best_tperf','accuracyPred','accuracyTest'}; 
        firstRow =  '1';
        lastRow = '1';
        firstCol = 'A';
        lastCol = 'AF';
        cellRange = [firstCol,firstRow,':', lastCol, lastRow];%[firstCol,num2str(firstRow),':',lastCol,num2str(lastRow)]
        sheetNum = 1;
        xlswrite(filename,col_header,sheetNum,cellRange );
    end

    numL = net.numLayers;
    tLayerFcn = "";
    tLayerSize = zeros(4);
    for i = 1 : numL
        tLayerFcn(i)  = net.layers{i}.transferFcn;
        tLayerSize(i) = net.layers{i}.size;
    end
    
    data = [id, reportN, dataSetName, dataSetSize, {expType}, size(dataTarget,1), net.numLayers,...
            checkLayerFcn(net,1), tLayerSize(1),checkLayerFcn(net,2), tLayerSize(2),checkLayerFcn(net,3), tLayerSize(3),...
            checkLayerFcn(net,4), tLayerSize(4),{tr.trainFcn}, tr.trainParam.lr, tr.trainParam.lr_inc, tr.trainParam.lr_dec,...
            tr.trainParam.mc, {tr.divideFcn},checkDividFcn(tr,1), checkDividFcn(tr,2), checkDividFcn(tr,3),...
            tr.num_epochs, tr.best_epoch, (tr.time(tr.num_epochs)*1000), tr.best_perf, tr.best_vperf, tr.best_tperf,...
            accuracyPred, accuracyTest];
        
    disp(['A', num2str((((expid-1) * numRep)) + exprep + 1)]);
    
firstRow =  num2str(((expid-1) * numRep) + exprep + 1);
lastRow = 5;
firstCol = 'A';
lastCol = 'AF';
cellRange = [firstCol,firstRow,':', lastCol, firstRow]%[firstCol,num2str(firstRow),':',lastCol,num2str(lastRow)]
sheetNum = 1;
disp(filename);
    xlswrite(filename,data,sheetNum,cellRange);

    function val = checkLayerFcn(net, index)

        if index <= net.numLayers
           val = net.layers{index}.transferFcn;
        else
            val= 'none';
        end
    end

    function val = checkDividFcn(tr, index)

        if size(tr.divideParam,1) == 1
           val= 'none';
        else
            if index == 1
                val = tr.divideParam.trainRatio;
            end
            if index == 2
                val = tr.divideParam.valRatio;
            end
            if index == 3
                val = tr.divideParam.testRatio;
            end

        end
    end
end
