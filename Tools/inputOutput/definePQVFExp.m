function Exp = definePQVFExp(mdl,dataSim,op,Exp,Fnom,Vnom,mode,port)
% Copyright 2020 The MathWorks, Inc.
%
%  This function defines an experiment for the VF replay model
%
% Exp = definePQVFExp(mdl,dataSim,op,Exp,Fnom,Vnom,maxP,maxQ,maxV,maxF,mode,port)
%
% dataSim is the event data
% op is the operating point
% mode is either 'PQ','VF',or 'PQVF'
% port is the output port that is used for the objective function
% measurements eg,'PQVFo'

for l = 1:numel(dataSim)
    
    ev = dataSim(l); % shorter variable name for convenience
    
    Exp_Sig_Output = Simulink.SimulationData.Signal;
    Exp_Sig_Output.BlockPath = [mdl,'/Gain2'];
    Exp_Sig_Output.PortType  = 'outport';
    Exp_Sig_Output.PortIndex = 1;
    Exp_Sig_Output.Name      = port;
    
    nt = numel(ev.Time);
    
    switch mode
        
        case 'PQVF'
            
            Exp(l).InputData =  [ev.Time ev.Pact ev.Qact op(l).Inputs(2).u*ones(nt,1) op(l).Inputs(3).u*ones(nt,1) ev.Vact ev.Fact/Fnom op(l).Inputs(5).u*ones(nt,1) op(l).Inputs(6).u*ones(nt,1)];
            
            Exp_Sig_Output.Values    = timeseries([(ev.Pact-ev.Pact(1))/ev.maxP (ev.Qact-ev.Qact(1))/ev.maxQ (ev.Vact/Vnom - ev.Vact(1)/Vnom)/ev.maxV (ev.Fact/Fnom - ev.Fact(1)/Fnom)/ev.maxF],ev.Time);
            
        case 'PQ'
            
            Exp(l).InputData =  [ev.Time ev.Pact ev.Qact op(l).Inputs(2).u*ones(nt,1) op(l).Inputs(3).u*ones(nt,1)];
            
            Exp_Sig_Output.Values    = timeseries([(ev.Vact/Vnom - ev.Vact(1)/Vnom)/ev.maxV (ev.Fact/Fnom - ev.Fact(1)/Fnom)/ev.maxF],ev.Time);
            
        case 'PQF'
            
            Exp(l).InputData =  [ev.Time ev.Pact ev.Qact op(l).Inputs(2).u*ones(nt,1) op(l).Inputs(3).u*ones(nt,1)];
            
            Exp_Sig_Output.Values    = timeseries([(ev.Vact/Vnom - ev.Vact(1)/Vnom)/ev.maxV (ev.Fact/Fnom - ev.Fact(1)/Fnom)/ev.maxF],ev.Time);
            
        case 'VF'
            
            Exp(l).InputData =  [ev.Time ev.Vact ev.Fact/Fnom op(l).Inputs(2).u*ones(nt,1) op(l).Inputs(3).u*ones(nt,1)];
            
            Exp_Sig_Output.Values    = timeseries([(ev.Pact-ev.Pact(1))/ev.maxP (ev.Qact-ev.Qact(1))/ev.maxQ],ev.Time);
            
        case 'VFPE'
            
            Exp(l).InputData =  [ev.Time ev.Vact ev.Fact/Fnom op(l).Inputs(2).u*ones(nt,1) ev.Efdact];
            
            Exp_Sig_Output.Values    = timeseries([(ev.Pact-ev.Pact(1))/ev.maxP (ev.Qact-ev.Qact(1))/ev.maxQ],ev.Time);
            
    end
    
    Exp(l).OutputData = Exp_Sig_Output;
    
end