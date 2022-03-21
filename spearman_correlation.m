function rho=spearman_correlation(x,y)
%calculate the pearson correlation between x and y
rho=0;
n=length(x);
if length(y)==n %x and y must to be in the same length
[~,i]=sort(x,'descend'); %we want the sorted values of x from the highes to the lowest
[~,Rank_x]=sort(i,'ascend'); %the previus line didn't give us the indices in a sorted order.
%for example, it gives: [3,1,2]. We want it to be [1,2,3] so we sort i
[~,i]=sort(y,'descend'); %we want the sorted values of x where 1 is the highest
[~,Rank_y]=sort(i,'ascend'); %sorting i vector of y indices
rho=pearson_correlation(Rank_x,Rank_y); %using pearson correlation
else
disp('spearman_correlation: vectors must be of the same length')
end