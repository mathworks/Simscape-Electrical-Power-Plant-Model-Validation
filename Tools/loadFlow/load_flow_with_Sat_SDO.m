function [op,opreport,opspec,opt] = load_flow_with_Sat_SDO(model,initState,alg,opspec,rep)
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

if initState == 0
    
    set_param(model,'LoadExternalInput','off');
    set_param(model,'LoadInitialState','off');

elseif initState == 1

    set_param(model,'LoadExternalInput','on');
    set_param(model,'LoadInitialState','on');

end


%% Create the options
opt = findopOptions('DisplayReport',rep); % on off or iter are the three options for report display
opt.OptimizationOptions.Algorithm = alg;

%% Perform the operating point search.
[op,opreport] = findop(model,opspec,opt);

%% 

set_param(model,'LoadExternalInput','on');
set_param(model,'LoadInitialState','on');


