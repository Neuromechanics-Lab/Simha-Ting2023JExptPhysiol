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
    simNo=4; % sim number of the file you want to load
end

ISIsims = input("Select:\n 1: to plot effect of conditioning amplitude data from fig 4\n" + ...
    "2: to plot effect of inter-stretch intervals from fig 4\n" + ...
    "3: to plot effect of no interfilament cooperativity from fig 2\n" + ...
    "4: to plot the effect of interfilament cooperativity from fig 2\n ");
if isempty(ISIsims)
    ISIsims=0; % set this to 1 if running inter-stretch interval sims; sest to 0 is running conditioning amplitude sims
end

% on your computer replace this part of the file path (fp_CurrSimOUT) from below
% with the path to the github repo on your computer
parms.fnp = input("\nEnter the path to the folder containing this script on your computer in single quotes:\n");
if isempty(parms.fnp)
    parms.fnp = '/Users/surabhisimha/GitHub/Emory/Simha-Ting2023JExptPhysiol/';
end

%% keep these constant to plot the ramp figures as seen in the manusript
% ie Figure 2b, 4a, 4b

protocolPick = '/customTri'; % this is parms.protcolPick in the "main" files
if ISIsims==1
    condAmpList = [0 0.25 0.5 0.75 1 1.25 1.5 1.75 2 3 7];
    ISIlist = 0;
elseif ISIsims==2
    condAmpList = 7*0.8;
    ISIlist = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.5, 3, 5, 8, 10];
else
    condAmpList = 7;
    ISIlist = 0;
end

fp_CurrSimOUT = strcat(parms.fnp,'/sim_output/');
fp_CurrSimIN = strcat(parms.fnp,'/sim_input');

MTUtoFibre=0.8;
vel =  15*10*MTUtoFibre;
triAmp = 7*MTUtoFibre;
if ISIsims==2
    iterList = ISIlist;
    riseTime = ((triAmp/100)*1300)/((vel/1000)*1300);
    maxTestRampStartTime = 2+(2*riseTime)+max(ISIlist);
elseif ISIsims==1
    iterList = condAmpList;
    condAmpList = condAmpList*MTUtoFibre;
    condAmpRiseTime = ((condAmpList/100)*1300)/((vel/1000)*1300);
    riseTime = condAmpRiseTime;
    maxTestRampStartTime = 2+(2*(max(condAmpRiseTime)));
end

