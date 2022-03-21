tic
Fs=25;
dt = 1/Fs;

list={};
list1={};
list2={};
all_data_train_No_Label_Trigger_event=[];
labels_Trigger_event=[];
labels=[];
trigger_skip=0;
error_in_label=0;
%% Selecting \ Imporing CSV FILES
d = uigetdir();
filePattern = fullfile(d, '*.csv');
file = dir(filePattern);
v = cell(1, numel(file));
data_ACC={};
data_GYRO={};
Acc_time={};
Gyro_time={};
trigger_count=[];
foucse_group=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 18 21 23 24];
for k=2:24
    try
    if ismember(k,foucse_group)
    for t=1:12
        name         = sprintf('%d.%d.Acc.csv',k,t);
        data_ACC{t}  = readtable(name);
        list{t}      = {name};
        name1        = sprintf('%d.%d.Gyro.csv',k,t);
        data_GYRO{t} = readtable(name1);
        list{t}      = {name1};

    end

    %% Selecting \ Importing csv label files
    %b = uigetdir();
    %filePattern=fullfile(b, '*.csv');
    %file=dir(filePattern);
    %l = cell(1, numel(file));
    for j = 1 : 12 
        name2           = sprintf('%d.%d.Label.csv',k,j);
        data_label{j}   = xlsread(name2);
        %data_label{j}.Properties.VariableNames(1:3)={'SecondsFromRecordingStart' 'Label' 'Notes'};
        list2{j}        = {name2};
    end


    %%
    for i=1:12
        Acc_x{i}        = data_ACC{i}.x_axis_g_;
        Acc_y{i}        = data_ACC{i}.y_axis_g_;
        Acc_z{i}        = data_ACC{i}.z_axis_g_;
        Vec_ACC{i}      = [Acc_x{i},Acc_y{i},Acc_z{i}];
        Acc_time{i}     = data_ACC{i}.elapsed_s_;
        Gyro_x{i}       = data_GYRO{i}.x_axis_deg_s_;
        Gyro_y{i}       = data_GYRO{i}.y_axis_deg_s_;
        Gyro_z{i}       = data_GYRO{i}.z_axis_deg_s_;
        Vec_Gyro{i}     = [Gyro_x{i},Gyro_y{i},Gyro_z{i}];
        Gyro_time{i}    = data_GYRO{i}.elapsed_s_;
    end
    %% Sycing data and fixing missing values.
    for i=1:12
        if length(Acc_time{i}) > length(Gyro_time{i})
            %Gyro_time{i}=Gyro_time{i}(~isnan(Gyro_time{i}));
            %Acc_time{i}=Acc_time{i}(~isnan(Acc_time{i}));
            Vec_Gyro{i}=sync(Acc_time{i},Gyro_time{i},Vec_Gyro{i},Vec_ACC{i});
            Acc_time{i}= Acc_time{i}(1:length(Gyro_time{i}));
        end
        if length(Acc_time{i}) < length(Gyro_time{i})
            %Acc_time{i}=Acc_time{i}(~isnan(Acc_time{i}));
            %Gyro_time{i}=Gyro_time{i}(~isnan(Gyro_time{i}));
            Vec_ACC{i}=sync(Gyro_time{i},Acc_time{i},Vec_ACC{i},Vec_Gyro{i});
            Gyro_time{i}= Gyro_time{i}(1:length(Acc_time{i}));
        end
    end



    %% Filtering the signal
    acc_f_allsig={}; % all tjere
    gyro_f_allsig={};
    for i=1:12
        [imf_x{i},residual_x{i},info_x{i}]=emd(Vec_ACC{i}(:,1),'Interpolation','pchip','Display',1);
        [imf_y{i},residual_y{i},info_y{i}]=emd(Vec_ACC{i}(:,2),'Interpolation','pchip','Display',1);
        [imf_z{i},residual_z{i},info_z{i}]=emd(Vec_ACC{i}(:,3),'Interpolation','pchip','Display',1);
        acc_filterd_x{i}=imf_x{i}(:,2);
        acc_filterd_y{i}=imf_y{i}(:,2);
        acc_filterd_z{i}=imf_z{i}(:,2);
        acc_f_allsig{i}=[acc_filterd_x{i},acc_filterd_y{i},acc_filterd_z{i}];


        [imf_x_g{i},residual_x_g{i},info_x_g{i}]=emd(Vec_Gyro{i}(:,1),'Interpolation','pchip','Display',1);
        [imf_y_g{i},residual_y_g{i},info_y_g{i}]=emd(Vec_Gyro{i}(:,2),'Interpolation','pchip','Display',1);
        [imf_z_g{i},residual_z_g{i},info_z_g{i}]=emd(Vec_Gyro{i}(:,3),'Interpolation','pchip','Display',1);
        gyro_filterd_x{i}=imf_x_g{i}(:,2);
        gyro_filterd_y{i}=imf_y_g{i}(:,2);
        gyro_filterd_z{i}=imf_z_g{i}(:,2);
        gyro_f_allsig{i}=[gyro_filterd_x{i},gyro_filterd_y{i},gyro_filterd_z{i}];
    end

    %% Creating label data vector
    label_second={};
    label_label={};
    freq_label={};
    labeled={};
    list=[];
    for i=1:12
        i
        label_second{i}=data_label{i}(:,1);
        label_second{i}=label_second{i}(~isnan(label_second{i}));
        label_label{i}=data_label{i}(:,2);
        label_label{i}=label_label{i}(~isnan(label_label{i}));
        labeled{i}=[label_second{i},label_label{i}];
        freq_label{i}=[zeros(length(Vec_ACC{i}),1)];
    end
    
    for i=1:12 % manual label records 
        for j=1:length(labeled{i}(:,1))
            x=labeled{i}(j,1);
            if x<=0
                error_in_label=error_in_label+1;
                continue   
            end
            if x>0
                two_before=(x-2)/0.04; % 2 seconds before the labels 
                if two_before < 0
                    error_in_label=error_in_label+1;
                    continue
                end
                three_after=(x+3)/0.04; % 3 seconds after the labels
                if three_after <0
                    error_in_label=error_in_label+1;
                    continue
                end
                freq_label{i}(two_before:three_after)=labeled{i}(j,2);
            end    
           


        end

    end

    %% Creating Features for ACC
    final_label=[];
    acc_Filterd_matrix=[];
    gyro_Filterd_matrix=[];
    time_acc=[];
    time_gyro=[];
    flag_ACC=0;
    flag_Gyro=0;
    triger_count=0
    for i=1:12                            % Records number 
        time = (0:length(acc_f_allsig{i})-1)* dt;
        %time=0:max(Acc_time{i})
        %time_acc=[time_acc time];
        for segment=1:length(time)-1
            ind=(segment-1)*5*Fs+(1:(Fs*5)); %5 seconds
            %ind=(segment-1)*5+(0:5)
            %[idx,~]=find(Acc_time{i}==ind)
            %if length(idx)~=5
                %flag_ACC=flag_ACC+1;
               %continue
            %end
            if max(max(ind))<= length(acc_f_allsig{i})
                %t=min(idx):max(idx)
                if event_trigger(acc_f_allsig{i},ind) & event_trigger(gyro_f_allsig{i},ind) == 1; % Trigger Condtion for window
                    triger_count=triger_count+1;
                    x=extract_features_acc_triger(acc_f_allsig{i},14,25,ind);
                    acc_Filterd_matrix=[acc_Filterd_matrix;x];
                    final_label=[final_label ;freq_label{i}(round(mean(ind)))];
                else
                    continue
                    
                end
                

            end
        end
    end
    %% Creating featurs For GYRO
    for i=1:12
        %time=0:max(Gyro_time{i})
        time = (0:length(gyro_f_allsig{i})-1) * dt;
        %time_gyro=[time_gyro time];
        for segment=1:length(time)-1
            ind=(segment-1)*5*Fs+(1:(Fs*5));
            %ind=(segment-1)*5+(0:5)
            %[idx,~]=find(Gyro_time{i}==ind)
            %if length(idx)~=5
                %flag_Gyro=flag_Gyro+1;
               %continue
            %end
            if max(max(ind))<= length(gyro_f_allsig{i})
                %t=min(idx):max(idx)
                if event_trigger(acc_f_allsig{i},ind) & event_trigger(gyro_f_allsig{i},ind) == 1; % Trigger Condtion for window
                    trigger_count=trigger_count+1;
                    g=extract_features_Trigger_Gyro(gyro_f_allsig{i},19,25,ind);
                    gyro_Filterd_matrix=[gyro_Filterd_matrix;g];
                else
                    continue
                end
                    
                
            end

        end

    end
    end
    %%
    train_data_Trigger_event              =[acc_Filterd_matrix gyro_Filterd_matrix final_label];
    data_matrix_Trigger_event             =[acc_Filterd_matrix gyro_Filterd_matrix]; 
    %the Big matrix of acc+gyro windows + features 
    all_data_train_No_Label_Trigger_event =[all_data_train_No_Label_Trigger_event ; data_matrix_Trigger_event];
    labels_Trigger_event                  =[labels_Trigger_event ; final_label];
    k

    %end
    catch
        fprintf('loop number %d  %d failed\n',k ,i)
        trigger_skip=trigger_skip+1;
end
%%
end
toc

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
