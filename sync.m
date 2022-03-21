function sync_data=sync(long_time,short_time,short_data,long_data)
[times_12, inds] = unique([long_time; short_time]); % (must use distrinct times)
l=length(long_time);
dataset_12 = [short_data;long_data];
dataset_12 = dataset_12(inds,:);
times_3 = linspace(min(times_12), max(times_12),l); 

% Now interpolate
sync_data = interp1(times_12, dataset_12, times_3) % (oldtime , data , newtime)
end
