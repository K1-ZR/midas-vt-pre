%%
function varargout = GUI_Main2_Preprocessor(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Main2_Preprocessor_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Main2_Preprocessor_OutputFcn, ...
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
% =========================================================================
% =========================================================================
% Initialize
function GUI_Main2_Preprocessor_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

% 1
set(handles.text23, 'visible', 'off'); set(handles.edit9, 'visible', 'off'); set(handles.text24, 'visible', 'off'); set(handles.edit10, 'visible', 'off');
set(handles.text25, 'visible', 'off'); set(handles.edit11, 'visible', 'off'); set(handles.text22, 'visible', 'off'); set(handles.edit16, 'visible', 'off');

% 2
set(handles.pushbutton7, 'enable', 'off');

% 3
set(handles.pushbutton9, 'enable', 'off');

% 4
set(handles.pushbutton8, 'enable', 'off');

function varargout = GUI_Main2_Preprocessor_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% =========================================================================
% =========================================================================
% Specimen Geo
function popupmenu1_Callback(hObject, eventdata, handles)
SetGlobal;
CurrentFolder = pwd;
TestType   = get(handles.popupmenu1,'Value')-1;

% 1 Direct tension test (Square RVE)
% 2 Direct shear test (Square RVE)
% 3 Three-point beam bending test
% 4 Four-point beam bending test
% 5 Semi-circular bending test
% 6 Indirect tension test

if  TestType==1 || TestType==2
    set(handles.text23,'visible', 'on'); set(handles.edit9, 'visible', 'on'); set(handles.text24, 'visible', 'on'); set(handles.edit10, 'visible', 'on');
    set(handles.text25, 'visible', 'off'); set(handles.edit11, 'visible', 'off'); set(handles.text22, 'visible', 'off'); set(handles.edit16, 'visible', 'off');
elseif TestType==3 || TestType==5
    set(handles.text23,'visible', 'on'); set(handles.edit9, 'visible', 'on'); set(handles.text24, 'visible', 'on'); set(handles.edit10, 'visible', 'on');
    set(handles.text25, 'visible', 'on'); set(handles.edit11, 'visible', 'on'); set(handles.text22, 'visible', 'off'); set(handles.edit16, 'visible', 'off');
elseif TestType==4
    set(handles.text23,'visible', 'on'); set(handles.edit9, 'visible', 'on'); set(handles.text24, 'visible', 'on'); set(handles.edit10, 'visible', 'on');
    set(handles.text25, 'visible', 'on'); set(handles.edit11, 'visible', 'on'); set(handles.text22, 'visible', 'on'); set(handles.edit16, 'visible', 'on');
elseif TestType==6
   set(handles.text23,'visible', 'on'); set(handles.edit9, 'visible', 'on'); set(handles.text24, 'visible', 'off'); set(handles.edit10, 'visible', 'off');
    set(handles.text25, 'visible', 'off'); set(handles.edit11, 'visible', 'off'); set(handles.text22, 'visible', 'off'); set(handles.edit16, 'visible', 'off');
end
 % ------------------------------------------------------------------------
function pushbutton12_Callback(hObject, eventdata, handles)
SetGlobal;
Dim_w=0; Dim_h=0; 
Dim_a=0; Dim_b=0;
Dim_CZw=0; Dim_CZh=0;
Dim_nw=0; Dim_nl=0;

Dim_w =   str2num( get(handles.edit9,'string') ); if isempty(Dim_w); Dim_w=0; end
Dim_h =   str2num( get(handles.edit10,'string') ); if isempty(Dim_h); Dim_h=0; end
Dim_a =   str2num( get(handles.edit11,'string') ); if isempty(Dim_a); Dim_a=0; end
Dim_b =   str2num( get(handles.edit16,'string') ); if isempty(Dim_b); Dim_b=0; end

close(figure(1))
set(handles.pushbutton7, 'enable', 'on'); 

% =========================================================================
% =========================================================================
% Input
function pushbutton1_Callback(hObject, eventdata, handles)
SetGlobal;
[FileName, FilePath] = uigetfile({'*.txt'},...
                                  'Select the mesh data');

function popupmenu2_Callback(hObject, eventdata, handles)
SetGlobal;
DelimiterType   = get(handles.popupmenu2,'Value');

if DelimiterType == 1
    Delimiter = ' ';
elseif DelimiterType == 2
    Delimiter = ',';
elseif DelimiterType == 3
    Delimiter = '\t';
end

function pushbutton7_Callback(hObject, eventdata, handles)
SetGlobal;

[ Coo_O, Con_O, El_Phase1, El_Phase2, El_CZ] = ReadInputForPreprocessorCase1([FilePath FileName], Delimiter);

TestType   = get(handles.popupmenu1,'Value')-1;
% TestType: 1: tension, 2: 3pbb, 3:SCB 

NumRegEl = size(Con_O,1);

if isempty(El_Phase2) == 1 
    HeteroIndex = 0;
else
    HeteroIndex = 1;
end

DispMesh(Coo_O, Con_O, size(Con_O,1));

set(handles.pushbutton9,'enable','on')

% =========================================================================
% =========================================================================
% Mesh
function pushbutton9_Callback(hObject, eventdata, handles)
SetGlobal;

[Coo, Con] = AddCohEl(Coo_O, Con_O, NumRegEl);

[Coo, Con] = RCM(Coo, Con, NumRegEl);

FindBCNode(Coo, Con, NumRegEl);

DispMesh(Coo, Con, NumRegEl);

handles.Coo =Coo;
handles.Con =Con;
% udate handle
guidata(hObject, handles);

set(handles.pushbutton8,'enable','on')

% =========================================================================
% =========================================================================
% Export
function pushbutton8_Callback(hObject, eventdata, handles)
SetGlobal;
OutputFileName = get(handles.edit1,'string');

if  get(handles.checkbox1,'value')==1
    MeshData2MIDASLibrary(handles.Coo, handles.Con);
end
if  get(handles.checkbox2,'value')==1
    MeshData2AbaqusInp(handles.Coo, handles.Con);
end 
set(handles.pushbutton10,'enable','on')

function pushbutton11_Callback(hObject, eventdata, handles)
Start_Preprocessor;

function pushbutton10_Callback(hObject, eventdata, handles)
close all
clear
clc
