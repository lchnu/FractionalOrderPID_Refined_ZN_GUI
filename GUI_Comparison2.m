function varargout = GUI_Comparison2(varargin)
% GUI_COMPARISON2 MATLAB code for GUI_Comparison2.fig
%      GUI_COMPARISON2, by itself, creates a new GUI_COMPARISON2 or raises the existing
%      singleton*.
%
%      H = GUI_COMPARISON2 returns the handle to a new GUI_COMPARISON2 or the handle to
%      the existing singleton*.
%
%      GUI_COMPARISON2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_COMPARISON2.M with the given input arguments.
%
%      GUI_COMPARISON2('Property','Value',...) creates a new GUI_COMPARISON2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Comparison2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Comparison2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Comparison2

% Last Modified by GUIDE v2.5 06-Jun-2022 15:24:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Comparison2_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Comparison2_OutputFcn, ...
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


% --- Executes just before GUI_Comparison2 is made visible.
function GUI_Comparison2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Comparison2 (see VARARGIN)

% Choose default command line output for GUI_Comparison2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_Comparison2 wait for user response (see UIRESUME)
% uiwait(handles.figComparison);

handles.run = 'Runing';                                       % 按钮运行时的显示
handles.defaultRun = 'RUN';                                   % 控制器按钮默认的显示
field1  = 'run';                 value1  = [1.0  0    0   ];  % 按钮运行时的颜色
field2  = 'defaultHighlight';    value2  = [0.5  0.5  0.5 ];  % 默认的原始颜色
field3  = 'defaultForeground';   value3  = [0    0    0   ];
field4  = 'defaultShadow';       value4  = [0.9  0.9  0.9 ];
field5  = 'compensator';         value5  = [0    0    0   ];  % 补偿器的颜色
field6  = 'FOPID1';              value6  = [1.0  0    0   ];  % FOPID1    控制器的颜色
field7  = 'FOPID2';              value7  = [0    0    1   ];  % FOPID2    控制器的颜色
field8  = 'ZNPID';               value8  = [0.13 0.55 0.13];  % ZNPID     控制器的颜色
field9  = 'RZNFOPID';            value9  = [1    0.65 0   ];  % RZNFOPID  控制器的颜色
field10 = 'PILamD';              value10 = [0.58 0    0.83];  % PILamD    控制器的颜色
field11 = 'controller';          value11 = [0.49 0.99  0  ];  % 控制器按钮的默认颜色
field12 = 'function';            value12 = [0.68 0.85 0.90];  % 功能按钮的默认颜色
color = struct(field1,value1, field2,value2, field3,value3, field4,value4, ...
    field5,value5, field6,value6, field7,value7, field8,value8, field9,value9, ...
    field10,value10, field11,value11, field12,value12);       % 保存颜色的结构体
handles.color = color;

handles.flagW= true;
handles.w    = 1e-2:1e-2:1e2; 
handles.opts = struct('WindowStyle','modal', 'Interpreter','tex');

handles.stepValue = str2double(get(handles.editStepValue, 'string'));   % 读取默认仿真参数
handles.disValue  = str2double(get(handles.editDisValue,  'string'));
handles.simTime   = str2double(get(handles.editSimTime,   'string'));
handles.disTime   = str2double(get(handles.editDisTime,   'string'));

handles.flagTa          = false;                            % 各部分的初始状态设置
handles.flagRelayTest	= false;
handles.flagCompensator = false;


handles.flagPoint1    = false;
handles.flagFOPID1    = false;
handles.flagRunFOPID1 = false;

handles.flagPoint2    = false;
handles.flagFOPID2    = false;
handles.flagRunFOPID2 = false;

handles.flagZNPID     = false;
handles.flagRunZNPID  = false;

handles.flagRZNFOPID	= false;
handles.flagRunRZNFOPID = false;

handles.flagPILamD    = false;
handles.flagRunPILamD = false;
handles.flagMargin    = false;


guidata(hObject, handles);                                  % 传递状态的全局变量
global reset;                                               % 保存初始状态的结构体
reset = handles;


% --- Outputs from this function are returned to the command line.
function varargout = GUI_Comparison2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





% ......................................................................... %
% ........................... Controlled Plant ............................ %
% ......................................................................... %

function editNs_Callback(hObject, eventdata, handles)
% hObject    handle to editNs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editNs as text
%        str2double(get(hObject,'String')) returns contents of editNs as a double
handles.flagCompensator = false;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function editNs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editMs_Callback(hObject, eventdata, handles)
% hObject    handle to editMs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMs as text
%        str2double(get(hObject,'String')) returns contents of editMs as a double
handles.flagCompensator = false;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function editMs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editN_Callback(hObject, eventdata, handles)
% hObject    handle to editN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editN as text
%        str2double(get(hObject,'String')) returns contents of editN as a double
handles.flagCompensator = false;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function editN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editL_Callback(hObject, eventdata, handles)
% hObject    handle to editL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editL as text
%        str2double(get(hObject,'String')) returns contents of editL as a double
handles.flagCompensator = false;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function editL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% ......................................................................... %
% ........................ Simulation Parameters .......................... %
% ......................................................................... %

function editStepValue_Callback(hObject, eventdata, handles)
% hObject    handle to editStepValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editStepValue as text
%        str2double(get(hObject,'String')) returns contents of editStepValue as a double

set(handles.checkboxFOPID1,  'value', 0);
checkboxFOPID1_Callback(hObject, eventdata, handles);
set(handles.checkboxFOPID2,  'value', 0);
checkboxFOPID2_Callback(hObject, eventdata, handles);
set(handles.checkboxZNPID,   'value', 0);
checkboxZNPID_Callback(hObject, eventdata, handles);
set(handles.checkboxRZNFOPID,'value', 0);
checkboxRZNFOPID_Callback(hObject, eventdata, handles);
set(handles.checkboxPILamD,  'value', 0);
checkboxPILamD_Callback(hObject, eventdata, handles);

handles.flagFOPID1   = false;
handles.flagFOPID2   = false;
handles.flagZNPID    = false;
handles.flagRZNFOPID = false;
handles.flagPILamD   = false;

