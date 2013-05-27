function varargout = GUI(varargin)
% GUI M-file for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 26-May-2013 20:42:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)


% ajoute les différents dossiers du projet
addpath(genpath('/home/raphal/Documents/2A/Projet_IMI/BioIMI/Matlab'));

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles) % Parcourir
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName,PathName] = uigetfile('*.dcm','MultiSelect','on','Selectionnez les images');
handles.FileName=FileName;

if isequal(class(FileName),'char') % un seul fichier
    FileName={FileName};
end
handles.FileName=FileName;
if ~(isequal(FileName,0) || isequal(PathName,0))
    
    [handles.Y,handles.info]=read_dicom_name(FileName,PathName);
    handles.nimages=length(FileName);
    handles.currentimage=1;
	Y1=imadjust(squeeze(handles.Y(:,:,1,handles.currentimage)));
    
    handles.rt=0;
    
	%imshow(Y1);
    set(handles.text1,'String',handles.FileName{1,1});
    imagesc(Y1)
    colormap('gray')
    axis image
	guidata(hObject,handles);
    %setappdata(handles.figure1,'Signal',x); 
    %setappdata(handles.figure1,'FreqEch',Fe); 

end

	

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles) % Movie
	display_scans(handles.Y,0);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles) % Selection
	[~,rect]=imcrop;
	handles.rect=rect;
	guidata(hObject,handles);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles) % Next
    handles.currentimage=mod(handles.currentimage,handles.nimages)+1;
	Y1=imadjust(squeeze(handles.Y(:,:,1,handles.currentimage)));
	%imshow(Y1);
    set(handles.text1,'String',handles.FileName{1,handles.currentimage});
    imagesc(Y1)
    colormap('gray')
    axis image
    
   if (handles.rt)
        hold on;
        imagesc(Y1)
        colormap('gray')
        axis image
        
        n_image=handles.FileName{1,handles.currentimage};
        n_image=str2num(n_image(end-7:end-4));% à améliorer, récuprère le numéro de l'image
        n_imageref=handles.FileName{1,1};
        n_imageref=str2num(n_imageref(end-7:end-4));% id

        [~]=add_RT(handles.info(1),handles.rt_info,n_image-n_imageref);
       
        hold off;
    end
        
    guidata(hObject,handles);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles) %Expert
  [FileName,PathName] = uigetfile('*.dcm','MultiSelect','off','Selectionnez l''image');
  handles.rt_info=dicominfo(strcat(PathName,FileName));
  handles.rt=1;
  Y1=imadjust(squeeze(handles.Y(:,:,1,handles.currentimage)));
  
  hold on;
    imagesc(Y1)
    colormap('gray')
    axis image
    n_image=handles.FileName{1,handles.currentimage};
    n_image=str2num(n_image(end-7:end-4));% à améliorer, récuprère le numéro de l'image
    n_imageref=handles.FileName{1,1};
    n_imageref=str2num(n_imageref(end-7:end-4));% id
    
    
    [~]=add_RT(handles.info(1),handles.rt_info,n_image-n_imageref);
 hold off;
 guidata(hObject,handles);

  
