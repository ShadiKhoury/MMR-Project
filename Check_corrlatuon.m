%%
data_matrix=normalize(data_matrix);
cor_feature_label=corr(data_matrix,final_label)
cor_features=corr(data_matrix)
heatmap(cor_features)
differ=abs(cor_features)>0.7;
%%
meas=round(data_matrix);
y=final_label;
%We also tried using MI and pearson but separman was better:
corr_func=@spearman_correlation;
corr_func_name='Spearman Correlation';
%@ gives other name to a function: New_name=@function
feature_class_correlation=zeros(size(meas,2),1);
%%%%%%%% corelation between feature and class:
for r=1:4 %printing all the corelations (output will be after the all code)
    feature_class_correlation(r)=corr_func(meas(:,r),y);
disp([corr_func_name,' of feature #',num2str(r),' = ', ...
num2str(feature_class_correlation(r))])
end
%%%%%%%% corelation between features
feature_feature_correlation=zeros(size(meas,2),size(meas,2));
for m=1:4
for n=1:4
feature_feature_correlation(m,n)=corr_func(meas(:,m),meas(:,n));
end
end
%displaying the feature with the maximum correlation to the labels:
[~,max_ind]=max(abs(feature_class_correlation));
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

