clc; close all
tic
% Determine where your m-file's folder is.
folder = fileparts(which("run2.m")); 
% Add that folder plus all subfolders to the path.
addpath(genpath("Samples"));
addpath(genpath("הקלטות"));
addpath(genpath("הרצאה"));
addpath(genpath("קבוצה 3"));
Fs=25;
dt = 1/Fs;

list={};
list1={};
list2={};
all_data_Window_No_Label=[];
labels_Window=[];
labels=[];
skip=0;
%% Selecting \ Imporing CSV FILES
d = uigetdir();
filePattern = fullfile(d, '*.csv');
file = dir(filePattern);
x = cell(1, numel(file));
data_ACC={};
data_GYRO={};
Acc_time={};
Gyro_time={};
error_in_label=0;
% Load DATA
for k=2:24
    try
    for t=1:12
        name        = sprintf('%d.%d.Acc.csv',k,t); %load acc data
        data_ACC{t}= readtable(name);
        list{t}={name};
        name1       = sprintf('%d.%d.Gyro.csv',k,t); %load gyro data
        data_GYRO{t}= readtable(name1);
        list{t}={name1};

    end

    %% Selecting \ Importing csv label files
    %b = uigetdir();
    %filePattern=fullfile(b, '*.csv');
    %file=dir(filePattern);
    %l = cell(1, numel(file));
    for j = 1 : 12 
        name2 = sprintf('%d.%d.Label.csv',k,j);
        data_label{j}= xlsread(name2);
        %data_label{j}.Properties.VariableNames(1:3)={'SecondsFromRecordingStart' 'Label' 'Notes'}; %Solving issues in reading the data
        list2{j}={name2};
    end


    %%
    for i=1:12
        Acc_x{i}=data_ACC{i}.x_axis_g_;
        Acc_y{i}=data_ACC{i}.y_axis_g_;
        Acc_z{i}=data_ACC{i}.z_axis_g_;
        Vec_ACC{i}=[Acc_x{i},Acc_y{i},Acc_z{i}];
        Acc_time{i}=data_ACC{i}.elapsed_s_;
        Gyro_x{i}=data_GYRO{i}.x_axis_deg_s_;
        Gyro_y{i}=data_GYRO{i}.y_axis_deg_s_;
        Gyro_z{i}=data_GYRO{i}.z_axis_deg_s_;
        Vec_Gyro{i}=[Gyro_x{i},Gyro_y{i},Gyro_z{i}];
        Gyro_time{i}=data_GYRO{i}.elapsed_s_;
    end
    %% Sycing data and fixing missing values.
    for i=1:12
        if length(Acc_time{i}) > length(Gyro_time{i})
            Vec_Gyro{i}=sync(Acc_time{i},Gyro_time{i},Vec_Gyro{i},Vec_ACC{i});
            Acc_time{i}= Acc_time{i}(1:length(Gyro_time{i}));
        end
        if length(Acc_time{i}) < length(Gyro_time{i})
            Vec_ACC{i}=sync(Gyro_time{i},Acc_time{i},Vec_ACC{i},Vec_Gyro{i});
            Gyro_time{i}= Gyro_time{i}(1:length(Acc_time{i}));
        end
    end



    %% Filtering the signal
    acc_f_allsig={};
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
        %label_second{i}=    data_label{i}.SecondsFromRecordingStart;
        label_second{i}=    data_label{i}(:,1)
        label_second{i}     =label_second{i}(~isnan(label_second{i})); % if label is Nan delet it
        %label_label{i}= data_label{i}.Label;
        label_label{i}= data_label{i}(:,2);
        label_label{i}=label_label{i}(~isnan(label_label{i}));
        labeled{i}=[label_second{i},label_label{i}];
        freq_label{i}=[zeros(length(Vec_ACC{i}),1)];
    end
    
    for i=1:12
        for j=1:length(labeled{i}(:,1))
            x=labeled{i}(j,1);
            if x<=0
                error_in_label=error_in_label+1;
                continue   
            end
            if x>0
                two_before=(x-2)/0.04;
                if two_before < 0
                    error_in_label=error_in_label+1;
                    continue
                end
                three_after=(x+3)/0.04;
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
    for i=1:12
        time = (0:length(acc_f_allsig{i})-1)* dt;
        %time=0:max(Acc_time{i})
        %time_acc=[time_acc time];
        for segment=1:length(time)-1
            ind=(segment-1)*5*Fs+(1:(Fs*5));
            %ind=(segment-1)*5+(0:5)
            %[idx,~]=find(Acc_time{i}==ind)
            %if length(idx)~=5
                %flag_ACC=flag_ACC+1;
               %continue
            %end
            if max(max(ind))<= length(acc_f_allsig{i})
                %t=min(idx):max(idx)
                x       =extract_features_ACC_window(acc_f_allsig{i},15,25,ind);
                acc_Filterd_matrix      =[acc_Filterd_matrix;x];
                final_label             =[final_label ;freq_label{i}(round(mean(ind)))];

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
                g       =extract_features_Gyro_window(gyro_f_allsig{i},17,25,ind);
                gyro_Filterd_matrix         =[gyro_Filterd_matrix;g];
            end

        end

    end

    %% Creating the large feature matrix for ACC AND GYRO FEATURES
    all_data_Window            =[acc_Filterd_matrix gyro_Filterd_matrix final_label]; %all data with lable
    all_data_matrix_Window     =[acc_Filterd_matrix gyro_Filterd_matrix]; 
    all_data_Window_No_Label   =[all_data_Window_No_Label ;all_data_matrix_Window];
    labels_Window              =[labels_Window ; final_label];
    k
 catch
        fprintf('loop number %d  %d failed\n',k ,i)
        skip=skip+1;
end

end


toc