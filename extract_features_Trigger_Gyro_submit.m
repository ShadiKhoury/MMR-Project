%% Feature Selection
function feat_vec=extract_features_Trigger_Gyro_submit(f_sig,n_features,sample_rate,ind)
feat_vec      =   zeros(1,n_features);                              %creating a vector with 1 row and n_features columns
x_sig=f_sig(ind,1); y_sig=f_sig(ind,2); z_sig=f_sig(ind,3);
new_sig=[x_sig,y_sig,z_sig];



        %% MAXIMUM signal energy
EE                =   sqrt(new_sig.^2);
feat_vec(1)       =   max(max(EE));
feat_vec(2)       =  entropy(normalize((x_sig)));
feat_vec(3)       =  entropy(normalize((y_sig)));
feat_vec(4)       =  entropy(normalize((z_sig)));
feat_vec(5)       =  sum(abs(z_sig-detrend(z_sig)));

%%

end

