function [] = ROCPRC(testscore,label_test)
numOfClasses = size(testscore,2);
f1=figure;
%ROC
subplot(1,numOfClasses ,1)
diffscore = testscore(:,1) - max([testscore(:,2),testscore(:,3),testscore(:,4),testscore(:,5),testscore(:,6),testscore(:,7),testscore(:,8),testscore(:,9)]);
[X,Y,] = perfcurve(label_test,diffscore);
plot(X,Y)
area(X,Y,'FaceColor',lines(1),'FaceAlpha',0.2)
xlabel('False positive rate') 
ylabel('True positive rate')
title({'ROC Curve'})

%ROC
subplot(1,numOfClasses ,2)
diffscore = testscore(:,2) - max(max([testscore(:,1),testscore(:,3),testscore(:,4),testscore(:,5),testscore(:,6),testscore(:,7),testscore(:,8),testscore(:,9)]));
[X,Y,] = perfcurve(label_test,diffscore);
plot(X,Y)
area(X,Y,'FaceColor',lines(1),'FaceAlpha',0.2)
xlabel('False positive rate') 
ylabel('True positive rate')
title({'ROC Curve'})

%ROC
subplot(1,numOfClasses ,3)
diffscore = testscore(:,3) -max(max([testscore(:,1),testscore(:,2),testscore(:,4),testscore(:,5),testscore(:,6),testscore(:,7),testscore(:,8),testscore(:,9)]));
[X,Y,] = perfcurve(label_test,diffscore);
plot(X,Y)
area(X,Y,'FaceColor',lines(1),'FaceAlpha',0.2)
xlabel('False positive rate') 
ylabel('True positive rate')
title({'ROC Curve'})

%ROC
subplot(1,numOfClasses ,4)
diffscore = testscore(:,4) - max(max([testscore(:,1),testscore(:,3),testscore(:,2),testscore(:,5),testscore(:,6),testscore(:,7),testscore(:,8),testscore(:,9)]));
[X,Y,] = perfcurve(label_test,diffscore);
plot(X,Y)
area(X,Y,'FaceColor',lines(1),'FaceAlpha',0.2)
xlabel('False positive rate') 
ylabel('True positive rate')
title({'ROC Curve'})

%ROC
subplot(1,numOfClasses ,5)
diffscore = testscore(:,5) - max(max([testscore(:,1),testscore(:,3),testscore(:,4),testscore(:,2),testscore(:,6),testscore(:,7),testscore(:,8),testscore(:,9)]));
[X,Y,] = perfcurve(label_test,diffscore);
plot(X,Y)
area(X,Y,'FaceColor',lines(1),'FaceAlpha',0.2)
xlabel('False positive rate') 
ylabel('True positive rate')
title({'ROC Curve'})

%ROC
subplot(1,numOfClasses ,6)
diffscore = testscore(:,6) - max(max([testscore(:,1),testscore(:,3),testscore(:,4),testscore(:,5),testscore(:,2),testscore(:,7),testscore(:,8),testscore(:,9)]));
[X,Y,] = perfcurve(label_test,diffscore);
plot(X,Y)
area(X,Y,'FaceColor',lines(1),'FaceAlpha',0.2)
xlabel('False positive rate') 
ylabel('True positive rate')
title({'ROC Curve'})

%ROC
subplot(1,numOfClasses ,7)
diffscore = testscore(:,7) - max(max([testscore(:,1),testscore(:,3),testscore(:,4),testscore(:,5),testscore(:,6),testscore(:,2),testscore(:,8),testscore(:,9)]));
[X,Y,] = perfcurve(label_test,diffscore);
plot(X,Y)
area(X,Y,'FaceColor',lines(1),'FaceAlpha',0.2)
xlabel('False positive rate') 
ylabel('True positive rate')
title({'ROC Curve'})

%ROC
subplot(1,numOfClasses ,8)
diffscore = testscore(:,8) - max(max([testscore(:,1),testscore(:,3),testscore(:,4),testscore(:,5),testscore(:,6),testscore(:,7),testscore(:,2),testscore(:,9)]));
[X,Y,] = perfcurve(label_test,diffscore);
plot(X,Y)
area(X,Y,'FaceColor',lines(1),'FaceAlpha',0.2)
xlabel('False positive rate') 
ylabel('True positive rate')
title({'ROC Curve'})

%ROC
subplot(1,numOfClasses ,9)
diffscore = testscore(:,9) - max(max([testscore(:,1),testscore(:,3),testscore(:,4),testscore(:,5),testscore(:,6),testscore(:,7),testscore(:,8),testscore(:,2)]));
[X,Y,] = perfcurve(label_test,diffscore);
plot(X,Y)
area(X,Y,'FaceColor',lines(1),'FaceAlpha',0.2)
xlabel('False positive rate') 
ylabel('True positive rate')
title({'ROC Curve'})
%%%%%%%%%

