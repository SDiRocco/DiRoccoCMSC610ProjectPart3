% DiRocco CMSC610 Project Part 3 Main
% Shawn DiRocco

% Run Main using SetUp file as string as input
% SetUp file must be in same path
function DiRoccoCMSC610ProjectPart3Main(SetupFile)
    StartTime = tic;
    %Runs Setup File to retrieve variables
    run(SetupFile)
    
    %Reads and Saves Original Images
    imds = imageDatastore(InputfilePath);
    Original = readall(imds);
    
    %Normalizing grayscale values to be equal to 1
    if (cR+cG+cB) ~= 1.0
        ctemp = [cR cG cB];
        cR = ctemp(1)/(ctemp(1)+ctemp(2)+ctemp(3));
        cG = ctemp(2)/(ctemp(1)+ctemp(2)+ctemp(3));
        cB = ctemp(3)/(ctemp(1)+ctemp(2)+ctemp(3));
    end
    
    %Convert from RGB to Grayscale
    for i = 1:1:length(Original)
        A = Original{i};
        if size(A,3) == 3
            A = cR*A(:,:,1)+cG*A(:,:,2)+cB*A(:,:,3);
        end
        Original{i} = A;
    end

    %Save File Names
    Files = imds.Files;
    Files = convertCharsToStrings(Files);
    match = wildcardPattern + "\";
    FilesNames = erase(Files,match);
    
    %Checking to See if amount of images matches amount inputed as Classes
    if length(Original) ~= (cyl+inter+let+modc+para+super+svar)
        error('Unequal Amount of Images in Input Folder Compared to Amount per Class')
    end
    
    %Errors for Ten Fold
    if 0 ~= rem(cyl,10)
        error('cyl is not divisible by 10')
    end
    
    if 0 ~= rem(inter,10)
        error('inter is not divisible by 10')
    end

    if 0 ~= rem(let,10)
        error('let is not divisible by 10')
    end

    if 0 ~= rem(modc,10)
        error('modc is not divisible by 10')
    end

    if 0 ~= rem(para,10)
        error('para is not divisible by 10')
    end

    if 0 ~= rem(super,10)
        error('super is not divisible by 10')
    end

    if 0 ~= rem(svar,10)
        error('svar is not divisible by 10')
    end
    Classes = [cyl,inter,let,modc,para,super,svar];
    Classstr = strsplit('cyl inter let mod para super svar');
    
    disp("Setup Excution Time(s) =")
    display(toc(StartTime))

    disp("Setup Excution Time per Image(s) =")
    display(toc(StartTime)./size(Original,1))
    
    ClearTime = tic;
    % Clear Output Folder
    if strcmpi('yes',Clear)
        DiRoccoClear(OutputfilePath)
    end
    
    disp("Clear Excution Time(s) =")
    display(toc(ClearTime))

    disp("Clear Excution Time per Image(s) =")
    display(toc(ClearTime)./size(Original,1))
    
    CopyTime = tic;
    % Copy Input to Output
    if strcmpi('yes',Copy)
        DiRoccoCopy(OutputfilePath,Original,FilesNames)
    end
    
    disp("Copy Excution Time(s) =")
    display(toc(CopyTime))

    disp("Copy Excution Time per Image(s) =")
    display(toc(CopyTime)./size(Original,1))

    KNNTime = tic;
    % KNN Classification
    acc = [];
    if strcmpi('yes',KNN)
        %Segmentation and Feature Extraction
        [cyltrain, intertrain,lettrain, modtrain, paratrain,supertrain, svartrain] = DiRoccoTraining(OutputfilePath,Original,FilesNames,Classstr,EdgeThreshold,cyl,inter,let,modc,para,super);
        disp("Done with Training")
        % Classification
        for i = 1:1:10
            NewData = [cyltrain((i*(cyl/10))-((cyl/10)-1):i*(cyl/10),:);intertrain((i*(inter/10))-((inter/10)-1):i*(inter/10),:);lettrain((i*(let/10))-((let/10)-1):i*(let/10),:);modtrain((i*(modc/10))-((modc/10)-1):i*(modc/10),:);paratrain((i*(para/10))-((para/10)-1):i*(para/10),:);supertrain((i*(super/10))-((super/10)-1):i*(super/10),:);svartrain((i*(svar/10))-((svar/10)-1):i*(svar/10),:)];
            Training = [cyltrain(1:(i*(cyl/10))-((cyl/10)),:);cyltrain(i*(cyl/10)+1:end,:);intertrain(1:(i*(inter/10))-((inter/10)),:);intertrain(i*(inter/10)+1:end,:);lettrain(1:(i*(let/10))-((let/10)),:);lettrain(i*(let/10)+1:end,:);modtrain(1:(i*(modc/10))-((modc/10)),:);modtrain(i*(modc/10)+1:end,:);paratrain(1:(i*(para/10))-((para/10)),:);paratrain(i*(para/10)+1:end,:);supertrain(1:(i*(super/10))-((super/10)),:);supertrain(i*(super/10)+1:end,:);svartrain(1:(i*(svar/10))-((svar/10)),:);svartrain(i*(svar/10)+1:end,:)];
            acc = [acc,DiRoccoKNN(Training,NewData,k)];
            disp("Done with Fold")
            disp(i)
        end
        disp("Mean Accuracy")
        disp(mean(acc))
        
    end
    
    disp("KNN Excution Time(s) =")
    display(toc(KNNTime))

    disp("KNN Excution Time per Image(s) =")
    display(toc(KNNTime)./size(Original,1))
end