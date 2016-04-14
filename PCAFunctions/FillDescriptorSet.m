function [descriptorSet] = FillDescriptorSet(MLMSet)
    
    trackedMLMSet = {'mAll1', 'mAll2','mStdS','mStdT','mSkewS','mSkewT','mKurtS','mKurtT', ...
        'stdMS','stdMT','stdStdS','stdStdT','stdSkewS','stdSkewT','stdKurtS','stdKurtT'};
    
    
    descriptorSet = {};
    idx = 0;
    for i = 1:numel(MLMSet)
        
        temp = cellfun(@(x) [MLMSet{i} '-' x], trackedMLMSet, 'UniformOutput',false);
        for j = 1:16
            descriptorSet{idx+j} = temp{j};
        end
        idx = idx +16;
        
        switch(MLMSet{i})
            case 'CC'
                temp = cellfun(@(x) [MLMSet{i} '-std-' x], trackedMLMSet, 'UniformOutput',false);
                for j = 1:16
                    descriptorSet{idx+j} = temp{j};
                end
                idx = idx +16;
                
                temp = cellfun(@(x) [MLMSet{i} '-range-' x], trackedMLMSet, 'UniformOutput',false);
                for j = 1:16
                    descriptorSet{idx+j} = temp{j};
                end
                idx = idx +16;
            case 'SLHC'
                temp = cellfun(@(x) [MLMSet{i} '-nExemp-' x], trackedMLMSet, 'UniformOutput',false);
                for j = 1:16
                    descriptorSet{idx+j} = temp{j};
                end
                idx = idx +16;
                
                temp = cellfun(@(x) [MLMSet{i} '-optDist-' x], trackedMLMSet, 'UniformOutput',false);
                for j = 1:16
                    descriptorSet{idx+j} = temp{j};
                end
                idx = idx +16;
                
            case 'FEPC'
                temp = cellfun(@(x) [MLMSet{i} '-cIdx-' x], trackedMLMSet, 'UniformOutput',false);
                for j = 1:16
                    descriptorSet{idx+j} = temp{j};
                end
                idx = idx +16;
            case 'FCSP'
                temp = cellfun(@(x) [MLMSet{i} '-range-' x], trackedMLMSet, 'UniformOutput',false);
                for j = 1:16
                    descriptorSet{idx+j} = temp{j};
                end
                idx = idx +16;
                
        end
        
    end
    
end