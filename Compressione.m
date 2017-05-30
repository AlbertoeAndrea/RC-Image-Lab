function varargout = Compressione(varargin)
% COMPRESSIONE MATLAB code for Compressione.fig
%      COMPRESSIONE, by itself, creates a new COMPRESSIONE or raises the existing
%      singleton*.
%
%      H = COMPRESSIONE returns the handle to a new COMPRESSIONE or the handle to
%      the existing singleton*.
%
%      COMPRESSIONE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMPRESSIONE.M with the given input arguments.
%
%      COMPRESSIONE('Property','Value',...) creates a new COMPRESSIONE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Compressione_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Compressione_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Compressione

% Last Modified by GUIDE v2.5 20-Apr-2017 15:27:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Compressione_OpeningFcn, ...
                   'gui_OutputFcn',  @Compressione_OutputFcn, ...
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


% --- Executes just before Compressione is made visible.
function Compressione_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Compressione (see VARARGIN)

% Choose default command line output for Compressione
handles.output = hObject;

global screen;
screen=get(0,'ScreenSize');

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
% UIWAIT makes Compressione wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global livello
set(handles.Radio_128, 'value', 1);
livello = 127;


% --- Outputs from this function are returned to the command line.
function varargout = Compressione_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Bottone_DCT.
function Bottone_DCT_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_DCT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fattore im2 dimensione last path
set(handles.Bottone_Histogram, 'enable', 'on');
set(handles.Bottone_Salva, 'enable', 'on');
%Effettuo il cast da stringa a intero in fattore
%e verifico se e' compreso tra 1 e 8 
fattore = cast(str2num(get(handles.Fattore, 'string')), 'double');
if ((fattore<9) && (fattore>0))==false
    h = msgbox('Invalid Value. Insert value between 1 and 8 ','Error','error');
else
    %Avvio WaitBar
    w = waitbar(0, 'DCT Compression ... Please wait ...');
    %Salvo le dimension e i canali dell'immagine
    [riga, colonna, canali] = size(im2);
    a=imresize(im2,[riga,colonna]);
    %Applico la DCT alle tre componenti di colore
    Z(:,:,1)=dct2(a(:,:,1));
    Z(:,:,2)=dct2(a(:,:,2));
    Z(:,:,3)=dct2(a(:,:,3));
    for i=1:riga
        waitbar(i/riga, w);
        for j=1:colonna
            if((i+j)>((riga+colonna)*(1-(fattore+1)/10)))
                Z(i,j,1)=0;
                Z(i,j,2)=0;
                Z(i,j,3)=0;
            end
        end
    end
    %Applico l'antitrasformata alle tre componenti di colore
    K(:,:,1)=idct2(Z(:,:,1));
    K(:,:,2)=idct2(Z(:,:,2));
    K(:,:,3)=idct2(Z(:,:,3));
    last = K;
    %Setto gli assi
    axes(handles.Assi2);
    % mostro l'immagine compressa a colori
    imshow(K);
    %Calcolo e visualizzo le metriche di qualita'
    set(handles.Ris_MSE, 'String', immse(im2, K));
    set(handles.Ris_SNR, 'String', snr(K, im2-K));
    set(handles.Ris_PSNR, 'String', psnr(K, im2-K));
    %Chiudo la WaitBar
    close(w);
    salva = fullfile(path, 'tmp.jpg');
    %Salvataggio immagine compressa
    imwrite(last, salva, 'jpg');
    info = imfinfo(salva);
    %Dimensioni in byte dell'immagine modificata
    dimensionemod = round((info.FileSize)/1024,2);
    set(handles.Dimensione2, 'String', strcat(int2str(dimensionemod), ' KB'));
    %Calcolo il Compression Ratio ossia
    %il rapporto tra l'immagine originale e quella modificata
    cr=dimensione/dimensionemod;
    %Mostro nell'apposito campo il Compression Ratio
    set(handles.Ris_CR, 'String', cr);
    delete (salva);
end


