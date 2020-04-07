% Copyright 2020 The MathWorks, Inc.

% Load initial Generator Equipment Parameters in MATLAB workspace

loadParameters

% Define data replay and open model template

replayParadigm = 'PQ'; % set as 'PQ' or 'VF'

mdl = ['template',replayParadigm,'replay'];

open_system(mdl)


% load measured data

loadMeasuredData

% Snubber
% Calculate Psnubber for trimming (the snubber is in the PQ replay
% block)

Rsnubber = 100;  % Ohm, snubber resistance
Psnubber = (dataSim.Vact(1)*1e3)^2/Rsnubber;

% configure power plant model 

configurePowerPlant

%% Compare Simulation to Measured Response

loadFlowReport = 'iter'; % if load flow is enabled, set report option ('on','off','iter')

replayEventData

%% SSE

plotObjFcn

