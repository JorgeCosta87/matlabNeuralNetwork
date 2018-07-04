function  uniqueNames = uniqueSubSpeciesInVector(leafsSpecieAndType)
    
    leafsSpecieAndType = unique(leafsSpecieAndType);
    size(leafsSpecieAndType);
    count = size(leafsSpecieAndType);
    count = count(1);

    for i = 1 : count 
        
        auxStr = cell2mat(leafsSpecieAndType(i));
        auxStr = strsplit(auxStr, '_');
        
        [~, n] = size(auxStr);
         
        if n < 2  
            auxVec(i)= strcat(auxStr(1), '_' , auxStr(1)) ; 
%             disp(i);
%             disp(auxStr(n));
        else  
%             disp(i);
%             disp(auxStr(n));
            
%                 disp([i , auxStr(n) ]);
         
            auxVec(i)= auxStr(n); 
            auxVec(i)= strcat(auxStr(1), '_', auxStr(n)) ; 
        end 
    end
%     size(auxVec)
%    uniqueNames = unique(auxVec);
%    size(uniqueNames)
    uniqueNames = auxVec;
     