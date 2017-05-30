function varargout = Cam(varargin)
% CAM MATLAB code for Cam.fig
%      CAM, by itself, creates a new CAM or raises the existing
%      singleton*.
%
%      H = CAM returns the handle to a new CAM or the handle to
%      the existing singleton*.
%
%      CAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAM.M with the given input arguments.
%
%      CAM('Property','Value',...) creates a new CAM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Cam_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Cam_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Cam

% Last Modified by GUIDE v2.5 26-Apr-2017 17:03:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Cam_OpeningFcn, ...
                   'gui_OutputFcn',  @Cam_OutputFcn, ...
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


% --- Executes just before Cam is made visible.
function Cam_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Cam (see VARARGIN)

% Choose default command line output for Cam
handles.output = hObject;

% create an axes that spans the whole gui
ah = axes('unit', 'normalized', 'position', [0 0 1 1]);
% import the background image and show it on the axes
bg = imread('sfondo7.jpg'); imagesc(bg);
% prevent plotting over the background and turn the axis off
set(ah,'handlevisibility','off','visible','off')
% making sure the background is behind all the other uicontrols
uistack(ah, 'bottom');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Cam wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Cam_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in configure.
function configure_Callback(hObject, eventdata, handles)
% hObject    handle to configure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IA DeviceID Format
IAHI=imaqhwinfo;
IA=(IAHI.InstalledAdaptors);
D=menu('Select Video Input Device:',IA);
if isempty(IA)||D==0
   msgbox({'You dont have any VideoInput Installed Adaptors!',...
           'OR',...
           'Please! try again and select Adaptor properly.'})
    return
end
IA=char(IA);
IA=IA(D,:);
IA(IA==' ')=[];
x=imaqhwinfo(IA);
try
DeviceID=menu('Select Device ID',x.DeviceIDs);
F=x.DeviceInfo(DeviceID).SupportedFormats;
nF=menu('Select the image save format.',F);
Format=F{nF};
catch e
   warndlg({'Try Another Device or ID ';...
            'You Donot Have Installed This Device(VideoInputDevice)'})
    return
end


% --- Executes on button press in preview.
function preview_Callback(hObject, eventdata, handles)
% hObject    handle to preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global IA DeviceID Format  CAM
try
VidObj= videoinput(IA, DeviceID, Format);
handles.VidObj=VidObj;CAM=1;
vidRes = get(handles.VidObj, 'VideoResolution');
nBands = get(handles.VidObj, 'NumberOfBands');
set(handles.Assi,'Visible','off')
axes(handles.Assi)
hImage = image( zeros(vidRes(1), vidRes(2), nBands) );
preview(handles.VidObj, hImage)
catch E
    msgbox({'Configure The Cam Correctly!',' ',E.message},'CAM INFO')
end
guidata(hObject, handles);


% --- Executes on button press in capture.
function capture_Callback(hObject, eventdata, handles)
% hObject    handle to capture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global S CAM Format;
if(CAM==1)
    CAM=0;
    S=getsnapshot(handles.VidObj);
    sub = Format(1:4);
    if ((strcmp(sub, 'YUY2')) | (strcmp(sub, 'I420')))
        S = ycbcr2rgb(S);
    end
    closepreview
%     clear VidObj
%     delete  VidObj
     imshow(S,'parent',handles.Assi);
else
   msgbox('Please! Start Cam First by Configure'); 
end


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CAM
[F,~,NotGet]=imputfile;
S=getimage(handles.Assi);
if(~NotGet&&~isempty(S)&& ~CAM)
    imwrite(S,F)
    msgbox(strcat('Image is saved at :',F))
else 
    msgbox('Image is not saved: First CAPTURE IT')
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Cam_Help;
