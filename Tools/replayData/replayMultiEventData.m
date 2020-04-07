% Copyright 2020 The MathWorks, Inc.

%% Open the Simulink model under consideration

open_system(mdl)

%% Calculate max and min for normalization

for l = 1:numel(dataSim)

    dataSim(l).maxP = max(abs(dataSim(l).Pact - dataSim(l).Pact(1))); %#ok<*SAGROW>
    dataSim(l).maxQ = max(abs(dataSim(l).Qact - dataSim(l).Qact(1)));
    
    dataSim(l).maxV = max(abs((dataSim(l).Vact - dataSim(l).Vact(1))/Vnom));
    dataSim(l).maxF = max(abs((dataSim(l).Fact - dataSim(l).Fact(1))/Fnom));

end

%% Define Data IO Structure
data = definePQVFIO(dataSim,Vnom,Fnom,MBase); % define the IO data structure

Exp = sdo.Experiment(mdl); % define experiment object

for le = 2:numel(data)
    
    Exp(le) = Exp(1);
    
end

%% Load Flow 

load_flow % run the load flow

%%

switch replayParadigm
    
    case 'PQF'
        
        port = 'VFo';
    
    case 'PQ'
        
        port = 'VFo';
        
    case 'VFPE'
        
        port = 'PQo';
    
    case 'VF'
        
        port = 'PQo';
        
    case 'PQVF'
        
        port = 'PQVFo';
        
end
  

Exp = definePQVFExp(mdl,dataSim,op,Exp,Fnom,Vnom,replayParadigm,port); % define the experiment


%% Simulate and plot results

for l = 1:numel(Exp)
    
    sim(mdl)
    
    objFcn
    
end


% plot extended event data

Expe = [];
Sige = [];

for lev = 1:numel(Exp)

    Expe = [Expe;Exp(lev).OutputData.Values.Data];
        
    SS = interp1(Sig(lev).Values.Time,Sig(lev).Values.Data,Exp(lev).OutputData.Values.Time);
    
    Sige = [Sige;SS];
    
end

time = linspace(0,1,size(Expe,1));

figure,subplot(211),plot(time,Expe,time,Sige),grid,title('Normalized Responses')
legend('Measured P','Measured Q','Simulated P','Simulated Q')
xlabel('Normalized time'),ylabel('Normalized magnitude')
subplot(211),axis([0 1 -1 1])

subplot(212),plot(time,(Expe-Sige)),grid,legend('P error','Q error')
xlabel('Normalized time'),ylabel('Absolute error')

tsExp = timeseries(Expe,time);
tsSig = timeseries(Sige,time);

Error = evalRequirement(r,tsSig,tsExp);
    
%err = Error/Exp(l).OutputData.Values.Time(end);

subplot(212),title(['SSE = ',num2str(Error)])
