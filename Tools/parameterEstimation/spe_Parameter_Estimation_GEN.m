function pOpt = spe_Parameter_Estimation_GEN(p,mdl,alg,Exp,opspec,paramsRel,paramsValues,port,idxO,loadFlowEnable,loadFlowReport)
% Copyright 2020 The MathWorks, Inc.
%
% pOpt = spe_Parameter_Estimation_GEN(p,mdl,alg,Exp,opspec,paramsRel,paramsValues,port,idxO)
%
% port - the ouput port that contains the signals used by the objective
% function, e.g. [mdl,'/PQVFo']
% idxO - an index for which signals in 'port' are used to calculate the
% objective function, e.g. for PQVF, idxO = [1 2 3]; will use only the PQV
% signals, idxO = [1 2 3 4]; will use all four, i.e. PQVF.


%% Create Estimation Objective Function
%
% Create a function that is called at each optimization iteration
% to compute the estimation cost.
%
% Use an anonymous function with one argument that calls Exciter_Generator_Vt_replay_optFcn.
optimfcn = @(P) Exciter_Generator_No_Load_optFcn(P,Exp,mdl,opspec,paramsRel,paramsValues,port,idxO,loadFlowEnable,loadFlowReport);


%% Optimization Options
%
% Specify optimization options.
Options = sdo.OptimizeOptions('Method','fmincon');
Options.MethodOptions.Algorithm = alg;
Options.MethodOptions.TolX = 1e-12;
Options.MethodOptions.TolFun = 1e-12;
Options.MethodOptions.MaxIter = 1000;
Options.MethodOptions.OutputFcn = @outfun;
Options.MethodOptions.TolCon =  1e-12;
Options.MethodOptions.UseParallel =  true;

%% Estimate the Parameters
%
% Call sdo.optimize with the estimation objective function handle,
% parameters to estimate, and options.
pOpt = sdo.optimize(optimfcn,p,Options);

%%
% Update the experiments with the estimated parameter values.
%Exp = setEstimatedValues(Exp,pOpt); %#ok<*NASGU>

%% Update Model
%
% Update the model with the optimized parameter values.
%sdo.setValueInModel(mdl,pOpt);

end

function Vals = Exciter_Generator_No_Load_optFcn(P,Exp,mdl,opspec,paramsRel,paramsValues,port,idxO,loadFlowEnable,loadFlowReport)
%PGE_ST4B_EXCITER_GENERATOR_INFINITEBUS_TMW_OPTFCN
%
% Function called at each iteration of the estimation problem.
%
% The function is called with a set of parameter values, P, and returns
% the estimation cost, Vals, to the optimization solver.
%
% See the sdoExampleCostFunction function and sdo.optimize for a more
% detailed description of the function signature.
%

%%
% Define a signal tracking requirement to compute how well the model
% output matches the experiment data.
r = sdo.requirements.SignalTracking;
r.Method = 'SSE';
r.RobustCost = 'off';

%[P(1).Value P(2).Value P(3).Value P(4).Value P(5).Value P(6).Value P(7).Value P(8).Value P(9).Value P(10).Value P(11).Value P(12).Value]

%%
% Update the experiment(s) with the estimated parameter values.
Exp = setEstimatedValues(Exp,P);

%%
% Simulate the model and compare model outputs with measured experiment
% data.

h = find_system(mdl,'FindAll','on','MaskType','Synchronous Machine'); % handle to synchronous machine

for l = 1:numel(Exp(1).Parameters) % all experiments share the same parameters
    
    evalin('base',[Exp(1).Parameters(l).Name,' = ',num2str(Exp(1).Parameters(l).Value),';']) 
    
end

opt = findopOptions('DisplayReport',loadFlowReport); % on off or iter are the three options for report display

optimType = 'graddescent';

opt.OptimizerType = optimType;
opt.OptimizationOptions.Algorithm = 'active-set';
opt.OptimizationOptions.TolX = 1e-1;
opt.OptimizationOptions.TolFun = 1e-1;
opt.OptimizationOptions.MaxIter = 200;
opt.OptimizationOptions.TolCon =  1e-1;

op = evalin('base','op');
opspec = evalin('base','opspec');

assignin('base','init',1)
    
if loadFlowEnable == 1
   
    opspec=initopspec(opspec,op);
    [op,~] = findop(mdl,opspec,opt);
    
end

assignin('base','init',0)
    
for noExp = 1:numel(Exp)
    
    assignin('base','opspec',opspec);
    assignin('base','op',op(noExp))
    
    strOP = mat2str(Exp(noExp).OutputData(1).Values.Time);
    
    yy = sim(mdl,'OutputOption','SpecifiedOutputTimes','OutputTimes',strOP); % simulator object not used

    yout = get(yy,'yout');
    
    idxS = false(numel(yout.signals),1);
    
    for ls = 1:numel(yout.signals) % index into the correct output port for the objective function calculation
        
        idxS(ls) = strcmp(yout.signals(ls).blockName,port);
        
    end
    
    Sig.Values = timeseries(yout.signals(idxS).values,yout.time); % PQgo
    
    sV = Sig.Values;
    eO = Exp.OutputData.Values;
    
    sV.Data = sV.Data(:,idxO);
    eO.Data = eO.Data(:,idxO);
    
    Error = evalRequirement(r,sV,eO);
    
     F_r.(['error',num2str(noExp)]) = Error/Exp(noExp).OutputData.Values.Time(end); %#ok<*AGROW>
    
    figure(1),subplot(1,numel(Exp),noExp),plot(Exp(noExp).OutputData.Values.Time,Exp(noExp).OutputData.Values.Data,Sig.Values.Time,Sig.Values.Data)
    xlabel('Time (s)'),ylabel(Exp(1).OutputData.Name),title(['Experiment ',num2str(noExp),' : f(x) = ',num2str(ceil(F_r.error1*1000)/1000)])
    

    drawnow
    
    
    for lcs = 1:numel(Exp(noExp).Parameters)
        
        idxRel = ismember(paramsRel,Exp(noExp).Parameters(lcs).Name);
        
        paramsValues(idxRel) = Exp(noExp).Parameters(lcs).Value;
        
    end
    
    PConstr.(['PC',num2str(noExp)]) = [
        paramsValues(4)  - paramsValues(1) % Xd    >=  Xq
        paramsValues(5)  - paramsValues(4) % Xq    >=  Xq_t
        paramsValues(2)  - paramsValues(5) % Xq_t  >=  Xd_t
        paramsValues(6)  - paramsValues(2) % Xd_t  >=  Xq_tt
        paramsValues(3)  - paramsValues(6) % Xq_tt >=  Xd_tt
        paramsValues(8)  - paramsValues(7) % Tdo_t >=  Tdo_tt
        paramsValues(10) - paramsValues(9) % Tqo_t >=  Tqo_tt
        ];
    
end

%% Return Values.
%
% Return the evaluated estimation cost in a structure to the
% optimization solver.

ffn = fieldnames(F_r);
ffp = fieldnames(PConstr);

Vals.F = 0;
Vals.Cleq = [];

for l = 1:numel(ffn)
    
    Vals.F = Vals.F + abs(F_r.(ffn{l}));
    
    Vals.Cleq = [Vals.Cleq;PConstr.(ffp{l})];
    
end

end

