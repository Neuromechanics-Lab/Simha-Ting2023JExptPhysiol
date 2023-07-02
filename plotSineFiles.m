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
protocolPick = '/sine'; % this is parms.protcolPick in the "main" files
ampList = [0.1 2];

% on your computer replace this part of the file path (fp_CurrSimOUT) from below
% with the path to the github repo on your computer
parms.fnp = '/Users/surabhisimha/Desktop/JExptPhysiol2023_SpindelModelCode/';

%% keep these constant to plot the ramp figures as seen in the manusript
% ie Figure 4c

fp_CurrSimOUT = strcat(parms.fnp,'sim_output/');
fp_CurrSimIN = strcat(parms.fnp,'sim_input');


MTUtoFibre=0.8;
ampList = round([ampList]*10000*MTUtoFibre);
sineFreq = 1;
figure(1);clf;
for i=1:numel(ampList)
    fname_mat = strcat(fp_CurrSimOUT,num2str(date),protocolPick,'Sim',num2str(simNo),'pCa64Freq'...
        ,num2str(sineFreq),'Amp',num2str(ampList(i)),'.mat');
    load(fname_mat);

    % protocol file
    fname_prot = strcat(fp_CurrSimIN,'/Protocols/',num2str(date),protocolPick,'Sim',num2str(simNo),'pCa64Freq'...
        ,num2str(sineFreq),'Amp',num2str(ampList(i)),'.txt');
    prot = dlmread(fname_prot,'',1,0);
  
    lenScaleFactor = 1/1300;
    
    figure(1);hold on;
    ax(1)=subplot(611);hold on;grid on;
      plot(t,length.bag*lenScaleFactor,'-','Color','b','LineWidth',3); 
      plot(cumsum(prot(:,2)),(1300+cumsum(prot(:,1)))*lenScaleFactor,'--','Color','k','LineWidth',2);
      ylabel('length [L0]'); title('sine')
      xlim([1.95 t(end)]);
    ax(2)=subplot(612);hold on; grid on;
      plot(t,force.bag,'-','Color','b','LineWidth',2);
      ylabel('stress [Nm^{-2}]');
      xlim([1.95 t(end)]);
      
    ax(3)=subplot(611);hold on; grid on;
      plot(t,length.chain*lenScaleFactor,'-','Color','r','LineWidth',1);
      xlim([1.95 t(end)]);
    ax(4)=subplot(613);hold on; grid on;
      plot(t,force.chain,'-','Color','r','LineWidth',2);
      ylabel('stress [Nm^{-2}]');
      xlim([1.95 t(end)]);
            
    rd=rd-rd(1000);rd(rd<0)=0; rs=rs-rs(1000);rs(rs<0)=0; r=r-r(1000);r(r<0)=0;
    ax(5)=subplot(614);hold on;grid on;
      plot(t,rd,'-','Color','b','LineWidth',2);
      ylabel({'bag', 'contribution'});
      xlim([1.95 t(end)]);      
    ax(6)=subplot(615);hold on; grid on;
      plot(t,rs,'-','Color','r','LineWidth',2);
      ylabel({'chain', 'contribution'});
      xlim([1.95 t(end)]);
    ax(7)=subplot(616);hold on;grid on;
      plot(t,r,'-','Color','g','LineWidth',2);
      ylabel({'total','receptor', 'potential'}); xlabel('time (s)');
      xlim([1.95 t(end)]);
    linkaxes(ax,'x')
pause
end