% --- Executes on button press in Bottone_JPEG.
function Bottone_JPEG_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_JPEG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fattore im2 dimensione last path
set(handles.Bottone_Histogram, 'enable', 'on');
set(handles.Bottone_Salva, 'enable', 'on');
%Effettuo il cast da stringa a intero in fattore
%e verifico se e' compreso tra 1 e 8 
fattore = cast(str2num(get(handles.Fattore, 'string')), 'double');
if ((fattore<9) && (fattore>0))==false
    h = msgbox('Invalid Value. Insert value between 1 and 8 ','Error','error');
else                                                                        
    w = waitbar(0, 'JPEG Compression ... Please wait ...');
    img=im2;
    % matrice di trasformazione 8x8
    T=dctmtx(8);        
    % trasformata coseno
    fun=@(x)(T*x*T');  
    % la maschera è inizializzata a zero
    mask=zeros(8); 
    % antitrasformata
    invdct=@(x)(T'*x*T);                                                        
    imgc=im2double(img);
    originale_c=imgc;
    % faccio la stessa cosa però per ogni componente di colore
    for i=1:3                                                                   
        waitbar(i/3, w);
        B_c(:,:,i)=blkproc(imgc(:,:,i), [8 8], fun);
        mask(1:(9-fattore) , 1:(9-fattore))=1;
        app=B_c(:,:,i);
        B_c_jpg_trasf(:,:,i)=blkproc(app, [8 8], @(x)(mask.*x));
        B_c_jpg(:,:,i)=blkproc(B_c_jpg_trasf(:,:,i), [8 8], invdct);
    end
    last = B_c_jpg;
    axes(handles.Assi2);
    % mostro l'immagine compressa a colori
    imshow(B_c_jpg);
    set(handles.Ris_MSE, 'String', immse(im2, B_c_jpg));
    set(handles.Ris_SNR, 'String', snr(B_c_jpg, im2-B_c_jpg));
    set(handles.Ris_PSNR, 'String', psnr(B_c_jpg, im2-B_c_jpg));
    %Chiudo la WaitBar
    close(w);
    salva = fullfile(path, 'tmp.jpg');
    %Salvataggio immagine compressa
    imwrite(last, salva, 'jpg');
    info = imfinfo(salva);
    %Dimensioni in byte dell'immagine modificata
    dimensionemod = round((info.FileSize)/1024,2);
    set(handles.Dimensione2, 'String', strcat(int2str(dimensionemod), ' KB'));
    %Calcolo il Compression Ratio ossia
    %il rapporto tra l'immagine originale e quella modificata
    cr=dimensione/dimensionemod;
    %Mostro nell'apposito campo il Compression Ratio
    set(handles.Ris_CR, 'String', cr);
    delete (salva);
end


% --- Executes on button press in Bottone_RGB.
function Bottone_RGB_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_RGB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global livello im2 dimensione last path
set(handles.Bottone_Histogram, 'enable', 'on');
set(handles.Bottone_Salva, 'enable', 'on');
%Avvio Waitbar
w = waitbar(0, 'RGB Quantization ... Please wait ...');
%Assegno ad img in uint8 il prodotto tra
%immagine originale e il livello scelto
img=uint8(im2*(livello));
%Assegno ad img in double il rapporto tra
%img e il livello scelto
img=double(img)/(livello);
%Copia per il salvataggio
last = img;
%Setto gli assi
axes(handles.Assi2);
%Mostro l'immagine modificata
imshow(img);
%Calcolo e visualizzo le metriche di qualita'
set(handles.Ris_MSE, 'String', immse(im2, img));
set(handles.Ris_SNR, 'String', snr(img, im2-img));
set(handles.Ris_PSNR, 'String', psnr(img, im2-img));
%Chiudo la Waitbar
close(w);
salva = fullfile(path, 'tmp.jpg');
imwrite(last, salva, 'jpg');
info = imfinfo(salva);
%Dimensioni in byte dell'immagine modificata
dimensionemod = round((info.FileSize)/1024,2);
set(handles.Dimensione2, 'String' , strcat(int2str(dimensionemod), 'KB'));
%Calcolo il Compression Ratio ossia
%il rapporto tra l'immagine originale e quella modificata
cr=dimensione/dimensionemod;
%Mostro nell'apposito campo il Compression Ratio
set(handles.Ris_CR, 'String', cr);
delete (salva);


% --- Executes on button press in Bottone_BN.
function Bottone_BN_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_BN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global livello im2 dimensione last path
set(handles.Bottone_Histogram, 'enable', 'on');
set(handles.Bottone_Salva, 'enable', 'on');
%Avvio Waitbar
w = waitbar(0, 'BN Quantization ... Please wait ...');
%Assegno ad img in uint8 il prodotto tra
%immagine originale e il livello scelto
img=uint8(im2*(livello-1));
%Assegno ad img in double il rapporto tra
%img e il livello scelto
img=double(img)/(livello-1);
%Converto img in scala di grigi
img=rgb2gray(img);
%Mostro l'immagine modificata
last = img;
%Setto gli assi
axes(handles.Assi2);
%Mostro l'immagine modificata
imshow(img);
%Calcolo e visualizzo le metriche di qualita'
set(handles.Ris_MSE, 'String', immse(rgb2gray(im2), img));
set(handles.Ris_SNR, 'String', snr(img, rgb2gray(im2)-img));
set(handles.Ris_PSNR, 'String', psnr(img, rgb2gray(im2)-img));
%Chiudo la Waitbar
close(w);
salva = fullfile(path, 'tmp.jpg');
imwrite(last, salva, 'jpg');
info = imfinfo(salva);
%Dimensioni in byte dell'immagine modificata
dimensionemod = round((info.FileSize)/1024,2);
set(handles.Dimensione2, 'String', strcat(int2str(dimensionemod), ' KB'));
%Calcolo il Compression Ratio ossia
%il rapporto tra l'immagine originale e quella modificata
cr=dimensione/dimensionemod;
%Mostro nell'apposito campo il Compression Ratio
set(handles.Ris_CR, 'String', cr);
delete (salva);


% --- Executes on button press in Bottone_FFT.
function Bottone_FFT_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_FFT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fattore im2 dimensione last path
set(handles.Bottone_Histogram, 'enable', 'on');
set(handles.Bottone_Salva, 'enable', 'on');
%Effettuo il cast da stringa a intero in fattore
%e verifico se e' compreso tra 1 e 8 
fattore = cast(str2num(get(handles.Fattore, 'string')), 'double');
if ((fattore<9) && (fattore>0))==false
    h = msgbox('Invalid Value. Insert value between 1 and 8 ','Error','error');
else
    %Avvio WaitBar
    w = waitbar(0, 'FFT Compression ... Please wait ...');
    %Dimensioni e canali dell'immagine
    [riga, colonna, canali] = size(im2);
    a=imresize(im2,[riga,colonna]);
    %applico la FFT alle tre componenti
    Z(:,:,1)=fft2(a(:,:,1));
    Z(:,:,2)=fft2(a(:,:,2));
    Z(:,:,3)=fft2(a(:,:,3));
    for i=1:riga
        waitbar(i/riga, w);
        for j=1:colonna
            if((i+j)>((riga+colonna)*(1-(fattore+1)/10)))
                Z(i,j,1)=0;
                Z(i,j,2)=0;
                Z(i,j,3)=0;
            end
        end
    end
    %Applico l'inversa alle tre componenti
    K(:,:,1)=ifft2(Z(:,:,1));
    K(:,:,2)=ifft2(Z(:,:,2));
    K(:,:,3)=ifft2(Z(:,:,3));
    last = K;
    axes(handles.Assi2);
    % mostro l'immagine compressa a colori
    imshow(K);
    %Calcolo e visualizzo le metriche di qualita'
    set(handles.Ris_MSE, 'String', immse(im2, K));
    set(handles.Ris_SNR, 'String', snr(K, im2-K));
    set(handles.Ris_PSNR, 'String', psnr(K, im2-K));
    %Chiudo la WaitBar
    close(w);
    salva = fullfile(path, 'tmp.jpg');
    %Salvataggio immagine compressa
    imwrite(last, salva, 'jpg');
    info = imfinfo(salva);
    %Dimensioni in byte dell'immagine modificata
    dimensionemod = round((info.FileSize)/1024,2);
    set(handles.Dimensione2, 'String', strcat(int2str(dimensionemod), ' KB'));
    %Calcolo il Compression Ratio ossia
    %il rapporto tra l'immagine originale e quella modificata
    cr=dimensione/dimensionemod;
    %Mostro nell'apposito campo il Compression Ratio
    set(handles.Ris_CR, 'String', cr);
    delete (salva);
end


function Fattore_Callback(hObject, eventdata, handles)
% hObject    handle to Fattore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Fattore as text
%        str2double(get(hObject,'String')) returns contents of Fattore as a double


% --- Executes during object creation, after setting all properties.
function Fattore_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fattore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Bottone_Apri.
function Bottone_Apri_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Apri (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im im2 dimensione path
%Vado a selezionare il path e il formato 
%dell'immagine in input
[file, path, user_cance] = uigetfile({'*.jpg';'*.png';'*.bmp';'*.tiff';'*.*'}, 'Open an image');
filepath = fullfile(path, file);
%Se l'immagine non e' stata selezionata 
%Mostro un messaggio d'errore
if (user_cance==0)
    msgbox(sprintf('Error'),'Error','Error');
    return
end
%Leggo l'immagine dal path selezioanto
im=imread(filepath);
%Converto l'immagine in double
im=im2double(im); 
%Copia di backup
im2=im;
%Mostro l'immagine negli assi
axes(handles.Assi1);
imshow(im);
%Attivo tutti i pulsanti dell'interfaccia
set(handles.Bottone_Reset, 'enable', 'on');
set(handles.Bottone_RGB, 'enable', 'on');
set(handles.Bottone_BN, 'enable', 'on');
set(handles.Assi1, 'visible', 'on');
set(handles.Bottone_DCT, 'enable', 'on');
set(handles.Bottone_JPEG, 'enable', 'on');
set(handles.Bottone_FFT, 'enable', 'on');
set(handles.Bottone_Apri, 'enable', 'off');
info = imfinfo(filepath);
%Calcolo la dimensione dell'immagine
dimensione = round((info.FileSize)/1024,2);
set(handles.Dimensione1, 'String', strcat(int2str(dimensione), ' KB'));
set(gca,'XTick',[],'YTick',[],'DataAspectRatio',[1 1 1]);

% --- Executes on button press in Bottone_Salva.
function Bottone_Salva_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Salva (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global last
% apro la classica finestra di windows (salva file)
[file,path] = uiputfile({'*.jpg';'*.png';'*.bmp';'*.tiff';'*.*'},'Save file name');
%se la finestra viene chiusa si blocca la funzione
if file==0
    return
end
%ottengo il percorso completo più nome con la funzione joinseq
pathfile=joinseq(path,file);
%scrivo il vettore colonna (Vdati) nel file.txt delimitato con (dlmwrite)
imwrite(last, pathfile, 'jpg');
%Mostro a video il messaggio di avvenuto salvataggio 
%e il relativo path di salvataggio
msgbox(strcat('Image is saved at :', pathfile))

% --- Executes on button press in Bottone_Reset.
function Bottone_Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Resetto gli assi e disabilito tutti i pulsanti.
axes(handles.Assi1); cla;
axes(handles.Assi2); cla;
set(handles.Assi1, 'visible', 'off');
set(handles.Assi2, 'visible', 'off');
set(handles.Bottone_Salva, 'enable', 'off');
set(handles.Bottone_Reset, 'enable', 'off');
set(handles.Bottone_RGB, 'enable', 'off');
set(handles.Bottone_BN, 'enable', 'off');
set(handles.Bottone_DCT, 'enable', 'off');
set(handles.Bottone_JPEG, 'enable', 'off');
set(handles.Bottone_FFT, 'enable', 'off');
set(handles.Bottone_Histogram, 'enable', 'off');
set(handles.Bottone_Apri, 'enable', 'on');
set(handles.Ris_MSE, 'String', '');
set(handles.Ris_SNR, 'String','');
set(handles.Ris_PSNR, 'String','');
set(handles.Ris_CR, 'String','');
set(handles.Dimensione1, 'String','');
set(handles.Dimensione2, 'String','');


% --- Executes on button press in Radio_128.
function Radio_128_Callback(hObject, eventdata, handles)
% hObject    handle to Radio_128 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Radio_128
global livello
livello=127;
% --- Executes on button press in Radio_64.
function Radio_64_Callback(hObject, eventdata, handles)
% hObject    handle to Radio_64 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Radio_64
global livello
livello=63;

% --- Executes on button press in Radio_32.
function Radio_32_Callback(hObject, eventdata, handles)
% hObject    handle to Radio_32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Radio_32
global livello
livello=31;

% --- Executes on button press in Radio_16.
function Radio_16_Callback(hObject, eventdata, handles)
% hObject    handle to Radio_16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Radio_16
global livello
livello=15;

% --- Executes on button press in Radio_8.
function Radio_8_Callback(hObject, eventdata, handles)
% hObject    handle to Radio_8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Radio_8
global livello
livello=7;
% --- Executes on button press in Radio_4.
function Radio_4_Callback(hObject, eventdata, handles)
% hObject    handle to Radio_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Radio_4
global livello
livello=3;


% --- Executes on button press in Bottone_Histogram.
function Bottone_Histogram_Callback(hObject, eventdata, handles)
% hObject    handle to Bottone_Histogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global im2 last

%Splitto l'immagine nei tre canali di colore
    Red = im2(:,:,1);
    Green = im2(:,:,2);
    Blue = im2(:,:,3);
%Prendo l'istogramma per ogni singolo canale
    [yRed, x] = imhist(Red);
    [yGreen, x] = imhist(Green);
    [yBlue, x] = imhist(Blue);
%Li mostro insieme in unico riquadro
    f = figure('numbertitle', 'off');
    subplot(3,2,1);
    imshow(im2);
    title('Immagine Originale');
    subplot(3,2,2);
    plot(x, yRed, 'Red', x, yGreen, 'Green', x, yBlue, 'Blue');
    title('Istogramma immagine originale');
    
    
    %Splitto l'immagine nei tre canali di colore
    Red = last(:,:,1);
    Green = last(:,:,2);
    Blue = last(:,:,3);
    %Prendo l'istogramma per ogni singolo canale
    [yRed, x] = imhist(Red);
    [yGreen, x] = imhist(Green);
    [yBlue, x] = imhist(Blue);
    %Li mostro insieme in unico riquadro
    subplot(3,2,3);
    imshow(last);
    title('Immagine Modificata');
    subplot(3,2,4);
    plot(x, yRed, 'Red', x, yGreen, 'Green', x, yBlue, 'Blue');
    title('Istogramma immagine modificata');

    diff1=im2-last;
    
%Splitto l'immagine nei tre canali di colore
    Red = diff1(:,:,1);
    Green = diff1(:,:,2);
    Blue = diff1(:,:,3);
    %Prendo l'istogramma per ogni singolo canale
    [yRed, x] = imhist(Red);
    [yGreen, x] = imhist(Green);
    [yBlue, x] = imhist(Blue);
    %Li mostro insieme in unico riquadro
    subplot(3,2,5);
    imshow(diff1);
    title('Immagine Differenza');
    subplot(3,2,6);
    plot(x, yRed, 'Red', x, yGreen, 'Green', x, yBlue, 'Blue');
    title('Istogramma immagine differenza');
    


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


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Compressione_Help;