handles.stepValue = str2double(get(handles.editStepValue, 'string'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function editStepValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editStepValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editDisValue_Callback(hObject, eventdata, handles)
% hObject    handle to editDisValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDisValue as text
%        str2double(get(hObject,'String')) returns contents of editDisValue as a double

set(handles.checkboxFOPID1,  'value', 0);
checkboxFOPID1_Callback(hObject, eventdata, handles);
set(handles.checkboxFOPID2,  'value', 0);
checkboxFOPID2_Callback(hObject, eventdata, handles);
set(handles.checkboxZNPID,   'value', 0);
checkboxZNPID_Callback(hObject, eventdata, handles);
set(handles.checkboxRZNFOPID,'value', 0);
checkboxRZNFOPID_Callback(hObject, eventdata, handles);
set(handles.checkboxPILamD,  'value', 0);
checkboxPILamD_Callback(hObject, eventdata, handles);

handles.flagFOPID1   = false;
handles.flagFOPID2   = false;
handles.flagZNPID    = false;
handles.flagRZNFOPID = false;
handles.flagPILamD   = false;

handles.disValue = str2double(get(handles.editDisValue, 'string'));
handles.flagFOPID2 = false;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function editDisValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDisValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editSimTime_Callback(hObject, eventdata, handles)
% hObject    handle to editSimTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSimTime as text
%        str2double(get(hObject,'String')) returns contents of editSimTime as a double

set(handles.checkboxFOPID1,  'value', 0);
checkboxFOPID1_Callback(hObject, eventdata, handles);
set(handles.checkboxFOPID2,  'value', 0);
checkboxFOPID2_Callback(hObject, eventdata, handles);
set(handles.checkboxZNPID,   'value', 0);
checkboxZNPID_Callback(hObject, eventdata, handles);
set(handles.checkboxRZNFOPID,'value', 0);
checkboxRZNFOPID_Callback(hObject, eventdata, handles);
set(handles.checkboxPILamD,  'value', 0);
checkboxPILamD_Callback(hObject, eventdata, handles);

handles.flagFOPID1   = false;
handles.flagFOPID2   = false;
handles.flagZNPID    = false;
handles.flagRZNFOPID = false;
handles.flagPILamD   = false;

handles.simTime = str2double(get(handles.editSimTime, 'string'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function editSimTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSimTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editDisTime_Callback(hObject, eventdata, handles)
% hObject    handle to editDisTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDisTime as text
%        str2double(get(hObject,'String')) returns contents of editDisTime as a double

set(handles.checkboxFOPID1,  'value', 0);
checkboxFOPID1_Callback(hObject, eventdata, handles);
set(handles.checkboxFOPID2,  'value', 0);
checkboxFOPID2_Callback(hObject, eventdata, handles);
set(handles.checkboxZNPID,   'value', 0);
checkboxZNPID_Callback(hObject, eventdata, handles);
set(handles.checkboxRZNFOPID,'value', 0);
checkboxRZNFOPID_Callback(hObject, eventdata, handles);
set(handles.checkboxPILamD,  'value', 0);
checkboxPILamD_Callback(hObject, eventdata, handles);

handles.flagFOPID1   = false;
handles.flagFOPID2   = false;
handles.flagZNPID    = false;
handles.flagRZNFOPID = false;
handles.flagPILamD   = false;

handles.disTime = str2double(get(handles.editDisTime, 'string'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function editDisTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDisTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% ......................................................................... %
% ............................ Compensator ................................ %
% ......................................................................... %

% --- Executes on button press in checkboxCompensator.
function checkboxCompensator_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxCompensator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxCompensator
handles.flagTa = false;
handles.flagCompensator = false;
guidata(hObject, handles);
if get(handles.checkboxCompensator, 'value')                    % 添加补偿器
    set(handles.popupmenuTa,  'enable', 'on');
    set(handles.pushbuttonGa, 'enable', 'on');
    set(handles.uipanelCompensator, 'foregroundcolor', handles.color.compensator);
    set(handles.uipanelCompensator, 'highlightcolor',  handles.color.compensator);
    set(handles.uipanelCompensator, 'shadowcolor',     handles.color.compensator);
else                                                            % 移除补偿器
    set(handles.popupmenuTa, 'enable', 'off');
    set(handles.pushbuttonGa, 'enable','off');
    set(handles.uipanelCompensator, 'foregroundcolor', handles.color.defaultForeground);
    set(handles.uipanelCompensator, 'highlightcolor',  handles.color.defaultHighlight);
    set(handles.uipanelCompensator, 'shadowcolor',     handles.color.defaultShadow);
end


% --- Executes on selection change in popupmenuTa.
function popupmenuTa_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuTa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuTa contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuTa
handles.flagCompensator = false;
Ta_num = get(handles.popupmenuTa, 'value');
switch Ta_num
    case 1
        handles.flagTa = false;
        guidata(hObject, handles)
        warndlg('\fontsize{10} Please choose the correct Ta!', 'Warning', handles.opts);
        return;
    case 2
        handles.Ta = 1e-1;
    case 3
        handles.Ta = 1e-2;
    case 4
        handles.Ta = 1e-3;
    case 5
        handles.Ta = 1e1;
    case 6
        handles.Ta = 1e2;
    case 7
        handles.Ta = 1e3;    
end
handles.flagTa = true;
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function popupmenuTa_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuTa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonGa.
function pushbuttonGa_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonGa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~(handles.flagTa)
    opts = struct('WindowStyle','modal', 'Interpreter','tex');
    warndlg('\fontsize{10} Please choose the correct Ta!', 'Warning', opts);
    return;
end
colorGa  = get(handles.pushbuttonGa, 'backgroundcolor');
stringGa = get(handles.pushbuttonGa, 'string');
set(handles.pushbuttonGa, 'backgroundcolor', handles.color.run);
set(handles.pushbuttonGa, 'string', handles.run);
pause(1e-1);

handles.flagCompensator = true;
Ns = str2num(get(handles.editNs,  'string'));                   % 读取系统
Ms = str2num(get(handles.editMs,  'string'));
n  = str2double(get(handles.editN,'string'));
L  = str2double(get(handles.editL,'string'));
if ((length(Ns)==1)&&(length(Ms)==2)&&(n==0))
    handles.flagFOPDT = true;
    handles.K = Ns    / Ms(2);
    handles.T = Ms(1) / Ms(2);
    set(handles.checkboxPILamD, 'enable', 'on');
else
    handles.flagFOPDT = false;
    set(handles.checkboxPILamD, 'enable', 'off');
end
try
    Ta = handles.Ta;
    [Gp,GpL,Ga,m,flagGa] = function_Compensator(Ns,Ms,n,L,Ta);      % 计算补偿器
    if flagGa                                                       % 显示补偿器
        set(handles.textGa, 'string', 'Ga(s) = ');
        if n == 0
            set(handles.textCompensatorNum, 'string', '1 ');
            set(handles.textCompensatorN,   'string', '');
        elseif n == 1
            set(handles.textCompensatorNum, 'string', ['s / ',num2str(Ta),' + 1']);
            set(handles.textCompensatorN,   'string', '');
        else
            set(handles.textCompensatorNum, 'string', ['( s / ',num2str(Ta),' + 1 )']);
            set(handles.textCompensatorN,   'string', num2str(n));
        end
        set(handles.textFrac, 'string', '——————————————————');
        if m == 1
            set(handles.textCompensatorDen, 'string', [num2str(Ta), ' s + 1']);
            set(handles.textCompensatorM,   'string', '');
        else
            set(handles.textCompensatorDen, 'string', ['( ', num2str(Ta), ' s + 1 )']);
            set(handles.textCompensatorM,   'string', num2str(m));
        end
    else
        set(handles.textCompensatorNum, 'string', '');
        set(handles.textCompensatorN,   'string', '');
        set(handles.textFrac,           'string', '');
        set(handles.textCompensatorDen, 'string', '');
        set(handles.textCompensatorM,   'string', '');
        set(handles.textGa,    'string', 'Ga(s) = 1');
    end
    
    handles.GpL = GpL;                  % 传递参数
    handles.Gp  = Gp;
    handles.Ga  = Ga;
    handles.L   = L;
    guidata(hObject, handles);
catch
    opts = struct('WindowStyle','modal', 'Interpreter','tex');
    errordlg('\fontsize{10} Please fill in the transfer function correctly !', 'ERROR', opts);
end

set(handles.pushbuttonGa, 'backgroundcolor', colorGa);
set(handles.pushbuttonGa, 'string', stringGa);





% ......................................................................... %
% ................. Critical Oscillation Parameters ....................... %
% ......................................................................... %

function editKc_Callback(hObject, eventdata, handles)
% hObject    handle to editKc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editKc as text
%        str2double(get(hObject,'String')) returns contents of editKc as a double


% --- Executes during object creation, after setting all properties.
function editKc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editKc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editTc_Callback(hObject, eventdata, handles)
% hObject    handle to editTc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTc as text
%        str2double(get(hObject,'String')) returns contents of editTc as a double


% --- Executes during object creation, after setting all properties.
function editTc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonRelayTest.
function pushbuttonRelayTest_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonRelayTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ( handles.flagTa ) && ~( handles.flagCompensator )
    opts = struct('WindowStyle','modal', 'Interpreter','tex');
    warndlg('\fontsize{10} Please calculate the Compensator before this operation !', 'Warning', opts);
    return;
end
colorRelayTest  = get(handles.pushbuttonRelayTest, 'backgroundcolor');
stringRelayTest = get(handles.pushbuttonRelayTest, 'string');
set(handles.pushbuttonRelayTest, 'enable', 'off');
set(handles.pushbuttonRelayTest, 'backgroundcolor', handles.color.run);
set(handles.pushbuttonRelayTest, 'string', handles.run);
pause(1e-1);

try
    if ~(handles.flagCompensator)
        Ns = str2num(get(handles.editNs,  'string'));   % 不加补偿器的情况下，读取系统
        Ms = str2num(get(handles.editMs,  'string'));
        n  = str2double(get(handles.editN,'string'));
        L  = str2double(get(handles.editL,'string'));
        if ((length(Ns)==1)&&(length(Ms)==2)&&(n==0))
            handles.flagFOPDT = true;
            handles.K = Ns    / Ms(2);
            handles.T = Ms(1) / Ms(2);
            set(handles.checkboxPILamD, 'enable', 'on');
        else
            handles.flagFOPDT = false;
            set(handles.checkboxPILamD, 'enable', 'off');
        end
        
        s  = tf('s');
        sys1 = tf(Ns, Ms, 'ioDelay', L);
        sys2 = tf(Ns, Ms);
        handles.GpL = sys1 / s^n;                   % 传递参数
        handles.Gp  = sys2 / s^n;
        handles.L   = L;
        handles.Ga  = 1;
        handles.flagRelayTest = true;
        guidata(hObject, handles);
    end
    
    GpLa = handles.GpL * handles.Ga;                % 传递参数
    [Gm,~,Wcp,~] = margin(GpLa);
    handles.Kc = Gm;                                % critical gain
    handles.Wc = Wcp;                               % critical frequency
    handles.Tc = 2*pi / Wcp;                        % critical period
    handles.GpLa = GpLa;
    guidata(hObject, handles);
    
    set(handles.checkboxFOPID1,  'enable', 'on');
    set(handles.checkboxFOPID2,  'enable', 'on');
    set(handles.checkboxZNPID,   'enable', 'on');
    set(handles.checkboxRZNFOPID,'enable', 'on');
    
    set(handles.editKc, 'string', num2str(handles.Kc,'%.4f'));
    set(handles.editTc, 'string', num2str(handles.Tc,'%.4f'));
catch
    errordlg('\fontsize{10} Please fill in the transfer function correctly !', 'ERROR', handles.opts);
end


set(handles.pushbuttonRelayTest, 'backgroundcolor', colorRelayTest);
set(handles.pushbuttonRelayTest, 'string', stringRelayTest);
set(handles.pushbuttonRelayTest, 'enable', 'on');





% ......................................................................... %
% ............................... FOPID 1 ................................. %
% ......................................................................... %

% --- Executes on button press in checkboxFOPID1.
function checkboxFOPID1_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxFOPID1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxFOPID1

if get(handles.checkboxFOPID1, 'value')
    if handles.flagRunFOPID1                            % 同一个系统运行一次后，不需要二次运行
        handles.flagFOPID1 = true;
    end
    set(handles.popupmenuPoint1,     'enable', 'on');   % 使能 FOPID1 控制器部分
    set(handles.editR1FOPID1,        'enable', 'on');
    set(handles.editR2FOPID1,        'enable', 'on');
    set(handles.editMuFOPID1,        'enable', 'on');
    set(handles.pushbuttonRunFOPID1, 'enable', 'on');
    set(handles.uipanelFOPID1, 'foregroundcolor', handles.color.FOPID1);
    set(handles.uipanelFOPID1, 'highlightcolor',  handles.color.FOPID1);
    set(handles.uipanelFOPID1, 'shadowcolor',     handles.color.FOPID1);
else                                                    % 关闭 FOPID1 控制器部分
    handles.flagFOPID1 = false;
    set(handles.popupmenuPoint1,     'enable', 'off');
    set(handles.editR1FOPID1,        'enable', 'off');
    set(handles.editR2FOPID1,        'enable', 'off');
    set(handles.editMuFOPID1,        'enable', 'off');
    set(handles.pushbuttonRunFOPID1, 'enable', 'off');
    set(handles.uipanelFOPID1, 'foregroundcolor', handles.color.defaultForeground);
    set(handles.uipanelFOPID1, 'highlightcolor',  handles.color.defaultHighlight);
    set(handles.uipanelFOPID1, 'shadowcolor',     handles.color.defaultShadow);
end
guidata(hObject, handles);


% --- Executes on selection change in popupmenuPoint1.
function popupmenuPoint1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuPoint1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuPoint1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuPoint1

point1 = get(handles.popupmenuPoint1, 'value');
switch point1
    case 1
        warndlg('\fontsize{10} Please choose the correct fixed-point !', 'Warning', handles.opts);
        handles.flagPoint1 = false;
        guidata(hObject, handles);
        return;
    case 2
        handles.selectPoint1 = true;
        handles.strPoint1 = 'new ZN-point';
    case 3
        handles.selectPoint1 = false;
        handles.strPoint1 = 'ZN-point';
end
if ~(handles.flagPoint1)
    handles.flagPoint1 = true;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenuPoint1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuPoint1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editR1FOPID1_Callback(hObject, eventdata, handles)
% hObject    handle to editR1FOPID1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editR1FOPID1 as text
%        str2double(get(hObject,'String')) returns contents of editR1FOPID1 as a double


% --- Executes during object creation, after setting all properties.
function editR1FOPID1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editR1FOPID1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editR2FOPID1_Callback(hObject, eventdata, handles)
% hObject    handle to editR2FOPID1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editR2FOPID1 as text
%        str2double(get(hObject,'String')) returns contents of editR2FOPID1 as a double


% --- Executes during object creation, after setting all properties.
function editR2FOPID1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editR2FOPID1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editMuFOPID1_Callback(hObject, eventdata, handles)
% hObject    handle to editMuFOPID1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMuFOPID1 as text
%        str2double(get(hObject,'String')) returns contents of editMuFOPID1 as a double



% --- Executes during object creation, after setting all properties.
function editMuFOPID1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMuFOPID1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonRunFOPID1.
function pushbuttonRunFOPID1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonRunFOPID1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~(handles.flagPoint1)
    warndlg('\fontsize{10} Please choose the correct fixed-point !', 'Warning', handles.opts);
    return;
end
colorRunFOPID1  = get(handles.pushbuttonRunFOPID1, 'backgroundcolor');
stringRunFOPID1 = get(handles.pushbuttonRunFOPID1, 'string');
set(handles.pushbuttonRunFOPID1, 'enable', 'off');
set(handles.pushbuttonRunFOPID1, 'backgroundcolor', handles.color.run);
set(handles.pushbuttonRunFOPID1, 'string', handles.run);
pause(1e-1);

try
    r1 = str2double(get(handles.editR1FOPID1, 'string'));   % 读取参数
    r2 = str2double(get(handles.editR2FOPID1, 'string'));
    mu = str2double(get(handles.editMuFOPID1, 'string'));
    handles.strFOPID1 = [' and r2 = ',num2str(r2),', \mu = ',num2str(mu)];
    % 控制器表达式 C(s) = Kp(1 + 1/(Ti*s^lambda) + Td*s^mu)
    [Kp,Ti,Td,lambda] = function_FOPID(handles.selectPoint1,r1,r2,mu,handles.Kc,handles.Tc);
catch
    errordlg('\fontsize{10} The input r_1, r_2 or \mu is not suitable !', 'ERROR', handles.opts);
    set(handles.pushbuttonRunFOPID1, 'backgroundcolor', colorRunFOPID1);
    set(handles.pushbuttonRunFOPID1, 'string', stringRunFOPID1);
    set(handles.pushbuttonRunFOPID1, 'enable', 'on');
    return;
end
try
    optionsFOPID1 = simset('SrcWorkspace', 'current');
    % 控制器表达式转换 C(s) = kp + ki/s^lambda + kd*s^mu)
    kpo = Kp;
    kio = Kp/Ti;
    kdo = Kp*Td;
    ifo = ousta_fod(-lambda,10,1e-5,1e+5);               % integral
    dfo = ousta_fod(mu,10,1e-5,1e+5);                    % differential
    Gc  = kpo + kio*ifo + kdo*dfo;
    
    set(handles.textKpFOPID1, 'string', num2str(kpo,'%.4f'));                   % 显示控制器
    set(handles.textKiFOPID1, 'string', num2str(kio,'%.4f'));
    set(handles.textKdFOPID1, 'string', num2str(kdo,'%.4f'));
    set(handles.textLamFOPID1,'string', num2str(lambda,'%.2f'));
    set(handles.textMuFOPID1, 'string', num2str(mu,'%.2f'));
    
    Ls = handles.GpLa * Gc;                                                     % 画 Nyquist 图参数
    if handles.flagW
        [handles.ReNyquistFOPID1,handles.ImNyquistFOPID1, ~]  =  nyquist(Ls, handles.w);
    else
        [handles.ReNyquistFOPID1,handles.ImNyquistFOPID1]  =  nyquist(Ls);
    end
    
    [~,handles.PmFOPID1,~,handles.WgcFOPID1] = margin(Ls);
    
    open_system('Model_ZN_FOPID','loadonly');
    Ga  = handles.Ga;                                                           % 仿真参数初始化
    Gp  = handles.Gp;
    L   = handles.L;
    Gp.iodelay = 0;
    
    step_value = handles.stepValue;
    sim_time   = handles.simTime;
    disturb_step_time  = handles.disTime;
    disturb_step_value = handles.disValue;
    
    warning off;
    sim('Model_ZN_FOPID.mdl',sim_time, optionsFOPID1);
    close_system('Model_ZN_FOPID', 0);
    
    handles.timeFOPID1 = time;                                                  % 仿真结果, 传递全局变量
    handles.outFOPID1  = FOPID_out;
    handles.FOPID1     = Gc;
    
    handles.flagFOPID1    = true;                                               % FOPID2 部分，状态参数更新
    handles.flagRunFOPID1 = true;
    guidata(hObject, handles);
catch
    errordlg('\fontsize{10} Please check the entered simulation parameters or the model "Model\_ZN\_FOPID.mdl" !', 'ERROR', handles.opts);
end

set(handles.pushbuttonRunFOPID1, 'backgroundcolor', colorRunFOPID1);
set(handles.pushbuttonRunFOPID1, 'string', stringRunFOPID1);
set(handles.pushbuttonRunFOPID1, 'enable', 'on');





% ......................................................................... %
% ............................... FOPID 2 ................................. %
% ......................................................................... %

% --- Executes on button press in checkboxFOPID2.
function checkboxFOPID2_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxFOPID2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxFOPID2

if get(handles.checkboxFOPID2, 'value')
    if handles.flagRunFOPID2
        handles.flagFOPID2 = true;
    end
    set(handles.popupmenuPoint2,     'enable', 'on');
    set(handles.editR1FOPID2,        'enable', 'on');
    set(handles.editR2FOPID2,        'enable', 'on');
    set(handles.editMuFOPID2,        'enable', 'on');
    set(handles.pushbuttonRunFOPID2, 'enable', 'on');
    set(handles.uipanelFOPID2, 'foregroundcolor',handles.color.FOPID2);
    set(handles.uipanelFOPID2, 'highlightcolor', handles.color.FOPID2);
    set(handles.uipanelFOPID2, 'shadowcolor',    handles.color.FOPID2);
else
    handles.flagFOPID2 = false;
    guidata(hObject,  handles);
    set(handles.popupmenuPoint2,     'enable', 'off');
    set(handles.editR1FOPID2,        'enable', 'off');
    set(handles.editR2FOPID2,        'enable', 'off');
    set(handles.editMuFOPID2,        'enable', 'off');
    set(handles.pushbuttonRunFOPID2, 'enable', 'off');
    set(handles.uipanelFOPID2, 'foregroundcolor', handles.color.defaultForeground);
    set(handles.uipanelFOPID2, 'highlightcolor',  handles.color.defaultHighlight);
    set(handles.uipanelFOPID2, 'shadowcolor',     handles.color.defaultShadow);
end
guidata(hObject, handles);


% --- Executes on selection change in popupmenuPoint2.
function popupmenuPoint2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuPoint2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuPoint2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuPoint2

point2 = get(handles.popupmenuPoint2, 'value');
switch point2
    case 1
        warndlg('\fontsize{10} Please choose the correct fixed-point !', 'Warning', handles.opts);
        handles.flagPoint2 = false;
        guidata(hObject, handles);
        return;
    case 2
        handles.selectPoint2 = true;
        handles.strPoint2 = 'new ZN-point';
    case 3
        handles.selectPoint2 = false;
        handles.strPoint2 = 'ZN-point';
end
if ~(handles.flagPoint2)
    handles.flagPoint2 = true;
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenuPoint2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuPoint2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editR1FOPID2_Callback(hObject, eventdata, handles)
% hObject    handle to editR1FOPID2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editR1FOPID2 as text
%        str2double(get(hObject,'String')) returns contents of editR1FOPID2 as a double


% --- Executes during object creation, after setting all properties.
function editR1FOPID2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editR1FOPID2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editR2FOPID2_Callback(hObject, eventdata, handles)
% hObject    handle to editR2FOPID2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editR2FOPID2 as text
%        str2double(get(hObject,'String')) returns contents of editR2FOPID2 as a double


% --- Executes during object creation, after setting all properties.
function editR2FOPID2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editR2FOPID2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editMuFOPID2_Callback(hObject, eventdata, handles)
% hObject    handle to editMuFOPID2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMuFOPID2 as text
%        str2double(get(hObject,'String')) returns contents of editMuFOPID2 as a double



% --- Executes during object creation, after setting all properties.
function editMuFOPID2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMuFOPID2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonRunFOPID2.
function pushbuttonRunFOPID2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonRunFOPID2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~(handles.flagPoint2)
    warndlg('\fontsize{10} Please choose the correct fixed-point !', 'Warning', handles.opts);
    return;
end
colorRunFOPID2  = get(handles.pushbuttonRunFOPID2, 'backgroundcolor');
stringRunFOPID2 = get(handles.pushbuttonRunFOPID2, 'string');
set(handles.pushbuttonRunFOPID2, 'enable', 'off');
set(handles.pushbuttonRunFOPID2, 'backgroundcolor', handles.color.run);
set(handles.pushbuttonRunFOPID2, 'string', handles.run);
pause(1e-1);

try
    r1 = str2double(get(handles.editR1FOPID2, 'string'));
    r2 = str2double(get(handles.editR2FOPID2, 'string'));
    mu = str2double(get(handles.editMuFOPID2, 'string'));
    handles.strFOPID2 = [' and r2 = ',num2str(r2),', \mu = ',num2str(mu)];
    % 控制器表达式 C(s) = Kp(1 + 1/(Ti*s^lambda) + Td*s^mu)
    [Kp,Ti,Td,lambda] = function_FOPID(handles.selectPoint2,r1,r2,mu,handles.Kc,handles.Tc);
catch
    errordlg('\fontsize{10} The input r_1, r_2 or \mu is not suitable !', 'ERROR', handles.opts);
    set(handles.pushbuttonRunFOPID2, 'backgroundcolor', colorRunFOPID2);
    set(handles.pushbuttonRunFOPID2, 'string', stringRunFOPID2);
    set(handles.pushbuttonRunFOPID2, 'enable', 'on');
    return;
end
try
    optionsFOPID2 = simset('SrcWorkspace', 'current');
    % 控制器表达式转换 C(s) = kp + ki/s^lambda + kd*s^mu)
    kpo = Kp;
    kio = Kp/Ti;
    kdo = Kp*Td;
    ifo = ousta_fod(-lambda,10,1e-5,1e+5);               % integral
    dfo = ousta_fod(mu,10,1e-5,1e+5);                    % differential
    Gc  = kpo + kio*ifo + kdo*dfo;
    
    set(handles.textKpFOPID2, 'string', num2str(kpo,'%.4f'));                   % 显示控制器
    set(handles.textKiFOPID2, 'string', num2str(kio,'%.4f'));
    set(handles.textKdFOPID2, 'string', num2str(kdo,'%.4f'));
    set(handles.textLamFOPID2,'string', num2str(lambda,'%.2f'));
    set(handles.textMuFOPID2, 'string', num2str(mu,'%.2f'));
    
    Ls = handles.GpLa * Gc;                                                     % 画 Nyquist 图参数
    if handles.flagW
        [handles.ReNyquistFOPID2,handles.ImNyquistFOPID2, ~]  =  nyquist(Ls, handles.w);
    else
        [handles.ReNyquistFOPID2,handles.ImNyquistFOPID2]  =  nyquist(Ls);
    end
    
    [~,handles.PmFOPID2,~,handles.WgcFOPID2] = margin(Ls);
    
    Ga  = handles.Ga;                                                           % 仿真参数初始化
    Gp  = handles.Gp;
    L   = handles.L;
    Gp.iodelay = 0;
    
    step_value = handles.stepValue;
    sim_time   = handles.simTime;
    disturb_step_time  = handles.disTime;
    disturb_step_value = handles.disValue;
    
    warning off;
    open_system('Model_ZN_FOPID','loadonly');
    sim('Model_ZN_FOPID.mdl',sim_time, optionsFOPID2);
    close_system('Model_ZN_FOPID', 0);
    
    handles.timeFOPID2 = time;                                                  % 仿真结果, 传递全局变量
    handles.outFOPID2  = FOPID_out;
    handles.FOPID2     = Gc;
    
    handles.flagFOPID2    = true;                                               % FOPID2 部分，状态参数更新
    handles.flagRunFOPID2 = true;
    guidata(hObject, handles);
catch
    errordlg('\fontsize{10} Please check the entered simulation parameters or the model "Model\_ZN\_FOPID.mdl" !', 'ERROR', handles.opts);
end
set(handles.pushbuttonRunFOPID2, 'backgroundcolor', colorRunFOPID2);
set(handles.pushbuttonRunFOPID2, 'string', stringRunFOPID2);
set(handles.pushbuttonRunFOPID2, 'enable', 'on');





% ......................................................................... %
% ................................ ZNPID .................................. %
% ......................................................................... %

% --- Executes on button press in checkboxZNPID.
function checkboxZNPID_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxZNPID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxZNPID

if get(handles.checkboxZNPID, 'value')
    if handles.flagRunZNPID
        handles.flagZNPID = true;
    end
    set(handles.pushbuttonRunZNPID, 'enable', 'on');
    set(handles.uipanelZNPID, 'foregroundcolor', handles.color.ZNPID);
    set(handles.uipanelZNPID, 'highlightcolor',  handles.color.ZNPID);
    set(handles.uipanelZNPID, 'shadowcolor',     handles.color.ZNPID);
else
    handles.flagZNPID = false;
    set(handles.pushbuttonRunZNPID, 'enable', 'off');
    set(handles.uipanelZNPID, 'foregroundcolor', handles.color.defaultForeground);
    set(handles.uipanelZNPID, 'highlightcolor',  handles.color.defaultHighlight);
    set(handles.uipanelZNPID, 'shadowcolor',     handles.color.defaultShadow);
end
guidata(hObject, handles);


% --- Executes on button press in pushbuttonRunZNPID.
function pushbuttonRunZNPID_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonRunZNPID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colorRunZNPID  = get(handles.pushbuttonRunZNPID, 'backgroundcolor');
stringRunZNPID = get(handles.pushbuttonRunZNPID, 'string');
set(handles.pushbuttonRunZNPID, 'enable', 'off');
set(handles.pushbuttonRunZNPID, 'backgroundcolor', handles.color.run);
set(handles.pushbuttonRunZNPID, 'string', handles.run);
pause(1e-1);
% 
try
    % 控制器表达式 C(s) = Kp(1 + 1/(Ti*s) + Td*s)
    if (handles.flagFOPDT)
        ZN_Kp = (1.2 * handles.T) / (handles.K * handles.L);
        ZN_Ti = 2 * handles.L;
        ZN_Td = 0.5 * handles.L;
    else
        Kc = handles.Kc;
        Tc = handles.Tc;
        
        ZN_Kp = 0.6*Kc;                                                             % 计算 ZNPID 控制器
        ZN_Ti = 0.5*Tc;
        ZN_Td = 0.125*Tc;
    end
    optionsZNPID = simset('SrcWorkspace', 'current');
    s  = tf('s');
    % 控制器表达式转换 C(s) = kp + ki/s + kd*s)
    ZN_kpo = ZN_Kp;
    ZN_kio = ZN_Kp/ZN_Ti;
    ZN_kdo = ZN_Kp*ZN_Td;
    ZN_Gc  = ZN_Kp*(1 + 1/(ZN_Ti*s) + ZN_Td*s);
    
    set(handles.textKpZNPID, 'string', num2str(ZN_kpo,'%.4f'));                 % 显示控制器
    set(handles.textKiZNPID, 'string', num2str(ZN_kio,'%.4f'));
    set(handles.textKdZNPID, 'string', num2str(ZN_kdo,'%.4f'));
    
    Ls = handles.GpLa * ZN_Gc;                                                  % 画 Nyquist 图参数
    if handles.flagW
        [handles.ReNyquistZNPID,handles.ImNyquistZNPID, ~]  =  nyquist(Ls, handles.w);
    else
        [handles.ReNyquistZNPID,handles.ImNyquistZNPID]  =  nyquist(Ls);
    end
    
    [~,handles.PmZNPID,~,handles.WgcZNPID] = margin(Ls);
    
    Gp  = handles.Gp;                                                           % 仿真参数初始化
    L   = handles.L;
    Gp.iodelay = 0;
    
    step_value = handles.stepValue;
    sim_time   = handles.simTime;
    disturb_step_time  = handles.disTime;
    disturb_step_value = handles.disValue;
    
    warning off;
    open_system('Model_ZN_PID','loadonly');
    sim('Model_ZN_PID.mdl',sim_time, optionsZNPID);
    close_system('Model_ZN_PID',0);
    
    handles.timeZNPID = time;                                                   % 仿真结果, 传递全局变量
    handles.outZNPID  = ZNPID_out;
    handles.ZNPID     = ZN_Gc;
    
    handles.flagZNPID    = true;                                                % ZNPID 部分，状态参数更新
    handles.flagRunZNPID = true;
    guidata(hObject, handles);
catch
    errordlg('\fontsize{10} Please check the entered simulation parameters or the model "Model\_ZN\_PID.mdl" !', 'ERROR', handles.opts);
end

set(handles.pushbuttonRunZNPID, 'backgroundcolor', colorRunZNPID);
set(handles.pushbuttonRunZNPID, 'string', stringRunZNPID);
set(handles.pushbuttonRunZNPID, 'enable', 'on');





% ......................................................................... %
% ............................... RZNPID .................................. %
% ......................................................................... %

% --- Executes on button press in checkboxRZNFOPID.
function checkboxRZNFOPID_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxRZNFOPID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxRZNFOPID

if get(handles.checkboxRZNFOPID, 'value')
    if handles.flagRunRZNFOPID
        handles.flagRZNFOPID = true;
    end
    set(handles.editLamRZNFOPID,       'enable', 'on');
    set(handles.pushbuttonRunRZNFOPID, 'enable', 'on');
    set(handles.uipanelRZNFOPID, 'foregroundcolor', handles.color.RZNFOPID);
    set(handles.uipanelRZNFOPID, 'highlightcolor',  handles.color.RZNFOPID);
    set(handles.uipanelRZNFOPID, 'shadowcolor',     handles.color.RZNFOPID);
else
    handles.flagRZNFOPID = false;
    set(handles.editLamRZNFOPID,       'enable', 'off');
    set(handles.pushbuttonRunRZNFOPID, 'enable', 'off');
    set(handles.uipanelRZNFOPID, 'foregroundcolor', handles.color.defaultForeground);
    set(handles.uipanelRZNFOPID, 'highlightcolor',  handles.color.defaultHighlight);
    set(handles.uipanelRZNFOPID, 'shadowcolor',     handles.color.defaultShadow);
end
guidata(hObject, handles);


function editLamRZNFOPID_Callback(hObject, eventdata, handles)
% hObject    handle to editLamRZNFOPID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editLamRZNFOPID as text
%        str2double(get(hObject,'String')) returns contents of editLamRZNFOPID as a double


% --- Executes during object creation, after setting all properties.
function editLamRZNFOPID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editLamRZNFOPID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonRunRZNFOPID.
function pushbuttonRunRZNFOPID_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonRunRZNFOPID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colorRunRZNFOPID  = get(handles.pushbuttonRunRZNFOPID, 'backgroundcolor');
stringRunRZNFOPID = get(handles.pushbuttonRunRZNFOPID, 'string');
set(handles.pushbuttonRunRZNFOPID, 'enable', 'off');
set(handles.pushbuttonRunRZNFOPID, 'backgroundcolor', handles.color.run);
set(handles.pushbuttonRunRZNFOPID, 'string', handles.run);
pause(1e-1);

try
    RZN_lambda = str2double(get(handles.editLamRZNFOPID, 'string'));            % 读取 lambda 的值
    handles.strRZNFOPID = [' \lambda = ',num2str(RZN_lambda)];
    % 控制器表达式 C(s) = Kp(1 + 1/(Ti*s^lambda) + Td*s^lambda)
    [RZN_Kp,RZN_Ti,RZN_Td] = function_RZNFOPID(RZN_lambda,handles.Kc,handles.Tc);% 计算 RZNFOPID 控制器
catch
    errordlg('\fontsize{10} The input \lambda is not suitable !', 'ERROR', handles.opts);
    set(handles.pushbuttonRunRZNFOPID, 'backgroundcolor', colorRunRZNFOPID);
    set(handles.pushbuttonRunRZNFOPID, 'string', stringRunRZNFOPID);
    set(handles.pushbuttonRunRZNFOPID, 'enable', 'on');
    return;
end
try
    optionsRZNFOPID = simset('SrcWorkspace', 'current');
    % 控制器表达式转换 C(s) = kp + ki/s^lambda + kd*s^lambda)
    RZN_kpo = RZN_Kp;
    RZN_kio = RZN_Kp/RZN_Ti;
    RZN_kdo = RZN_Kp*RZN_Td;
    dfod    = ousta_fod(RZN_lambda,10,1e-5,1e+5);                               % s^lambda
    ifod    = ousta_fod(-RZN_lambda,10,1e-5,1e+5);                              % s^-lambda
    RZN_Gc  = RZN_Kp*(1 + (1/RZN_Ti)*ifod + RZN_Td*dfod);
    
    set(handles.textKpRZNFOPID, 'string', num2str(RZN_kpo,'%.4f'));             % 显示控制器
    set(handles.textKiRZNFOPID, 'string', num2str(RZN_kio,'%.4f'));
    set(handles.textKdRZNFOPID, 'string', num2str(RZN_kdo,'%.4f'));
    set(handles.textLamRZNFOPID,'string', num2str(RZN_lambda,'%.4f'));
    set(handles.textMuRZNFOPID, 'string', num2str(RZN_lambda,'%.4f'));
    
    Ls = handles.GpLa * RZN_Gc;                                                 % 画 Nyquist 图参数
    if handles.flagW
        [handles.ReNyquistRZNFOPID,handles.ImNyquistRZNFOPID,~] = nyquist(Ls, handles.w);
    else
        [handles.ReNyquistRZNFOPID,handles.ImNyquistRZNFOPID] = nyquist(Ls);
    end
    
    [~,handles.PmRZNFOPID,~,handles.WgcRZNFOPID] = margin(Ls);
    
    Gp  = handles.Gp;                                                           % 仿真参数初始化
    L   = handles.L;
    Gp.iodelay = 0;
    step_value = handles.stepValue;
    sim_time   = handles.simTime;
    disturb_step_time  = handles.disTime;
    disturb_step_value = handles.disValue;
    
    warning off;
    open_system('Model_RZN_FOPID','loadonly');
    sim('Model_RZN_FOPID.mdl',sim_time, optionsRZNFOPID);
    close_system('Model_RZN_FOPID',0);
    handles.timeRZNFOPID = time;                                                % 仿真结果, 传递全局变量
    handles.outRZNFOPID  = RZN_FOPID_out;
    handles.RZNFOPID     = RZN_Gc;
    
    handles.flagRZNFOPID    = true;                                             % RZNFOPID 部分，状态参数更新
    handles.flagRunRZNFOPID = true;
    guidata(hObject, handles);
catch
    errordlg('\fontsize{10} Please check the entered simulation parameters or the model "Model\_RZN\_FOPID.mdl" !', 'ERROR', handles.opts);
end

set(handles.pushbuttonRunRZNFOPID, 'backgroundcolor', colorRunRZNFOPID);
set(handles.pushbuttonRunRZNFOPID, 'string', stringRunRZNFOPID);
set(handles.pushbuttonRunRZNFOPID, 'enable', 'on');





% ......................................................................... %
% ............................ P lambda ID ................................ %
% ......................................................................... %

% --- Executes on button press in checkboxPILamD.
function checkboxPILamD_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxPILamD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxPILamD

if get(handles.checkboxPILamD, 'value')
    if handles.flagRunPILamD
        handles.flagPILamD = true;
    end
    set(handles.editWcPILamD,        'enable', 'on');
    set(handles.editPMPILamD,        'enable', 'on');
    set(handles.popupmenuPILamD,     'enable', 'on');
    set(handles.pushbuttonRunPILamD, 'enable', 'on');
    set(handles.uipanelPILamD, 'foregroundcolor', handles.color.PILamD);
    set(handles.uipanelPILamD, 'highlightcolor',  handles.color.PILamD);
    set(handles.uipanelPILamD, 'shadowcolor',     handles.color.PILamD);
else
    handles.flagPILamD = false;
    set(handles.editWcPILamD,        'enable', 'off');
    set(handles.editPMPILamD,        'enable', 'off');
    set(handles.popupmenuPILamD,     'enable', 'off');
    set(handles.pushbuttonRunPILamD, 'enable', 'off');
    set(handles.uipanelPILamD, 'foregroundcolor', handles.color.defaultForeground);
    set(handles.uipanelPILamD, 'highlightcolor',  handles.color.defaultHighlight);
    set(handles.uipanelPILamD, 'shadowcolor',     handles.color.defaultShadow);
end
guidata(hObject,  handles);


% --- Executes on selection change in popupmenuPILamD.
function popupmenuPILamD_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuPILamD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuPILamD contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuPILamD

try
    controllerSelect = get(handles.popupmenuPILamD, 'value');
    switch controllerSelect
        case 1
%             warndlg('\fontsize{10} Please select a controller for comparison !', 'Warning', handles.opts);
            set(handles.editWcPILamD, 'string', '');
            set(handles.editPMPILamD, 'string', '');
            return;
        case 2
            set(handles.editWcPILamD, 'string', num2str(handles.WgcFOPID1,'%.2f'));
            set(handles.editPMPILamD, 'string', num2str(handles.PmFOPID1, '%.1f'));
        case 3
            set(handles.editWcPILamD, 'string', num2str(handles.WgcFOPID2,'%.2f'));
            set(handles.editPMPILamD, 'string', num2str(handles.PmFOPID2, '%.1f'));
        case 4
            set(handles.editWcPILamD, 'string', num2str(handles.WgcZNPID,'%.2f'));
            set(handles.editPMPILamD, 'string', num2str(handles.PmZNPID, '%.1f'));
        case 5
            set(handles.editWcPILamD, 'string', num2str(handles.WgcRZNFOPID,'%.2f'));
            set(handles.editPMPILamD, 'string', num2str(handles.PmRZNFOPID, '%.1f'));
    end
catch
    set(handles.popupmenuPILamD, 'value', 1);
    warndlg('\fontsize{10} Please run the selected controller before this operation !', 'Warning', handles.opts);
end



% --- Executes during object creation, after setting all properties.
function popupmenuPILamD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuPILamD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editWcPILamD_Callback(hObject, eventdata, handles)
% hObject    handle to editWcPILamD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editWcPILamD as text
%        str2double(get(hObject,'String')) returns contents of editWcPILamD as a double


% --- Executes during object creation, after setting all properties.
function editWcPILamD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editWcPILamD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editPMPILamD_Callback(hObject, eventdata, handles)
% hObject    handle to editPMPILamD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPMPILamD as text
%        str2double(get(hObject,'String')) returns contents of editPMPILamD as a double


% --- Executes during object creation, after setting all properties.
function editPMPILamD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPMPILamD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonRunPILamD.
function pushbuttonRunPILamD_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonRunPILamD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Wc = str2double(get(handles.editWcPILamD, 'string'));                   % gain crossover frequency
PM = str2double(get(handles.editPMPILamD, 'string'));                   % phase margin
if (isnan(Wc) || isnan(PM))
    errordlg('\fontsize{10} \omega_{gc} or PM entered incorrectly !', 'ERROR', handles.opts);
    return;
end

colorRunPILamD  = get(handles.pushbuttonRunPILamD, 'backgroundcolor');
stringRunPILamD = get(handles.pushbuttonRunPILamD, 'string');
set(handles.pushbuttonRunPILamD, 'enable', 'off');
set(handles.pushbuttonRunPILamD, 'backgroundcolor', handles.color.run);
set(handles.pushbuttonRunPILamD, 'string', handles.run);
pause(1e-1);

try
    optionsPILamD = simset('SrcWorkspace', 'current');
    Gp = handles.Gp;
    L  = handles.L;
    
    Wc = str2double(get(handles.editWcPILamD, 'string'));                   % gain crossover frequency
    PM = str2double(get(handles.editPMPILamD, 'string'));                   % phase margin
    % 控制器表达式 C(s) = kp + ki/s^lambda + kd*s
    [kp,ki,kd,lambda] = function_PI_lambdaD(handles.K,handles.T,L,Wc,PM);
catch
    errordlg('\fontsize{10} Error in "function_PI_lambdaD.m" !', 'ERROR', handles.opts);
    set(handles.pushbuttonRunPILamD, 'backgroundcolor', colorRunPILamD);
    set(handles.pushbuttonRunPILamD, 'string', stringRunPILamD);
    set(handles.pushbuttonRunPILamD, 'enable', 'on');
    return;
end
try
    handles.strPILamD = [' \lambda = ',num2str(lambda)];
    
    set(handles.textKpPILamD, 'string', num2str(kp,'%.4f'));                % 显示控制器
    set(handles.textKiPILamD, 'string', num2str(ki,'%.4f'));
    set(handles.textKdPILamD, 'string', num2str(kd,'%.4f'));
    set(handles.textLamPILamD,'string', num2str(lambda,'%.4f'));
    
    ifod = ousta_fod(-lambda,10,1e-5,1e+5);                                 % s^lambda
    Gc   = kp + ki*ifod + kd;
    Ls   = handles.GpLa * Gc;                                                 % 画 Nyquist 图参数
    if handles.flagW
        [handles.ReNyquistPILamD,handles.ImNyquistPILamD,~] = nyquist(Ls, handles.w);
    else
        [handles.ReNyquistPILamD,handles.ImNyquistPILamD] = nyquist(Ls);
    end
    
    T_s = 1/2000;
    if (lambda >= 1)
        dfod = irid_fod(-lambda+1, T_s, 5);
    else
        dfod = irid_fod(-lambda, T_s, 5);
    end
    Gp.iodelay = 0;                                                             % 仿真参数初始化
    step_value = handles.stepValue;
    sim_time   = handles.simTime;
    disturb_step_time  = handles.disTime;
    disturb_step_value = handles.disValue;
    
    warning off;
    open_system('Model_PI_lambdaD','loadonly');
    sim('Model_PI_lambdaD.mdl',sim_time, optionsPILamD);
    close_system('Model_PI_lambdaD',0);
    clc;
    
    handles.timePILamD = time;                                                  % 仿真结果, 传递全局变量
    handles.outPILamD  = PILamD_out;
    handles.PILamD     = Gc;
    
    handles.flagPILamD = true;
    handles.flagRunPILamD = true;
    guidata(hObject, handles);
catch
    errordlg('\fontsize{10} Please check the entered simulation parameters or the model "Model\_PI\_lambdaD.mdl" !', 'ERROR', handles.opts);
end

set(handles.pushbuttonRunPILamD, 'backgroundcolor', colorRunPILamD);
set(handles.pushbuttonRunPILamD, 'string', stringRunPILamD);
set(handles.pushbuttonRunPILamD, 'enable', 'on');


% ......................................................................... %
% ............................. Function. ................................. %
% ......................................................................... %

% --- Executes on button press in pushbuttonNyquist.
function pushbuttonNyquist_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonNyquist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colorNyquist = get(handles.pushbuttonNyquist, 'backgroundcolor');
stringNyquist = get(handles.pushbuttonNyquist, 'string');
set(handles.pushbuttonNyquist, 'enable', 'off');
set(handles.pushbuttonNyquist, 'backgroundcolor', handles.color.run);
set(handles.pushbuttonNyquist, 'string', handles.run);
pause(1e-1);

figure('Name', 'Nyquist Diagram');                                          % Nyquist Diagram
hold on;
grid on;
% title('Nyquist diagram of open-loop system for different controllers','FontName','Times New Roman','FontSize',15);
xlabel('Real','FontName','Times New Roman','FontSize',15);
ylabel('Imag','FontName','Times New Roman','FontSize',15);
axis([-1.2 0.2 -1.5 0.5]);

if handles.flagZNPID
    plot(squeeze(handles.ReNyquistZNPID), squeeze(handles.ImNyquistZNPID), ...
        'Color',handles.color.ZNPID, 'LineWidth',2, 'DisplayName','ZN-PID');
end
if handles.flagRZNFOPID
    plot(squeeze(handles.ReNyquistRZNFOPID), squeeze(handles.ImNyquistRZNFOPID), ...
        'Color',handles.color.RZNFOPID, 'LineWidth',2, ...
        'DisplayName',['PI^{\lambda}D^{\lambda}: ', handles.strRZNFOPID]);
end
if handles.flagPILamD
    plot(squeeze(handles.ReNyquistPILamD), squeeze(handles.ImNyquistPILamD), ...
        'Color',handles.color.PILamD, 'LineWidth',2, ...
        'DisplayName',['PI^{\lambda}D: ', handles.strPILamD]);
end
flagNewZNPointFOPID1 = false;
flagZNPointFOPID1    = false;
if handles.flagFOPID1
    plot(squeeze(handles.ReNyquistFOPID1), squeeze(handles.ImNyquistFOPID1), ...
        'Color',handles.color.FOPID1, 'LineWidth',2, ...
        'DisplayName',['ZN-PI^{\lambda}D^{\mu}1: ', handles.strPoint1,handles.strFOPID1]);
    if handles.selectPoint1
        flagNewZNPointFOPID1 = true;
    else
        flagZNPointFOPID1    = true;
    end
end
flagNewZNPointFOPID2 = false;
flagZNPointFOPID2    = false;
if handles.flagFOPID2
    plot(squeeze(handles.ReNyquistFOPID2), squeeze(handles.ImNyquistFOPID2), ...
        'Color',handles.color.FOPID2, 'LineWidth',2, ...
        'DisplayName',['ZN-PI^{\lambda}D^{\mu}2: ', handles.strPoint2,handles.strFOPID2]);
    if handles.selectPoint2
        flagNewZNPointFOPID2 = true;
    else
        flagZNPointFOPID2    = true;
    end
end

if handles.flagZNPID || handles.flagRZNFOPID || flagZNPointFOPID1 || flagZNPointFOPID2
    plot(-0.6,-0.6*(-1/(2*pi*0.5)+0.125*2*pi), '.k', 'MarkerSize',25, 'LineWidth',2, 'DisplayName','ZN-point');
end
if flagNewZNPointFOPID1 || flagNewZNPointFOPID2
    plot(-0.5,-0.5*(-1/(2*pi*0.5)+0.125*2*pi), '.r', 'MarkerSize',25, 'LineWidth',2, 'DisplayName','New ZN-point');
end
legend;
hold off;

set(handles.pushbuttonNyquist, 'backgroundcolor', colorNyquist);
set(handles.pushbuttonNyquist, 'string', stringNyquist);
set(handles.pushbuttonNyquist, 'enable', 'on');


% --- Executes on button press in pushbuttonTimeResponse.
function pushbuttonTimeResponse_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonTimeResponse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

colorTime  = get(handles.pushbuttonTimeResponse, 'backgroundcolor');
stringTime = get(handles.pushbuttonTimeResponse, 'string');
set(handles.pushbuttonTimeResponse, 'enable', 'off');
set(handles.pushbuttonTimeResponse, 'backgroundcolor', handles.color.run);
set(handles.pushbuttonTimeResponse, 'string', handles.run);
pause(1e-1);

figure('Name', 'Time Response');                                            % Time Response Diagram
hold on;
% title('Step response of closed-loop system for different controllers','FontName','Times New Roman','FontSize',15);
xlabel('Time (s)',     'FontName','Times New Roman','FontSize',15);
ylabel('Step response','FontName','Times New Roman','FontSize',15);
plot([0, handles.simTime], [handles.stepValue, handles.stepValue], ...
    '--k', 'LineWidth',2, 'DisplayName','Input');
if handles.flagZNPID
     plot(handles.timeZNPID, handles.outZNPID, ...
         'Color',handles.color.ZNPID, 'LineWidth',2, 'DisplayName','ZN-PID');
end
if handles.flagRZNFOPID
    plot(handles.timeRZNFOPID, handles.outRZNFOPID, ...
        'Color',handles.color.RZNFOPID, 'LineWidth',2, ...
        'DisplayName',['PI^{\lambda}D^{\lambda}: ', handles.strRZNFOPID]);
end
if handles.flagPILamD
    plot(handles.timePILamD, handles.outPILamD, ...
        'Color',handles.color.PILamD, 'LineWidth',2, ...
        'DisplayName',['PI^{\lambda}D: ', handles.strPILamD]);
end
if handles.flagFOPID1
    plot(handles.timeFOPID1, handles.outFOPID1, ...
        'Color',handles.color.FOPID1, 'LineWidth',2, ...
        'DisplayName',['ZN-PI^{\lambda}D^{\mu}1: ', handles.strPoint1,handles.strFOPID1]);
end
if handles.flagFOPID2
    plot(handles.timeFOPID2, handles.outFOPID2, ...
        'Color',handles.color.FOPID2, 'LineWidth',2, ...
        'DisplayName',['ZN-PI^{\lambda}D^{\mu}2: ', handles.strPoint2,handles.strFOPID2]);
end
legend;
hold off;

set(handles.pushbuttonTimeResponse, 'backgroundcolor', colorTime);
set(handles.pushbuttonTimeResponse, 'string', stringTime);
set(handles.pushbuttonTimeResponse, 'enable', 'on');


% --- Executes on button press in pushbuttonRest.
function pushbuttonRest_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonRest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbuttonRest, 'enable', 'off');
opts.Interpreter = 'tex';
opts.Default = 'No';
clear_choice = questdlg('\fontsize{10} Clear all records?', 'Warning', 'Yes', 'No', opts);
switch clear_choice
    case 'No'
        set(handles.pushbuttonRest, 'enable', 'on');
        return;
    case 'Yes'
end
% ........................... Controlled Plant ............................ %
set(handles.editNs, 'string', '[ N(s) ]');
set(handles.editMs, 'string', '[ M(s) ]');
set(handles.editN,  'string', 'n');
set(handles.editL,  'string', 'L');
% ........................ Simulation Parameters .......................... %
set(handles.editStepValue, 'string', '1');
set(handles.editDisValue,  'string', '0.5');
set(handles.editSimTime,   'string', '100');
set(handles.editDisTime,   'string', '50');
% ............................ Compensator ................................ %
set(handles.popupmenuTa,        'value', 1);
set(handles.checkboxCompensator,'value', 0);
checkboxCompensator_Callback(hObject, eventdata, handles);
set(handles.textGa,             'string', 'Ga(s) = ');
set(handles.textCompensatorNum, 'string', '( s / Ta + 1 )');
set(handles.textCompensatorN,   'string', 'n');
set(handles.textFrac,           'string', '——————————————————');
set(handles.textCompensatorDen, 'string', '( Ta s + 1 )');
set(handles.textCompensatorM,   'string', 'm');
set(handles.pushbuttonGa, 'backgroundcolor', handles.color.controller);
set(handles.pushbuttonGa, 'string', 'get Ga(s)');
% ................. Critical Oscillation Parameters ....................... %
set(handles.editKc, 'string', 'Kc');
set(handles.editTc, 'string', 'Tc');
set(handles.pushbuttonRelayTest, 'backgroundcolor', handles.color.controller);
set(handles.pushbuttonRelayTest, 'string', 'Relay Test');
% ............................... FOPID 1 ................................. %
set(handles.popupmenuPoint1, 'value', 1);
set(handles.checkboxFOPID1,  'value', 0);
checkboxFOPID1_Callback(hObject, eventdata, handles);
set(handles.checkboxFOPID1,'enable', 'off');
set(handles.editR1FOPID1,  'string', '4');
set(handles.editR2FOPID1,  'string', '1');
set(handles.editMuFOPID1,  'string', '1');
set(handles.textKpFOPID1,  'string', 'kp');
set(handles.textKiFOPID1,  'string', 'ki');
set(handles.textLamFOPID1, 'string', 'λ');
set(handles.textKdFOPID1,  'string', 'kd');
set(handles.textMuFOPID1,  'string', 'μ');
set(handles.pushbuttonRunFOPID1, 'backgroundcolor', handles.color.controller);
set(handles.pushbuttonRunFOPID1, 'string', handles.defaultRun);
% ............................... FOPID 2 ................................. %
set(handles.popupmenuPoint2, 'value', 1);
set(handles.checkboxFOPID2,  'value', 0);
checkboxFOPID2_Callback(hObject, eventdata, handles);
set(handles.checkboxFOPID2,'enable', 'off');
set(handles.editR1FOPID2,  'string', '4');
set(handles.editR2FOPID2,  'string', '1');
set(handles.editMuFOPID2,  'string', '1');
set(handles.textKpFOPID2,  'string', 'kp');
set(handles.textKiFOPID2,  'string', 'ki');
set(handles.textLamFOPID2, 'string', 'λ');
set(handles.textKdFOPID2,  'string', 'kd');
set(handles.textMuFOPID2,  'string', 'μ');
set(handles.pushbuttonRunFOPID2, 'backgroundcolor', handles.color.controller);
set(handles.pushbuttonRunFOPID2, 'string', handles.defaultRun);
% ................................ ZNPID .................................. %
set(handles.checkboxZNPID, 'value', 0);
checkboxZNPID_Callback(hObject, eventdata, handles);
set(handles.checkboxZNPID,'enable', 'off');
set(handles.textKpZNPID, 'string', 'kp');
set(handles.textKiZNPID, 'string', 'ki');
set(handles.textKdZNPID, 'string', 'kd');
set(handles.pushbuttonRunZNPID, 'backgroundcolor', handles.color.controller);
set(handles.pushbuttonRunZNPID, 'string', handles.defaultRun);
% ............................... RZNPID .................................. %
set(handles.checkboxRZNFOPID, 'value', 0);
checkboxRZNFOPID_Callback(hObject, eventdata, handles);
set(handles.checkboxRZNFOPID,'enable', 'off');
set(handles.editLamRZNFOPID, 'string', '1');
set(handles.textKpRZNFOPID,  'string', 'kp');
set(handles.textKiRZNFOPID,  'string', 'ki');
set(handles.textLamRZNFOPID, 'string', 'λ');
set(handles.textKdRZNFOPID,  'string', 'kd');
set(handles.textMuRZNFOPID,  'string', 'λ');
set(handles.pushbuttonRunRZNFOPID, 'backgroundcolor', handles.color.controller);
set(handles.pushbuttonRunRZNFOPID, 'string', handles.defaultRun);
% ............................ P lambda ID ................................ %
set(handles.checkboxPILamD, 'value', 0);
set(handles.popupmenuPILamD,'value', 1);
checkboxPILamD_Callback(hObject, eventdata, handles);
set(handles.checkboxPILamD, 'enable', 'off');
set(handles.editWcPILamD, 'string', '');
set(handles.editPMPILamD, 'string', '');
set(handles.textKpPILamD, 'string', 'kp');
set(handles.textKiPILamD, 'string', 'ki');
set(handles.textLamPILamD,'string', 'λ');
set(handles.textKdPILamD, 'string', 'kd');
set(handles.pushbuttonRunPILamD, 'backgroundcolor', handles.color.controller);
set(handles.pushbuttonRunPILamD, 'string', handles.defaultRun);
% .............................. Function ................................. %
set(handles.pushbuttonNyquist, 'backgroundcolor', handles.color.function);
set(handles.pushbuttonNyquist, 'string', 'Nyquist');
set(handles.pushbuttonTimeResponse, 'backgroundcolor', handles.color.function);
set(handles.pushbuttonTimeResponse, 'string', 'Time Response');
% ..................... Delete Process Variable ........................... %
clear handles;
global reset;
handles = reset;
guidata(hObject, handles);
clc;
set(handles.pushbuttonRest, 'enable', 'on');


% --- Executes on button press in pushbuttonSave.
function pushbuttonSave_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbuttonSave, 'enable', 'off');
set(gcf,'Units','Inches');              % 调整界面使其大小合适
pos = get(gcf,'Position');
set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])

