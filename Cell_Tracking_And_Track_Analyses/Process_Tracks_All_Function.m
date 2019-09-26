function Process_Tracks_All_Function(Folder,METHOD,Duration,NFrames)

Select_Oscillating_Tracks=1; % 1: select oscillating cells only, 0: all cells. 
Kuramoto_Movie=1;
Phase_Movie=1;

% Folder=pwd
% METHOD='PAUL';%'INTRINSIC_PEAKS';%, 'INTRINSIC_PEAKS',
SUB_METHOD='MOV_MEAN'; %'DETREND','MOV_MEAN'
% addpath('~/Dropbox/HES_Clean_Folder/Human/')
% close all
NFrames
%% Loading and selecting the data

load(strcat(Folder,'/Tracks_Auto_All.mat'));

% Tracks is a Ntrack x 4 x Duration Matrix
% for each track (between 1-Ntrack), Tracks(i,:,:) contains, for each
% time point, the positions (x,y), Max and Mean Hes intensity
% 
% Duration=140;
% Min_Duration=30;                % Minimal duration of the tracking
MinSignalAmplitude=100;      % Minimal variation of HES during the track
MaxHesAmplitude=100000000;     % Maximal Peak of HES during the track

% Duration
selected=find((TracksDuration(:,2)-TracksDuration(:,1))>Duration);

Tracks_2=Tracks(selected,:,:,:);
TracksDuration_2=TracksDuration(selected);
NFrames=min(NFrames,size(Tracks_2,3));


figure;
N_Tracks=length(TracksDuration_2)
plot(squeeze(nanmean(Tracks_2(:,3,:),1)),'linewidth',3);

figure(3)
plot(nanmean(squeeze((Tracks_2(:,3,:)))));


