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


%% Parameter estimation

% parameters to estimate

params = {
    'dyn.genrou_102_STEAM.h'
    'dyn.pss2b_102_STEAM.tw1'
    'dyn.pss2b_102_STEAM.tw2'
    'dyn.pss2b_102_STEAM.ks1'
    };

% parameter constraints as a ratio of initial value

minParam = [0.2 0.2 0.2 0.2 0.2];
maxParam = [5.0 5.0 5.0 5.0 5.0];

idxO = [1 2]; % select signals to be used for objective function calculation.

% enable or disable load flow every iteration (if parameters are all time
% constants and/or PSS parameters, you may disable the load flow)

loadFlowEnable = 0; % 1 - enabled, 0 - disabled

loadFlowReport = 'off'; % if load flow is enabled, set report option ('on','off','iter')

% estimate parameters

estimateParameters