%DiRocco Segmentation and Feature Extraction
function [cyltrain, intertrain,lettrain, modtrain, paratrain,supertrain, svartrain] = DiRoccoTraining(OutputfilePath,Original,FilesNames,Classstr,EdgeThreshold,cyl,inter,let,modc,para,super)
    mkdir(OutputfilePath,'OTSU')
    Trainingdata = [];
    cyltrain = [];
    intertrain = [];
    lettrain = [];
    modtrain = [];
    paratrain = [];
    supertrain = [];
    svartrain = [];
    for i = 1:1:length(Original)
            %OTSU
            A = Original{i};
            
            num_bins = 256;
            counts = imhist(A,num_bins);
            num_bins = numel(counts);
            counts = double(counts(:));
            
            p = counts / sum(counts);
            omega = cumsum(p);
            mu = cumsum(p .* (1:num_bins)');
            mu_t = mu(end);
            sigma_b_squared = (mu_t * omega - mu).^2 ./ (omega .* (1 - omega));
            
            maxval = max(sigma_b_squared);
            isfinite_maxval = isfinite(maxval);
            if isfinite_maxval
                idx = mean(find(sigma_b_squared == maxval));
                tval = (idx - 1) / (num_bins - 1);
            else
                tval = 0.0;
            end
            
            A(A >= tval*255) = uint8(255);
            A(A < tval*255) = uint8(0);

            %imwrite(A,OutputfilePath+"OTSU\"+FilesNames{i},'bmp')
            %Area
            area = sum(A(:)==0);
            %Perimeter
            DerivativeFilt = 0.5*[0 -1 0;-1 0 1;0 1 0];
            Filtersize = size(DerivativeFilt);
            EA = A(1+floor(Filtersize(1)/2):size(A,1)-floor(Filtersize(1)/2),1+floor(Filtersize(1)/2):size(A,2)-floor(Filtersize(1)/2));
            for r = 1:1:size(EA,1)
                 for c = 1:1:size(EA,2)
                     Gradient = double(A(r:r+Filtersize(1)-1,c:c+Filtersize(1)-1)).*DerivativeFilt;
                     magGradient = sqrt((sum(Gradient(2,:))^2+(sum(Gradient(:,2)))^2));
                     if magGradient > EdgeThreshold
                         EA(r,c) = 0;
                     else
                         EA(r,c) = 255;
                     end
                 end
            end
            perimeter = sum(EA(:)==0);
            %meanValue
            MA = Original{i};
            for r = 1:1:size(MA,1)
                for c = 1:1:size(MA,2)
                    if A(r,c) == 255
                        MA(r,c) = NaN;
                    end
                end
            end
            
            meanValue = nanmean(MA,'all');
            %Variance
            Variance = nanvar(double(MA),0,'all');
            %Create TrainingData Matrix
            if i <= cyl
                cyltrain = [cyltrain; area,perimeter,meanValue,Variance,Classstr(1)];
                Trainingdata = [Trainingdata; area,perimeter,meanValue,Variance,Classstr(1)];
            elseif i <= cyl+inter
                intertrain = [intertrain; area,perimeter,meanValue,Variance,Classstr(2)];
                Trainingdata = [Trainingdata; area,perimeter,meanValue,Variance,Classstr(2)];
            elseif i <=cyl+inter+let
                lettrain = [lettrain; area,perimeter,meanValue,Variance,Classstr(3)];
                Trainingdata = [Trainingdata; area,perimeter,meanValue,Variance,Classstr(3)];
            elseif i <=cyl+inter+let+modc
                modtrain = [modtrain; area,perimeter,meanValue,Variance,Classstr(4)];
                Trainingdata = [Trainingdata; area,perimeter,meanValue,Variance,Classstr(4)];
            elseif i <=cyl+inter+let+modc+para
                paratrain =[paratrain; area,perimeter,meanValue,Variance,Classstr(5)];
                Trainingdata = [Trainingdata; area,perimeter,meanValue,Variance,Classstr(5)];
            elseif i <=cyl+inter+let+modc+para+super
                supertrain = [supertrain; area,perimeter,meanValue,Variance,Classstr(6)];
                Trainingdata = [Trainingdata; area,perimeter,meanValue,Variance,Classstr(6)];
            else
                svartrain = [svartrain; area,perimeter,meanValue,Variance,Classstr(7)];
                Trainingdata = [Trainingdata; area,perimeter,meanValue,Variance,Classstr(7)];
            end

    end
    writecell(Trainingdata,'Trainingdata.csv')
end