[FileName, PathName, Fileindex] = uiputfile({'*.pdf', 'Portable Document Format (*.pdf)'; ...
    '*.bmp', 'Bitmap (*.bmp)'; ...
    '*.eps', 'EPS file (*.eps)'; ...
    '*.emf', 'Enhanced metafile (*.emf)'; ...
    '*.fig', 'MATLAB Figure (*.fig)'; ...
    '*.jpg', 'JPEG image (*.jpg)'; ...
    '*.pcx', 'Paintbrush 24-bit file (*.pcx)'; ...
    '*.pbm', 'Portable Bitmap file (*.pbm)'; ...
    '*.pgm', 'Portable Graymap file (*.pgm)'; ...
    '*.png', 'Portable Network Graphics (*.png)'; ...
    '*.ppm', 'Portable Pixmap file (*.ppm)'; ...
    '*.svg', 'Scalable Vector Graphics file (*.svg)'; ...
    '*.tif', 'TIFF image (*.tif)';...
    '*.tif', 'TIFF no compression image (*.tif)'} ,...
    'Save as', 'Untitled');

if  FileName ~= 0
    file = strcat(PathName,FileName);
    switch Fileindex                %根据不同的选择保存为不同的类型
        case 1
            print(gcf, file, '-dpdf', '-r0');
            fprintf('>>Saved to: %s\n',file);
        case 2
            print(gcf, file, '-dbmp', '-r0');
            fprintf('>>Saved to: %s\n',file);
        case 3
            print(gcf, file, '-depsc','-r0');
            fprintf('>>Saved to: %s\n',file);
        case 4
            print(gcf, file, '-dmeta','-r0');
            fprintf('>>Saved to: %s\n',file);
        case 5
            savefig(gcf, file);
            fprintf('>>Saved to: %s\n',file);
        case 6
            print(gcf, file, '-djpeg','-r0');
            fprintf('>>Saved to: %s\n',file);
        case 7
            print(gcf,file,'-dpcx24b','-r0');
            fprintf('>>Saved to: %s\n',file);
        case 8
            print(gcf, file, '-dpbm', '-r0');
            fprintf('>>Saved to: %s\n',file);
        case 9
            print(gcf, file, '-dpgm', '-r0');
            fprintf('>>Saved to: %s\n',file);
        case 10
            print(gcf, file, '-dpng', '-r0');
            fprintf('>>Saved to: %s\n',file);
        case 11
            print(gcf, file, '-dppm', '-r0');
            fprintf('>>Saved to: %s\n',file);
        case 12
            print(gcf, file, '-dsvg', '-r0');
            fprintf('>>Saved to: %s\n',file);
        case 13
            print(gcf, file, '-dtiff','-r0');
            fprintf('>>Saved to: %s\n',file);
        case 14
            print(gcf, file,'-dtiffn','-r0');
            fprintf('>>Saved to: %s\n',file);
    end
end
set(handles.pushbuttonSave, 'enable', 'on');


% --- Executes on button press in pushbuttonStep.
function pushbuttonStep_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbuttonStep, 'enable', 'off');
figSimComparison2 = gcf;
GUI_Main;
close(figSimComparison2);
