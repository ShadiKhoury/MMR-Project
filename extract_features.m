%% Feature Selection
function feat_vec=extract_features(f_sig,n_features,sample_rate,ind)
feat_vec      =   zeros(1,n_features);                              %creating a vector with 1 row and n_features columns
x_sig=f_sig(ind,1); y_sig=f_sig(ind,2); z_sig=f_sig(ind,3);
new_sig=[x_sig,y_sig,z_sig];
 
feat_vec(1)   = mean(x_sig); feat_vec(2)  = mean(y_sig); feat_vec(3)  = mean(z_sig);      %mean features
feat_vec(4)   = range(x_sig); feat_vec(5) = range(y_sig); feat_vec(6) = range(z_sig);     %range features
feat_vec(7)   = sum(diff(sign(diff(x_sig)))~=0);
feat_vec(8)   = sum(diff(sign(diff(y_sig)))~=0);
feat_vec(9)   = sum(diff(sign(diff(z_sig)))~=0);
feat_vec(10)  = max(diff(sqrt((x_sig.^2 + y_sig.^2 + z_sig.^2))));  %the first derivitive of the energy of acc
%[XP] = pentropy(x_sig,sample_rate); [YP] = pentropy(y_sig,sample_rate); [ZP] = pentropy(z_sig,sample_rate);  
%feat_vec(11)  = XP';                                                %returns the spectral entropy of vector x
%feat_vec(12)  = YP';                                                %returns the spectral entropy of vector x
%feat_vec(13)  = ZP';                                                %returns the spectral entropy of vector x
feat_vec(11)  = length(findpeaks(new_sig(:,1)));                    %feature number of peaks in x  
feat_vec(12)  = length(findpeaks(new_sig(:,2)));                    %feature number of peaks in y  
feat_vec(13)  = length(findpeaks(new_sig(:,3)));                    %feature number of peaks in z  
feat_vec(14)  = sum(isoutlier(f_sig(:,1)));                         % isouliner 5
feat_vec(15)  = kurtosis(new_sig(:,1));                             % Kurtosis 6
[Px,fx]       = pwelch(new_sig(:,1),[],[],[],sample_rate);
[Py,fy]       = pwelch(new_sig(:,2),[],[],[],sample_rate);
[Pz,fz]       = pwelch(new_sig(:,3),[],[],[],sample_rate);

%the 5th feature is the sum of the power spectral density (PSD)
feat_vec(16)  = sum(Px);  feat_vec(17) = sum(Py); feat_vec(18) = sum(Pz); 
max_mag_x     = max(Px(4:end));
f_max_mag_x   = fx(Px == max_mag_x);
max_mag_y     = max(Py(4:end));
f_max_mag_y   = fy(Py == max_mag_y);
max_mag_z     = max(Pz(4:end));
f_max_mag_z   = fz(Pz == max_mag_z);

%%Maximun Featuer frequancy 
feat_vec(19) = f_max_mag_x(1);   %the Frequancy of the maximan Power of the feature x 
feat_vec(20) = f_max_mag_y(1);   %the Frequancy of the maximan Power of the feature y 
feat_vec(21) = f_max_mag_z(1);   %the Frequancy of the maximan Power of the feature z 

        %% comparing the window's first and second half:
sig_squared        = new_sig(:,1).^2+new_sig(:,2).^2+new_sig(:,3).^2 ;%squered signal
derivate_sig       = diff(sig_squared)/sample_rate;                   %Dirvative of signal
center_of_acc      = round(length(derivate_sig)/2);                   %finding the center of the acc data
first_half         = sig_squared(1:center_of_acc-1);
second_half        = sig_squared(center_of_acc:end);
feat_vec(22)       = (std(first_half)-std(second_half));              %comparing std between windows parts 4
%% FFT and Amplitued 
fft_X              = fft(new_sig(:,1));% X axis
amp_X              = 20*log(abs(real(fft_X)));
feat_vec(23)       = std(amp_X);
fft_Y              = fft(new_sig(:,2));% Y axis
amp_Y              = 20*log(abs(real(fft_Y)));
feat_vec(24)       = std(amp_Y);
fft_Z              = fft(new_sig(:,1));% Z axis
amp_X              = 20*log(abs(real(fft_Z)));
feat_vec(25)       = std(amp_X);
%% max measure of the asymmetry of the probability distribution
skwe               = skewness(new_sig);  
feat_vec(26)       = max(skwe);
 %%  hte max interquartile range (The returned value is the difference between the 75th and the 25th percentile values for the distribution)
%iqr                = iqr(new_sig); %interquartile range (The returned value is the difference between the 75th and the 25th percentile values for the distribution)
%feat_vec(27)       = max(iq);
        %% MAXIMUM signal energy
EE                 =   sqrt(new_sig.^2);
feat_vec(27)       =   max(max(EE));
%%

end

