% Copyright 2020 The MathWorks, Inc.

% Measured data

idx = {'01','03','09','11'};

for l = 1:numel(idx)
    
    dataMeas = readtable(['Event-',idx{l},'-2016.csv']); % read excel file
    
    dataSima.Time = dataMeas.tA; % map excel data to dataSim structure
    dataSima.Vact = dataMeas.vA;
    dataSima.Fact = dataMeas.fA;
    dataSima.Pact = dataMeas.pA;
    dataSima.Qact = dataMeas.qA;

    dataSim(l) = dataSima; %#ok<*SAGROW>
    
end

