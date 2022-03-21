%% Feature Selection
function feat_vec=extract_features_acc_triger_submit(f_sig,n_features,sample_rate,ind)
feat_vec      =   zeros(1,n_features);                              %creating a vector with 1 row and n_features columns
x_sig=f_sig(ind,1); y_sig=f_sig(ind,2); z_sig=f_sig(ind,3);
new_sig=[x_sig,y_sig,z_sig];
fft_Z              = fft(new_sig(:,1));% Z axis
amp_Z              = 20*log(abs(real(fft_Z)));
feat_vec(1)       = std(amp_Z);


%%
feat_vec(2)       =  entropy(normalize((x_sig)));
feat_vec(3)       =  entropy(normalize((y_sig)));
feat_vec(4)       =  entropy(normalize((z_sig)));
fft_Y              = fft(new_sig(:,2));% Y axis
amp_Y              = 20*log(abs(real(fft_Y)));
feat_vec(5)       = std(amp_Y);
end