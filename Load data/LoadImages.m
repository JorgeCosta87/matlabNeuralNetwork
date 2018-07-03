function imagesToReturn = LoadImages(path, idsInput, namesInput, uniqueSpeciesVector)
    
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
        imagesOnDir(i).binData = imbinarize(imagesOnDir(i).binData, 0.5);
        
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
        
        % testing image processing

%         startX = round((87/2)-(x/2));
%         startY = round((87/2)-(y/2));
%         
%         merge(startY: startY + y  - 1, startX: startX + x - 1) = imagesOnDir(i).binData;
        
        
        %averaging filter
%             h_average = fspecial('average',3);
%             merge = imfilter(merge, h_average);
            
        %gaussian filter
%             h_gaussian = fspecial('gaussian', 3, 0.5);
%             merge = imfilter(merge, h_gaussian);
        %median filter
        merge = medfilt2(merge);
            
        %edge presevation 
            %merge = imguidedfilter(merge);

        % END testing image processing
        
       
        
        
        if( ( x > 87 ) || y > 87)
           disp(i) 
        end
         
        imagesOnDir(i).binData = merge;  
        
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
        
        imagesToReturn(add).leafSpeciesName = imagesOnDir(i).leafSpeciesName;
        imagesToReturn(add).leafType        = imagesOnDir(i).leafType;
        imagesToReturn(add).binData         = imagesOnDir(i).binData;
        imagesToReturn(add).leafFullName    = imagesOnDir(i).leafFullName;
        imagesToReturn(add).id              = imagesOnDir(i).id;
        add = add + 1;
    end
    
%     uniqueSpecies = unique([imagesToReturn.leafSpeciesName]);
%     size(imagesToReturn)
%     add
    for i = 1 : (add - 1)
        imagesToReturn(i).speciesId = find(strcmp(uniqueSpeciesVector, imagesToReturn(i).leafSpeciesName));
    end
    
    
  %  disp( count);