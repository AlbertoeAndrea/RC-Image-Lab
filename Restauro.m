function varargout = Restauro(varargin)
% RESTAURO MATLAB code for Restauro.fig
%      RESTAURO, by itself, creates a new RESTAURO or raises the existing
%      singleton*.
%
%      H = RESTAURO returns the handle to a new RESTAURO or the handle to
%      the existing singleton*.
%
%      RESTAURO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESTAURO.M with the given input arguments.
%
%      RESTAURO('Property','Value',...) creates a new RESTAURO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Restauro_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Restauro_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Restauro

% Last Modified by GUIDE v2.5 21-Apr-2017 14:28:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Restauro_OpeningFcn, ...
                   'gui_OutputFcn',  @Restauro_OutputFcn, ...
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


% --- Executes just before Restauro is made visible.
function Restauro_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Restauro (see VARARGIN)

% Choose default command line output for Restauro
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

%set(handles.figure1,'CloseRequestFcn',@close_Callback);
% UIWAIT makes Restauro wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Restauro_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function Indice_Filtro_Callback(hObject, eventdata, handles)
% hObject    handle to Indice_Filtro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Indice_Filtro as text
%        str2double(get(hObject,'String')) returns contents of Indice_Filtro as a double
global filtro
switch get(handles.Indice_Filtro,'Value')
      case 1
      filtro = 2;
      case 2
      filtro = 3;
      case 3
      filtro = 4;
      case 4
      filtro = 5;
      case 5
      filtro = 6;
      case 6
      filtro = 7;
    otherwise
end


% --- Executes during object creation, after setting all properties.
function Indice_Filtro_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Indice_Filtro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Bottone_Butterworth.
function Bottone_Butterworth_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Butterworth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global red green blue im last
set(handles.Bottone_Salva, 'enable', 'on');
% Applico la Fast Fourier Transform alle tre componenti
% dell'immagine 
fourierRed = fft2(red);
fourierGreen = fft2(green);
fourierBlue = fft2(blue);
% Salvo le dimensioni dell'immagine
[M, N] = size(red);
ordine = 10;
raggio = 70;
u = 0:(M-1);
v = 0:(N-1);
idx = find(u > M/2);
u(idx) = u(idx)-M;
idy = find(v > N/2);
v(idy) = v(idy)-N;
[V, U] = meshgrid(v, u);
D = sqrt(U.^2+V.^2);
% Applico il filtro di Butterworth alle tre componenti
buttFilter = 1./(1+(D./raggio).^(2.*ordine));
buttFilterRed = fourierRed.*buttFilter;
buttFilterGreen = fourierGreen.*buttFilter;
buttFilterBlue = fourierBlue.*buttFilter;
% Calcolo dell'Inverse Fast Fourier Transform
antRed = real(ifft2(buttFilterRed));
antGreen = real(ifft2(buttFilterGreen));
antBlue = real(ifft2(buttFilterBlue));
anttrasf = cat(3, antRed, antGreen, antBlue);
set(handles.Ris_MSE, 'String', immse(im, anttrasf));
set(handles.Ris_SNR, 'String', snr(anttrasf, im-anttrasf));
last = anttrasf;
axes(handles.Assi2);
imshow(anttrasf);


% --- Executes on button press in Bottone_Alpha.
function Bottone_Alpha_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im red green blue last
set(handles.Bottone_Salva, 'enable', 'on');
masksize=2;
d=4;
[ro col]=size(red);
tempRed=[];
tempGreen=[];
tempBlue=[];
graber=0;
akkumulatorRed=[];
akkumulatorGreen=[];
akkumulatorBlue=[];
% data l'elevata complessita' dell'algoritmo, viene istanziata
% una waitbar per accompagnare l'utente nell'attesa
% dell'applicazione del filtro all'immagine
w = waitbar(0, 'Alpha-trimmed filtering ... Please wait ...');
for i=1:ro;
    waitbar(i/ro, w);
    for j=1:col;
        for m=-masksize:masksize;
            for n=-masksize:masksize;
                if (i+m>0 && i+m<ro && j+n>0 && j+n<col && ...
                        masksize+m>0 && masksize+m<ro && ...
                        masksize+n>0 && masksize+n<col) 
                    
                    tempRed=[tempRed red(i+m,j+n)];
                    tempGreen=[tempGreen green(i+m,j+n)];
                    tempBlue=[tempBlue blue(i+m,j+n)];
                end
            end
        end  
        tempRed=sort(tempRed);
        tempGreen=sort(tempGreen);
        tempBlue=sort(tempBlue);
        lenth=length(tempRed);
        for k=((d/2)-1):(lenth-(d/2))
            akkumulatorRed=[akkumulatorRed tempRed(k)];
            akkumulatorGreen=[akkumulatorGreen tempGreen(k)];
            akkumulatorBlue=[akkumulatorBlue tempBlue(k)];
        end
        akkumulatorRed=sum(akkumulatorRed);
        akkumulatorGreen=sum(akkumulatorGreen);
        akkumulatorBlue=sum(akkumulatorBlue);
        refimageRed(i,j)=(akkumulatorRed) / (25-d);
        refimageGreen(i,j)=(akkumulatorGreen) / (25-d);
        refimageBlue(i,j)=(akkumulatorBlue) / (25-d);
        akkumulatorRed=[];
        tempRed=[];
        akkumulatorGreen=[];
        tempGreen=[];
        akkumulatorBlue=[];
        tempBlue=[];
    end
