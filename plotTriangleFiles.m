% generate figures for journal of expt physiology
%%%%%%%%%%%%%%%%%%%IMPORTANT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this the cleaned up version for uploading with the manuscript. it
% only generates the figures that are in the manuscript
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
close all

%% Edit these
% (refer to the code where you ran the simulation and generated the file)
simNo=4; % sim number of the file you want to load
date=20230702; % date used for saving the file you want to plot
protocolPick = '/customTri'; % this is parms.protcolPick in the "main" files
ISIsims=0; % set this to 1 if running inter-stretch interval sims; sest to 0 is running conditioning amplitude sims

% for the inter-stretch interval simualtions, add the list. otherwise enter
% 0
ISIlist = 0;
% for the conditioning ampplitude simulations, add the list. otherwise set
% it to 7
condAmpList = 0.25;

% on your computer replace this part of the file path (fp_CurrSimOUT) from below
% with the path to the github repo on your computer
parms.fnp = '/Users/surabhisimha/Desktop/JExptPhysiol2023_SpindelModelCode/';

%% keep these constant to plot the ramp figures as seen in the manusript
% ie Figure 2b, 4a, 4b

fp_CurrSimOUT = strcat(parms.fnp,'sim_output/');
fp_CurrSimIN = strcat(parms.fnp,'sim_input');

MTUtoFibre=0.8;
vel =  15*10*MTUtoFibre;
triAmp = 7*MTUtoFibre;
if ISIsims==1
    iterList = ISIlist;
    riseTime = ((triAmp/100)*1300)/((vel/1000)*1300);
    maxTestRampStartTime = 2+(2*riseTime)+max(ISIlist);
else
    iterList = condAmpList;
    condAmpList = condAmpList*MTUtoFibre;
    condAmpRiseTime = ((condAmpList/100)*1300)/((vel/1000)*1300);
    riseTime = condAmpRiseTime;
    maxTestRampStartTime = 2+(2*(max(condAmpRiseTime)));
end

figure(1);
for i=1:numel(iterList)

    if ISIsims==1
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

    else
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
      plot(t_padded,length.bag*lenScaleFactor,'-','Color','b','LineWidth',3); 
      plot(extraTimeToBeAdded(i)+cumsum(prot(:,2)),(1300+cumsum(prot(:,1)))*lenScaleFactor,'--','Color','k','LineWidth',2);
      ylabel('length [L0]'); title(strcat(titleStr));
      plot([maxTestRampStartTime maxTestRampStartTime],ylim,'k--','LineWidth',0.5)
    ax(2)=subplot(612);hold on;grid on
      plot(t_padded,thresholdedToBaseline.bagForce,'-','Color','b','LineWidth',2);
      plot([maxTestRampStartTime maxTestRampStartTime],ylim,'k--','LineWidth',0.5)
      ylabel('stress [Nm^{-2}]');
    
    ax(3)=subplot(611);hold on;grid on
      plot(t_padded,length.chain*lenScaleFactor,'-','Color','r','LineWidth',1);
      plot([maxTestRampStartTime maxTestRampStartTime],ylim,'k--','LineWidth',0.5)
    ax(4)=subplot(613);hold on; ex(2)=ax(4);
      plot(t_padded,thresholdedToBaseline.chainForce,'-','Color','r','LineWidth',2);
      plot([maxTestRampStartTime maxTestRampStartTime],ylim,'k--','LineWidth',0.5)
      ylabel('stress [Nm^{-2}]');
     
    rd=rd-rd(1000);rd(rd<0)=0; rs=rs-rs(1000);rs(rs<0)=0; r=r-r(1000);r(r<0)=0;
    ax(5)=subplot(614);hold on;grid on
      plot(t_padded,rd,'-','Color','b','LineWidth',2);
      plot([maxTestRampStartTime maxTestRampStartTime],ylim,'k--','LineWidth',0.5)
      ylabel({'bag', 'contribution'});     
    ax(6)=subplot(615);hold on;grid on
      plot(t_padded,rs,'-','Color','r','LineWidth',2);
      plot([maxTestRampStartTime maxTestRampStartTime],ylim,'k--','LineWidth',0.5)
      ylabel({'chain', 'contribution'});
    ax(7)=subplot(616);hold on;grid on
      plot(t_padded,r,'-','Color','g','LineWidth',2);
      plot([maxTestRampStartTime maxTestRampStartTime],ylim,'k--','LineWidth',0.5)
      ylabel({'total','receptor', 'potential'}); xlabel('time (s)');
    linkaxes(ax,'x')
% pause
end