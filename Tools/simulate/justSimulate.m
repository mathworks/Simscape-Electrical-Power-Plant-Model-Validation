% Copyright 2020 The MathWorks, Inc.

plotObjFcn

%% Plot results

switch replayParadigm
    
    case 'PQF'
        
        plotPQReplayResults

    case 'PQ'
        
        plotPQReplayResults

    case 'VF'
        
        plotVFReplayResults
    
    case 'VFPE'
        
        plotVFReplayResults
        
    case 'PQVF'
        
        plotPQVFReplayResults
        
end
