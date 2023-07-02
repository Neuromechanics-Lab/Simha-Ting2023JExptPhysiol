% generate figures for journal of expt physiology
%%%%%%%%%%%%%%%%%%%IMPORTANT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this the cleaned up version for uploading with the manuscript. it
% only generates the figures that are in the manuscript
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
close all

%% Edit these
% (refer to the code where you ran the simulation and generated the file)
simNo=1; % sim number of the file you want to load
date=20230702; % date used for saving the file you want to plot
protocolPick = '/rampNoThinFilamentDeact'; % this is parms.protcolPick in the "main" files

% on your computer replace this part of the file path (fp_CurrSimOUT) from below
% with the path to the github repo on your computer
parms.fnp = '/Users/surabhisimha/Desktop/JExptPhysiol2023_SpindelModelCode/';

%% keep these constant to plot the ramp figures as seen in the manusript
% ie Figure 2a and Figure 3

fp_CurrSimOUT = strcat(parms.fnp,'sim_output/');
fp_CurrSimIN = strcat(parms.fnp,'sim_input');

MTUtoFibre=0.8;
rampVel =  45*10*MTUtoFibre; %10 15 30 45 % [5 7 10 15 30 45];
rampAmp = 7*MTUtoFibre;

%load files
fname_mat = strcat(fp_CurrSimOUT,num2str(date),protocolPick,'Sim',num2str(simNo),'pCa64Amp',...
    num2str(rampAmp*10),'Vel',num2str(rampVel),'.mat');
load(fname_mat);

fname_prot = strcat(fp_CurrSimIN,'/Protocols/',num2str(date),protocolPick,'Sim',num2str(simNo),'pCa64Amp',...
    num2str(rampAmp*10),'Vel',num2str(rampVel),'.txt');
prot = dlmread(fname_prot,'',1,0);

%% plotting
figure(1);hold on;

    if parms.k_coop==0
        titleStr = 'No coop';
    elseif parms.k_coop>0
        titleStr = 'With coop';
    end

    ax(1)=subplot(611);hold on;grid on;dx(1)=ax(1);
      plot(t,length.bag/1300,'-','Color','b','LineWidth',3); 
      plot(cumsum(prot(:,2)),(1300+cumsum(prot(:,1)))/1300,'--','Color','k','LineWidth',2);
      ylabel('length [nm]'); title(strcat(titleStr)); 
      xlim([1.8 2.4])
    ax(2)=subplot(612);hold on; grid on;
      plot(t,force.bag,'-','Color','b','LineWidth',2);
      ylabel('stress [Nm^{-2}]');
      xlim([1.8 2.4]);ylim([0 4e5])
    
    ax(3)=subplot(611);hold on; grid on;
      plot(t,length.chain/1300,'-','Color','r','LineWidth',1);
      xlim([1.8 2.4])
    ax(4)=subplot(613);hold on; grid on;
      plot(t,force.chain,'-','Color','r','LineWidth',2);
      ylabel('stress [Nm^{-2}]');
      xlim([1.8 2.4]);ylim([0 3e5])
      linkaxes(ax,'x')
            
    ax(5)=subplot(614);hold on; grid on;
      plot(t,rd,'-','Color','b','LineWidth',2);
      ylabel({'bag', 'contribution'});
      xlim([1.8 2.4]);ylim([0 6])
    ax(6)=subplot(615);hold on; grid on;
      plot(t,rs,'-','Color','r','LineWidth',2);
      ylabel({'chain', 'contribution'});xlabel('time (s)');
      xlim([1.8 2.4]);ylim([0 6])   
    ax(7)=subplot(616);hold on;grid on;
      plot(t,r,'-','Color','g','LineWidth',2);
      ylabel({'total','receptor', 'potential'}); xlabel('time (s)');
      ylim([0 6])
      xlim([1.8 2.4])
      linkaxes(ax,'x')
      
%% some metrics
[~,indStart] = min(r(2000:2156));
p = polyfit(t(2000+indStart:2156),r((2000+indStart:2156)),1);
rampResponse = p(1);
initialBurst = max(r(2000:2156)) - r(1000);
dynamicIndex = r(2156)-r(end);