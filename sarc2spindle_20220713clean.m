function [t,r,rs,rd] = sarc2spindle_20220713clean(dataB,dataC,kFc,kFb,kYb)

t1 = dataC.time_s; %time

% find non-nan values in both bag and chain fibres
notNanChainIndices = find(~isnan(dataC.hs_force));
notNanBagIndices = find(~isnan(dataB.hs_force));
commonIndices = intersect(notNanChainIndices,notNanBagIndices);
Fs = dataC.hs_force(commonIndices);
Fd = dataB.hs_force(commonIndices);
t = t1(commonIndices);

Fs_filt = Fs;
Fd_filt = Fd;

% Yank-dominant fiber (dynamic fiber)
Y = diff(Fd_filt)./diff(t); %yank
Y(Y<0) = 0; %threshold
Y(end+1) = Y(end); %make Y same length as F

rs = Fs_filt*kFc; %static component
rd = Fd_filt*kFb + Y*kYb; %dynamic component

rs(rs<0) = 0;

rs = 2*rs/(10^5);
rd = 2*rd/(10^5);

r = rs + rd; %linear sum

%Firing Threshold
r(r<0.0) = 0; 
