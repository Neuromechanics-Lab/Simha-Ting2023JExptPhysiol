%% spindleMain_fig4_sinusoids

clear
close all
parms=[];

%% edit to change file name where results are stored

parms.date = input("Enter today's date in 'YYYYMMDD' format to create corresponding folder for saving data:\n");
parms.simNo = input("\nA simualtion number so that the files from this run do not overwrite previous runs:\n");
if isempty(parms.date)
    parms.date = '20230702'; % should be today's date in YYYYMMDD format for saving file name
    parms.simNo=[1]; % just a sim number so as to not overwrite files
end

% on your computer replace this part of the file path (fp_CurrSimOUT) from below
% with the path to the github repo on your computer
parms.fnp = input("\nEnter the path to the folder containing this script on your computer in single quotes:\n");
parms.fp_MATMyoSim = input("\nEnter the path to the folder containting the MAT MyoSim repository on your computer in single quotes:\n");
parms.fp_MATMyoSim = strcat(parms.fp_MATMyoSim,'/MATMyoSim/code/');
if isempty(parms.fnp)
    parms.fnp = '/Users/surabhisimha/GitHub/Emory/Simha-Ting2023JExptPhysiol/';
end
if isempty(parms.fp_MATMyoSim)
    parms.fp_MATMyoSim = '/Users/surabhisimha/GitHub/Emory/MATMyoSim/code/';
end

%% keep constant to simulate the results from figure 2a

%intrafusal fibre properties
parms.modelPick = '2State';
parms.mode = -1; % this allows the fibre to go slack when shortened force goes negative
parms.k_coop = 1; % inter-filament cooperativity
parms.b_f = 600;
parms.b_g = 7;
parms.c_f = 400;
parms.c_g = 300;

%protocol properties
parms.protocolPick = 'sine';
MTUtoFibre=0.8;
parms.freq = 1;  % in Hz; sinusoidal freq
ampList = [0.002 0.004 0.006 0.008 0.01 0.012 0.014 0.016 0.018 0.02 0.022 0.024 0.04 0.06 0.08 0.1 0.12 0.14 0.16 0.18 0.2 0.4 0.6 0.8 1 1.5 2];
parms.amp = 7*MTUtoFibre; % in %L0; second, test stretch amplitude
parms.pCa = 6.4; % ~10% activation for the chain fibre; kept constant for all sims
parms.vel = 15*MTUtoFibre; % in percentage L0/s; stretch velocity

% run simulation
fp_CurrSimOUT = strcat(parms.fnp,'/sim_output/');
results_base_file = sprintf('%s%s/%s',fp_CurrSimOUT,parms.date,parms.protocolPick); %need to change / to \ for windows OS
cm = lines(13);
for i=1:numel(ampList)
    parms.amp = ampList(i)*MTUtoFibre; % in %L0; amplitude of sinusoid
    parms.fibreType = 'Bag';
    parms.twoStateType = 'newSpindleBag1';
    [results_file_bag] = simulateSarc(parms)
    parms.fibreType = 'Chain';
    parms.twoStateType = 'newSpindleChain1';
    [results_file_chain] = simulateSarc(parms)

%%
[t,r,rs,rd] = sarc2spindleDriver(results_file_bag,results_file_chain);

saveCurrentWithForce('results_file_bag',results_file_bag,'results_file_chain',results_file_chain,'t',t,...
            'r',r,'rs',rs,'rd',rd,'parms',parms,'outputfilename',sprintf('%sSim%ipCa%iFreq%iAmp%i.mat',...
            results_base_file,parms.simNo,round(parms.pCa*10),round(parms.freq),round(parms.amp*10000)));
end