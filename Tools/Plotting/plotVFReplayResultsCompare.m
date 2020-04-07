% Copyright 2020 The MathWorks, Inc.
figure;
subplot(2,2,1)
hold all;
plot(dataSim.Time, dataSim.Pact);
plot(yout.time,yout.signals(3).values(:,1));
xlabel('Time (s)');
ylabel('P');
title('Simulink vs Other Platform');
legend('Other Platform','Simulink')
grid on;

subplot(2,2,2)
hold all;
plot(dataSim.Time, dataSim.Qact);
plot(yout.time,yout.signals(3).values(:,2));
xlabel('Time (s)');
ylabel('Q');
title('Simulink vs Other Platform');
legend('Other Platform','Simulink')
grid on;

subplot(2,2,3)
hold all;
plot(dataSim.Time, dataSim.Vact);
plot(yout.time,yout.signals(4).values(:,2));
xlabel('Time (s)');
ylabel('Voltage');
title('Simulink vs Other Platform');
legend('Other Platform','Simulink')
grid on;

subplot(2,2,4)
hold all;
plot(dataSim.Time, dataSim.Fact);
plot(yout.time,yout.signals(4).values(:,4)*Fnom);
xlabel('Time (s)');
ylabel('Freq');
title('Simulink vs Other Platform');
legend('Other Platform','Simulink')
grid on;