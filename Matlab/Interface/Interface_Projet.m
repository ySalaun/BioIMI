function varargout = Interface_Projet(varargin)
%INTERFACE_PROJET M-file for Interface_Projet.fig
%      INTERFACE_PROJET, by itself, creates a new INTERFACE_PROJET or raises the existing
%      singleton*.
%
%      H = INTERFACE_PROJET returns the handle to a new INTERFACE_PROJET or the handle to
%      the existing singleton*.
%
%      INTERFACE_PROJET('Property','Value',...) creates a new INTERFACE_PROJET using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to Interface_Projet_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      INTERFACE_PROJET('CALLBACK') and INTERFACE_PROJET('CALLBACK',hObject,...) call the
%      local function named CALLBACK in INTERFACE_PROJET.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Interface_Projet

% Last Modified by GUIDE v2.5 27-Jan-2013 20:27:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Interface_Projet_OpeningFcn, ...
                   'gui_OutputFcn',  @Interface_Projet_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before Interface_Projet is made visible.
function Interface_Projet_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for Interface_Projet
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Interface_Projet wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Interface_Projet_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x = getappdata(handles.figure1,'Signal');
xn = getappdata(handles.figure1,'SignalNoise');
signal_filtre = getappdata(handles.figure1,'FiltSignal'); 
figure, 
plot(xn(1:length(signal_filtre)),'r') ;
hold on
plot(x(1:length(signal_filtre)),'b');
hold on
plot(signal_filtre,'m') ;
ylabel('Amplitude du signal');
xlabel('Numero d echantillon');
legend('Signal bruite','Signal de depart','Signal filtre');
axis tight ;


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s = getappdata(handles.figure1,'FiltSignal');
Fe = getappdata(handles.figure1,'FreqEch');
soundsc(s,Fe) ;

% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


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



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


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


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ordreLPC = str2double(get(handles.edit2,'string'));
if isnan(ordreLPC)
  errordlg('You must enter a numeric value','Bad Input','modal')
  uicontrol(hObject)
 return
end
nbIter = str2double(get(handles.edit3,'string'));
if isnan(nbIter)
  errordlg('You must enter a numeric value','Bad Input','modal')
  uicontrol(hObject)
 return
end
val1 = get(handles.checkbox1,'Value') ;
% APPDATA
x = getappdata(handles.figure1,'Signal');
Fe = getappdata(handles.figure1,'FreqEch');
var = getappdata(handles.figure1,'NoiseVar');


val = get(handles.popupmenu2,'Value');
switch val
    case 1
    signal_filtre  = filtrage( x,Fe,var,ordreLPC,nbIter,val1,1 ) ;
    case 2
    % selection du filtre de Wiener causal 2
    signal_filtre  = filtrage( x,Fe,var,ordreLPC,nbIter,val1,2 ) ;
end
setappdata(handles.figure1,'FiltSignal',signal_filtre);
warndlg('Filtrage termine avec succes','Filtrage');



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s = getappdata(handles.figure1,'SignalNoise');
Fe = getappdata(handles.figure1,'FreqEch');
soundsc(s,Fe) ;



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
xn = getappdata(handles.figure1,'SignalNoise');
x = getappdata(handles.figure1,'Signal');
figure, 
plot(xn,'r') ;
hold on
plot(x,'b');
ylabel('Amplitude du signal');
xlabel('Numero d echantillon');
legend('Signal bruite','Signal de depart');
axis tight ;


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
var = str2double(get(handles.edit1,'string'));
if isnan(var)
  errordlg('You must enter a numeric value','Bad Input','modal')
  uicontrol(hObject)
 return
end
setappdata(handles.figure1,'NoiseVar',var) ;
x = getappdata(handles.figure1,'Signal');
noise = 0 + sqrt(var).*randn(size(x)) ;
xn = x + noise ;
setappdata(handles.figure1,'SignalNoise',xn); 





function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


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


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.wav', 'Pick an audio file');
name1 = strcat(pathname,filename);
if isequal(filename,0) || isequal(pathname,0)
       set(handles.edit4,'String','User pressed cancel');
else
    set(handles.edit4,'String',filename) ;
    [x,Fe]=wavread(name1);
    setappdata(handles.figure1,'Signal',x); 
    setappdata(handles.figure1,'FreqEch',Fe); 

end



% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x = getappdata(handles.figure1,'Signal');
Fe = getappdata(handles.figure1,'FreqEch');
soundsc(x,Fe) ;


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Spectre d une trame
s = getappdata(handles.figure1,'FiltSignal');
Fe = getappdata(handles.figure1,'FreqEch');
calcul_spectre(s,Fe);
