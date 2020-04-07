% Copyright 2020 The MathWorks, Inc.
clearvars

load baselineParamsSTEAM

dyn.esst4b_102_STEAM.vrmax = 999; % expand constraints
dyn.esst4b_102_STEAM.vrmin = -999;
dyn.esst4b_102_STEAM.vmmax = 999;
dyn.esst4b_102_STEAM.vmmin = -999;

govDisable = 1; % disable governor

% Generator saturation curve

[ifd,vt] = createSatCurve(dyn.genrou_102_STEAM.s1,dyn.genrou_102_STEAM.s12); 

% Nominal values

Vnom = sys.GENERATOR(1).BUSV; % VLL kV
Fnom = 60;
MBase = sys.GENERATOR(1).MBASE      ; % MVA

% define parameters for generator relative constraints

gen = 'genrou_102_STEAM';

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