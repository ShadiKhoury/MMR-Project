%% PREDICTION _window
% Add that folder plus all subfolders to the path.
addpath(genpath("Samples"));
addpath(genpath("הקלטות"));
addpath(genpath("הרצאה"));
addpath(genpath("קבוצה 3"));
%% Using feature selction to select best features
%load('all_data_Window_No_Label.mat')
%load('labels_Window.mat')
[idx,weights]=Feature_selction(all_data_Window_No_Label,labels_Window,10)
%% Selecteing top 10 features from the sorted features with best ranking 
top_10_idx_window      = [idx(1:10)]
new_filterd_window_data         = all_data_Window_No_Label(:,top_10_idx_window);
%[differ,cor_features,cor_feature_label ]        = MMRcorrolation(new_filterd_window_data, labels_Window)
figure
%gplotmatrix(new_filterd_window_data,[],labels_Window)

%% Bulding the Cross varidation (train: 70%, test: 30%) For training 
 
cv = cvpartition(size(labels_Window,1),'HoldOut',0.3);
disp(cv)
idxx = cv.test;
istrain = training(cv); % Data for fitting
istest = test(cv);   
% Separate to training and test data
dataTrain_window       = new_filterd_window_data(~idxx,:); % Data for fitting
labelTrain_window      =labels_Window(~idxx,:);  % labels for fitting
dataTest_window       = new_filterd_window_data(idxx,:); % Data for quality assessment
labelTest_window       =labels_Window(idxx,:);  % labels for quality assessment


%% Create the RandomForest ensemble
rng('default')
t = templateTree('Reproducible',true,'MaxNumSplits',300,'Prune','on'); % For reproducibility of random predictor selections);
%t = templateTree('MaxNumSplits',3,'NumVariablesToSample',1);
num_trees=35;
features    =top_10_idx_window;
tic
bagTree = fitcensemble(dataTrain_window,labelTrain_window,'Method','RUSBoost','NPrint',300,'NumBins',500,'NumLearningCycles',1000,'LearnRate',0.05,'Prior','empirical','Learners',t);
disp('Training time for RandomForest:')
toc

% for r=1:5
%     view(bagTree.Trained{r},'Mode','graph')
% end
%% Calculate confusion matrix
tab=tabulate(labels_Window(istest));
tic;
[Yfit_bag,score] = predict(bagTree,dataTest_window);
disp('Prediction time for RandomForest prediction:');
toc
disp('Confusion matrix (percentage) with Random Forest:');
stt=confusionmat(labelTest_window,Yfit_bag)
stats_trigger=confusionmatStats(Yfit_bag,labelTest_window)
figure;
confusionchart(labels_Window(istest),Yfit_bag,'RowSummary','absolute','ColumnSummary','absolute');
%% ROC
% for i=1:9
%    positive=i;
%     [x_ROC,y_ROC,threshold,AUC]=perfcurve(labels_Window(istest),score(:,positive),tab(positive));
%     disp(['AUC (ROC) : ',num2str(AUC),' for label= ',num2str(positive)]);
%     figure;plot(x_ROC,y_ROC);line([0 1],[0 1],'color','r');xlim([0 1]);ylim([0 1])
%     xlabel('FPR');ylabel('TPR');title('ROC curve')
% 
%     % PRC
%     [x_PRC,y_PRC,threshold_PRC,AUC_PRC]=perfcurve(labels_Window(istest),score(:,positive),tab(positive),'XCrit','tpr','YCrit','ppv');
%     disp(['AUC (PRC) : ',num2str(AUC_PRC), ' for label= ',num2str(positive)]);
%     figure;plot(x_PRC,y_PRC);line([0 1],[tab(positive,2)/sum(istest) tab(positive,2)/sum(istest)],'color','r');xlim([0 1]);ylim([0 1])
%     xlabel('Recall');ylabel('Precision');title('PRC curve')
% end

%% The Model you want to release to the world
tic
bagTree_Submit= fitcensemble(dataTrain_window,labelTrain_window,'Method','RUSBoost','NPrint',300,'NumBins',500,'NumLearningCycles',1000,'LearnRate',0.05,'Prior','empirical','Learners',t);
disp('Training time for RandomForest:')
toc

%% How to select a working point??
% select a working point with maximum sensitivity on 'versicolor'
figure
[Yfit_bagt,score] = predict(bagTree,dataTrain_window);
plot(score)