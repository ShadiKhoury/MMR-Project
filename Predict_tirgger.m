%% PREDICTION _Trigger

%%
%  load('all_data_train_No_Label_Trigger_event.mat')
% load('labels_Trigger_event.mat')
%% Select top 10 features

[idx,weights]=Feature_selction(all_data_train_No_Label_Trigger_event,labels_Trigger_event,10)
%% billding best matirx with the TOP 10 features
top_idx_trigger= [idx(1:10)]
new_filterd_trigger_data=all_data_train_No_Label_Trigger_event(:,top_idx_trigger);
%[differ,cor_features,cor_feature_label ] = MMRcorrolation(new_filterd_trigger_data, labels_Trigger_event)
%figure
%gplotmatrix(new_filterd_trigger_data,[],labels_Trigger_event)

%% Cross varidation (train: 70%, test: 30%)

cv = cvpartition(size(labels_Trigger_event,1),'HoldOut',0.3);
disp(cv)
idxx = cv.test;
istrain = training(cv); % Data for fitting
istest = test(cv);   
% Separate to training and test data
dataTrain_trigger       = new_filterd_trigger_data(~idxx,:); % Data for fitting
labelTrain_trigger      =labels_Trigger_event(~idxx,:);  % labels for fitting
dataTest_trigger        = new_filterd_trigger_data(idxx,:); % Data for quality assessment
labelTest_trigger       =labels_Trigger_event(idxx,:);  % labels for quality assessment

%%
%% Create the RandomForest ensemble

rng('default')
t = templateTree('Reproducible',true,'MaxNumSplits',300,'Prune','on'); % For reproducibility of random predictor selections);
%t = templateTree('MaxNumSplits',3,'NumVariablesToSample',1);

tic
bagTree = fitcensemble(dataTrain_trigger,labelTrain_trigger,'Method','RUSBoost','NPrint',300,'NumBins',500,'NumLearningCycles',1000,'LearnRate',0.05,'Prior','empirical','Learners',t);
disp('Training time for RandomForest:')
toc
% %for r=1:5
%     view(bagTree.Trained{r},'Mode','graph')
% %end
%%
%% Calculate confusion matrix
tab=tabulate(labels_Trigger_event(istest));
tic;
[Yfit_bag,score]    = predict(bagTree,dataTest_trigger); % Prediction
disp('Prediction time for RandomForest prediction:');
toc
disp('Confusion matrix (percentage) with Random Forest:');
stt     =confusionmat(labelTest_trigger,Yfit_bag)   % confuiso matrix
stats_trigger=confusionmatStats(Yfit_bag,labelTest_trigger)
figure;
confusionchart(labels_Trigger_event(istest),Yfit_bag,'RowSummary','absolute','ColumnSummary','absolute');

%% ROC
% for i=1:9
%     positive=i;
%     [x_ROC,y_ROC,threshold,AUC]=perfcurve(labels_Trigger_event(istest),score(:,positive),tab(positive));
%     disp(['AUC (ROC) : ',num2str(AUC),' for label= ',num2str(positive)]);
%     figure;plot(x_ROC,y_ROC);line([0 1],[0 1],'color','r');xlim([0 1]);ylim([0 1])
%     xlabel('FPR');ylabel('TPR');title('ROC curve')
% 
%     % PRC
%     [x_PRC,y_PRC,threshold_PRC,AUC_PRC]=perfcurve(labels_Trigger_event(istest),score(:,positive),tab(positive),'XCrit','tpr','YCrit','ppv');
%     disp(['AUC (PRC) : ',num2str(AUC_PRC),' for label= ',num2str(positive)]);
%     figure;plot(x_PRC,y_PRC);line([0 1],[tab(positive,2)/sum(istest) tab(positive,2)/sum(istest)],'color','r');xlim([0 1]);ylim([0 1])
%     xlabel('Recall');ylabel('Precision');title('PRC curve')
% end
%% The Model you want to release to the world

rng('default')
t = templateTree('Reproducible',true,'MaxNumSplits',300,'Prune','on');
bagTree_submit =  fitcensemble(new_filterd_trigger_data,labels_Trigger_event,'Method','RUSBoost','NPrint',300,'NumBins',50,'NumLearningCycles',1000,'LearnRate',0.05,'Prior','empirical','Learners',t);
disp('Training time for RandomForest:')
toc
