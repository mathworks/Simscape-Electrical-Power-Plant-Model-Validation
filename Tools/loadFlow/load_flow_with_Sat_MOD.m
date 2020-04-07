function [op,opreport,opspec,opt] = load_flow_with_Sat_MOD(model,data,initState,opt)
% Copyright 2020 The MathWorks, Inc.
%
% [op,opreport] = load_flow_with_Sat(model,data,initState,alg,op1)
%
% model = model name
% data = data structure that has fieldnames that match the input and output ports
% initState = 0 if there is no previous operating condition for this model
% initState = 1 if there is a previous operating condition for this model, and you want to use that operating condition as the start point for rerunning the load flow
% alg = algorithm used. 'interior-point' is recommended.
% op1 = operating point from load flow without saturation
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
% 


if initState == 0
    
    set_param(model,'LoadExternalInput','off');
    set_param(model,'LoadInitialState','off');

elseif initState == 1

    set_param(model,'LoadExternalInput','on');
    set_param(model,'LoadInitialState','on');

end

%% Inports & Outports

opspec = operspec(model);

%opspec=initopspec(opspec,op1);

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


% for lstates = 1:numel(opspec.States)
% 
%         opspec.States(lstates).x     = op1.States(lstates).x;
%         
% end


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
 %   opspec.States(idxElec(lE)).Known = true;
    
end

idxTheta = find(~cellfun(@isempty,regexpi(bNames,'theta integrator')));


for lT = 1:numel(idxTheta)
    
    opspec.States(idxTheta(lT)).SteadyState = false;
    opspec.States(idxTheta(lT)).x = 0;
    opspec.States(idxTheta(lT)).Known = true;
    
end
% 
% idxMech = find(~cellfun(@isempty,regexpi(bNames,'Mechanical model/Integrator1')));
% 
% for lM = 1:numel(idxMech)
%     
%     opspec.States(idxMech(lM)).SteadyState = false;
%     opspec.States(idxMech(lM)).x = -pi/2;
%     opspec.States(idxMech(lM)).Known = true;
%     
% end
% 
% idxMech = find(~cellfun(@isempty,regexpi(bNames,'Mechanical model/Integrator2')));
% 
% for lM = 1:numel(idxMech)
%     
%     opspec.States(idxMech(lM)).SteadyState = false; % false
%     opspec.States(idxMech(lM)).Known = false;
%     
% end

idxM1 = find(~cellfun(@isempty,regexpi(bNames,'Mechanical model/Rotor angle thetam')) | ~cellfun(@isempty,regexpi(bNames,'Mechanical model/Integrator1')) | ~cellfun(@isempty,regexpi(bNames,'Mechanical model/measurements/Integrator1')) | ~cellfun(@isempty,regexpi(bNames,'Mechanical model/Integrator2')));% & cellfun(@isempty,regexpi(bNames,'Mechanical model/Integrator1')));

for lM1 = 1:numel(idxM1)
    
    opspec.States(idxM1(lM1)).SteadyState = false;
    
end

% 
% 
% idxSat = find(~cellfun(@isempty,regexpi(bNames,'Time Constant/Integrator')));
% 
% for lS = 1:numel(idxSat)
%     
%     opspec.States(idxSat(lS)).x = op1.States(idxSat(lS)).x;
%     opspec.States(idxSat(lS)).Known = true;
%     
% end

%% Transfer op1 values to opspec

% for ls = 1:numel(op1.States)
% 
%     opspec.States(ls).x = op1.States(ls).x;
%     
% end

% for li = 1:numel(op1.Inputs)
% 
%     opspec.Inputs(li).u = op1.Inputs(li).u;
%     
% end

%opspec.Inputs(1).Known = true;
    
% opspec.Inputs(1).Known = 0;
% opspec.Inputs(2).Known = 1;


%% Perform the operating point search.


% idxGov = find(~cellfun(@isempty,regexpi(bNames,'/S1_TF/Integrator')) & ~cellfun(@isempty,regexpi(bNames,'General Governor')));
% 
% for lS = 1:numel(idxGov)
%     
%     opspec.States(idxGov(lS)).x = 0;
%     opspec.States(idxGov(lS)).Known = true;
%     
% end

[op,opreport] = findop(model,opspec,opt);

%opspec=initopspec(opspec,op); 

%% 
% 
% set(h1a,'Commented','off'); 
% set(h1b,'Commented','off'); 
% set(h1c,'Commented','off'); 
% set(h2,'Commented','off'); 
% 

set_param(model,'LoadExternalInput','on');
set_param(model,'LoadInitialState','on');


