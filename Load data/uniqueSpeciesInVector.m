function  uniqueNames = uniqueSpeciesInVector(leafsSpecieAndType)
    
    leafsSpecieAndType = unique(leafsSpecieAndType);
    
    count = size(leafsSpecieAndType);
    count = count(1);

    for i = 1 : count 
        auxStr = cell2mat(leafsSpecieAndType(i));
        auxStr = strsplit(auxStr, '_');
        
%         [~, n] = size(auxStr); 
        
        auxVec(i)= auxStr(1);
        
        
%         REVIEW THIS CODE LATTER
%         if n == 2 
%             auxVec(i)= auxStr(1);  
%         elseif n == 1
%             sprintf('i = %d , n = %d , fullName = %s ', i, n, cell2mat(leafsSpecieAndType(i)) );
%                auxVec(i) = auxStr(1);
%         else 
%             sprintf('i = %d , n = %d , fullName = %s ', i, n, cell2mat(leafsSpecieAndType(i)) );
%             auxVec(i) = auxStr(3);  
%         end 
    end
    
   uniqueNames = unique(auxVec);
    
     