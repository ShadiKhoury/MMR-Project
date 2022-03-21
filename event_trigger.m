function [response] =event_trigger(sig,ind)
%original signal = sig 
%ind = windows vector
sig1            = sig(ind);                  %sig1 = signal in window indexs
center_of_acc   = round(length(sig1)/2);     % Half of the signals 
first_half      = sig1(1:center_of_acc-1);   % signal1 from 1 to first Half 0 to 2.5 second
second_half     = sig1(center_of_acc:end); % signal1 from first half to end 2.5 to 5 second
r               = std(first_half)-std(second_half) %cheaking the std from the different windows
if max(ind) <= 125     %10 seconds
    ind1=1             % going back X second 
else
    ind1= min(ind)-125; % going back 5 seconds
end
ind2                = ind1+125;       % original window before 5 seconds 
sig_5_before        = sig(ind1:ind2); % window from -10 to -5 seconds before. 
center_of_acc       = round(length(sig_5_before)/2); %-2.5 seconds
first_half          = sig_5_before(1:center_of_acc-1); %first_half fron 0 to -
second_half         = sig_5_before(center_of_acc:end);
r1                  = std(first_half)-std(second_half)

if r>r1 
    response=1 % extract feature
else
    response=0 % pass window 
end
end




