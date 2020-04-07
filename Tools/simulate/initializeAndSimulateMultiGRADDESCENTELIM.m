% Copyright 2020 The MathWorks, Inc.
for l = 1:numel(Exp)
    
    opspeca=initopspec(opspec(l),op(l));
    opt.OptimizerType = 'graddescent-elim';
    
    init = 1; %#ok<*NASGU>
    
    [opa,opreporta] = findop(mdl,opspeca,opt);
    
    init = 0;

    op(l) = opa; %#ok<*SAGROW>
    opreport(l) = opreporta;
    opspec(l) = opspeca;
    
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

subplot(212),plot(time,(Expe-Sige)),grid,legend('P error','Q error')
xlabel('Normalized time'),ylabel('Absolute error')

tsExp = timeseries(Expe,time);
tsSig = timeseries(Sige,time);

Error = evalRequirement(r,tsSig,tsExp);
    
%err = Error/Exp(l).OutputData.Values.Time(end);

subplot(212),title(['SSE = ',num2str(Error)])
