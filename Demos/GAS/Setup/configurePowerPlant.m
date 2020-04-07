% Copyright 2020 The MathWorks, Inc.
variantChoices

pss = 'PSS2A';
avr = 'REXS';
gov = 'GGOV1';
gen = 'GENROU_TRANSFORMER';

pssParam = 'dyn.pss2a_102_GAS';
avrParam = 'dyn.rexs_102_GAS';
govParam = 'dyn.ggov1_102_GAS';
genParam = 'dyn.genrou_102_GAS';
sysGenParam = 'sys.GENERATOR(2)';
sysTxParam = 'sys.TRANSFORMER';

% PSS

idxPSS = find(ismember(pss_choices,pss));

hpss = find_system(mdl,'FindAll','on','Name','PSS');
set(hpss,'VariantControlMode','Label');
set(hpss,'LabelModeActiveChoice',['Variant',num2str(idxPSS)])
hpss1 = find_system(mdl,'FindAll','on','Name',pss);
set(hpss1, 'p', pssParam);

%% AVR

idxAVR = find(ismember(avr_choices,avr));

havr = find_system(mdl,'FindAll','on','Name','AVR');
set(havr,'VariantControlMode','Label');
set(havr,'LabelModeActiveChoice',['Variant',num2str(idxAVR)])
havr1 = find_system(mdl,'FindAll','on','Name',avr);
set(havr1, 'p', avrParam);

%% GOV

idxGOV = find(ismember(gov_choices,gov));

hgov = find_system(mdl,'FindAll','on','Name','GOV');
set(hgov,'VariantControlMode','Label');
set(hgov,'LabelModeActiveChoice',['Variant',num2str(idxGOV)])
hgov1 = find_system(mdl,'FindAll','on','Name',gov);
set(hgov1, 'p', govParam);
set(hgov1, 'g', sysGenParam);

%% GEN

idxGEN = find(ismember(gen_choices,gen));

hgen = find_system(mdl,'FindAll','on','Name','GENERATION');
set(hgen,'VariantControlMode','Label');
set(hgen,'LabelModeActiveChoice',['Variant',num2str(idxGEN)])
hgen1 = find_system(mdl,'FindAll','on','Name',gen);
set(hgen1, 'g', sysGenParam);
set(hgen1, 't', sysTxParam);
set(hgen1, 'p', genParam);

