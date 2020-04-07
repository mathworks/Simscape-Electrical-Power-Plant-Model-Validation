function data = definePQVFIO(dataSim,Vnom,Fnom,MBase)
% Copyright 2020 The MathWorks, Inc.
% 
% This function sets up the data structure that defines the IO
% relationships for load flow calculation for VF replay
%
% data = definePQVFIO(dataSim,Vnom,Fnom,MBase)
%
% dataSim is a structure that contains event data
% Vnom is nominal voltage in kV
% Fnom is nominal frequency in Hz
% MBAse is system base power in MW
%

for l = 1:numel(dataSim)
    
    if ismember('Vact',fieldnames(dataSim(l)))
        
        data(l).VtrefiPQ.u = dataSim(l).Vact(1)/Vnom;
        data(l).VtrefiPQ.Known = false;
        
        data(l).VtrefiVF.u = dataSim(l).Vact(1)/Vnom;
        data(l).VtrefiVF.Known = false;
        
    end
    
    if ismember('Efdact',fieldnames(dataSim(l)))
        
        data(l).EfdiVF.u = dataSim(l).Efdact(1);
        data(l).EfdiVF.Known = true;
        
    end
    
    data(l).PmiVF.u = 0;
    data(l).PmiVF.Known = false;
    
    %%%%%%%%%%%% VF %%%%%%%%%%%%%%%%%%
    
    data(l).VFi.u = [dataSim(l).Vact(1) dataSim(l).Fact(1)/Fnom];
    data(l).VFi.Known = [true;true];
    
    data(l).vmoVF.y = dataSim(l).Vact(1);
    data(l).vmoVF.Known = true;
    
    data(l).woVF.y = dataSim(l).Fact(1)/Fnom;
    data(l).woVF.Known = true;
    
    data(l).PQoVF.y = [dataSim(l).Pact(1);dataSim(l).Qact(1)];
    data(l).PQoVF.Known = [true;true];
    
    %%%%%%%%%%%%% PQ %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    data(l).PQi.u = [dataSim(l).Pact(1);dataSim(l).Qact(1)];
    data(l).PQi.Known = [true;true];
    
    data(l).vmoPQ.y = dataSim(l).Vact(1);
    data(l).vmoPQ.Known = true;
    
    data(l).woPQ.y = dataSim(l).Fact(1)/Fnom;
    data(l).woPQ.Known = true;
    
    data(l).PQoPQ.y = [dataSim(l).Pact(1);dataSim(l).Qact(1)];
    data(l).PQoPQ.Known = [false;false]; % false or true
    
end

end