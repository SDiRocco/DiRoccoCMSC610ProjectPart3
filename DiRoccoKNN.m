% DiRocco K-NN Classification
function accuracy = DiRoccoKNN(Training,NewData,k)
    accuracy = [];
    for i = 1:1:size(NewData,2)
        distance = [];

        % Compute Distance
        for j = 1:1:size(Training,1)
            distance = [distance, (NewData{i,1}-Training{j,1})^2+(NewData{i,2}-Training{j,2})^2+(NewData{i,3}-Training{j,3})^2+(NewData{i,4}-Training{j,4})^2];
        end
        [minval, idx] = mink(distance,k);

        %Check if Correct
        if strcmpi(NewData(i,5),Training(idx(k),5))
            accuracy = [accuracy, 1];
        else
            accuracy = [accuracy, 0];
        end
    end

    %Compute Accuracy
    accuracy = (sum(accuracy)/size(accuracy,2))*100;
end