function New_Tracking_Exclusion_All(Folder,Typical_Distance,N_frames,NumTracks,SkippedFrames)
% function New_Tracking_Exclusion_All(Folder,Typical_Distance,N_frames,SkippedFrames)
% Folder=pwd
% Typical_Distance=45
% N_frames=140
% SkippedFrames=3;

AllCells=zeros(N_frames,1000,4);
CellsInTrack=ones(N_frames,1000);
M=1;
for Frame=1:N_frames
    X1=load(strcat(Folder,sprintf('/Cherry_%d_centers.txt',Frame)));
    Intensities1=load(strcat(Folder,sprintf('/Cherry_%d_intensities.txt',Frame)));
    AllCells(Frame,1:max(size(X1)),1:2)=X1';
    AllCells(Frame,1:max(size(X1)),3:4)=Intensities1(1:2,:)';
    CellsInTrack(Frame,1:max(size(X1)))=0;
    M=max(M,(size(X1,2)));
end

AllCells=AllCells(:,1:M,:);
CellsInTrack=CellsInTrack(:,1:M);

Num_Tracks=M;
Tracks=nan*ones(Num_Tracks*10,4,N_frames);
TracksDuration=zeros(Num_Tracks*10,2);
% Is_In_Track=zeros(Num_Tracks,N_frames);
Is_In_Track=CellsInTrack;
track_count=0;

while(sum(1-Is_In_Track(:))>0)
    track_count=track_count+1;
    [f,g]=find(Is_In_Track==0);
    FirstFreeFrame=min(f);
    FirstFreeCell=min(g(f==FirstFreeFrame));
    
    x1=squeeze(AllCells(FirstFreeFrame,FirstFreeCell,1:2));
    I1=squeeze(AllCells(FirstFreeFrame,FirstFreeCell,3:4));
    Is_In_Track(FirstFreeFrame,FirstFreeCell)=1;
            
    Tracks(track_count,1:2,FirstFreeFrame)=x1;
    Tracks(track_count,3:4,FirstFreeFrame)=I1(1:2);
            
    TracksDuration(track_count,1)=FirstFreeFrame;
    TracksDuration(track_count,2)=FirstFreeFrame;
    Frame=FirstFreeFrame+1;
    KeepTrack=1;
    while (Frame<N_frames & KeepTrack>-SkippedFrames)
        X2=squeeze(AllCells(Frame,:,1:2));
        Intensities2=squeeze(AllCells(Frame,:,3:4))';
        
        Available=find(Is_In_Track(Frame,:)==0);
        Z2=X2(Available,:)';
        Distances=sqrt((x1(1,1)-Z2(1,:)).^2+ (x1(2,1)-Z2(2,:)).^2);
                
        if min(Distances)<Typical_Distance
            Closest=find(Distances==min(Distances),1);
            x1=Z2(:,Closest);
            
            Tracks(track_count,1:2,Frame)=x1;
            Tracks(track_count,3:4,Frame)=Intensities2(1:2,Available(Closest));
            TracksDuration(track_count,2)=TracksDuration(track_count,2)+1;
            Is_In_Track(Frame,Available(Closest))=1;
            Frame=Frame+1;
            
        else
            Tracks(track_count,:,Frame)=nan;
            KeepTrack=KeepTrack-1;
        end
    end
end
% end
Tracks=Tracks(1:track_count,:,:);
TracksDuration=TracksDuration(1:track_count,:);
save(strcat(Folder,'/Tracks_Auto_All'),'Tracks','TracksDuration');
