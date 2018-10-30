%%
function varargout = GUI_Main1_PreProcessor(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Main1_PreProcessor_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Main1_PreProcessor_OutputFcn, ...
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
% INITIALIZE ==============================================================
% =========================================================================
function GUI_Main1_PreProcessor_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

% 1
set(handles.text4, 'visible', 'off'); set(handles.edit2, 'visible', 'off'); set(handles.text5, 'visible', 'off'); set(handles.edit3, 'visible', 'off');
set(handles.text6, 'visible', 'off'); set(handles.edit4, 'visible', 'off'); set(handles.text31, 'visible', 'off'); set(handles.edit25, 'visible', 'off');
set(handles.text22,'visible', 'off'); set(handles.edit17, 'visible', 'off');set(handles.text23, 'visible', 'off'); set(handles.edit18, 'visible', 'off');
set(handles.text8, 'visible', 'off'); set(handles.edit6, 'visible', 'off'); set(handles.text7, 'visible', 'off'); set(handles.edit5, 'visible', 'off');

% 2
set(handles.radiobutton1, 'enable', 'off');
set(handles.radiobutton2, 'enable', 'off');
set(handles.uipanel8, 'visible', 'off');
set(handles.pushbutton2, 'enable', 'off');  
set(handles.pushbutton3, 'visible', 'off');

set(handles.slider1,'sliderstep',[0.002 0.002],'max',1,'min',0,'Value',0.5)
set(handles.edit23, 'String', num2str(0.5));

% 3
set(handles.pushbutton4, 'enable', 'off');

set(handles.text17,'ToolTipString','Maximum mesh edge length');
set(handles.edit12,'ToolTipString','Maximum mesh edge length');
set(handles.text18,'ToolTipString',sprintf('Control the size difference of two adjacent elements\nStrictly between 1 and 2'));
set(handles.edit13,'ToolTipString',sprintf('Control the size difference of two adjacent elements\nStrictly between 1 and 2'));

% 4
set(handles.pushbutton7, 'enable', 'off');


function varargout = GUI_Main1_PreProcessor_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% =========================================================================
% TEST GEOMETRY    ========================================================
% =========================================================================
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

if  TestType==1
    im = imread([CurrentFolder, '\Gallery\', 'DTT.png']);
    set(handles.text4, 'visible', 'on'); set(handles.edit2, 'visible', 'on'); set(handles.text5, 'visible', 'on'); set(handles.edit3, 'visible', 'on');
    set(handles.text6, 'visible', 'off'); set(handles.edit4, 'visible', 'off'); set(handles.text31, 'visible', 'off'); set(handles.edit25, 'visible', 'off');
    set(handles.text22,'visible', 'on'); set(handles.edit17, 'visible', 'on','enable','off'); set(handles.text23, 'visible', 'on'); set(handles.edit18, 'visible', 'on','enable','on');
    set(handles.text8, 'visible', 'off'); set(handles.edit6, 'visible', 'off'); set(handles.text7, 'visible', 'off'); set(handles.edit5, 'visible', 'off');
elseif TestType==2
    im = imread([CurrentFolder, '\Gallery\', 'DST.png']);
    set(handles.text4, 'visible', 'on'); set(handles.edit2, 'visible', 'on'); set(handles.text5, 'visible', 'on'); set(handles.edit3, 'visible', 'on');
    set(handles.text6, 'visible', 'off'); set(handles.edit4, 'visible', 'off'); set(handles.text31, 'visible', 'off'); set(handles.edit25, 'visible', 'off');
    set(handles.text22,'visible', 'on'); set(handles.edit17, 'visible', 'on','enable','off'); set(handles.text23, 'visible', 'on'); set(handles.edit18, 'visible', 'on','enable','on');
    set(handles.text8, 'visible', 'off'); set(handles.edit6, 'visible', 'off'); set(handles.text7, 'visible', 'off'); set(handles.edit5, 'visible', 'off');
elseif TestType==3
    im = imread([CurrentFolder, '\Gallery\', 'TPBT.png']);
    set(handles.text4, 'visible', 'on'); set(handles.edit2, 'visible', 'on'); set(handles.text5, 'visible', 'on'); set(handles.edit3, 'visible', 'on');
    set(handles.text6, 'visible', 'on'); set(handles.edit4, 'visible', 'on'); set(handles.text31, 'visible', 'off'); set(handles.edit25, 'visible', 'off');
    set(handles.text22,'visible', 'on'); set(handles.edit17, 'visible', 'on','enable','on');set(handles.text23, 'visible', 'on'); set(handles.edit18, 'visible', 'on','enable','on');
    set(handles.text8, 'visible', 'on'); set(handles.edit6, 'visible', 'on'); set(handles.text7, 'visible', 'on'); set(handles.edit5, 'visible', 'on');
elseif TestType==4
    im = imread([CurrentFolder, '\Gallery\', 'FPBT.png']);
    set(handles.text4, 'visible', 'on'); set(handles.edit2, 'visible', 'on'); set(handles.text5, 'visible', 'on'); set(handles.edit3, 'visible', 'on');
    set(handles.text6, 'visible', 'on'); set(handles.edit4, 'visible', 'on'); set(handles.text31, 'visible', 'on'); set(handles.edit25, 'visible', 'on');
    set(handles.text22,'visible', 'on'); set(handles.edit17, 'visible', 'on','enable','on');set(handles.text23, 'visible', 'on'); set(handles.edit18, 'visible', 'on','enable','on');
    set(handles.text8, 'visible', 'on'); set(handles.edit6, 'visible', 'on'); set(handles.text7, 'visible', 'on'); set(handles.edit5, 'visible', 'on');
elseif TestType==5
    im = imread([CurrentFolder, '\Gallery\', 'SCBT.png']);
    set(handles.text4, 'visible', 'on'); set(handles.edit2, 'visible', 'on'); set(handles.text5, 'visible', 'on'); set(handles.edit3, 'visible', 'on');
    set(handles.text6, 'visible', 'on'); set(handles.edit4, 'visible', 'on'); set(handles.text31, 'visible', 'off'); set(handles.edit25, 'visible', 'off');
    set(handles.text22,'visible', 'on'); set(handles.edit17, 'visible', 'on');set(handles.text23, 'visible', 'on'); set(handles.edit18, 'visible', 'on','enable','on');
    set(handles.text8, 'visible', 'on'); set(handles.edit6, 'visible', 'on'); set(handles.text7, 'visible', 'on'); set(handles.edit5, 'visible', 'on');
elseif TestType==6
    im = imread([CurrentFolder, '\Gallery\', 'ITT.png']);
    set(handles.text4, 'visible', 'on'); set(handles.edit2, 'visible', 'on'); set(handles.text5, 'visible', 'off'); set(handles.edit3, 'visible', 'off');
    set(handles.text6, 'visible', 'off'); set(handles.edit4, 'visible', 'off'); set(handles.text31, 'visible', 'off'); set(handles.edit25, 'visible', 'off');
    set(handles.text22,'visible', 'on'); set(handles.edit17, 'visible', 'on');set(handles.text23, 'visible', 'on'); set(handles.edit18, 'visible', 'on','enable','on');
    set(handles.text8, 'visible', 'off'); set(handles.edit6, 'visible', 'off'); set(handles.text7, 'visible', 'off'); set(handles.edit5, 'visible', 'off');
end
im = imresize(im,.5);
figure(1); imshow(im);
set(figure(1), 'menubar', 'none');
set(figure(1),'name','Specimen geometry');

function edit2_Callback(hObject, eventdata, handles)
TestType   = get(handles.popupmenu1,'Value')-1;
if TestType==1 || TestType==2
    set(handles.edit17,'string',get(handles.edit2,'string'));
elseif TestType==6
    set(handles.edit18,'string',get(handles.edit2,'string'));
    set(handles.edit3,'string',get(handles.edit2,'string'));
end

function edit3_Callback(hObject, eventdata, handles)
TestType   = get(handles.popupmenu1,'Value')-1;
% if TestType==1 || TestType==2 || TestType==3 || TestType==4 || TestType==5 
%     set(handles.edit18,'string',get(handles.edit3,'string'));
% end


function pushbutton6_Callback(hObject, eventdata, handles)
SetGlobal;
Dim_w=0; Dim_h=0; 
Dim_a=0; Dim_b=0;
Dim_CZw=0; Dim_CZh=0;
Dim_nw=0; Dim_nl=0;

Dim_w =   str2num( get(handles.edit2,'string') ); if isempty(Dim_w); Dim_w=0; end
Dim_h =   str2num( get(handles.edit3,'string') ); if isempty(Dim_h); Dim_h=0; end
Dim_a =   str2num( get(handles.edit4,'string') ); if isempty(Dim_a); Dim_a=0; end
Dim_b =   str2num( get(handles.edit25,'string') ); if isempty(Dim_b); Dim_b=0; end
Dim_CZw = str2num( get(handles.edit17,'string') ); if isempty(Dim_CZw); Dim_CZw=0; end
Dim_CZh = str2num( get(handles.edit18,'string') ); if isempty(Dim_CZh); Dim_CZh=0; end
Dim_nw =  str2num( get(handles.edit6,'string') ); if isempty(Dim_nw); Dim_nw=0; end
Dim_nl =  str2num( get(handles.edit5,'string') ); if isempty(Dim_nl); Dim_nl=0; end

close(figure(1))
set(handles.radiobutton1, 'enable', 'on');
set(handles.radiobutton2, 'enable', 'on');
% =========================================================================
% 2  MICROSTRUCTURE =======================================================
% =========================================================================
function radiobutton1_Callback(hObject, eventdata, handles)
SetGlobal;
HeteroIndex = 0;
set(handles.uipanel8, 'visible', 'off');
set(handles.pushbutton2, 'enable', 'on');
set(handles.pushbutton3, 'visible', 'off');

function radiobutton2_Callback(hObject, eventdata, handles)
SetGlobal;
HeteroIndex = 1;
set(handles.uipanel8, 'visible', 'on');
set(handles.pushbutton2, 'enable', 'on');
set(handles.pushbutton3, 'visible', 'on');

function pushbutton1_Callback(hObject, eventdata, handles)
SetGlobal;
[MixtureImageName, MixtureImagePath] = uigetfile({'*.JPG;*.PNG'},...
                                                  'Select microstructure image');
% set the initial value for threshold
I = imread([MixtureImagePath, MixtureImageName]);
I = rgb2gray(I);
Level = graythresh(I);                                                 
set(handles.edit23, 'String', num2str(Level));    
set(handles.slider1, 'Value', Level);

set(handles.text27, 'enable', 'on');
set(handles.edit21, 'enable', 'on');
set(handles.pushbutton5, 'enable', 'on');


function slider1_Callback(hObject, eventdata, handles)
SegmentationThreshold = get(handles.slider1, 'Value');
set(handles.edit23, 'String', num2str(SegmentationThreshold));

function pushbutton5_Callback(hObject, eventdata, handles)
SetGlobal;

SegmentationThreshold = get(handles.slider1, 'Value');
set(handles.edit23, 'String', num2str(SegmentationThreshold));

MinFineParticleSize = str2num( get(handles.edit21,'string') );
if isempty(get(handles.edit21,'string')); MinFineParticleSize=0; end

ConvexingFactor = str2num( get(handles.edit24,'string') );

set(handles.pushbutton2, 'enable', 'off');
set(handles.pushbutton3, 'enable', 'off');
set(handles.pushbutton5, 'enable', 'off');
Image2Shape;
set(handles.pushbutton2, 'enable', 'on');
set(handles.pushbutton3, 'enable', 'on');
set(handles.pushbutton5, 'enable', 'on');

function pushbutton3_Callback(hObject, eventdata, handles)
SetGlobal;
close(figure(1));

set(handles.pushbutton5, 'enable', 'off');
set(handles.pushbutton2, 'enable', 'off');

system(['mspaint ','"', MixtureImagePath,MixtureImageName,'"']);

function pushbutton2_Callback(hObject, eventdata, handles)
close(figure(1)); close(figure(2));
Shape2Geom;

set(handles.pushbutton4, 'enable', 'on');

% =========================================================================
% MESH ====================================================================
% =========================================================================
function edit13_Callback(hObject, eventdata, handles)
if ~isempty(get(handles.edit12,'value')) && ~isempty(get(handles.edit13,'value'))
    set(handles.pushbutton4, 'enable', 'on');
end

% function checkbox1_Callback(hObject, eventdata, handles)
% SetGlobal;
% JigglingIndex = get(handles.checkbox1,'value');
% if JigglingIndex==1
%     set(handles.text19, 'enable', 'on');
%     set(handles.edit14, 'enable', 'on');
% end 

function pushbutton4_Callback(hObject, eventdata, handles)
SetGlobal;
MaxMeshSize = str2num( get(handles.edit12,'string') );
MeshGrowthRate = str2num( get(handles.edit13,'string') );
% if JigglingIndex==1
%     JigglingMaxIter = str2num( get(handles.edit12,'string') );
% end
JigglingIndex = 1;
JigglingMaxIter = 1000;

% Mesh
[Coo, Con] = Geom2Mesh;

% ADD COHESIVE EL to REGULAR MESH
if get(handles.checkbox4,'value')==1
    [Coo, Con] = AddCohEl(Coo, Con, NumRegEl);
end
% RCM RELABLING of COH+REG MESH
[Coo, Con] = RCM(Coo, Con, NumRegEl);
% FIND BOUNDARY NODES
FindBCNode(Coo, Con, NumRegEl);
% PLOT MESH
DispMesh(Coo, Con, NumRegEl);

handles.Coo =Coo;
handles.Con =Con;
% save and update data
guidata(hObject, handles)

set(handles.pushbutton7, 'enable', 'on');


% =========================================================================
% WRITE OUTPUT
% =========================================================================
function pushbutton7_Callback(hObject, eventdata, handles)
SetGlobal;
OutputFileName = get(handles.edit22,'string');

if      get(handles.checkbox2,'value')==1
    MeshData2MIDASLibrary(handles.Coo, handles.Con);
end
if  get(handles.checkbox3,'value')==1
    MeshData2AbaqusInp(handles.Coo, handles.Con);
end 
set(handles.pushbutton9, 'enable', 'on');

function pushbutton9_Callback(hObject, eventdata, handles)
close all
clear
clc

function pushbutton10_Callback(hObject, eventdata, handles)
Start_Preprocessor;
