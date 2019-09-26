function [savedcenters,levels]=SelectNewFeather(ImageNB,savedcenters,levels)
%function
%[savedcenters,levels]=SelectNewFeather(ImageNB,savedcenters,levels)
    rect=(getrect());

    xmin=floor(rect(1));
    xmax=ceil(rect(1)+rect(3));
    ymin=floor(rect(2));
    ymax=ceil(rect(2)+rect(4));
    Zone=ImageNB(ceil(ymin):ceil(ymax),ceil(xmin):ceil(xmax));
    [v,ind]=max(Zone(:));
    [MatrixI,MatrixJ] = ind2sub(size(Zone),ind);
    FeatherX=xmin+MatrixJ;
    FeatherY=ymin+MatrixI;
    
    plot(FeatherX,FeatherY,'mo');
    
    savedcenters(:,end+1)=[FeatherX;FeatherY];
    levels(end+1)=0;
    fprintf('FeathX=%f,FeathY=%f',FeatherX,FeatherY);

%     % Construct a questdlg with three options
%     choice = questdlg('Did I find it now?','Add missing Feather', 'This is a feather!', ...
% 	'No, search again', 'Forget about it','Forget about it');
%     % Handle response
%     switch choice
%         case 'This is a feather!'
%             savedcenters(:,end+1)=[FeatherX;FeatherY];
%             levels(end+1)=0;
%             fprintf('FeathX=%f,FeathY=%f',FeatherX,FeatherY);
%         case 'No, search again'
%             SelectNewFeather(ImageNB,savedcenters,levels);
%         case 'Forget about it'
%     end
% end
