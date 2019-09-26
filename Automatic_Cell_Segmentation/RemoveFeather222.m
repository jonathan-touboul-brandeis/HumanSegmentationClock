function [ListCenters,Levels]=RemoveFeather(ImageNB,ListCenters,Levels)
% function savedcenters=RemoveFeather(ImageNB,ListCenters,Levels)

[xc yc] = ginput(1)
NumFeath=max(size(ListCenters));
Diff=sum(abs(ListCenters-[xc;yc]*ones(1,NumFeath)),1);

[v,ind]=find(Diff==min(Diff));

plot(ListCenters(1,ind),ListCenters(2,ind),'square');


plot(ListCenters(1,ind),ListCenters(2,ind),'kx','MarkerSize',40);
        if ind==1
            ListCenters=ListCenters(:,2:end);
            Levels=Levels(2:end);
        elseif ind==NumFeath
            ListCenters=ListCenters(:,1:(end-1));
            Levels=Levels(1:(end-1));
        else
            ListCenters=[ListCenters(:,1:ind-1) ListCenters(:,ind+1:end)];
            Levels=[Levels(1:ind-1); Levels(ind+1:end)];
        end
        
        
% % Construct a questdlg with three options
% choice = questdlg('What do I do?','It looked like it...', 'Remove it!', ...
%     'No, search again', 'Forget about it','Forget about it');
% % Handle response
% switch choice
%     case 'Remove it!'
%         plot(ListCenters(1,ind),ListCenters(2,ind),'kx','MarkerSize',40);
%         if ind==1
%             ListCenters=ListCenters(:,2:end);
%             Levels=Levels(2:end);
%         elseif ind==NumFeath
%             ListCenters=ListCenters(:,1:(end-1));
%             Levels=Levels(1:(end-1));
%         else
%             ListCenters=[ListCenters(:,1:ind-1) ListCenters(:,ind+1:end)];
%             Levels=[Levels(1:ind-1); Levels(ind+1:end)];
%         end
%     case 'No, search again'
%         [ListCenters,Levels]=RemoveFeather(ImageNB,ListCenters,Levels);
%     case 'Forget about it'
% end
% end
