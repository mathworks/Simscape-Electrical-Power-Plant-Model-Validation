% Copyright 2020 The MathWorks, Inc.
clearvars

load baselineParamsGAS % load baseline parameters

govDisable = 0; % enable governor

% Generator saturation curve

[ifd,vt] = createSatCurve(dyn.genrou_102_GAS.s1,dyn.genrou_102_GAS.s12); 

% Nominal values

Vnom = sys.GENERATOR(1).BUSV; % VLL kV
Fnom = 60;
MBase = sys.GENERATOR(1).MBASE      ; % MVA

% define parameters for generator relative constraints

gen = 'genrou_102_GAS';

paramsRel    = {
    'dyn.(gen).ld'
    'dyn.(gen).lpd'
    'dyn.(gen).lppd'
    'dyn.(gen).lq'
    'dyn.(gen).lpq'
    'dyn.(gen).lppd'
    'dyn.(gen).tpdo'
    'dyn.(gen).tppdo'
    'dyn.(gen).tpqo'
    'dyn.(gen).tppqo'
    }; 

paramsValues = [
    dyn.(gen).ld
    dyn.(gen).lpd
    dyn.(gen).lppd
    dyn.(gen).lq
    dyn.(gen).lpq
    dyn.(gen).lppd
    dyn.(gen).tpdo
    dyn.(gen).tppdo
    dyn.(gen).tpqo
    dyn.(gen).tppqo
    ];