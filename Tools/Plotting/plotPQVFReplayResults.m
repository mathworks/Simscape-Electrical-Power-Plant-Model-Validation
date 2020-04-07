% Copyright 2020 The MathWorks, Inc.
%% PQVF Replay

figure;
subplot(2,2,1)
hold all;
plot(dataSim.Time, dataSim.Pact);
plot(yout.time,yout.signals(10).values(:,1));
xlabel('Time (s)');
ylabel('P');
title('Simulated vs Measured Results');
legend('Meas','Sim')
grid on;

subplot(2,2,2)
hold all;
plot(dataSim.Time, dataSim.Qact);
plot(yout.time,yout.signals(10).values(:,2));
xlabel('Time (s)');
ylabel('Q');
title('Simulated vs Measured Results');
legend('Meas','Sim')
grid on;

subplot(2,2,3)
hold all;
plot(dataSim.Time, dataSim.Vact);
plot(yout.time,yout.signals(5).values(:,1));
xlabel('Time (s)');
ylabel('Voltage');
title('Simulated vs Measured Results');
legend('Meas','Sim')
grid on;

subplot(2,2,4)
hold all;
plot(dataSim.Time, dataSim.Fact);
plot(yout.time,yout.signals(2).values*Fnom);
xlabel('Time (s)');
ylabel('Freq');
title('Simulated vs Measured Results');
legend('Meas','Sim')
grid on;