end
close(w);
refimage = cat(3, refimageRed, refimageGreen, refimageBlue);
set(handles.Ris_MSE, 'String', immse(im, refimage));
set(handles.Ris_SNR, 'String', snr(refimage, im-refimage));
last = refimage;
axes(handles.Assi2);
imshow(refimage);


% --- Executes on button press in Bottone_Average.
function Bottone_Average_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im filtro red green blue last
set(handles.Bottone_Salva, 'enable', 'on');
w = fspecial('average', [filtro, filtro]);
aritRed = imfilter(red, w);
aritGreen = imfilter(green, w);
aritBlue = imfilter(blue, w);
arit = cat(3, aritRed, aritGreen, aritBlue);
set(handles.Ris_MSE, 'String', immse(im, arit));
set(handles.Ris_SNR, 'String', snr(arit, im-arit));
last = arit;
axes(handles.Assi2);
imshow(arit);


% --- Executes on button press in Bottone_Contra.
function Bottone_Contra_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Contra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im filtro red green blue last
set(handles.Bottone_Salva, 'enable', 'on');
controRed=charmean(red,filtro,filtro,1);
controGreen=charmean(green,filtro,filtro,1);
controBlue=charmean(blue,filtro,filtro,1);
contro = cat(3, controRed, controGreen, controBlue);
last = contro;
axes(handles.Assi2);
imshow(contro);
set(handles.Ris_MSE, 'String', immse(im, contro));
set(handles.Ris_SNR, 'String', snr(contro, im-contro));


