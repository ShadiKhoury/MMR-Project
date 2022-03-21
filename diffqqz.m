v=diff(data_GYRO{1}.elapsed_s_)
n=diff(data_ACC{1}.elapsed_s_)
short_one=length(data_GYRO{1}.elapsed_s_)
%%
plot(v)
hold on 
plot(n)
hold on
t=find(v>mean(v))
for i=1:length(t)-1
    data_ACC{1}.elapsed_s_(t(i))=interp1(t(i:i+1),data_ACC{1}.elapsed_s_(t(i:i+1)),t(i),"linear")
    
end
%%
v=diff(data_GYRO{1}.elapsed_s_)
n=diff(data_ACC{1}.elapsed_s_)
plot(v)
hold on 
plot(n)
hold on
%%
%num2str(1.8e+03,'%.0f')
[times_12, inds] = unique([Acc_time{1}; Gyro_time{1}]); % (must use distrinct times)
l=length(Acc_time{1});
dataset_12 = [Vec_Gyro{1};Vec_ACC{1}];
dataset_12 = dataset_12(inds,:);
dataset_21=  [Vec_ACC{1};Vec_Gyro{1}];
times_3 = linspace(min(times_12), max(times_12),l); 

% Now interpolate
dataset_3 = interp1(times_12, dataset_12, times_3)

