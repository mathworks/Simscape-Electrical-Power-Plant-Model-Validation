% Copyright 2020 The MathWorks, Inc.

%% Open the Simulink model under consideration

open_system(mdl)

Exp = sdo.Experiment(mdl); % define experiment object

%% Initialize Model

for l = 1:numel(dataSim)

    dataSim(l).maxP = max(abs(dataSim(l).Pact - dataSim(l).Pact(1))); %#ok<*SAGROW>
    dataSim(l).maxQ = max(abs(dataSim(l).Qact - dataSim(l).Qact(1)));
    
    dataSim(l).maxV = max(abs((dataSim(l).Vact - dataSim(l).Vact(1))/Vnom));
    dataSim(l).maxF = max(abs((dataSim(l).Fact - dataSim(l).Fact(1))/Fnom));

end

%% Define Data IO Structure
data = definePQVFIO(dataSim,Vnom,Fnom,MBase); % define the IO data structure

%% Load Flow

load_flow % run the load flow


%%

switch replayParadigm
    
    case 'PQ'
        
        port = 'VFo';
    
    case 'PQF'
        
        port = 'VFo';
        
    case 'VF'
        
        port = 'PQo';
        
    case 'PQVF'
        
        port = 'PQVFo';
        
end
  
%Exp = definePQVFExp(mdl,dataSim,op,Exp,Fnom,Vnom,maxP,maxQ,maxV,maxF,replayParadigm,port); % define the experiment

Exp = definePQVFExp(mdl,dataSim,op,Exp,Fnom,Vnom,replayParadigm,port); % define the experiment


%% Parameter Estimation

fn = fieldnames(dyn);

stop_optim

p = sdo.getParameterFromModel(mdl,params); % place parameters in sdo object

for lp = 1:numel(params)
    
    p(lp).Maximum = p(lp).Value*maxParam(lp);
    p(lp).Minimum = p(lp).Value*minParam(lp);
    p(lp).Scale   = 1;
    
end

tic;pOpt = spe_Parameter_Estimation_GEN(p,mdl,'interior-point',Exp,opspec,paramsRel,paramsValues,[mdl,'/',port],idxO,loadFlowEnable,loadFlowReport);toc

% ------------------------------------------------------------------------%

for lnp = 1:numel(pOpt) % set workspace variables to new values
    
    eval([pOpt(lnp).Name,' = pOpt(lnp).Value;'])
    
end

save([pwd,'\OptimResults\pOpt_data'],'pOpt')