% --- Executes on button press in Bottone_Median.
function Bottone_Median_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Median (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im filtro red green blue last
set(handles.Bottone_Salva, 'enable', 'on');
medianoRed = medfilt2(red, [filtro,filtro]);
medianoGreen = medfilt2(green, [filtro,filtro]);
medianoBlue = medfilt2(blue, [filtro,filtro]);
mediano = cat(3, medianoRed, medianoGreen, medianoBlue);
last = mediano;
axes(handles.Assi2);
imshow(mediano);
set(handles.Ris_MSE, 'String', immse(im, mediano));
set(handles.Ris_SNR, 'String', snr(mediano, im-mediano));


% --- Executes on button press in Bottone_Max.
function Bottone_Max_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im filtro red green blue last
set(handles.Bottone_Salva, 'enable', 'on');
maxRed = ordfilt2(red, filtro^2, ones(filtro, filtro));
maxGreen = ordfilt2(green, filtro^2, ones(filtro, filtro));
maxBlue = ordfilt2(blue, filtro^2, ones(filtro, filtro));
max = cat(3, maxRed, maxGreen, maxBlue);
last = max;
axes(handles.Assi2);
imshow(max);
set(handles.Ris_MSE, 'String', immse(im, max));
set(handles.Ris_SNR, 'String', snr(max, im-max));


% --- Executes on button press in Bottone_Min.
function Bottone_Min_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im filtro red green blue last
set(handles.Bottone_Salva, 'enable', 'on');
minRed = ordfilt2(red, 1, ones(filtro, filtro));
minGreen = ordfilt2(green, 1, ones(filtro, filtro));
minBlue = ordfilt2(blue, 1, ones(filtro, filtro));
min = cat(3, minRed, minGreen, minBlue);
last = min;
axes(handles.Assi2);
imshow(min);
set(handles.Ris_MSE, 'String', immse(im, min));
set(handles.Ris_SNR, 'String', snr(min, im-min));


% --- Executes on button press in Bottone_Midpoint.
function Bottone_Midpoint_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Midpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im filtro red green blue last
set(handles.Bottone_Salva, 'enable', 'on');
midRed = ordfilt2(red,5,ones(filtro+1, filtro+1));
midGreen = ordfilt2(green,5,ones(filtro+1, filtro+1));
midBlue = ordfilt2(blue,5,ones(filtro+1, filtro+1));
mid = cat(3, midRed, midGreen, midBlue);
last = mid;
axes(handles.Assi2);
imshow(mid);
set(handles.Ris_MSE, 'String', immse(im, mid));
set(handles.Ris_SNR, 'String', snr(mid, im-mid));


% --- Executes on button press in Bottone_Wiener.
function Bottone_Wiener_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Wiener (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im filtro red green blue last
set(handles.Bottone_Salva, 'enable', 'on');
wienerRed=wiener2(red,[filtro+2 filtro+2]);
wienerGreen=wiener2(green,[filtro+2 filtro+2]);
wienerBlue=wiener2(blue,[filtro+2 filtro+2]);
wiener = cat(3, wienerRed, wienerGreen, wienerBlue);
last = wiener;
axes(handles.Assi2);
imshow(wiener);
set(handles.Ris_MSE, 'String', immse(im, wiener));
set(handles.Ris_SNR, 'String', snr(wiener, im-wiener));


% --- Executes on button press in Bottone_Apri.
function Bottone_Apri_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Apri (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im % immagine da restaurare
global filtro % indice di filtraggio che sarà applicato al filtro scelto
global red green blue % componenti RGB dell'immagine
[path,user_cance]=imgetfile();
if user_cance
    msgbox(sprintf('Error'),'Error','Error');
    return
end
im=imread(path);
im=im2double(im); % conversione a double
red=im(:,:,1); % componente red
green=im(:,:,2); % componente green
blue=im(:,:,3); % componente blue
axes(handles.Assi1);
imshow(im); % mostro l'immagine nell'asse a sinistra
% una volta aperta l'immagine, vengono abilitati tutti i bottoni
% inabilitati
set(handles.Bottone_Reset, 'enable', 'on');
set(handles.Bottone_Average, 'enable', 'on');
set(handles.Bottone_Contra, 'enable', 'on');
set(handles.Bottone_Median, 'enable', 'on');
set(handles.Bottone_Max, 'enable', 'on');
set(handles.Bottone_Min, 'enable', 'on');
set(handles.Bottone_Midpoint, 'enable', 'on');
set(handles.Bottone_Wiener, 'enable', 'on');
set(handles.Bottone_Alpha, 'enable', 'on');
set(handles.Bottone_Butterworth, 'enable', 'on');
set(handles.Assi1, 'visible', 'on');
set(handles.Indice_Filtro, 'enable', 'on');
% indice di default = 2
set(handles.Indice_Filtro, 'value', 1);
filtro = 2;
set(handles.Bottone_Apri, 'enable', 'off');
set(gca,'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1]);

% --- Executes on button press in Bottone_Salva.
function Bottone_Salva_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Salva (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global last % salvataggio dell'ultima immagine restaurata
% classica finestra di windows (salva file) per ottenere la stringa
% (file = nomefile.txt e path = percorso completo)
[file,path] = uiputfile({'*.jpg';'*.png';'*.bmp';'*.tiff';'*.*'},'Save file name');
% se la finestra viene chiusa si blocca la funzione
if file==0
    return
end
% ottenimento del percorso completo + nome con la funzione joinseq
pathfile=joinseq(path,file);
% salvataggio dell'immagine restaurata nel percorso scelto
imwrite(last, pathfile, 'jpg');
msgbox(strcat('Image is saved at :', pathfile))


% --- Executes on button press in Bottone_Reset.
function Bottone_Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% reset dell'interfaccia di Restauro
axes(handles.Assi1); cla;
axes(handles.Assi2); cla;
set(handles.Assi1, 'visible', 'off');
set(handles.Assi2, 'visible', 'off');
set(handles.Bottone_Salva, 'enable', 'off');
set(handles.Bottone_Reset, 'enable', 'off');
set(handles.Bottone_Average, 'enable', 'off');
set(handles.Bottone_Contra, 'enable', 'off');
set(handles.Bottone_Median, 'enable', 'off');
set(handles.Bottone_Max, 'enable', 'off');
set(handles.Bottone_Min, 'enable', 'off');
set(handles.Bottone_Midpoint, 'enable', 'off');
set(handles.Bottone_Wiener, 'enable', 'off');
set(handles.Bottone_Alpha, 'enable', 'off');
set(handles.Bottone_Butterworth, 'enable', 'off');
set(handles.Indice_Filtro, 'enable', 'off');
set(handles.Bottone_Apri, 'enable', 'on');
set(handles.Ris_MSE, 'String', '');
set(handles.Ris_SNR, 'String', '');


% --- Executes on button press in Bottone_Modifica.
function Bottone_Modifica_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Modifica (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
conf=questdlg('Are you sure you want to switch to Modification?','Exit Image','Yes','No','No');
switch conf
    case 'Yes'
        close(gcf);
        Modifica;
    case 'No'
        return
end


% --- Executes on button press in Bottone_Compressione.
function Bottone_Compressione_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Compressione (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
conf=questdlg('Are you sure you want to switch to Compressione?','Exit Image','Yes','No','No');
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


% --- Executes on button press in pushbutton37.
function pushbutton37_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Restauro_Help;
