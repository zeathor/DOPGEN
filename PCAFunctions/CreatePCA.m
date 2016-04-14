function [ PCASet, dataRaw, dataClean ] = CreatePCA(dynamicSet, DOPSet, MLMSet, settings)
%% This script is solely for PCA stuff
fileName = 'ADPB-PCA-';
if(isfield(settings,'groupName') == 0)
    groupName = [DOPSet{:}, '-', dynamicSet{:}];
    legendStr = groupName;
else
    groupName = settings.groupName;
end

if(numel(dynamicSet)*numel(DOPSet) == 3)
    cMap = [0 0 1; 0 1 0; 1 0 0];
elseif(numel(dynamicSet)*numel(DOPSet) == 2)
    cMap = [0 0 1; 1 0 0];
else
    cMap = jet(numel(dynamicSet)*numel(DOPSet));
end
[ dataSet, descriptorSet, IDSet, dStart, dEnd, dStep] = GenerateDataSet(DOPSet, dynamicSet,MLMSet,settings);


[ newDataSet, newDescriptorSet] = PostProcessDataSet(dataSet, descriptorSet,settings.statsRemove);


[coeff,score,ev,~,explained] = pca(newDataSet,'VariableWeights','variance');


figure('units','normalized','outerposition',[0 0 1 1]); hold on
for i = 1:length(dStart)
    sMap = linspace(50,500,(dEnd(i)-dStart(i)+1)/dStep(i));
    sMap = repmat(sMap, dStep(i), 1);
    sMap = reshape(sMap,1,numel(sMap));
    
    scatter(score(dStart(i):dEnd(i),1),score(dStart(i):dEnd(i),2),sMap, 'MarkerFaceColor',cMap(i,:), 'markeredgecolor','k');
%     for j = 1:(dEnd(i)-dStart(i)+1)/dStep(i)
%         scoreStart = dStart(i)+(j-1)*dStep(i); 
%         scoreEnd = scoreStart+dStep(i)-1;
%         scatter(score(scoreStart:scoreEnd,1),score(scoreStart:scoreEnd,2),sMap(j), 'MarkerFaceColor',cMap(i,:));
%     end
end

grid on


if(numel(DOPSet) == 1)
    legendStr = dynamicSet;
elseif(numel(dynamicSet) == 1)
    legendStr = DOPSet;
else
    for i = 1:numel(DOPSet)
        for j = 1:numel(dynamicSet)
            legendStr{j+(i-1)*numel(dynamicSet)} = [DOPSet{i} '-' dynamicSet{j}];
        end
    end
end

legend(legendStr{:});
saveFigure([fileName groupName]);
    
dataRaw.dataSet = dataSet;
dataRaw.descriptorSet = descriptorSet;
dataRaw.IDSet = IDSet;

dataClean.dataSet = newDataSet; 
dataClean.descriptorSet = newDescriptorSet;
dataClean.IDSet = IDSet;

PCASet.coeff = coeff;
PCASet.score = score;
PCASet.ev = ev;
% PCASet.tsquare = tsquare;
PCASet.explained = explained;
end

