% Copyright 2020 The MathWorks, Inc.

switch replayParadigm
    
    case 'PQ'
        
        port = [mdl,'/VFo'];
        
        idxO = [1 2];
        
    case 'PQF'
        
        port = [mdl,'/VFo'];
        
        idxO = [1 2];
        
    case 'VF'
        
        port = [mdl,'/PQo'];
        
        idxO = [1 2];
   
    case 'VFPE'
        
        port = [mdl,'/PQo'];
        
        idxO = [1 2];
        
    case 'PQVF'
        
        port = [mdl,'/PQVFo'];
        
        idxO = [1 2 3 4];
        
end

r = sdo.requirements.SignalTracking;
r.Method = 'SSE';
r.RobustCost = 'off';

strOP = mat2str(Exp(l).OutputData.Values.Time);

% yy = sim(mdl,'OutputOption','SpecifiedOutputTimes','OutputTimes',strOP); % simulator object not used
% 
% yout = get(yy,'yout');

idxS = false(numel(yout.signals),1);

for ls = 1:numel(yout.signals) % index into the correct output port for the objective function calculation
    
    idxS(ls) = strcmp(yout.signals(ls).blockName,port);
    
end

Siga.Values = timeseries(yout.signals(idxS).values,yout.time); % PQgo

Sig(l) = Siga;

sV = Siga.Values;
eO = Exp(l).OutputData.Values;

sV.Data = sV.Data(:,idxO);
eO.Data = eO.Data(:,idxO);

Error = evalRequirement(r,sV,eO);
    
err = Error/Exp(l).OutputData.Values.Time(end);

% figure,plot(Exp(l).OutputData.Values.Time,Exp(l).OutputData.Values.Data,Sig(l).Values.Time,Sig(l).Values.Data),grid
% xlabel('Time (s)'),ylabel(Exp(l).OutputData.Name),title(['Experiment 1 : f(x) = ',num2str(ceil(err*1000)/1000)])

