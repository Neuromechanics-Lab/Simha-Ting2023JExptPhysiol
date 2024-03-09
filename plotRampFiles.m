% generate figures for journal of expt physiology
%%%%%%%%%%%%%%%%%%%IMPORTANT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this the cleaned up version for uploading with the manuscript. it
% only generates the figures that are in the manuscript
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
% close all
cm=parula(5);

%% Edit these
% (refer to the code where you ran the simulation and generated the file)

date = input("Enter the date of the data that you want to plot in 'YYYYMMDD' format:\n");
simNo = input("\nEnter the simualtion number of the data you want to plot:\n");
if isempty(date)
    date=20230702; % date used for saving the file you want to plot
    simNo=1; % sim number of the file you want to load
end

protocolPickNum = input("Select the number corresponding to the protocol name (the value of parms.protocolPick " + ...
    "from the main_ script whose results you are trying to plot):\n" + ...
    "1 - rampNoThinFilamentDeact\n 2 - rampNoCoop\n 3 - rampWithCoop\n");

switch protocolPickNum
    case 1
        protocolPick = '/rampNoThinFilamentDeact';
    case 2
        protocolPick = '/rampNoCoop';
    case 3
        protocolPick = '/ramp';
end

if isempty(protocolPick)
    protocolPick = '/rampNoThinFilamentDeact'; % this is parms.protcolPick in the "main" files
end

% on your computer replace this part of the file path (fp_CurrSimOUT) from below
% with the path to the github repo on your computer
parms.fnp = input("\nEnter the path to the folder containing this script on your computer in single quotes:\n");
if isempty(parms.fnp)
    parms.fnp = '/Users/surabhisimha/GitHub/Emory/Simha-Ting2023JExptPhysiol/';
end

%% keep these constant to plot the ramp figures as seen in the manusript
% ie Figure 2a and Figure 3

fp_CurrSimOUT = strcat(parms.fnp,'/sim_output/');
fp_CurrSimIN = strcat(parms.fnp,'/sim_input');

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
      plot(t,length.bag/1300,'-','Color',cm(1,:),'LineWidth',3); 
      plot(cumsum(prot(:,2)),(1300+cumsum(prot(:,1)))/1300,'--','Color','k','LineWidth',2);
      ylabel('length [nm]','fontsize',16); title(strcat(titleStr),'fontsize',16); 
      xlim([1.8 2.4])
      set(gcf,'color','w')
      box off;

    ax(2)=subplot(612);hold on; grid on;
      plot(t,force.bag,'-','Color',cm(1,:),'LineWidth',2);
      ylabel('stress [Nm^{-2}]','fontsize',16);
      xlim([1.8 2.4]);ylim([0 4e5])
      set(gca,'fontsize',16)
      set(gcf,'color','w')
      box off;
    
    ax(3)=subplot(611);hold on; grid on;
      plot(t,length.chain/1300,'-','Color',cm(2,:),'LineWidth',1);
      xlim([1.8 2.4])
    ax(4)=subplot(613);hold on; grid on;
      plot(t,force.chain,'-','Color',cm(2,:),'LineWidth',2);
      ylabel('stress [Nm^{-2}]','fontsize',16);
      xlim([1.8 2.4]);ylim([0 3e5])
      set(gcf,'color','w')
      box off;
      linkaxes(ax,'x')
            
    ax(5)=subplot(614);hold on; grid on;
      plot(t,rd,'-','Color',cm(1,:),'LineWidth',2);
      ylabel({'bag', 'contribution'},'fontsize',16);
      xlim([1.8 2.4]);ylim([0 6])
      set(gcf,'color','w')
      box off;
    ax(6)=subplot(615);hold on; grid on;
      plot(t,rs,'-','Color',cm(2,:),'LineWidth',2);
      ylabel({'chain', 'contribution'},'fontsize',16);
      xlim([1.8 2.4]);ylim([0 6])   
      set(gcf,'color','w')
      box off;
    ax(7)=subplot(616);hold on;grid on;
      plot(t,r,'-','Color',cm(3,:),'LineWidth',2);
      ylabel({'total','receptor', 'potential'},'fontsize',16); xlabel('time (s)','fontsize',16);
      ylim([0 6])
      xlim([1.8 2.4])
      set(gcf,'color','w')
      box off;
      linkaxes(ax,'x')
      
%% some metrics
[~,indStart] = min(r(2000:2156));
p = polyfit(t(2000+indStart:2156),r((2000+indStart:2156)),1);
rampResponse = p(1);
initialBurst = max(r(2000:2156)) - r(1000);
dynamicIndex = r(2156)-r(end);