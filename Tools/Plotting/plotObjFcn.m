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

strOP = mat2str(Exp.OutputData.Values.Time);

yy = sim(mdl,'OutputOption','SpecifiedOutputTimes','OutputTimes',strOP); % simulator object not used

yout = get(yy,'yout');

idxS = false(numel(yout.signals),1);

for ls = 1:numel(yout.signals) % index into the correct output port for the objective function calculation
    
    idxS(ls) = strcmp(yout.signals(ls).blockName,port);
    
end

Sig.Values = timeseries(yout.signals(idxS).values,yout.time); % PQgo

sV = Sig.Values;
eO = Exp.OutputData.Values;

sV.Data = sV.Data(:,idxO);
eO.Data = eO.Data(:,idxO);

Error = evalRequirement(r,sV,eO);
    
err = Error/Exp.OutputData.Values.Time(end);

figure,plot(Exp.OutputData.Values.Time,Exp.OutputData.Values.Data,Sig.Values.Time,Sig.Values.Data),grid
xlabel('Time (s)'),ylabel(Exp.OutputData.Name),title(['Experiment 1 : f(x) = ',num2str(ceil(err*1000)/1000)])


switch replayParadigm
    
    case 'PQ'
        
        legend({'Vmeas','Fmeas','Vsim','Fsim'})
        
    case 'VF'
        
        legend({'Pmeas','Qmeas','Psim','Qsim'})
        
    case 'PQVF'
        
        legend({'Pmeas','Qmeas','Vmeas','Fmeas','Psim','Qsim','Vsim','Fsim'})
end
