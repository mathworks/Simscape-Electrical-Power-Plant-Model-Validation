% Copyright 2020 The MathWorks, Inc.

% Measured data

dataMeas = readtable('Event-01-2016.csv'); % read excel file

dataSim.Time = dataMeas.tA; % map excel data to dataSim structure
dataSim.Vact = dataMeas.vA;
dataSim.Fact = dataMeas.fA;
dataSim.Pact = dataMeas.pA;
dataSim.Qact = dataMeas.qA;

% Apply noise filtering and compare responses
% 
% ws = 40;
% 
% mthd = 'rlowess';
% 
% dataSim.Vact = smoothdata(dataSim.Vactn,'sgolay',ws);
% dataSim.Fact = smoothdata(dataSim.Factn,'sgolay',ws);
% dataSim.Pact = smoothdata(dataSim.Pactn,'sgolay',ws);
% dataSim.Qact = smoothdata(dataSim.Qactn,'sgolay',ws);
% 
% snrV = snr(dataSim.Vactn,dataSim.Vactn-dataSim.Vact);
% snrF = snr(dataSim.Vactn,dataSim.Factn-dataSim.Fact);
% snrP = snr(dataSim.Vactn,dataSim.Pactn-dataSim.Pact);
% snrQ = snr(dataSim.Vactn,dataSim.Qactn-dataSim.Qact);
% 
% figure(1),subplot(221),plot([dataSim.Vact dataSim.Vactn]),grid,legend('Smoothed','Original'),title(['SNR = ',num2str(snrV)])
% figure(1),subplot(222),plot([dataSim.Fact dataSim.Factn]),grid,legend('Smoothed','Original'),title(['SNR = ',num2str(snrF)])
% figure(1),subplot(223),plot([dataSim.Qact dataSim.Qactn]),grid,legend('Smoothed','Original'),title(['SNR = ',num2str(snrQ)])
% figure(1),subplot(224),plot([dataSim.Pact dataSim.Pactn]),grid,legend('Smoothed','Original'),title(['SNR = ',num2str(snrP)])
