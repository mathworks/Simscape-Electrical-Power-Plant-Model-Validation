% Copyright 2020 The MathWorks, Inc.

% Load initial Generator Equipment Parameters in MATLAB workspace

loadParameters

% Define data replay and open model template

replayParadigm = 'VF'; % set as 'VF'

mdl = ['template',replayParadigm,'replay'];

open_system(mdl)

% configure power plant model 

configurePowerPlant

% load measured data

loadMeasuredData

% parameters to estimate

dyn.pss2a_102_GAS.ks1 = 20;
dyn.pss2a_102_GAS.tw1 = 5;
dyn.pss2a_102_GAS.tw2 = 5;

params = {
    'dyn.pss2a_102_GAS.ks1'
    'dyn.pss2a_102_GAS.tw1'
    'dyn.pss2a_102_GAS.tw2'
    };

% parameter constraints as a ratio of initial value

minParam = [0.5 0.5 0.5 0.5 0.5];
maxParam = [2.0 2.0 2.0 2.0 2.0];

idxO = [1 2]; % select signals to be used for objective function calculation.

% enable or disable load flow every iteration (if parameters are all time
% constants and/or PSS parameters, you may disable the load flow)

loadFlowEnable = 0; % 1 - enabled, 0 - disabled

loadFlowReport = 'iter'; % if load flow is enabled, set report option ('on','off','iter')

% estimate parameters

estimateParameters