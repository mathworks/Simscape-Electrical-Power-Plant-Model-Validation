% Copyright 2020 The MathWorks, Inc.

% Load initial Generator Equipment Parameters in MATLAB workspace

loadParameters

%load manualParamsGAS

% Define data replay and open model template

replayParadigm = 'VF'; % set as 'VF'

mdl = ['template',replayParadigm,'replay'];

open_system(mdl)

% configure power plant model 

configurePowerPlant

% load measured data

loadMeasuredDataMulti

% parameters to estimate

params = {
    'dyn.pss2a_102_GAS.ks1'
    'dyn.pss2a_102_GAS.tw1'
    'dyn.pss2a_102_GAS.tw2'
    'dyn.rexs_102_GAS.tf'
    'dyn.genrou_102_GAS.h'
    };

% parameter constraints as a ratio of initial value

minParam = [0.9 0.9 0.9 0.9 0.9];
maxParam = [1.1 1.1 1.1 1.1 1.1];

idxO = [1 2]; % select signals to be used for objective function calculation.

% enable or disable load flow every iteration (if parameters are all time
% constants and/or PSS parameters, you may disable the load flow)

loadFlowEnable = 0; % 1 - enabled, 0 - disabled

loadFlowReport = 'off'; % if load flow is enabled, set report option ('on','off','iter')

% estimate parameters

estimateParametersMulti