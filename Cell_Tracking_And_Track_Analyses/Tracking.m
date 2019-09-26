function varargout = Tracking(varargin)



% TRACKING MATLAB code for Tracking.fig
%      TRACKING, by itself, creates a new TRACKING or raises the existing
%      singleton*.
%
%      H = TRACKING returns the handle to a new TRACKING or the handle to
%      the existing singleton*.
%
%      TRACKING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRACKING.M with the given input arguments.
%
%      TRACKING('Property','Value',...) creates a new TRACKING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Tracking_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Tracking_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Tracking

% Last Modified by GUIDE v2.5 23-Apr-2019 21:39:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Tracking_OpeningFcn, ...
                   'gui_OutputFcn',  @Tracking_OutputFcn, ...
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

% --- Executes just before Tracking is made visible.
function Tracking_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Tracking (see VARARGIN)

% Choose default command line output for Tracking
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using Tracking.
% if strcmp(get(hObject,'Visible'),'off')
%     plot(rand(5));
% end

% UIWAIT makes Tracking wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Tracking_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
handles.output = hObject;
handles.edit1=30;
handles.edit2=130;
handles.edit3=0;
handles.edit4=50;
handles.edit5=0;
guidata(hObject, handles);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Folder
Folder=uigetdir('./')
cd(Folder)
cd ..
addpath('./');
cd(Folder);
load('Hes_1.mat')
imagesc(hes);
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
global Track_Radius
Track_Radius= ceil(str2double(get(hObject,'String')));
if isnan(Track_Radius)
    Track_Radius = 30;
    set(hObject,'String',Track_Radius);
    errordlg('Input must be a number', 'Error')
end
handles.edit1 = Track_Radius;
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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global StartFromFirst Track_Radius Folder N_Frames SkippedFrames
StartingFromFirst=get(handles.StartFromFrame,'SelectedObject');
Name=get(StartingFromFirst,'String');
Track_Radius=handles.edit1;
N_Frames=handles.edit2;
SkippedFrames=handles.edit5;

    cd(Folder);
    cd ..
%     Tracking_FunctionOnlyStart(Folder,Track_Radius,N_Frames,1)
    if strcmp(Name,'All')
        StartFromFirst=0;
    else
        StartFromFirst=1;
    end
    display('Tracking Cells...')
    if StartFromFirst
        New_Tracking_Exclusion(Folder,Track_Radius,N_Frames,1,SkippedFrames)
    else
        New_Tracking_Exclusion_All(Folder,Track_Radius,N_Frames,1,SkippedFrames)
    end
    display('Done!')


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
global StartFromFirst
StartFromFirst= 1-get(hObject,'Value');
guidata(hObject,handles)



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
global N_Frames
N_Frames= ceil(str2double(get(hObject,'String')));
if isnan(N_Frames)
    N_Frames = 160;
    set(hObject,'String',N_Frames);
    errordlg('Input must be a number', 'Error')
end
handles.edit2 = N_Frames;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Folder Track_label
load(strcat(Folder,'/Tracks_Auto_All.mat'));
Dur=0;
while Dur<20
Track_label=handles.edit3;
if Track_label==0
    Track_label=randi(size(Tracks,1));
end
Start=TracksDuration(Track_label,1);
Dur=TracksDuration(Track_label,2)-TracksDuration(Track_label,1);
end
Track_label

x=Tracks(Track_label,1,Start);
y=Tracks(Track_label,2,Start);
xmin=ceil(max(1,x-300));
xmax=ceil(min(2320,x+300));
ymin=ceil(max(1,y-300));
ymax=ceil(min(2320,y+300));

S=load(strcat(Folder,sprintf('/Cherry_%d',Start)));
S=S.cherry;
imagesc(S(ymin:ymax,xmin:xmax))
hold on
scatter(x-xmin,y-ymin);
hold off
for i=1:Dur-1
    x=Tracks(Track_label,1,Start+i);
    y=Tracks(Track_label,2,Start+i);

