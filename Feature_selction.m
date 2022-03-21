function [idx,weights]=Feature_selection(data,labels,k)

[idx,weights] = relieff(data,labels,k)% Filter Method and SFS featuers are added
bar(weights(idx))
xlabel("Predictor rank")
ylabel("Predictor Importnace Score")

xtickangle(45)
end

