function New_Tracking_Exclusion(Folder,Typical_Distance,N_frames,NumTracks,SkippedFrames)
% SkippedFrames=0;

X1=load(strcat(Folder,sprintf('/Cherry_%d_centers.txt',1)));
Intensities1=load(strcat(Folder,sprintf('/Cherry_%d_intensities.txt',1)));

N1=size(X1,2);
Num_Tracks=N1;

Tracks=nan*ones(Num_Tracks,4,N_frames);
TracksDuration=zeros(Num_Tracks,1);
Is_In_Track=zeros(10*Num_Tracks,N_frames);

for i=1:Num_Tracks
%     progressbar(i,Num_Tracks)
    x1=X1(:,i);
    I1=Intensities1(1:2,i);
    Is_In_Track(i,1)=1;
            
    Tracks(i,1:2,1)=x1;
    Tracks(i,3:4,1)=I1(1:2);
            
    TracksDuration(i)=0;
    Is_In_Track((Num_Tracks+1):end,1)=1;
    Frame=2;
    KeepTrack=1;
    while (Frame<N_frames & KeepTrack>-SkippedFrames)
        X2=load(strcat(Folder,sprintf('/Cherry_%d_centers.txt',Frame)));
        Intensities2=load(strcat(Folder,sprintf('/Cherry_%d_intensities.txt',Frame)));
        
        Available=find(Is_In_Track(1:size(X2,2),Frame)==0);
        Z2=X2(:,Available);
        Distances=sqrt((x1(1,1)-Z2(1,:)).^2+ (x1(2,1)-Z2(2,:)).^2);
                
        if min(Distances)<Typical_Distance
            Closest=find(Distances==min(Distances),1);
            x1=Z2(:,Closest);
            
            Tracks(i,1:2,Frame)=x1;
            Tracks(i,3:4,Frame)=Intensities2(1:2,Available(Closest));
            TracksDuration(i)=TracksDuration(i)+1;
            Is_In_Track(i,Available(Closest))=1;
            Frame=Frame+1;
            
        else
            Tracks(i,:,Frame)=nan;
            KeepTrack=KeepTrack-1;
        end
    end
end
% end
save(strcat(Folder,'/Tracks_Auto2'),'Tracks','TracksDuration');

%%

% TimeMin=70;
% display
% sum(TracksDuration>TimeMin)
% plot(squeeze((Tracks(find(TracksDuration>TimeMin),3,1:TimeMin)))')
% hold on
% plot(squeeze(nanmean(Tracks(find(TracksDuration>TimeMin),3,1:TimeMin),1)),'linewidth',3)
% figure;
% plot(squeeze(nanmean(Tracks(find(TracksDuration>TimeMin),3,1:TimeMin),1)),'linewidth',3)
% 
% 
% %%
% TimeMin=80;
% sum(TracksDuration>TimeMin)
% plot(squeeze((Tracks(:,3,2:TimeMin)))')
% hold on
% plot(squeeze(nanmean(Tracks(:,3,2:TimeMin),1)),'linewidth',3)
% figure;
% plot(squeeze(nanmean(Tracks(:,3,2:TimeMin),1)),'linewidth',3)
% 
% figure;
% 
% plot(squeeze((Tracks(:,3,2:TimeMin)))')

