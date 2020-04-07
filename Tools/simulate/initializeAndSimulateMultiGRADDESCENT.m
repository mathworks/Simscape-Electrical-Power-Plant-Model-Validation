% Copyright 2020 The MathWorks, Inc.
opt.OptimizerType = 'graddescent';
    
for lo = 1:numel(Exp)

    opspeca=initopspec(opspec(lo),op(lo));

    opspec(lo) = opspeca; %#ok<*SAGROW>
    
end

init = 1; %#ok<*NASGU>

[op,opreport] = findop(mdl,opspec,opt);

init = 0;

    
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
