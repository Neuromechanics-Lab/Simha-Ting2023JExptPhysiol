%% spindleMain_fig4_triangles with differnet inter-stretch intervals

clear
close all
parms=[];

%% edit to change file name where results are stored

parms.date = input("Enter today's date in 'YYYYMMDD' format to create corresponding folder for saving data:\n");
parms.simNo = input("\nA simualtion number so that the files from this run do not overwrite previous runs:\n");
if isempty(parms.date)
    parms.date = '20230702'; % should be today's date in YYYYMMDD format for saving file name
    parms.simNo=[3]; % just a sim number so as to not overwrite files
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
parms.protocolPick = 'customTri';
MTUtoFibre=0.8;
ISI_list = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.5, 3, 5, 8, 10];
parms.condAmp = 7*MTUtoFibre; % in %L0; first, conditioning stretch amplitude
parms.amp = 7*MTUtoFibre; % in %L0; second, test stretch amplitude
parms.pCa = 6.4; % ~10% activation for the chain fibre; kept constant for all sims
parms.vel = 15*MTUtoFibre; % in percentage L0/s; stretch velocity

% run simulation
fp_CurrSimOUT = strcat(parms.fnp,'/sim_output/');
results_base_file = sprintf('%s%s/%s',fp_CurrSimOUT,parms.date,parms.protocolPick); %need to change / to \ for windows OS
cm = lines(13);
for i=1:numel(ISI_list)
    parms.ISI = ISI_list(i);  % in seconds; inter-stretch-interval
    parms.fibreType = 'Bag';
    parms.twoStateType = 'newSpindleBag1';
    [results_file_bag] = simulateSarc(parms)
    parms.fibreType = 'Chain';
    parms.twoStateType = 'newSpindleChain1';
    [results_file_chain] = simulateSarc(parms)

%%
[t,r,rs,rd] = sarc2spindleDriver(results_file_bag,results_file_chain);

saveCurrentWithForce('results_file_bag',results_file_bag,'results_file_chain',results_file_chain,'t',t,...
        'r',r,'rs',rs,'rd',rd,'parms',parms,'outputfilename',sprintf('%sSim%ipCa%iISI%icondAmp%iAmp%iVel%i.mat',...
        results_base_file,parms.simNo,round(parms.pCa*10),round(parms.ISI*10),round(parms.condAmp*10),round(parms.amp*10),round(parms.vel*10)));
end