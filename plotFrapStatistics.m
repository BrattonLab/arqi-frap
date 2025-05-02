

%figure
%scatter([1:60],abs(amp),16,rejectionClass.^2)

%% Replace path below with you own variables.
P87G=load('Z:\dsmendez\diana\code\Diana\frapTestCombined2\masked\1\varsFinal.mat');
WT=load('Z:\dsmendez\diana\code\Diana\frapTestCombined2\masked\2\varsFinal.mat');
R16A=load('Z:\dsmendez\diana\code\Diana\frapTestCombined2\masked\3\varsFinal.mat');
R49Q=load('Z:\dsmendez\diana\code\Diana\frapTestCombined2\masked\4\varsFinal.mat');

%%
D1=P87G.Dfilt;
D2=WT.Dfilt;
D3=R16A.Dfilt;
D4=R49Q.Dfilt;

mean(D1)
mean(D2)
mean(D3)
mean(D4)
figure

a1=repmat (1,[length(D1),1]) 
b1=repmat (2,[length(D2),1]) 
c1=repmat (3,[length(D3),1]) 
d1=repmat (4,[length(D4),1]) 

labelsPlot1=[a1',b1',c1',d1'];

Dmat = nan(max([length(D1),length(D2),length(D3),length(D4)]),4)
Dmat(1:length(D2),1)=D2;
Dmat(1:length(D1),2)=D1;
Dmat(1:length(D3),3)=D3;
Dmat(1:length(D4),4)=D4;
fracCol=[D2,D1,D3,D4];
%jitterplot(fracCol,labelsPlot1)
% hold on
%violin(Dmat)
figure;boxplot(Dmat,'Notch','on','Labels',{'WT','P87G','R16A','R49Q'},'whisker',1)

% title('Compare Random Data from Different Distributions')
%%


[~,P12]=ttest(Dmat(:,1),Dmat(:,2))
[~,P13]=ttest(Dmat(:,1),Dmat(:,3))
[~,P14]=ttest(Dmat(:,1),Dmat(:,4))
[~,P23]=ttest(Dmat(:,2),Dmat(:,3))
[~,P24]=ttest(Dmat(:,2),Dmat(:,4))
[~,P34]=ttest(Dmat(:,3),Dmat(:,4))

% P values should past a pairswise comparison with the bonferroni
% correction to account for multiple comparisons. 
%%
mB1=P87G.mobFracFilt;
mB2=WT.mobFracFilt;
mB3=R16A.mobFracFilt;
mB4=R49Q.mobFracFilt;

mBmat = nan(max([length(mB1),length(mB2),length(mB3),length(mB4)]),4)
mBmat(1:length(mB2),1)=mB2;
mBmat(1:length(mB1),2)=mB1;
mBmat(1:length(mB3),3)=mB3;
mBmat(1:length(mB4),4)=mB4;

csvwrite('Z:\dsmendez\diana\code\Diana\frapTestCombined2\masked\mBData.csv',mBmat)

