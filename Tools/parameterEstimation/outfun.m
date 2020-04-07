function stop = outfun(x,optimValues,state,varargin)
% Copyright 2020 The MathWorks, Inc.


if ismember(state,'iter')
    
    eF = exist('OptimResults','dir');
    
    if eF == 0
       
        system('md OptimResults');
        
    end
    
    save([pwd,'\OptimResults\optim_data_',num2str(optimValues.iteration)],'x')
    
end

a = evalin('base','flag');

if a == 1
    
    stop = true;
    
else
    
    stop = false;
    
end


    