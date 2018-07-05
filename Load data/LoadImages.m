function imagesToReturn = LoadImages(path, idsInput, namesInput, uniqueSpeciesVector, uniqueSpeciesAndSubSpeciesVector)
    
    % Get the name of all images on directory
    imagesOnDir = dir([path '\*.jpg']);
    
    % The how many image file exist
    nCount = size(imagesOnDir);
    nCount = nCount(1);
    
    % count = 0;
    add = 1;
    for i = 1 : nCount
        %disp(imagesOnDir(i).name);
        
        % Load the binary data to memry
        imagesOnDir(i).binData = imread(fullfile(path, imagesOnDir(i).name));
        
        % Conver the image to black and white
        imagesOnDir(i).binData = im2bw(imagesOnDir(i).binData, 0.5);
        
        % Transform the file name into leaf Id, numeric
        auxLeafId = strsplit(imagesOnDir(i).name, '.');
        auxLeafId = auxLeafId(1);
        auxLeafId = cell2mat(auxLeafId); 
        imagesOnDir(i).id = str2double(auxLeafId);
        
        % merge the image on a normalized size
        % REVIEW THIS PART.
        % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        merge = zeros(87);
        imagesOnDir(i).binData = imresize(imagesOnDir(i).binData,0.05) ;
        [y, x] = size(imagesOnDir(i).binData);
        merge(1:y, 1:x) = imagesOnDir(i).binData;
        
        if( ( x > 87 ) || y > 87)
           disp(i) 
        end
         
        imagesOnDir(i).binData = merge;  
        
        [B,~] = bwboundaries(imagesOnDir(i).binData,'noholes'); 
        B = B{1,1};
       
        
        aux = regionprops(imagesOnDir(i).binData, 'Perimeter', 'Area', 'Orientation');
        imagesOnDir(i).orientation  = round(abs(aux.Orientation));
        imagesOnDir(i).Area         = round(aux.Area);
        imagesOnDir(i).Perimeter    = round( aux.Perimeter);
        imagesOnDir(i).width        = max(B(:,1)) - min(B(:,1));
        imagesOnDir(i).height       = max(B(:,2)) - min(B(:,2));
        imagesOnDir(i).avgBoarderX  = round(mean(B(:,1)));
        imagesOnDir(i).avgBoarderY  = round( mean(B(:,2)));
        
        points = detectHarrisFeatures(imagesOnDir(i).binData);
        imagesOnDir(i).corners = points.Count;
        
        % convert matrix to vector
        imagesOnDir(i).binData = imagesOnDir(i).binData(:);
       
        
        
        
        
        
        %  pause(20);
        %  return;
        % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        
        % search the name of image file in the array of name loaded from
        % the xls
        indexOnName = find(idsInput == imagesOnDir(i).id );

        % some file are not listed in the xls, so we continue to the next
        % iteration
        if isempty(indexOnName)
           % disp(imagesOnDir(i).name);
           % count = count + 1;
            continue
        end

        % the full name is the species + the leaf type
        imagesOnDir(i).leafFullName = namesInput(indexOnName);

        %separate the species name from the leaf type
        specieAndLeafType = cell2mat(imagesOnDir(i).leafFullName);
        specieAndLeafType = strsplit(specieAndLeafType, '_')  ;

        
        % Some leafs only have a spieces name and no leaf type
        % in that case the specie and the leaf type remain the same
        
        [~, b] = size(specieAndLeafType);
        
        % define the leaf type
        if b < 2 
            imagesOnDir(i).leafType = specieAndLeafType(1);  
        else 
            imagesOnDir(i).leafType = specieAndLeafType(b); 
        end
        
        % define the species name
        imagesOnDir(i).leafSpeciesName = specieAndLeafType(1);
        
        imagesToReturn(add).leafSpecies     = imagesOnDir(i).leafSpeciesName;
        imagesToReturn(add).leafSubSpecies  = imagesOnDir(i).leafType;
        imagesToReturn(add).binData         = imagesOnDir(i).binData;
        imagesToReturn(add).leafFullName    = imagesOnDir(i).leafFullName;
        imagesToReturn(add).id              = imagesOnDir(i).id;
        
        imagesToReturn(add).leaf_specie_subspecie = strcat(imagesToReturn(add).leafSpecies, '_', imagesToReturn(add).leafSubSpecies);
         
       
       
        imagesToReturn(add).orientation = imagesOnDir(i).orientation    ;  
        imagesToReturn(add).Area        = imagesOnDir(i).Area           ;
        imagesToReturn(add).Perimeter   = imagesOnDir(i).Perimeter      ;
        imagesToReturn(add).width       = imagesOnDir(i).width          ;
        imagesToReturn(add).height      = imagesOnDir(i).height         ;
        imagesToReturn(add).avgBoarderX = imagesOnDir(i).avgBoarderX    ;
        imagesToReturn(add).avgBoarderY = imagesOnDir(i).avgBoarderY    ;
        imagesToReturn(add).corners     = imagesOnDir(i).corners        ;
        
        imagesToReturn(add).charcAsVec = [imagesToReturn(add).orientation, imagesToReturn(add).Area ,...
            imagesToReturn(add).Perimeter, imagesToReturn(add).width, imagesToReturn(add).height, ...
            imagesToReturn(add).avgBoarderX , imagesToReturn(add).avgBoarderY , imagesToReturn(add).corners ];
        
        imagesToReturn(add).charcAsVec = imagesToReturn(add).charcAsVec';
        
        add = add + 1;
    end
    
%     uniqueSpecies = unique([imagesToReturn.leafSpeciesName]);
%     size(imagesToReturn)
%     add
    for i = 1 : (add - 1)
        imagesToReturn(i).speciesId    = find(strcmp(uniqueSpeciesVector, imagesToReturn(i).leafSpecies));
        imagesToReturn(i).subSpeciesId = find(strcmp(uniqueSpeciesAndSubSpeciesVector, imagesToReturn(i).leaf_specie_subspecie)); 
    end
    
    
  %  disp( count);