function R_square=pearson_correlation(x,y)
%calculate the pearson correlation between x and y
R_square=0;
n=length(x);
if n==length(y) %x and y must to be in the same length
Nx=(x-mean(x))/std(x);
Ny=(y-mean(y))/std(y);
R_square=(sum(Nx.*Ny))/(n-1);
else
disp('pearson_correlation: vectors must be of the same length')
end