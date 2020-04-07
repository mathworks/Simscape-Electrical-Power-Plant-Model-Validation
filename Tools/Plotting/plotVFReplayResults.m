% Copyright 2020 The MathWorks, Inc.
figure;
subplot(2,2,1)
hold all;
plot(dataSim(l).Time, dataSim(l).Pact);
plot(yout.time,yout.signals(3).values(:,1));
xlabel('Time (s)');
ylabel('P');
title('Simulated vs Measured Results');
legend('Meas','Sim')
grid on;

subplot(2,2,2)
hold all;
plot(dataSim(l).Time, dataSim(l).Qact);
plot(yout.time,yout.signals(3).values(:,2));
xlabel('Time (s)');
ylabel('Q');
title('Simulated vs Measured Results');
legend('Meas','Sim')
grid on;

subplot(2,2,3)
hold all;
plot(dataSim(l).Time, dataSim(l).Vact);
plot(yout.time,yout.signals(4).values(:,2));
xlabel('Time (s)');
ylabel('Voltage');
title('Simulated vs Measured Results');
legend('Meas','Sim')
grid on;

subplot(2,2,4)
hold all;
plot(dataSim(l).Time, dataSim(l).Fact);
plot(yout.time,yout.signals(4).values(:,4)*Fnom);
xlabel('Time (s)');
ylabel('Freq');
title('Simulated vs Measured Results');
legend('Meas','Sim')
grid on;
