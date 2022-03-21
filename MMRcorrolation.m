function [differ,cor_features,cor_feature_label ] = MMRcorrolation(data_matrix, final_label)
%%

data_matrix=normalize(data_matrix);
cor_feature_label   =  corr(data_matrix,final_label)
cor_features        =   corr(data_matrix)
heatmap(cor_features)
differ=abs(cor_features)>0.7;
%%
meas=round(data_matrix);
y=final_label;
%We also tried using MI and pearson but separman was better:
corr_func=@spearman_correlation;
corr_func_name='Spearman Correlation';
%@ gives other name to a function: New_name=@function
%% feature-label correlation
len=size(meas,2);
W=zeros(len,1);
for j=1:len
    [~,W(j)] = relieff(meas(:,j),y,10);
end
disp(['relieff weights are: ',num2str(W')])

%% 2-features-label exhaustic search
couples=logical(...
    [1,1,0,0;...
    1,0,1,0;...
    1,0,0,1;...
    0,1,1,0;...
    0,1,0,1;...
    0,0,1,1]);
len=size(couples,1);
W2=zeros(len,2);
for j=1:len
    [~,W2(j,:)] = relieff(meas(:,couples(j,:)),y,10);
end
disp(['relieff weights for couples are: '])
[couples,W2]
%%%%%%%% corelation between features
feature_feature_correlation=zeros(size(meas,2),size(meas,2));
for m=1:4
for n=1:4
feature_feature_correlation(m,n)=corr_func(meas(:,m),meas(:,n));
end
end
%displaying the feature with the maximum correlation to the labels:
[~,max_ind]=max(abs(feature_feature_correlation));
disp(['Maximum ',corr_func_name, ' between feature #',num2str(max_ind),' and label'])
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
%using CFS to choose our next features:
for n_features=2:size(meas,2)
fprintf('\nLooking for the best %d features combination\n',n_features)
CFS=zeros(size(meas,2)-length(max_ind),1);
available_features=setdiff((1:size(meas,2)),max_ind);
for r=available_features
CFS(r)=calculate_CFS(feature_class_correlation,feature_feature_correlation,[max_ind,r]);
disp(['CFS criterion of feature(s) ',num2str(max_ind),' with feature #',num2str(r),' = ',num2str(CFS(r))])
end
[~,ind]=max(CFS);
max_ind=[max_ind,ind];
disp(['Max CFS (',corr_func_name,') for feature combination: ',num2str(max_ind)])
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
end
end
