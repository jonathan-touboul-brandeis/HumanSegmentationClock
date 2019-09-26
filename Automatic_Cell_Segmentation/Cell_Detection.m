function varargout = Cell_Detection(varargin)
% CELL_DETECTION MATLAB code for Cell_Detection.fig
%      CELL_DETECTION, by itself, creates a new CELL_DETECTION or raises the existing
%      singleton*.
%
%      H = CELL_DETECTION returns the handle to a new CELL_DETECTION or the handle to
%      the existing singleton*.
%
%      CELL_DETECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CELL_DETECTION.M with the given input arguments.
%
%      CELL_DETECTION('Property','Value',...) creates a new CELL_DETECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Cell_Detection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Cell_Detection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Cell_Detection

% Last Modified by GUIDE v2.5 04-Apr-2019 09:33:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Cell_Detection_OpeningFcn, ...
                   'gui_OutputFcn',  @Cell_Detection_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Cell_Detection is made visible.
function Cell_Detection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Cell_Detection (see VARARGIN)

% Choose default command line output for Cell_Detection
handles.output = hObject;
handles.edit1=0.3;
handles.edit3=0.3;
handles.edit4=1;
handles.edit9=15;
handles.edit10=0.3;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Cell_Detection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Cell_Detection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%----------> here we LOAD image

global im im2 path
% [path,user_cance]=imgetfile();
% if user_cance
%     msgbox(sprintf('Error'),'Error','Error');
%     return
% end
[baseFileName, folder] = uigetfile('*.mat', 'Select a mat file');
if baseFileName == 0
  % User clicked the Cancel button.
  return;
end
fullFileName = fullfile(folder, baseFileName)
im = load(fullFileName);
im=im.cherry;
% im=imread(path);
% im=1-im2double(im); %converts to double
im2=im; %for backup process :)
axes(handles.axes1);
imagesc(im);
axis(handles.axes1,'image');
colormap gray



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%------------>here we run the AUTODETECTION of feathers

global im im2 savedcenters Levels col colorss



% if not(exist('MinThreshold'))
    MaxThreshold=handles.edit10
% end
% if not(exist('MaxThreshold'))
%     MaxThreshold=0.9;
    MinThreshold=handles.edit3
% end
% if not(exist('NumThreshold'))
%     NumThreshold=4;
    NumThreshold=handles.edit4
    MinArea=handles.edit9
    
% end

% fprintf('%f\n',MinThreshold);

% im2=im;

[col,colorss,savedcenters,Levels]=balayagethresholdFILTREThreshsMinArea(im,MinThreshold,MaxThreshold,NumThreshold,MinArea);

axes(handles.axes1);
hold off
axes(handles.axes1);
imagesc(im);
axis(handles.axes1,'image');
hold on
 for i=1:length(savedcenters)
%         if Levels(i)
%             col=strcat(colorss(mod(Levels(i),length(colorss))+1),'o');
%         else
%             col='ko';
%         end
        plot(savedcenters(1,i),savedcenters(2,i),'or')
 end
 



 
 
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%------------>Here we REMOVE feathers

global im im2 Levels Levels2 savedcenters savedcenters2

im2=im;
Levels2=Levels;
savedcenters2=savedcenters;

[savedcenters,Levels]=RemoveFeather222(im,savedcenters,Levels)




% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%----------->Here we REPLOT

global im savedcenters Levels colorss


axes(handles.axes1);

imagesc(im);
length(savedcenters)

 for i=1:length(savedcenters)
         hold on
        if Levels(i)
            col=strcat(colorss(mod(Levels(i),length(colorss))+1),'o');
        else
            col='yo';
        end
        plot(savedcenters(1,i),savedcenters(2,i),col)
 end



% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Here we ADD feathers

global im im2 Levels Levels2 savedcenters savedcenters2

im2=im;
Levels2=Levels;
savedcenters2=savedcenters;
size(savedcenters)
[savedcenters,Levels]=SelectNewFeather(im,savedcenters,Levels);
size(savedcenters)




% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA

% Here we UNDO last operation

global im im2 Levels Levels2 savedcenters savedcenters2 colorss

im=im2;
Levels=Levels2;
savedcenters=savedcenters2;

axes(handles.axes1);

imagesc(im);

 for i=1:length(savedcenters)
         hold on
        if Levels(i)
            col=strcat(colorss(mod(Levels(i),length(colorss))+1),'o');
        else
            col='ko';
        end
        plot(savedcenters(1,i),savedcenters(2,i),col)
 end




% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%----------->Here we PLOT only DOTS

global savedcenters im path

save(strcat(path,'_coordinates.txt'),'savedcenters','-ascii')
figure(5)
hold off

%  for i=1:length(savedcenters)
%         hold on
% %         if Levels(i)
% %             col=strcat(colorss(Levels(i)),'o');
% %         else
% %             col='ko';
% %         end
%         plot(savedcenters(1,i),savedcenters(2,i),'o')
%  end

S=size(im);
% plot(S(2)-savedcenters(1,:),S(1)-savedcenters(2,:),'ro','MarkerSize',3)
% imagesc(im)
% colormap gray
% hold on
% plot(savedcenters(1,:),savedcenters(2,:),'ro','MarkerSize',3)
% hold on
% plot(0,0,'x')
% plot(S(2),S(1),'x')
% % axis ij
% axis('image');
% saveas(gcf,strcat(path,'_dotplot.png'))

 



 
 
 
 
 
 
 
 
 
 
% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
global MinThreshold

MinThreshold = str2double(get(hObject,'String'));
if isnan(MinThreshold)
    MinThreshold = 0;
    set(hObject,'String',MinThreshold);
    errordlg('Input must be a number', 'Error')
end
handles.edit1 = MinThreshold;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
global MinThreshold 

MinThreshold = str2double(get(hObject,'String'))
if isnan(MinThreshold)
    MinThreshold = 0.3;
    set(hObject,'String',MinThreshold);
    errordlg('Input must be a number', 'Error')
end
handles.edit3 = MinThreshold;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
global NumThreshold

NumThreshold = str2double(get(hObject,'String'));

if isnan(NumThreshold)
    NumThreshold = 1;
    set(hObject,'String',NumThreshold);
    errordlg('Input must be a number', 'Error')
end
handles.edit4 = NumThreshold;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im
im=1-im;
axes(handles.axes1);

imagesc(im);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Radius_Smoothing im
H = fspecial('gaussian',Radius_Smoothing,Radius_Smoothing);
im= imfilter(im,H,'replicate');
axes(handles.axes1);

imagesc(im);



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
global Radius_Smoothing

Radius_Smoothing = str2double(get(hObject,'String'));

if isnan(Radius_Smoothing)
    Radius_Smoothing = 4;
    set(hObject,'String',Radius_Smoothing);
    errordlg('Input must be a number', 'Error')
end
handles.edit4 = Radius_Smoothing;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im Small_Radius Big_Radius
DD_small=strel('disk',Small_Radius );
DD_large=strel('disk',Big_Radius)
im=imclose(im,DD_small)-imopen(im,DD_large);

% im= im-imfilter(im,fspecial('gaussian',Big_Radius,Big_Radius));

axes(handles.axes1);

imagesc(im);


function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
global Small_Radius 

Small_Radius = str2double(get(hObject,'String'));

if isnan(Small_Radius )
    Small_Radius = 3;
    set(hObject,'String',Small_Radius );
    errordlg('Input must be a number', 'Error')
end
handles.edit4 = Small_Radius ;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double
global Big_Radius
Big_Radius = str2double(get(hObject,'String'));

if isnan(Big_Radius)
    Big_Radius = 15;
    set(hObject,'String',Big_Radius);
    errordlg('Input must be a number', 'Error')
end
handles.edit7 = Big_Radius;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double
global Thresh
Thresh = str2double(get(hObject,'String'));
if isnan(Thresh)
    Thresh = 3000;
    set(hObject,'String',Thresh );
    errordlg('Input must be a number', 'Error')
end
handles.edit8 = Thresh ;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Thresh im
im=min(im,Thresh);
axes(handles.axes1);

imagesc(im);



% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im
M=max(im(:));
moy=mean(im(:));
M=max(im(:)-moy);
im=(im-moy)/M;
axes(handles.axes1);

imagesc(im);




function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double
global MinArea
MinArea = str2double(get(hObject,'String'));
if isnan(MinArea)
    MinArea = 15;
    set(hObject,'String',MinArea );
    errordlg('Input must be a number', 'Error')
end
handles.edit9 = MinArea;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double
global MaxThreshold
MaxThreshold = str2double(get(hObject,'String'));
if isnan(MaxThreshold )
    MaxThreshold  = 0.3;
    set(hObject,'String',MaxThreshold  );
    errordlg('Input must be a number', 'Error')
end
handles.edit10 = MaxThreshold ;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
