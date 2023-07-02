%% spindleMain_fig2_rampNoInterfilamentCoopertivity

clear
close all
parms=[];

%% edit to change file name where results are stored
parms.date = '20230702'; %Enter today's date in YYYYMMDD format for saving file name
parms.simNo=[1]; % for file name, to not overwrite files

% on your computer replace this part of the file path (fp_CurrSimOUT) from below
% with the path to the github repo on your computer
parms.fnp = '/Users/surabhisimha/Desktop/JExptPhysiol2023_SpindelModelCode/';
parms.fp_MATMyoSim = '/Users/surabhisimha/GitHub/Emory/MATMyoSim/code/';

%% keep constant to simulate the results from figure 2a

% intrafusal fibre properties
parms.modelPick = '2State';
parms.mode = -1; % this allows the fibre to go slack when shortened force goes negative
parms.k_coop = 0; % inter-filament cooperativity
parms.b_f = 600;
parms.b_g = 7;
parms.c_f = 400;
parms.c_g = 300;

% protocol properties
parms.protocolPick = 'rampNoCoop';
MTUtoFibre=0.8;
parms.amp = 7*MTUtoFibre; % in %L0
parms.pCa = 6.4; % ~10% activation for the chain fibre; kept constant for all sims
parms.vel = 45*MTUtoFibre; % in percentage L0/s

% run simulation
fp_CurrSimOUT = strcat(parms.fnp,'sim_output/');
results_base_file = sprintf('%s%s/%s',fp_CurrSimOUT,parms.date,parms.protocolPick); %need to change / to \ for windows OS
cm = lines(13);
parms.fibreType = 'Bag';
parms.twoStateType = 'newSpindleBag1';
[results_file_bag] = simulateSarc(parms)
parms.fibreType = 'Chain';
parms.twoStateType = 'newSpindleChain1';
[results_file_chain] = simulateSarc(parms)
%%
[t,r,rs,rd] = sarc2spindleDriver(results_file_bag,results_file_chain);

saveCurrentWithForce('results_file_bag',results_file_bag,'results_file_chain',results_file_chain,'t',t,...
    'r',r,'rs',rs,'rd',rd,'parms',parms,'outputfilename',sprintf('%sSim%ipCa%iAmp%iVel%i.mat',...
    results_base_file,parms.simNo,round(parms.pCa*10),round(parms.amp*10),round(parms.vel*10)));

