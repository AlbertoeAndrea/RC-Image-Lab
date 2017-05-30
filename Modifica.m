function varargout = Modifica(varargin)
% MODIFICA MATLAB code for Modifica.fig
%      MODIFICA, by itself, creates a new MODIFICA or raises the existing
%      singleton*.
%
%      H = MODIFICA returns the handle to a new MODIFICA or the handle to
%      the existing singleton*.
%
%      MODIFICA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODIFICA.M with the given input arguments.
%
%      MODIFICA('Property','Value',...) creates a new MODIFICA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Modifica_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Modifica_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Modifica

% Last Modified by GUIDE v2.5 19-Apr-2017 10:04:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Modifica_OpeningFcn, ...
                   'gui_OutputFcn',  @Modifica_OutputFcn, ...
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


% --- Executes just before Modifica is made visible.
function Modifica_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Modifica (see VARARGIN)

% Choose default command line output for Modifica
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

% set(handles.Bottone_Flip,'CData',flip(1:ceil(128/30):end,1:ceil(128/30):end,:));
% set(handles.Bottone_Rotate,'CData',rotate(1:ceil(128/30):end,1:ceil(128/30):end,:));
%set(handles.figure1,'CloseRequestFcn',@close_Callback);
% UIWAIT makes Modifica wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Modifica_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Bottone_Apri.
function Bottone_Apri_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Apri (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im im2 lastRot path
[path,user_cance]=imgetfile();
if user_cance
    msgbox(sprintf('Error'),'Error','Error');
    return
end
im=imread(path);
%im=im2double(im); %converts to double
im2=im; %for backup process :)
lastRot = im;
axes(handles.Assi);
imshow(im);
set(handles.Bottone_Negativo, 'enable', 'on');
set(handles.Bottone_Grigi, 'enable', 'on');
set(handles.Bottone_Reset, 'enable', 'on');
set(handles.Slider_Luminosita, 'enable', 'on');
set(handles.Bottone_Rosso, 'enable', 'on');
set(handles.Bottone_Verde, 'enable', 'on');
set(handles.Bottone_Blu, 'enable', 'on');
set(handles.Bottone_Edge, 'enable', 'on');
set(handles.Bottone_Laplacian, 'enable', 'on');
set(handles.Bottone_Unsharp, 'enable', 'on');
set(handles.Assi, 'visible', 'on');
set(handles.Bottone_Apri, 'enable', 'off');
set(handles.Bottone_Flip, 'enable', 'on');
set(handles.Bottone_Rotate, 'enable', 'on');
set(handles.Bottone_Comic, 'enable', 'on');
set(handles.Bottone_Water, 'enable', 'on');
set(handles.Bottone_Canny, 'enable', 'on');
set(handles.Bottone_Artistic, 'enable', 'on');
set(handles.Bottone_Auto, 'enable', 'on');
set(handles.listMaps, 'enable', 'on');
set(gca,'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1]);

% --- Executes on button press in Bottone_Salva.
function Bottone_Salva_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Salva (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global last
% F = getframe(handles.Assi);
% Image = frame2im(F);
% apro la classica finestra di windows (salva file)per ottenere la stringa
%(file=nomefile.txt e path=percorso completo)
[file,path] = uiputfile({'*.jpg';'*.png';'*.bmp';'*.tiff';'*.*'},'Save file name');
%se la finestra viene chiusa si blocca la funzione
if file==0
    return
end
%ottengo il percorso completo più nome con la funzione joinseq
pathfile=joinseq(path,file);
%scrivo il vettore colonna (Vdati) nel file.txt delimitato con (dlmwrite)
imwrite(last, pathfile, 'jpg');
msgbox(strcat('Image is saved at :', pathfile))


% --- Executes on button press in Bottone_Reset.
function Bottone_Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im lastRot
axes(handles.Assi); cla;
axes(handles.AssiRis); cla;
set(handles.Assi, 'visible', 'off');
set(handles.AssiRis, 'visible', 'off');
set(handles.Bottone_Apri, 'enable', 'on');
set(handles.Bottone_Salva, 'enable', 'off');
set(handles.Bottone_Negativo, 'enable', 'off');
set(handles.Bottone_Grigi, 'enable', 'off');
set(handles.Bottone_Reset, 'enable', 'off');
set(handles.Slider_Luminosita, 'enable', 'off');
set(handles.Bottone_Rosso, 'enable', 'off');
set(handles.Bottone_Verde, 'enable', 'off');
set(handles.Bottone_Blu, 'enable', 'off');
set(handles.Bottone_Edge, 'enable', 'off');
set(handles.Bottone_Laplacian, 'enable', 'off');
set(handles.Bottone_Unsharp, 'enable', 'off');
set(handles.Bottone_Flip, 'enable', 'off');
set(handles.Bottone_Rotate, 'enable', 'off');
set(handles.Bottone_Comic, 'enable', 'off');
set(handles.Bottone_Water, 'enable', 'off');
set(handles.Bottone_Canny, 'enable', 'off');
set(handles.Bottone_Artistic, 'enable', 'off');
set(handles.Bottone_Auto, 'enable', 'off');
set(handles.listMaps, 'enable', 'off');
lastRot = im;


% --- Executes on button press in Bottone_Grigi.
function Bottone_Grigi_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Grigi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im last lastRot
set(handles.Bottone_Salva, 'enable', 'on');
lastRot = im;
image = im;
image = im2double(image);
imgray=(image(:,:,1)+image(:,:,2)+image(:,:,2))/3;
last = imgray;
axes(handles.AssiRis);
imshow(imgray);


% --- Executes on slider movement.
function Slider_Luminosita_Callback(hObject, eventdata, handles)
% hObject    handle to Slider_Luminosita (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global im last lastRot
set(handles.Bottone_Salva, 'enable', 'on');
lastRot = im;
image = im;
image = im2double(image);
val=0.5*get(hObject,'Value')-0.5;
imbright=image+val;
last = imbright;
axes(handles.AssiRis);
imshow(imbright);


% --- Executes during object creation, after setting all properties.
function Slider_Luminosita_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Slider_Luminosita (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in Bottone_Negativo.
function Bottone_Negativo_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Negativo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im last lastRot
set(handles.Bottone_Salva, 'enable', 'on');
lastRot = im;
image = im;
image = im2double(image);
imblack=image;
imblack=1-image;
last = imblack;
axes(handles.AssiRis);
imshow(imblack);


% --- Executes on button press in Bottone_Rosso.
function Bottone_Rosso_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Rosso (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im last lastRot
set(handles.Bottone_Salva, 'enable', 'on');
lastRot = im;
red = im(:,:,1); % Red channel
last = red;
axes(handles.AssiRis);
imshow(red);


% --- Executes on button press in Bottone_Verde.
function Bottone_Verde_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Verde (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im last lastRot
set(handles.Bottone_Salva, 'enable', 'on');
lastRot = im;
green = im(:,:,2); % Green channel
last = green;
axes(handles.AssiRis);
imshow(green);


% --- Executes on button press in Bottone_Blu.
function Bottone_Blu_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Blu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im last lastRot
set(handles.Bottone_Salva, 'enable', 'on');
lastRot = im;
blue = im(:,:,3); % Blue channel
last = blue;
axes(handles.AssiRis);
imshow(blue);


% --- Executes on button press in Bottone_Edge.
function Bottone_Edge_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im last lastRot
set(handles.Bottone_Salva, 'enable', 'on');
lastRot = im;
out = edge(rgb2gray(im),'sobel');
last = out;
axes(handles.AssiRis);
imshow(out);


% --- Executes on button press in Bottone_Laplacian.
function Bottone_Laplacian_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Laplacian (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im last lastRot
set(handles.Bottone_Salva, 'enable', 'on');
lastRot = im;
f = fspecial('laplacian');
out = imfilter(im, f);
last = out;
axes(handles.AssiRis);
imshow(out);


% --- Executes on button press in Bottone_Unsharp.
function Bottone_Unsharp_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Unsharp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im last lastRot
set(handles.Bottone_Salva, 'enable', 'on');
lastRot = im;
f = fspecial('unsharp');
out = imfilter(im, f);
last = out;
axes(handles.AssiRis);
imshow(out);


% --- Executes on button press in Bottone_Restauro.
function Bottone_Restauro_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Restauro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
conf=questdlg('Are you sure you want to switch to Restoration?','Exit Image','Yes','No','No');
switch conf
    case 'Yes'
        close(gcf);
        Restauro;
    case 'No'
        return
end


% --- Executes on button press in Bottone_Compressione.
function Bottone_Compressione_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Compressione (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
conf=questdlg('Are you sure you want to switch to Compression?','Exit Image','Yes','No','No');
switch conf
    case 'Yes'
        close(gcf);
        Compressione;
    case 'No'
        return
end

function close_Callback(hObject, eventdata, handles)
selection = questdlg('Do you want to close UnisaGraphics?',...
                     'Close Request Function',...
                     'Yes','No','No');
switch selection,
   case 'Yes',
    delete(gcf);
   case 'No'
     return
end


% --- Executes on button press in Bottone_Rotate.
function Bottone_Rotate_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Rotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global lastRot
set(handles.Bottone_Salva, 'enable', 'on');
I = lastRot;
Ir90 = rot90(I(:,:,1));
Ig90 = rot90(I(:,:,2));
Ib90 = rot90(I(:,:,3));

I = Ir90;
I(:,:,2) = Ig90;
I(:,:,3) = Ib90;

lastRot = I;
axes(handles.AssiRis);
cla(handles.AssiRis);
image(I);
set(gca,'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1]);


% --- Executes on button press in Bottone_Flip.
function Bottone_Flip_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Flip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I im lastRot;
set(handles.Bottone_Salva, 'enable', 'on');
lastRot = im;
I = im;
Irflip = fliplr(I(:,:,1));
Igflip = fliplr(I(:,:,2));
Ibflip = fliplr(I(:,:,3));

I = Irflip;
I(:,:,2) = Igflip;
I(:,:,3) = Ibflip;

axes(handles.AssiRis);
cla(handles.AssiRis);
image(I);
set(gca,'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1]);


% --- Executes on selection change in listMaps.
function listMaps_Callback(hObject, eventdata, handles)
% hObject    handle to listMaps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listMaps contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listMaps
global im2 lastRot last M
lastRot = im2;
M = im2;
set(handles.Bottone_Salva, 'enable', 'on');
if get(handles.listMaps,'Value') ~= 1
    Y = 0.299*M(:,:,1) + 0.587*M(:,:,2) + 0.114*M(:,:,3);
    Y = cat(3,Y,Y,Y);
    x = linspace(0,255,64);
    maps = cellstr(get(handles.listMaps,'String'));
    map = eval(lower(maps{get(handles.listMaps,'Value')}));
    
    map = imresize(map, [64 3]);
    
    Yr = interp1(x,map(:,1),double(Y(:,:,1)));
    Yg = interp1(x,map(:,2),double(Y(:,:,2)));
    Yb = interp1(x,map(:,3),double(Y(:,:,3)));

    M = Yr;
    M(:,:,2) = Yg;
    M(:,:,3) = Yb;
    
    M = uint8(M.*255);
end

last = M;
axes(handles.AssiRis);
imshow(M);
set(gca,'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1]);



% --- Executes during object creation, after setting all properties.
function listMaps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listMaps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Bottone_Cam.
function Bottone_Cam_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Cam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Cam;


% --- Executes on button press in Bottone_Comic.
function Bottone_Comic_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Comic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im last lastRot M
set(handles.Bottone_Salva, 'enable', 'on');
lastRot = im;
M = im;
% Change contrast +60
Mr = M(:,:,1);
Mg = M(:,:,2);
Mb = M(:,:,3);

x = [0 94 98 255];
y = [0 34 158 255];

M(:,:,1) = floor(interp1(x, y, double(Mr), 'spline')); % MCr
M(:,:,2) = floor(interp1(x, y, double(Mg), 'spline')); % MCg
M(:,:,3) = floor(interp1(x, y, double(Mb), 'spline')); % MCb

% Change exposure +30
M = M + 30;

last = M;
% Display image
axes(handles.AssiRis);
imshow(M);
set(gca,'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1]);


% --- Executes on button press in Bottone_Water.
function Bottone_Water_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Water (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im last lastRot
set(handles.Bottone_Salva, 'enable', 'on');
lastRot = im;
level = graythresh(im);
image = im2bw(im, level);
last = image;
axes(handles.AssiRis);
imshow(image);


% --- Executes on button press in Bottone_Canny.
function Bottone_Canny_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Canny (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im last lastRot
set(handles.Bottone_Salva, 'enable', 'on');
lastRot = im;
image = rgb2gray(im);
image = im2double(image);
image = edge(image, 'canny');
last = image;
axes(handles.AssiRis);
imshow(image);


% --- Executes on button press in Bottone_Artistic.
function Bottone_Artistic_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Artistic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im last lastRot
set(handles.Bottone_Salva, 'enable', 'on');
lastRot = im;
image = imfilter_artistic(im);
last = image;
axes(handles.AssiRis);
imshow(image);


% --- Executes on button press in Bottone_Auto.
function Bottone_Auto_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Auto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im last lastRot M
set(handles.Bottone_Salva, 'enable', 'on');
lastRot = im;
M = im;
% Change contrast +15
Mr = M(:,:,1);
Mg = M(:,:,2);
Mb = M(:,:,3);

x = [0 71.5 120.5 255];
y = [0 56.5 135.5 255];

M(:,:,1) = floor(interp1(x, y, double(Mr), 'spline')); % MCr
M(:,:,2) = floor(interp1(x, y, double(Mg), 'spline')); % MCg
M(:,:,3) = floor(interp1(x, y, double(Mb), 'spline')); % MCb

% Change exposure +25
M = M + 25;
last = im;
% Display image
axes(handles.AssiRis);
imshow(M);
set(gca,'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1]);


% --- Executes on button press in pushbutton45.
function pushbutton45_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Modifica_Help;
