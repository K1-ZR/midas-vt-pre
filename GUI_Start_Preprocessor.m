function varargout = GUI_Start_Preprocessor(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Start_Preprocessor_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Start_Preprocessor_OutputFcn, ...
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

function GUI_Start_Preprocessor_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
clear global


function varargout = GUI_Start_Preprocessor_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


function pushbutton1_Callback(hObject, eventdata, handles)
if     get(handles.radiobutton1,'value')==1
    GUI_Main2_Preprocessor;
    ModelGenModeIndex = 2;
elseif get(handles.radiobutton2,'value')==1
    GUI_Main1_PreProcessor;
    ModelGenModeIndex = 1;
end
close(GUI_Start_Preprocessor);


function pushbutton2_Callback(hObject, eventdata, handles)
close all
clear
clc
