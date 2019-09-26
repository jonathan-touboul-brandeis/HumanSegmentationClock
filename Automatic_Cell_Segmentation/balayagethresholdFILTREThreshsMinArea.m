function [col,colorss,savedcenters,levels]=balayagethresholdFILTREThreshsMinArea(im,minthresh,maxthresh,numthresh,MinArea)

% close all
% clear all
Im=im;
ImageNB =sum(Im,3);
% ImageNB=rgb2gray(Im);


% H = fspecial('gaussian',4,4);
% ImageNB = imfilter(ImageNB,H,'replicate');
% figure()
% imagesc(ImageNB);
% colormap gray;
% MinArea=15;
    
% figure(1)
% imagesc(ImageNB)
% colormap gray
% hold on
%%
MAAX=max(max(ImageNB));
MIIN=min(min(ImageNB));
j=1;
colorss=['g','r','b','c','m','y','k','w'];
numthresh
if numthresh==1
    savedcenters=[];
    levels = [];
    minthresh
    maxthresh
    Imagebin=ImageNB>=(MIIN+.5*(minthresh+maxthresh)*(MAAX-MIIN));
    
    
    DD=strel('disk',1);
     DD2=strel('disk',1);
     Imagebin=imclose(imopen(Imagebin,DD2),DD);
     CC = bwconncomp(Imagebin);
    S = regionprops(CC,'Centroid');
    S = reshape([S.Centroid],2,length(S));
    selected=(cell2mat(struct2cell(regionprops(CC,ImageNB,'Area')))>MinArea);
    savedcenters = horzcat(savedcenters,S(:,selected)); 
    levels= vertcat(levels,j*ones(sum(selected),1));
    col=strcat(colorss(mod(j,length(colorss))+1),'o');







else
threshvals=linspace(minthresh,maxthresh,numthresh);
savedcenters=[];
levels = [];

for thresh = threshvals
    Imagebin=ImageNB>=(MIIN+thresh*(MAAX-MIIN));
    

    
   
    
%      DD=strel('disk',1);
%      DD2=strel('disk',1);
%      Imagebin=imclose(imopen(Imagebin,DD2),DD);
     




%      figure(2)
%     if j<3
%     ax(j)=subplot(1,3,j)
%     colormap gray
%     imagesc(Imagebin)
%     end
    
    % [centers, radii, metric] = imfindcircles(Imagebin,[5 12]);
    CC = bwconncomp(Imagebin);
    S = regionprops(CC,'Centroid');
    S = reshape([S.Centroid],2,length(S));
    MM = cell2mat(struct2cell(regionprops(CC,ImageNB,'MeanIntensity')));
    if thresh < max(threshvals)
        nextthresh=threshvals(j+1);
        selected=(MM<=(MIIN+nextthresh*(MAAX-MIIN))) & (cell2mat(struct2cell(regionprops(CC,ImageNB,'Area')))>MinArea);
        savedcenters = horzcat(savedcenters,S(:,selected)); 
        levels= vertcat(levels,j*ones(sum(sum(selected)),1));
        col=strcat(colorss(mod(j,length(colorss))+1),'o');
    else
        savedcenters = horzcat(savedcenters,S); 
        levels= vertcat(levels,j*ones(sum(MM>(MIIN+1*(MAAX-MIIN))),1));
        col=strcat(colorss(mod(j,length(colorss))+1),'o');
    end
    
    
%     for i=1:length(S)
%         pt=S(i).Centroid;
%         hold on
%         
%         plot(pt(1),pt(2),col)
%     end
    j=j+1;
end

savedcenters = horzcat(savedcenters,S(:,MM>=(MAAX+threshvals(end)))); 
levels= vertcat(levels,j*ones(sum(MM>=(MAAX+threshvals(end))),1));
end
%%
% 

% plot(centers(:,1),centers(:,2),'go')
% viscircles(centers, radii,'EdgeColor','b');
% for i=1:length(S)
%     pt=S(i).Centroid;
%     plot(pt(1),pt(2),'wo')
% end
% 
% figure(2)  
%  ax(3)=subplot(1,3,3)
% imagesc(ImageNB)
% colormap gray
% hold on
%     for i=1:length(savedcenters)
%         pt=savedcenters(i).Centroid;
%         hold on
%         col=strcat(colorss(levels(i)),'o');
%         plot(pt(1),pt(2),col)
%     end
% linkaxes([ax(3) ax(2) ax(1)],'xy')

%%
% figure(3)
% imagesc(ImageNB)
% colormap gray
% hold on
%  for i=1:length(savedcenters)
%         hold on
%         if levels(i)
%             col=strcat(colorss(levels(i)),'o');
%         else
%             col='ko';
%         end
%         plot(savedcenters(1,i),savedcenters(2,i),col)
%  end
