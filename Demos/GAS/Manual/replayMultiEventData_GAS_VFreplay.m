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

loadMeasuredDataMulti

%% Compare Simulation to Measured Response

loadFlowReport = 'iter'; % if load flow is enabled, set report option ('on','off','iter')

replayMultiEventData


