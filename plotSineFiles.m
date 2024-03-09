% generate figures for journal of expt physiology
%%%%%%%%%%%%%%%%%%%IMPORTANT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this the cleaned up version for uploading with the manuscript. it
% only generates the figures that are in the manuscript
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
close all
cm=parula(5);

%% Edit these
% (refer to the code where you ran the simulation and generated the file)

date = input("Enter the date of the data that you want to plot in 'YYYYMMDD' format:\n");
simNo = input("\nEnter the simualtion number of the data you want to plot:\n");
if isempty(date)
    date=20230702; % date used for saving the file you want to plot
    simNo=1; % sim number of the file you want to load
end

% on your computer replace this part of the file path (fp_CurrSimOUT) from below
% with the path to the github repo on your computer
parms.fnp = input("\nEnter the path to the folder containing this script on your computer in single quotes:\n");
if isempty(parms.fnp)
    parms.fnp = '/Users/surabhisimha/GitHub/Emory/Simha-Ting2023JExptPhysiol/';
end

%% keep these constant to plot the ramp figures as seen in the manusript
% ie Figure 4c
protocolPick = '/sine'; % this is parms.protcolPick in the "main" files
ampList = [0.1 2];

fp_CurrSimOUT = strcat(parms.fnp,'/sim_output/');
fp_CurrSimIN = strcat(parms.fnp,'/sim_input');


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
      plot(t,length.bag*lenScaleFactor,'-','Color',cm(1,:),'LineWidth',3); 
      plot(cumsum(prot(:,2)),(1300+cumsum(prot(:,1)))*lenScaleFactor,'--','Color','k','LineWidth',2);
      ylabel('length [L0]','fontsize',16); title('sine','fontsize',16)
      xlim([1.95 t(end)]);
      set(gcf,'color','w')
      box off;
    ax(2)=subplot(612);hold on; grid on;
      plot(t,force.bag,'-','Color',cm(1,:),'LineWidth',2);
      ylabel('stress [Nm^{-2}]','fontsize',16);
      xlim([1.95 t(end)]);
      set(gcf,'color','w')
      box off;
      
    ax(3)=subplot(611);hold on; grid on;
      plot(t,length.chain*lenScaleFactor,'-','Color',cm(2,:),'LineWidth',1);
      xlim([1.95 t(end)]);
      set(gcf,'color','w')
      box off;
    ax(4)=subplot(613);hold on; grid on;
      plot(t,force.chain,'-','Color',cm(2,:),'LineWidth',2);
      ylabel('stress [Nm^{-2}]','fontsize',16);
      xlim([1.95 t(end)]);
      set(gcf,'color','w')
      box off;
            
    rd=rd-rd(1000);rd(rd<0)=0; rs=rs-rs(1000);rs(rs<0)=0; r=r-r(1000);r(r<0)=0;
    ax(5)=subplot(614);hold on;grid on;
      plot(t,rd,'-','Color',cm(1,:),'LineWidth',2);
      ylabel({'bag', 'contribution'},'fontsize',16);
      xlim([1.95 t(end)]);  
      set(gcf,'color','w')
      box off;
    ax(6)=subplot(615);hold on; grid on;
      plot(t,rs,'-','Color',cm(2,:),'LineWidth',2);
      ylabel({'chain', 'contribution'},'fontsize',16);
      xlim([1.95 t(end)]);
      set(gcf,'color','w')
      box off;
    ax(7)=subplot(616);hold on;grid on;
      plot(t,r,'-','Color',cm(3,:),'LineWidth',2);
      ylabel({'total','receptor', 'potential'},'fontsize',16); xlabel('time (s)','fontsize',16);
      xlim([1.95 t(end)]);
      set(gcf,'color','w')
      box off;
    linkaxes(ax,'x')
pause
end
