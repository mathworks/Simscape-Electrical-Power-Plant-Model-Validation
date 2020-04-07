function [op,opreport,opspec,opt] = load_flow_INIT(model,data,initState,alg)
% Copyright 2020 The MathWorks, Inc.
%
% [op,opreport] = test_LF(model,Vt0,initState)
%
% model = model name
% data = data structure that has fieldnames that match the input and output ports
% initState = 0 if there is no previous operating condition for this model
% initState = 1 if there is a previous operating condition for this model, and you want to use that operating condition as the start point for rerunning the load flow
% alg = algorithm used. 'interior-point' is recommended.
%

% h1a = find_system(model,'FollowLinks','on','IncludeCommented','on','LookUnderMasks','All','FindAll','on','BlockType','Saturate'); % find saturation blocks
% h1b = find_system(model,'FollowLinks','on','IncludeCommented','on','LookUnderMasks','All','FindAll','on','BlockType','DeadZone'); % find saturation blocks
% h1c = find_system(model,'FollowLinks','on','IncludeCommented','on','LookUnderMasks','All','FindAll','on','BlockType','Backlash'); % find saturation blocks
% h2 = find_system(model,'FollowLinks','on','IncludeCommented','on','LookUnderMasks','All','FindAll','on','Name','integrator_reset'); % find integrator reset blocks
% 
% 
% set(h1a,'Commented','through'); % comment through all saturation blocks
% set(h1b,'Commented','through'); % comment through all saturation blocks
% set(h1c,'Commented','through'); % comment through all saturation blocks
% set(h2,'Commented','on'); % comment out all integrator reset blocks


if initState == 0
    
    set_param(model,'LoadExternalInput','off');
    set_param(model,'LoadInitialState','off');

elseif initState == 1

    set_param(model,'LoadExternalInput','on');
    set_param(model,'LoadInitialState','on');

end

%% Inports & Outports

opspec = operspec(model);

for lin = 1:numel(opspec.Inputs)

    a1 = strsplit(opspec.Inputs(lin).Block,'/');
    
    if sum(ismember(fieldnames(data),a1{2})) > 0
        
        opspec.Inputs(lin).u     = data.(a1{2}).u;
        opspec.Inputs(lin).Known = data.(a1{2}).Known;
        
    end
    
end

for lout = 1:numel(opspec.Outputs)

    a2 = strsplit(opspec.Outputs(lout).Block,'/');
    
    if sum(ismember(fieldnames(data),a2{2})) > 0
        
        opspec.Outputs(lout).y     = data.(a2{2}).y;
        opspec.Outputs(lout).Known = data.(a2{2}).Known;
        
    end
    
end

%%


bNames = cell(numel(opspec.getstatestruct.signals),1);

for l = 1: numel(opspec.getstatestruct.signals)
    
    bNames{l} = opspec.getstatestruct.signals(l).blockName;
    
end

% index into the states that need to be set as non-steady-state

idxElec = find(~cellfun(@isempty,regexpi(bNames,'Electrical model/Integrator')));

for lE = 1:numel(idxElec)
    
    opspec.States(idxElec(lE)).SteadyState = false;
    opspec.States(idxElec(lE)).x = 0;
    opspec.States(idxElec(lE)).Known = true;
    
end



idxTheta = find(~cellfun(@isempty,regexpi(bNames,'theta integrator')));

for lT = 1:numel(idxTheta)
    
    opspec.States(idxTheta(lT)).SteadyState = false;
    opspec.States(idxTheta(lT)).x = 0;
    opspec.States(idxTheta(lT)).Known = true;
    
end



idxMech = find(~cellfun(@isempty,regexpi(bNames,'Mechanical model/measurements/Integrator')) | ~cellfun(@isempty,regexpi(bNames,'Mechanical model/Rotor angle thetam')) | ~cellfun(@isempty,regexpi(bNames,'Mechanical model/Integrator1'))  | ~cellfun(@isempty,regexpi(bNames,'Mechanical model/Integrator1')) | ~cellfun(@isempty,regexpi(bNames,'Mechanical model/theta')));

for lM = 1:numel(idxMech)
    
    opspec.States(idxMech(lM)).SteadyState = false;
    opspec.States(idxMech(lM)).x = -pi/2;
    opspec.States(idxMech(lM)).Known = true;
    
end

%% Create the options
opt = findopOptions('DisplayReport','iter'); % on off or iter are the three options for report display
opt.OptimizationOptions.Algorithm = alg;

%% Perform the operating point search.
[op,opreport] = findop(model,opspec,opt);

%% 

% set(h1a,'Commented','off');
% set(h1b,'Commented','off');
% set(h1c,'Commented','off');
% set(h2,'Commented','off');

set_param(model,'LoadExternalInput','on');
set_param(model,'LoadInitialState','on');