ax=figure;
plot(squeeze((Tracks_2(:,3,:)))');
savefig(strcat(Folder,'/All_Hes.fig'))

figure;
pcolor(squeeze((Tracks_2(:,3,:))))
caxis([0,max(max(squeeze((Tracks_2(:,3,:)))))/2.5])
title('All Hes');
savefig(strcat(Folder,'/All_Hes_HeatMap.fig'))

if Select_Oscillating_Tracks
    Hes=squeeze(Tracks_2(:,3,:));
    Osc=zeros(1,size(Hes,1));
    for i=1:size(Hes,1)
        S=Hes(i,:);
        S=S(~isnan(S));
        S=S-movmean(S,25);
        Osc(i)=max(abs(fft(S)))>600;
    end
    selected=find(Osc)
    Tracks_2=Tracks_2(selected,:,:,:);
    TracksDuration_2=TracksDuration(selected);
    N_Tracks=length(TracksDuration_2);
    save(strcat(Folder,'/Oscillating_Tracks'),'Tracks_2','TracksDuration_2');
    Hes_Oscillating=squeeze(Tracks_2(:,3,:));
    xlswrite(strcat(Folder,'/Hes_Oscillating'),Hes_Oscillating);
end

figure(3)
hold on
plot(nanmean(squeeze((Tracks_2(:,3,:)))));


ax=figure;
size(squeeze((Tracks_2(:,3,:))))
if min(size(squeeze((Tracks_2(:,3,:)))))>1
plot(squeeze((Tracks_2(:,3,:)))');
savefig(strcat(Folder,'/All_Hes_Oscillating.fig'))

figure;
pcolor(squeeze((Tracks_2(:,3,:))))
caxis([0,max(max(squeeze((Tracks_2(:,3,:)))))/2.5])
title('All Oscillating Hes');
savefig(strcat(Folder,'/All_Hes_Oscillating_HeatMap.fig'))

plot(squeeze((Tracks_2(:,3,:)))');

%%
if strcmp(METHOD,'HILBERT')
    ntimes=NFrames;
    Times=1:NFrames;
    interplevel=1;
    xx=1:(ntimes*interplevel);
    
    ncells=N_Tracks;
    
    if strcmp(SUB_METHOD,'DETREND')
        Transformation=@(x,s) angle(hilbert(smooth(detrend(x),s)));
    else
        Transformation=@(x,s) angle(hilbert(smooth(x-movmean(x,30*interplevel,'omitnan'),s)));
    end
    
    
    IntrinsicPhase=NaN*ones(ncells,ntimes);
    Data=squeeze(Tracks_2(:,3,1:end));
    
    Mean=nanmean(Data);
    % Mean=Mean(isfinite(Mean));
    figure;
    plot(Mean)
    savefig(strcat(Folder,'/Mean_Hes.fig'))
    
    Smoothing_Radius=5;
    
    Dephasage=NaN*ones(ncells,ntimes*interplevel);
    
    
    for Track_Number=1:ncells
%         progressbar(Track_Number,ncells);
        DD=Data(Track_Number,:);
        size(DD)
        if prod(size(DD))==0
            Track_Number
            DD
            ncells
            size(Data)
        end
        %     if interplevel>1
        DD=interp1(1:interplevel:interplevel*ntimes,DD,xx);
        %     end
        
        Dephasage(Track_Number,:)=Transformation(DD,Smoothing_Radius);
    end
    % Dephasage(find(isnan(squeeze(Tracks_2(:,3,:)))))=nan;
    
    
elseif strcmp(METHOD,'INTRINSIC_PEAKS')
    [peaksmean,locsmean]=findpeaks(smooth(Mean,10),'MinPeakDistance',15);
    n_peaks_mean=length(peaksmean);
    mean_period=mean(diff(locsmean));
    
    findpeaks(smooth(Mean,6),'MinPeakDistance',15);
    
    Dephasage=NaN*ones(ncells,n_peaks_mean);
    IntrinsicPhase=NaN*ones(ncells,ntimes);
    IntrinsicPhase2=NaN*ones(ncells,ntimes);
    for i=1:(ncells-1)
        %     progressbar(i,ncells)
        D=Data(i+1,:);
        Td=1:NFrames;
        
        [peaksD,locsD]=findpeaks(smooth(D,7),'MinPeakDistance',6,'MinPeakProminence',5);
        if locsD(1)>14
            locsD2=[find(isfinite(D),1);locsD(:)];
        else
            locsD2=locsD;
        end
        if length(locsD2)>0
            for p=1:length(locsD2)-1
                IntrinsicPhase(i,locsD2(p):locsD2(p+1))=((locsD2(p):locsD2(p+1))-locsD2(p))/(locsD2(p+1)-locsD2(p));
            end
            
        end
        
        if length(locsD)>0
            for p=1:min(length(peaksD)-1,n_peaks_mean-1)
                IntrinsicPhase2(i,locsD(p):locsD(p+1))=((locsD(p):locsD(p+1))-locsD(p))/(locsD(p+1)-locsD(p));
                if min(abs(locsmean-locsD(p)))==0
                    Dephasage(i,p)=0;
                else
                    if min(locsmean)<locsD(p)
                        previous=locsmean(find(locsmean<=locsD(p),1,'last'));
                    else
                        previous=min(locsmean)-mean_period;
                    end
                    if max(locsmean)>locsD(p)
                        next=locsmean(find(locsmean>locsD(p),1,'first'));
                    else
                        next=max(locsmean)+mean_period;
                    end
                    Dephasage(i,p)=(locsD(p)-previous)/(next-previous);
                end
                
            end
            %         IntrinsicPhase2(i,1:locsD(p))=((locsD(p):locsD(p+1))-locsD(p))/(locsD(p+1)-locsD(p));
            
        end
        %     Dephasage(isnan(squeeze(Tracks_2(:,3,:))))=nan;
        figure(1)
        hold off
        findpeaks(smooth(D,7),'MinPeakDistance',6,'MinPeakProminence',5);
        hold on
        plot(locsmean,peaksmean,'o')
        title(sprintf('cell %d',i))
        plot(Mean);
        %     saveas(gcf,sprintf('%d_vs_mean.eps',i));
        
        Dephasage(i,:)
        Dephasage=wrapToPi(IntrinsicPhase*2*pi);
    end
    
elseif strcmp(METHOD,'PAUL')
    ncells=N_Tracks
    NFrames
    ntimes=NFrames;
    Times=1:NFrames;
    Data=squeeze(Tracks_2(:,3,:));
    interplevel=1;
    
    Mean=nanmean(Data);
    % Mean=Mean(isfinite(Mean));
    figure;
    plot(Mean)
    savefig(strcat(Folder,'/Mean_Hes.fig'))
    
    Dephasage=NaN*ones(ncells,NFrames);
    
    for Track_Number=1:ncells
%         progressbar(Track_Number,ncells);
        DD=Data(Track_Number,:);
        if prod(size(DD))==0
            Track_Number
            DD
            ncells
            size(Data)
        end
        %     if interplevel>1
        %     end
        X=(DD-movmean(DD,20))./movstd(DD,20);
        NotNaN=find(~isnan(X));
        Dephasage(Track_Number,NotNaN)=angle(hilbert(X(NotNaN)));
    end
    
end
dlmwrite(strcat(Folder,'/Phases.txt'),Dephasage);
%%

% Longest=find(TracksDuration(:,1)==1 & (TracksDuration(:,2)-TracksDuration(:,1))>60);
% Dephasage_Longest=Dephasage(Longest,:);
% PhaseRef=Dephasage_Longest(1,:);
% Distance=nanmean((Dephasage_Longest-ones(size(Dephasage_Longest,1),1)*PhaseRef).^2);
% [~,order]=sort(Distance)
% OrderInit=1:ncells;
% OrderInit(Longest)=[];
% 
% OrderFinal=horzcat(Longest(order),OrderInit);
order=1:ncells
cols= vertcat(summer,flipud(summer));
xtimes=(1:interplevel*NFrames)*18/60/interplevel;
[xtimes,ytimes]=meshgrid(xtimes,1:ncells);

size(xtimes)
size(ytimes)
size(Dephasage)

figure()
h=pcolor(xtimes,ytimes,(Dephasage(order,1:NFrames)*180/pi))
set(h,'Edgecolor','none');
colormap(cols)
caxis([-180,180])
colorbar('Ticks',-180:20:180)
savefig(strcat(Folder,'/PhasePlot.fig'))


figure()
plot(nanmean(Dephasage))
hold on
plot(nanmean(Dephasage)+nanstd(Dephasage))
plot(nanmean(Dephasage)-nanstd(Dephasage))
ylim([-pi pi]);
savefig(strcat(Folder,'/PhaseStats.fig'))

%%
x=0:0.01:2*pi;
ntimesKura=NFrames;
Order_Parameter=zeros(1,ntimesKura);
if Kuramoto_Movie
figure()
v = VideoWriter(strcat(Folder,'/KuramotoAnalysis.avi'));
v.FrameRate = 5;  % Default 30
v.Quality = 100;    % Default 75
open(v);
end

for i=1:ntimesKura*interplevel
    Kura=exp(1i*(2*pi*0*i/20 + Dephasage(:,i)));
    Z=nanmean(Kura);
    Order_Parameter(i)=abs(Z);
    
    if Kuramoto_Movie
    hold off
    plot(sin(x),cos(x),'k--');
    hold on
    plot(Kura,'o')
    
    
    quiver(0,0,real(Z),imag(Z),'linewidth',2)
    axis equal;
    pause(0.1)
    frame = getframe(gcf);
    writeVideo(v,frame);
    end
        if Kuramoto_Movie
        hold off
        plot(sin(x),cos(x),'k--');
        hold on
        plot(Kura,'o')
        quiver(0,0,real(Z),imag(Z),'linewidth',2)
        axis equal;
        pause(0.1)
        frame = getframe(gcf);
        writeVideo(v,frame);
    end
    
%     if i==53
%         figure;
%         plot(sin(x),cos(x),'k--');
%         hold on
%         scatter(Kura,'o','MarkerSize',10)
%         quiver(0,0,real(Z),imag(Z),'linewidth',2)
%         axis equal;
%         savefig(strcat(Folder,'Kuramoto_Frame_53.fig'));
%     end
%     
%     if i==2
%         figure;
%         plot(sin(x),cos(x),'k--');
%         hold on
%         plot(Kura,'o','MarkerSize',10)
%         quiver(0,0,real(Z),imag(Z),'linewidth',2)
%         axis equal;
%         savefig(strcat(Folder,'Kuramoto_Frame_2.fig'));
%     end
end
if Kuramoto_Movie
close(v)
end
figure()
hold on
plot(Order_Parameter)
ylim([0 1])
%%
Kuramoto_Hilbert=exp(1i*Dephasage);
Order_Parameter_Hilbert=nanmean(Kuramoto_Hilbert);

figure()
plot(abs(Order_Parameter_Hilbert(1:ntimesKura)))
KOP=abs(Order_Parameter_Hilbert(1:ntimesKura));


ylim([0 1])
MC_Randomize=1000;
RandomizedPhases=zeros(MC_Randomize,NFrames);
for mc=1:MC_Randomize
    RPhase=Randomize(Dephasage(:,1:NFrames));
    RandomizedPhases(mc,:)=nanmean(exp(1i*RPhase));
end

hold on
plot(abs(mean(Order_Parameter_Hilbert)))
Kuramoto_RandomPhase=(abs(mean(RandomizedPhases)));
Kuramoto_RandomPhase_std=(abs(std(RandomizedPhases)));

plot(Kuramoto_RandomPhase,'linewidth',2)

x2=1:size(Kuramoto_Hilbert,2);
x2=[x2,fliplr(x2)];
inbetween=[abs(Kuramoto_RandomPhase)-abs(Kuramoto_RandomPhase_std)/2,fliplr(abs(Kuramoto_RandomPhase)+abs(Kuramoto_RandomPhase_std)/2)];
fill(x2,inbetween,'g')
alpha(0.2)
savefig(strcat(Folder,'/KuramotoAnalysis.fig'))
% Save data here. 
%dlmwrite(strcat(Folder,'/Kuramoto_Order_Parameter.txt'),Dephasage);

% KOP=abs(mean(Order_Parameter_Hilbert));

xlswrite(strcat(Folder,'/Kuramoto_Order_Parameter_'),KOP);
xlswrite(strcat(Folder,'/Kuramoto_Random_Phase'),Kuramoto_RandomPhase);
xlswrite(strcat(Folder,'/Kuramoto_Random_Phase_std'),Kuramoto_RandomPhase_std);
%%
size(Tracks_2)
Dephasage_Distance=zeros(ncells,ncells,NFrames,2);

hold on
Close=300;
Inter=500;
Far=1000;

nclose=0;
ninter=0;
nfar=0;
naway=0;

CloseDephasage=[];zeros(ncells*ncells,1);
InterDephasage=[];zeros(ncells*ncells,1);
FarDephasage=[];zeros(ncells*ncells,1);
AwayDephasage=[];zeros(ncells*ncells,1);

nclose_old=0;
ninter_old=0;
nfar_old=0;
naway_old=0;

for i=1:ncells
    Pos_xi=squeeze(Tracks_2(i,1,1:NFrames));
    Pos_yi=squeeze(Tracks_2(i,2,1:NFrames));
    for j=(i+1):ncells
        Delta_x=squeeze(Tracks_2(j,1,1:NFrames))-Pos_xi;
        Delta_y=squeeze(Tracks_2(j,2,1:NFrames))-Pos_yi;
        Distance=sqrt(Delta_x.^2+Delta_y.^2);
        PhaseShift=abs(angle(exp(1i*(Dephasage(i,:)-Dephasage(j,:)))));
%         PhaseShift=min(PhaseShift,2*pi-PhaseShift);
        
        for t=1:ceil(NFrames/2)
            if Distance(t)>0 & Distance(t)<Close
                nclose=nclose+1;
                CloseDephasage(end+1)=min(PhaseShift(t),2*pi-PhaseShift(t));
            elseif Distance(t)>Close & Distance(t)<Inter
                ninter=ninter+1;
                InterDephasage(end+1)=min(PhaseShift(t),2*pi-PhaseShift(t));
            elseif Distance(t)>Inter & Distance(t)<Far
                nfar=nfar+1;
                FarDephasage(end+1)=min(PhaseShift(t),2*pi-PhaseShift(t));
            else
                naway=naway+1;
                AwayDephasage(end+1)=min(PhaseShift(t),2*pi-PhaseShift(t));
            end
        end
    end
end

ddxx=0.0001;
XX=ddxx:ddxx:pi;
STDEV_Kura=sin(XX)./XX;
STDEV_Kura_Fun=@(s) XX(find((STDEV_Kura(2:end)-0.2).*(STDEV_Kura(1:end-1)-0.2)<0,1))

figure;
MeanClose=angle(nanmean(exp(1i*CloseDephasage)));
StdClose=STDEV_Kura_Fun(abs(nanmean(exp(1i*CloseDephasage))));

MeanInter=angle(nanmean(exp(1i*InterDephasage)));
StdInter=STDEV_Kura_Fun(abs(nanmean(exp(1i*InterDephasage))));

MeanFar=angle(nanmean(exp(1i*FarDephasage)));
StdFar=STDEV_Kura_Fun(abs(nanmean(exp(1i*FarDephasage))));

MeanAway=angle(nanmean(exp(1i*AwayDephasage)));
StdAway=STDEV_Kura_Fun(abs(nanmean(exp(1i*AwayDephasage))));

errorbar(Close,MeanClose,StdClose,'o')
hold on
errorbar(Inter,MeanInter,StdInter,'o')
errorbar(Far,MeanFar,StdFar,'o')
errorbar(2*Far,MeanAway,StdAway,'o')

ylim([-pi pi])
savefig(strcat(Folder,'/StatisticsPhase.fig'))

StatsSync=zeros(4,2)
StatsSync(1,1)=MeanClose;
StatsSync(1,2)=StdClose;
StatsSync(2,1)=MeanInter;
StatsSync(2,2)=StdInter;
StatsSync(3,1)=MeanFar;
StatsSync(3,2)=StdFar;
StatsSync(4,1)=MeanAway;
StatsSync(4,2)=StdAway;

dlmwrite(strcat(Folder,'/StatsPhasesWaves.txt'),StatsSync);
xlswrite(strcat(Folder,'/StatsPhases'),StatsSync);


NN=1000;
pmat=zeros(4,4);
[h,pmat(1,2)]=kstest2(CloseDephasage(randi(nclose,NN,1)),InterDephasage(randi(ninter,NN,1)));
[h,pmat(1,3)]=kstest2(CloseDephasage(randi(nclose,NN,1)),FarDephasage(randi(nfar,NN,1)));
[h,pmat(1,4)]=kstest2(CloseDephasage(randi(nclose,NN,1)),AwayDephasage(randi(naway,NN,1)));
[h,pmat(2,3)]=kstest2(InterDephasage(randi(ninter,NN,1)),FarDephasage(randi(nfar,NN,1)));
[h,pmat(2,4)]=kstest2(InterDephasage(randi(ninter,NN,1)),AwayDephasage(randi(naway,NN,1)));
[h,pmat(3,4)]=kstest2(FarDephasage(randi(nfar,NN,1)),AwayDephasage(randi(naway,NN,1)));
pmat

nclose
ninter
nfar
naway

nbins=30;
min_bin=pi/nbins;
[a1,b1]=hist(CloseDephasage,linspace(min_bin,pi,nbins));
[a2,b2]=hist(InterDephasage,linspace(min_bin,pi,nbins));
[a3,b3]=hist(FarDephasage,linspace(min_bin,pi,nbins));
[a4,b4]=hist(AwayDephasage,linspace(min_bin,pi,nbins));
figure;
plot(b1,a1/sum(a1*(b1(2)-b1(1))))
hold on
plot(b2,a2/sum(a2*(b1(2)-b1(1))))
plot(b3,a3/sum(a3*(b1(2)-b1(1))))
plot(b4,a4/sum(a4*(b1(2)-b1(1))))
legend('d<300','300<d<500','500<d<1000','d>1000');
savefig(strcat(Folder,'/DistributionPhaseShiftsDistance.fig'))
xlswrite(strcat(Folder,'/P_Values_Matrix_Wave'),pmat);


%%
% Movie with phase
if Phase_Movie
figure;
v = VideoWriter(strcat(Folder,'/PositionsAndPhase_All.avi'));
v.FrameRate = 5;  % Default 30
v.Quality = 100;    % Default 75
open(v);

for i=1:Duration-2
    H=load(strcat(Folder,sprintf('/Hes_%d',i)));
    C=load(strcat(Folder,sprintf('/Cherry_%d',i)));
    C=C.cherry;
    H=H.hes;
    
    im=zeros(size(H,1),size(H,2),3);
    im(:,:,1)=C/1000;
    im(:,:,2)=(H-200)/300;

    imagesc(im)
    hold on
    scatter(squeeze(Tracks_2(:,1,i)),squeeze(Tracks_2(:,2,i)),100,fillmissing(mod(squeeze(Dephasage(:,i))',2*pi),'constant',0),'filled');
    hold off
    caxis([0 2*pi])
    colorbar
    colormap(hsv)
    frame = getframe(gcf);
    writeVideo(v,frame);
end
close(v)
end
end
        