figure(1);
for i=1:numel(iterList)

    if ISIsims==2
        fname_mat = strcat(fp_CurrSimOUT,num2str(date),protocolPick,'Sim',num2str(simNo),'pCa64ISI'...
            ,num2str(ISIlist(i)*10),'condAmp',num2str(condAmpList*10),'Amp',...
            num2str(triAmp*10),'Vel',num2str(vel),'.mat');
        load(fname_mat);
        condTriStartInd = find(t>2,1);
        condTriEndInd = find(t>(2+(2*riseTime)),1);
        testRampStartInd = find(t>(2+(2*riseTime)+ISIlist(i)),1);
        testRampStartTime(i) = (2+(2*riseTime)+ISIlist(i));
        extraTimeToBeAdded(i) = maxTestRampStartTime-testRampStartTime(i);

        % protocol file
        fname_prot = strcat(fp_CurrSimIN,'/Protocols/',num2str(date),protocolPick,'Sim',num2str(simNo),'pCa64ISI'...
            ,num2str(ISIlist(i)*10),'condAmp',num2str(condAmpList*10),'Amp',...
            num2str(triAmp*10),'Vel',num2str(vel),'.txt');
        prot = dlmread(fname_prot,'',1,0);

    elseif ISIsims==1
        fname_mat = strcat(fp_CurrSimOUT,num2str(date),protocolPick,'Sim',num2str(simNo),'pCa64ISI'...
            ,num2str(ISIlist*10),'condAmp',num2str(condAmpList(i)*10),'Amp',...
            num2str(triAmp*10),'Vel',num2str(vel),'.mat');
        load(fname_mat);
        condTriStartInd = find(t>2,1);
        condTriEndInd = find(t>(2+(2*riseTime)),1);
        testRampStartInd = find(t>(2+(2*condAmpRiseTime(i))),1);
        testRampStartTime(i) = (2+(2*condAmpRiseTime(i)));
        extraTimeToBeAdded(i) = maxTestRampStartTime-testRampStartTime(i);

        % protocol file
        fname_prot = strcat(fp_CurrSimIN,'/Protocols/',num2str(date),protocolPick,'Sim',num2str(simNo),'pCa64ISI'...
            ,num2str(ISIlist*10),'condAmp',num2str(condAmpList(i)*10),'Amp',...
            num2str(triAmp*10),'Vel',num2str(vel),'.txt');
        prot = dlmread(fname_prot,'',1,0);
    end
  
    if parms.k_coop==0
        titleStr = 'No coop';
    elseif parms.k_coop>0
        titleStr = 'With coop';
    end
    
    %% create scaling factor for length and padding for time alignment with test stretch
    
    t_padded = t+extraTimeToBeAdded(i);
    lenScaleFactor = 1/1300;
    thresholdedToBaseline.bagForce = force.bag-force.bag(1000); thresholdedToBaseline.bagForce(thresholdedToBaseline.bagForce<0)=0;
    thresholdedToBaseline.chainForce = force.chain-force.chain(1000); thresholdedToBaseline.chainForce(thresholdedToBaseline.chainForce<0)=0;
    
    %% plotting
    figure(1);hold on;
    ax(1)=subplot(611);hold on;grid on
      plot(t_padded,length.bag*lenScaleFactor,'-','Color',cm(1,:),'LineWidth',3); 
      plot(extraTimeToBeAdded(i)+cumsum(prot(:,2)),(1300+cumsum(prot(:,1)))*lenScaleFactor,'--','Color','k','LineWidth',2);
      ylabel('length [L0]','fontsize',16); title(strcat(titleStr),'fontsize',16);
      plot([maxTestRampStartTime maxTestRampStartTime],ylim,'k--','LineWidth',0.5)
      set(gcf,'color','w')
      box off;
    ax(2)=subplot(612);hold on;grid on
      plot(t_padded,thresholdedToBaseline.bagForce,'-','Color',cm(1,:),'LineWidth',2);
      plot([maxTestRampStartTime maxTestRampStartTime],ylim,'k--','LineWidth',0.5)
      ylabel('stress [Nm^{-2}]','fontsize',16);
      set(gcf,'color','w')
      box off;
    
    ax(3)=subplot(611);hold on;grid on
      plot(t_padded,length.chain*lenScaleFactor,'-','Color',cm(2,:),'LineWidth',1);
      plot([maxTestRampStartTime maxTestRampStartTime],ylim,'k--','LineWidth',0.5)
      set(gcf,'color','w')
      box off;
    ax(4)=subplot(613);hold on; ex(2)=ax(4);
      plot(t_padded,thresholdedToBaseline.chainForce,'-','Color',cm(2,:),'LineWidth',2);
      plot([maxTestRampStartTime maxTestRampStartTime],ylim,'k--','LineWidth',0.5)
      ylabel('stress [Nm^{-2}]','fontsize',16);
      set(gcf,'color','w')
      box off;
     
    rd=rd-rd(1000);rd(rd<0)=0; rs=rs-rs(1000);rs(rs<0)=0; r=r-r(1000);r(r<0)=0;
    ax(5)=subplot(614);hold on;grid on
      plot(t_padded,rd,'-','Color',cm(1,:),'LineWidth',2);
      plot([maxTestRampStartTime maxTestRampStartTime],ylim,'k--','LineWidth',0.5)
      ylabel({'bag', 'contribution'},'fontsize',16);     
      set(gcf,'color','w')
      box off;
    ax(6)=subplot(615);hold on;grid on
      plot(t_padded,rs,'-','Color',cm(2,:),'LineWidth',2);
      plot([maxTestRampStartTime maxTestRampStartTime],ylim,'k--','LineWidth',0.5)
      ylabel({'chain', 'contribution'},'fontsize',16);
      set(gcf,'color','w')
      box off;
    ax(7)=subplot(616);hold on;grid on
      plot(t_padded,r,'-','Color',cm(3,:),'LineWidth',2);
      plot([maxTestRampStartTime maxTestRampStartTime],ylim,'k--','LineWidth',0.5)
      ylabel({'total','receptor', 'potential'},'fontsize',16); xlabel('time (s)');
      set(gcf,'color','w')
      box off;
    linkaxes(ax,'x')
% pause
end