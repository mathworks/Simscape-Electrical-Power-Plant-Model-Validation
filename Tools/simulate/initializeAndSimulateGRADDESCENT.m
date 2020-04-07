% Copyright 2020 The MathWorks, Inc.
opspec=initopspec(opspec,op);
opt.OptimizerType = 'graddescent';
init = 1;
[op,opreport] = findop(mdl,opspec,opt);
init = 0;

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
