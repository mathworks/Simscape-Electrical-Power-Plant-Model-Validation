% Copyright 2020 The MathWorks, Inc.
%% Measured data

events = {'01' '02' '03' '04' '05' '06' '07' '08' '09' '10' '11' '12'};

l = 1; % event under frequency control

dataMeas = readtable(['Event-',events{l},'-2016-STEAM.csv']); % read csv file

dataSim.Time = dataMeas.tA; % map excel data to dataSim structure
dataSim.Vactn = dataMeas.vA*345/500; % correct voltage data for 345kV base
dataSim.Factn = dataMeas.fA;
dataSim.Pactn = dataMeas.pA;
dataSim.Qactn = dataMeas.qA;

% apply noise filtering and compare responses

ws = 40;

dataSim.Vact = smoothdata(dataSim.Vactn,'sgolay',ws);
dataSim.Fact = smoothdata(dataSim.Factn,'sgolay',ws);
dataSim.Pact = smoothdata(dataSim.Pactn,'sgolay',ws);
dataSim.Qact = smoothdata(dataSim.Qactn,'sgolay',ws);