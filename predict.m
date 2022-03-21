num_vali={};
num_train={};
for i=1:5
rand_num_valid=randperm(size(data_matrix,1));
num_valid{i}=rand_num_valid(1:round(size(data_matrix,1)*0.2));
num_train{i}=rand_num_valid(round(size(data_matrix,1)*0.2)+1:end);
end
num_train=cell2mat(num_train);
num_valid=cell2mat(num_valid);
%% hyper_paramters
numEpochs = 5;
miniBatchSize = 256;
learnRate = 0.01;
gradientDecayFactor = 0.5;
squaredGradientDecayFactor = 0.999;
gradientThreshold = 1;
plots = "training-progress";
labelThreshold = 0.5;
numObservationsTrain = numel(documentsTrain);
numIterationsPerEpoch = floor(numObservationsTrain/miniBatchSize);
validationFrequency = numIterationsPerEpoch;
%%
if plots == "training-progress"
    figure
    
    % Labeling F-Score.
    subplot(2,1,1)
    lineFScoreTrain = animatedline('Color',[0 0.447 0.741]);
    lineFScoreValidation = animatedline( ...
        'LineStyle','--', ...
        'Marker','o', ...
        'MarkerFaceColor','black');
    ylim([0 1])
    xlabel("Iteration")
    ylabel("Labeling F-Score")
    grid on
    
    % Loss.
    subplot(2,1,2)
    lineLossTrain = animatedline('Color',[0.85 0.325 0.098]);
    lineLossValidation = animatedline( ...
        'LineStyle','--', ...
        'Marker','o', ...
        'MarkerFaceColor','black');
    ylim([0 inf])
    xlabel("Iteration")
    ylabel("Loss")
    grid on
end
%%

%% a
classf = @(train_data, train_labels, test_data, test_labels)...
    predict(fitcsvm(train_data, train_labels,'KernelFunction','linear'), test_data) ; % the moodle
P=classf(data_matrix(num_train,[4,3,5,6,7,8,9,10,11,12]),final_label(num_train,:),data_matrix(num_valid,[4,3,5,6,7,8,9,10,11,12]),final_label(num_valid,:));...
    % here we want to find the best featercombination 
    %  we add thecombination to #chnage here#
%% b
v=y_train(num_train,:);
Error_rate=(sum(P~=v(1:length(P),:))/length(v(1:length(P),:)))*100 % calaucaltes the error rate of that predaction = the combiation we used 
%% feature selection

opts = statset('display','iter');
classf = @(train_data, train_labels, test_data, test_labels)...
    sum(predict(fitcsvm(train_data, train_labels,'KernelFunction','rbf'), test_data) ~= test_labels);

[fs, history] = sequentialfs(classf, x_train, y_train, 'cv', c, 'options', opts);