f2=figure;
%PRC
subplot(1,numOfClasses ,1)
diffscore = testscore(:,1) - max(max([testscore(:,2),testscore(:,3),testscore(:,4),testscore(:,5),testscore(:,6),testscore(:,7),testscore(:,8),testscore(:,9)]));
[X,Y,] = perfcurve(label_test,diffscore,'XCrit', 'tpr', 'YCrit', 'prec');
plot(X,Y)
area(X,Y,'FaceColor',lines(1),'FaceAlpha',0.2)
xlabel('Recall')
ylabel('Precision')
title('PRC Curve')

%PRC
subplot(1,numOfClasses ,2)
diffscore = testscore(:,2) - max(max([testscore(:,1),testscore(:,3),testscore(:,4),testscore(:,5),testscore(:,6),testscore(:,7),testscore(:,8),testscore(:,9)]));
[X,Y,] = perfcurve(label_test,diffscore,'XCrit', 'tpr', 'YCrit', 'prec');
plot(X,Y)
area(X,Y,'FaceColor',lines(1),'FaceAlpha',0.2)
xlabel('Recall')
ylabel('Precision')
title('PRC Curve')


%PRC
subplot(1,numOfClasses ,3)
diffscore = testscore(:,3) - max(max([testscore(:,1),testscore(:,2),testscore(:,4),testscore(:,5),testscore(:,6),testscore(:,7),testscore(:,8),testscore(:,9)]));
[X,Y,] = perfcurve(label_test,diffscore,'XCrit', 'tpr', 'YCrit', 'prec');
plot(X,Y)
area(X,Y,'FaceColor',lines(1),'FaceAlpha',0.2)
xlabel('Recall')
ylabel('Precision')
title('PRC Curve')


%PRC
subplot(1,numOfClasses ,4)
diffscore = testscore(:,4) - max(max([testscore(:,1),testscore(:,3),testscore(:,2),testscore(:,5),testscore(:,6),testscore(:,7),testscore(:,8),testscore(:,9)]));
[X,Y,] = perfcurve(label_test,diffscore,'XCrit', 'tpr', 'YCrit', 'prec');
plot(X,Y)
area(X,Y,'FaceColor',lines(1),'FaceAlpha',0.2)
xlabel('Recall')
ylabel('Precision')
title('PRC Curve')


%PRC
subplot(1,numOfClasses ,5)
diffscore = testscore(:,5) - max(max([testscore(:,1),testscore(:,3),testscore(:,4),testscore(:,2),testscore(:,6),testscore(:,7),testscore(:,8),testscore(:,9)]));
[X,Y,] = perfcurve(label_test,diffscore,'XCrit', 'tpr', 'YCrit', 'prec');
plot(X,Y)
area(X,Y,'FaceColor',lines(1),'FaceAlpha',0.2)
xlabel('Recall')
ylabel('Precision')
title('PRC Curve')


%PRC
subplot(1,numOfClasses ,6)
diffscore = testscore(:,6) - max(max([testscore(:,1),testscore(:,3),testscore(:,4),testscore(:,5),testscore(:,2),testscore(:,7),testscore(:,8),testscore(:,9)]));
[X,Y,] = perfcurve(label_test,diffscore,'XCrit', 'tpr', 'YCrit', 'prec');
plot(X,Y)
area(X,Y,'FaceColor',lines(1),'FaceAlpha',0.2)
xlabel('Recall')
ylabel('Precision')
title('PRC Curve')


%PRC
subplot(1,numOfClasses ,7)
diffscore = testscore(:,7) - max(max([testscore(:,1),testscore(:,3),testscore(:,4),testscore(:,5),testscore(:,6),testscore(:,2),testscore(:,8),testscore(:,9)]));
[X,Y,] = perfcurve(label_test,diffscore,'XCrit', 'tpr', 'YCrit', 'prec');
plot(X,Y)
area(X,Y,'FaceColor',lines(1),'FaceAlpha',0.2)
xlabel('Recall')
ylabel('Precision')
title('PRC Curve')


%PRC
subplot(1,numOfClasses ,8)
diffscore = testscore(:,8) - max(max([testscore(:,1),testscore(:,3),testscore(:,4),testscore(:,5),testscore(:,6),testscore(:,7),testscore(:,2),testscore(:,9)]));
[X,Y,] = perfcurve(label_test,diffscore,'XCrit', 'tpr', 'YCrit', 'prec');
plot(X,Y)
area(X,Y,'FaceColor',lines(1),'FaceAlpha',0.2)
xlabel('Recall')
ylabel('Precision')
title('PRC Curve')

%PRC
subplot(1,numOfClasses ,9)
diffscore = testscore(:,9) - max(max([testscore(:,1),testscore(:,3),testscore(:,4),testscore(:,5),testscore(:,6),testscore(:,7),testscore(:,8),testscore(:,2)]));
[X,Y,] = perfcurve(label_test,diffscore,'XCrit', 'tpr', 'YCrit', 'prec');
plot(X,Y)
area(X,Y,'FaceColor',lines(1),'FaceAlpha',0.2)
xlabel('Recall')
ylabel('Precision')
title('PRC Curve')
end