%     h=figure(1)
    S=load(strcat(Folder,sprintf('/Cherry_%d',Start+i)));
    S=S.cherry;
    imagesc(S(ymin:ymax,xmin:xmax))
    hold on
    scatter(x-xmin,y-ymin,'r');
%     scatter(xmax-x,y-ymin,'r');
    hold off
    pause(0.1)
%     frame = getframe(h); 
%     im = frame2im(frame); 
%     [imind,cm] = rgb2ind(im,256);
%     pause(0.1);
end

% 
% TimeMin=70;
% sum(TracksDuration>TimeMin)
% plot(squeeze((Tracks(find(TracksDuration>TimeMin),3,1:TimeMin)))')
% hold on
% plot(squeeze(nanmean(Tracks(find(TracksDuration>TimeMin),3,1:TimeMin),1)),'linewidth',3)
% figure;
% plot(squeeze(nanmean(Tracks(find(TracksDuration>TimeMin),3,1:TimeMin),1)),'linewidth',3)



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
global Track_label
Track_label= ceil(str2double(get(hObject,'String')));
if isnan(Track_label)
    Track_label = 1;
    set(hObject,'String',Track_Radius);
    errordlg('Input must be a number', 'Error')
end
handles.edit3 = Track_label;
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


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Folder Duration
Duration=handles.edit4;

StartingFromFirst=get(handles.StartFromFrame,'SelectedObject')
Name=get(StartingFromFirst,'String')
if strcmp(Name,'All')
    load(strcat(Folder,'/Tracks_Auto_All.mat'));
    TotalDuration=TracksDuration(:,2)-TracksDuration(:,1);
    sum(TotalDuration>Duration)
    plot(squeeze(nanmean(Tracks(find(TotalDuration>Duration),3,:),1)),'linewidth',3)
    figure;
    plot(squeeze(nanmean(Tracks(find(TotalDuration>Duration),3,:),1)),'linewidth',3)

else
    load(strcat(Folder,'/Tracks_Auto2.mat'));
    TotalDuration=TracksDuration;
    plot(squeeze(nanmean(Tracks(find(TotalDuration>Duration),3,1:Duration),1)),'linewidth',3)
    figure;
    plot(squeeze(nanmean(Tracks(find(TotalDuration>Duration),3,1:Duration),1)),'linewidth',3)
end
sum(TotalDuration>Duration)

% plot(squeeze((Tracks(find(TracksDuration>TimeMin),3,1:TimeMin)))')
% hold on



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
global Duration
Duration= ceil(str2double(get(hObject,'String')));
if isnan(Duration)
    Duration= 50;
    set(hObject,'String',Track_Radius);
    errordlg('Input must be a number', 'Error')
end
handles.edit4 = Duration;
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


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Folder Duration
Duration=handles.edit4;

StartingFromFirst=get(handles.StartFromFrame,'SelectedObject')
Name=get(StartingFromFirst,'String')

if strcmp(Name,'All')
    load(strcat(Folder,'/Tracks_Auto_All.mat'));
    TotalDuration=TracksDuration(:,2)-TracksDuration(:,1);
    sum(TotalDuration>Duration)

    plot(squeeze((Tracks(find(TotalDuration>Duration),3,:)))')
    hold on
    plot(squeeze(nanmean(Tracks(find(TotalDuration>Duration),3,:),1)),'linewidth',3)
    hold off
    figure;
    plot(squeeze((Tracks(find(TotalDuration>Duration),3,:)))')
    hold on
    plot(squeeze(nanmean(Tracks(find(TotalDuration>Duration),3,:),1)),'linewidth',3)
    hold off

else
    load(strcat(Folder,'/Tracks_Auto2.mat'));
    TotalDuration=TracksDuration;
    sum(TotalDuration>Duration)

    plot(squeeze((Tracks(find(TotalDuration>Duration),3,1:Duration)))')
    hold on
    plot(squeeze(nanmean(Tracks(find(TotalDuration>Duration),3,1:Duration),1)),'linewidth',3)
    hold off
    figure;
    plot(squeeze((Tracks(find(TotalDuration>Duration),3,1:Duration)))')
    hold on
    plot(squeeze(nanmean(Tracks(find(TotalDuration>Duration),3,1:Duration),1)),'linewidth',3)
    hold off
end
sum(TotalDuration>Duration)





% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Folder Duration NFrames

% METHOD='HILBERT';
% METHOD='INTRINSIC_PEAKS';
METHOD='PAUL';

NFrames=handles.edit2
Duration=handles.edit4;

StartingFromFirst=get(handles.StartFromFrame,'SelectedObject')
Name=get(StartingFromFirst,'String')
if strcmp(Name,'All')
    StartFromFirst=0;
else
    StartFromFirst=1;
end
if StartFromFirst
    ProcessTracks(Folder,METHOD,Duration)
else
    Process_Tracks_All_Function(Folder,METHOD,Duration,NFrames);
end




function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
global SkippedFrames
SkippedFrames= ceil(str2double(get(hObject,'String')));
if isnan(SkippedFrames)
    SkippedFrames= 0;
    set(hObject,'String',SkippedFrames);
    errordlg('Input must be a number', 'Error')
end
handles.edit5 = SkippedFrames;
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


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Folder Duration
Duration=handles.edit4
StartingFromFirst=get(handles.StartFromFrame,'SelectedObject')
Name=get(StartingFromFirst,'String')
if strcmp(Name,'All')
    StartFromFirst=0;
    load(strcat(Folder,'/Tracks_Auto_All.mat'));
    TotalDuration=TracksDuration(:,2)-TracksDuration(:,1);
    Tracks2=squeeze((Tracks(find(TotalDuration>Duration),:,:)));
    TracksDuration2=TracksDuration(find(TotalDuration>Duration),:);
else
    StartFromFirst=1;
    load(strcat(Folder,'/Tracks_Auto2.mat'));
    TotalDuration=TracksDuration;
    Tracks2=squeeze((Tracks(find(TotalDuration>Duration),:,1:TracksDuration(find(TotalDuration>Duration)))));
    TracksDuration2=ones(length(find(TotalDuration>Duration)),2);
    TracksDuration2(:,2)=TotalDuration(find(TotalDuration>Duration));
end

sum(TotalDuration>Duration)

Period_fft=[];
Period_xcorr=[];
pks=zeros(1,size(Tracks2,1));
for i=1:size(Tracks2,1)
    y=smooth(squeeze(Tracks2(i,3,TracksDuration2(i,1):TracksDuration2(i,2))));
    Fs = 1;
    
    y=y-mean(y);
    % Calculate fft
    ydft = fft(y);
    % Only take one side of the Fourier transform
    ydft = 2*ydft(1:ceil((length(y)+1)/2));
    % Calculate the frequencies
    freq = 0:Fs/length(y):Fs/2;
    

    [a,b]=findpeaks(abs(ydft));
    F=min(b(b>3));
    Period_fft(i)=(1/freq(F));
    
    [a b]=xcorr(y);
    [~,locs]=findpeaks(a);
    Period_xcorr(i)=mean(diff(locs));
    
%     figure;
%     findpeaks(smooth(squeeze(Tracks2(i,3,TracksDuration2(i,1):TracksDuration2(i,2)))),'MinPeakProminence',5,'MinPeakDistance',5);
    pks(i)=length(findpeaks(smooth(squeeze(Tracks2(i,3,TracksDuration2(i,1):TracksDuration2(i,2)))),'MinPeakProminence',5,'MinPeakDistance',5));
    
   
end
Period_fft
Period_xcorr
dlmwrite(strcat(Folder,'/Period_FFT.txt'),Period_fft)
dlmwrite(strcat(Folder,'/Period_XCORR.txt'),Period_xcorr)
% figure;
% hist(Period_fft,linspace(0,120,20))
% 
% figure;
% hist(Period_xcorr,linspace(0,120,20))

save(strcat(Folder,'/Period_EachTrack.mat'),'Period_fft','Period_xcorr')
save(strcat(Folder,'/NumberOfPeaks.mat'),'pks')
dlmwrite(strcat(Folder,'/NumberOfPeaks.txt'),pks);



% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
