% Copyright 2020 The MathWorks, Inc.

%% Options for operating point solver

options = findopOptions;
options.DisplayReport = 'iter';
options.OptimizationOptions.Algorithm = 'interior-point';


%%

h = find_system(mdl,'LookUndermasks','all','FollowLinks','on','FindAll','on','MaskType','Synchronous Machine'); % handle to synchronous machine

set(h,'SetSaturation','on') % turn on saturation


for l = 1:numel(data)
    
    alg = 'interior-point';
    
    optimType = 'graddescent-elim';
    
    % Create the options
    opt = findopOptions('DisplayReport',loadFlowReport); % on off or iter are the three options for report display
    opt.OptimizerType = optimType;
    opt.OptimizationOptions.Algorithm = alg;
    opt.OptimizationOptions.TolX = 1e-2;
    opt.OptimizationOptions.TolFun = 1e-2;
    opt.OptimizationOptions.MaxIter = 200;
    opt.OptimizationOptions.TolCon =  1e-2;
    
    init = 1; %#ok<*NASGU>
 
    [opa,~,opspeca,opta] = load_flow_with_Sat_MOD(mdl,data(l),0,opt);
    
    %
    optimTypea = 'graddescent';
    
    opt1 = opta;
    
    opt1.OptimizerType = optimTypea;
    opt1.OptimizationOptions.Algorithm = 'interior-point';
    opt1.OptimizationOptions.TolX = 1e-1;
    opt1.OptimizationOptions.TolFun = 1e-1;
    opt1.OptimizationOptions.MaxIter = 200;
    opt1.OptimizationOptions.TolCon =  1e-1;
    
    opspeca = initopspec(opspeca,opa);
    [opa,opreporta] = findop(mdl,opspeca,opt1);
    
    op(l) = opa; %#ok<*SAGROW>
    
    opspec(l) = opspeca;
    
    opreport(l) = opreporta;
    
    init = 0;
    
end
