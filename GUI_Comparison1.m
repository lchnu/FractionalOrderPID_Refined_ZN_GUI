function varargout = GUI_Comparison1(varargin)
% GUI_COMPARISON1 MATLAB code for GUI_Comparison1.fig
%      GUI_COMPARISON1, by itself, creates a new GUI_COMPARISON1 or raises the existing
%      singleton*.
%
%      H = GUI_COMPARISON1 returns the handle to a new GUI_COMPARISON1 or the handle to
%      the existing singleton*.
%
%      GUI_COMPARISON1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_COMPARISON1.M with the given input arguments.
%
%      GUI_COMPARISON1('Property','Value',...) creates a new GUI_COMPARISON1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Comparison1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Comparison1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Comparison1

% Last Modified by GUIDE v2.5 02-Jun-2022 16:03:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Comparison1_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Comparison1_OutputFcn, ...
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


% --- Executes just before GUI_Comparison1 is made visible.
function GUI_Comparison1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Comparison1 (see VARARGIN)

% Choose default command line output for GUI_Comparison1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_Comparison1 wait for user response (see UIRESUME)
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
field8  = 'FOPID3';              value8  = [0.13 0.55 0.13];  % ZNPID     控制器的颜色
field9  = 'FOPID4';              value9  = [1    0.65 0   ];  % RZNFOPID  控制器的颜色
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

handles.flagPoint3    = false;
handles.flagFOPID3    = false;
handles.flagRunFOPID3 = false;

handles.flagPoint4    = false;
handles.flagFOPID4    = false;
handles.flagRunFOPID4 = false;



guidata(hObject, handles);                                  % 传递状态的全局变量
global reset;                                               % 保存初始状态的结构体
reset = handles;


% --- Outputs from this function are returned to the command line.
function varargout = GUI_Comparison1_OutputFcn(hObject, eventdata, handles) 
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
set(handles.checkboxFOPID3,  'value', 0);
checkboxFOPID3_Callback(hObject, eventdata, handles);
set(handles.checkboxFOPID4,  'value', 0);
checkboxFOPID4_Callback(hObject, eventdata, handles);

handles.flagFOPID1 = false;
handles.flagFOPID2 = false;
handles.flagFOPID3 = false;
handles.flagFOPID4 = false;


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
set(handles.checkboxFOPID3,  'value', 0);
checkboxFOPID3_Callback(hObject, eventdata, handles);
set(handles.checkboxFOPID4,  'value', 0);
checkboxFOPID4_Callback(hObject, eventdata, handles);

handles.flagFOPID1 = false;
handles.flagFOPID2 = false;
handles.flagFOPID3 = false;
handles.flagFOPID4 = false;

handles.disValue = str2double(get(handles.editDisValue, 'string'));
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
set(handles.checkboxFOPID3,  'value', 0);
checkboxFOPID3_Callback(hObject, eventdata, handles);
set(handles.checkboxFOPID4,  'value', 0);
checkboxFOPID4_Callback(hObject, eventdata, handles);

handles.flagFOPID1 = false;
handles.flagFOPID2 = false;
handles.flagFOPID3 = false;
handles.flagFOPID4 = false;

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
set(handles.checkboxFOPID3,  'value', 0);
checkboxFOPID3_Callback(hObject, eventdata, handles);
set(handles.checkboxFOPID4,  'value', 0);
checkboxFOPID4_Callback(hObject, eventdata, handles);

handles.flagFOPID1 = false;
handles.flagFOPID2 = false;
handles.flagFOPID3 = false;
handles.flagFOPID4 = false;

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
handles.flagCompensator = false;
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
    warndlg('\fontsize{10} Please choose the correct Ta!', 'Warning', handles.opts);
    return;
end
colorGa  = get(handles.pushbuttonGa, 'backgroundcolor');
stringGa = get(handles.pushbuttonGa, 'string');
set(handles.pushbuttonGa, 'enable', 'off');
set(handles.pushbuttonGa, 'backgroundcolor', handles.color.run);
set(handles.pushbuttonGa, 'string', handles.run);
pause(1e-1);

handles.flagCompensator = true;
Ns = str2num(get(handles.editNs,  'string'));                   % 读取系统
Ms = str2num(get(handles.editMs,  'string'));
n  = str2double(get(handles.editN,'string'));
L  = str2double(get(handles.editL,'string'));

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
    errordlg('\fontsize{10} Please fill in the transfer function correctly !', 'ERROR', handles.opts);
end

set(handles.pushbuttonGa, 'backgroundcolor', colorGa);
set(handles.pushbuttonGa, 'string', stringGa);
set(handles.pushbuttonGa, 'enable', 'on');





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
    warndlg('\fontsize{10} Please calculate the Compensator before this operation !', 'Warning', handles.opts);
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
    guidata(hObject, handles)
    
    set(handles.checkboxFOPID1, 'enable', 'on');
    set(handles.checkboxFOPID2, 'enable', 'on');
    set(handles.checkboxFOPID3, 'enable', 'on');
    set(handles.checkboxFOPID4, 'enable', 'on');
    
    set(handles.editKc, 'string', num2str(handles.Kc,'%.4f'));
    set(handles.editTc, 'string', num2str(handles.Tc,'%.4f'));
catch
    errordlg('\fontsize{10} Please  fill in the transfer function correctly !', 'ERROR', handles.opts);
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
        handles.flagPoint1 = false;
        guidata(hObject, handles);
        warndlg('\fontsize{10} Please choose the correct fixed-point !', 'Warning', handles.opts);
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
    errordlg('\fontsize{10} Please check the entered simulation parameters or the model "Model\_ZN\_FOPID.mdl" !', 'Error', handles.opts);
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
        handles.flagPoint2 = false;
        guidata(hObject, handles);
        warndlg('\fontsize{10} Please choose the correct fixed-point !', 'Warning', handles.opts);
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
% ............................... FOPID 3 ................................. %
% ......................................................................... %

% --- Executes on button press in checkboxFOPID3.
function checkboxFOPID3_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxFOPID3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxFOPID3

if get(handles.checkboxFOPID3, 'value')
    if handles.flagRunFOPID3                            % 同一个系统运行一次后，不需要二次运行
        handles.flagFOPID3 = true;
    end
    set(handles.popupmenuPoint3,     'enable', 'on');   % 使能 FOPID3 控制器部分
    set(handles.editR1FOPID3,        'enable', 'on');
    set(handles.editR2FOPID3,        'enable', 'on');
    set(handles.editMuFOPID3,        'enable', 'on');
    set(handles.pushbuttonRunFOPID3, 'enable', 'on');
    set(handles.uipanelFOPID3, 'foregroundcolor', handles.color.FOPID3);
    set(handles.uipanelFOPID3, 'highlightcolor',  handles.color.FOPID3);
    set(handles.uipanelFOPID3, 'shadowcolor',     handles.color.FOPID3);
else                                                    % 关闭 FOPID3 控制器部分
    handles.flagFOPID3 = false;
    set(handles.popupmenuPoint3,     'enable', 'off');
    set(handles.editR1FOPID3,        'enable', 'off');
    set(handles.editR2FOPID3,        'enable', 'off');
    set(handles.editMuFOPID3,        'enable', 'off');
    set(handles.pushbuttonRunFOPID3, 'enable', 'off');
    set(handles.uipanelFOPID3, 'foregroundcolor', handles.color.defaultForeground);
    set(handles.uipanelFOPID3, 'highlightcolor',  handles.color.defaultHighlight);
    set(handles.uipanelFOPID3, 'shadowcolor',     handles.color.defaultShadow);
end
guidata(hObject, handles);


% --- Executes on selection change in popupmenuPoint3.
function popupmenuPoint3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuPoint3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuPoint3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuPoint3

point3 = get(handles.popupmenuPoint3, 'value');
switch point3
    case 1
        handles.flagPoint3 = false;
        guidata(hObject, handles);
        warndlg('\fontsize{10} Please choose the correct fixed-point !', 'Warning', handles.opts);
        return;
    case 2
        handles.selectPoint3 = true;
        handles.strPoint3 = 'new ZN-point';
    case 3
        handles.selectPoint3 = false;
        handles.strPoint3 = 'ZN-point';
end
if ~(handles.flagPoint3)
    handles.flagPoint3 = true;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenuPoint3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuPoint3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editR1FOPID3_Callback(hObject, eventdata, handles)
% hObject    handle to editR1FOPID3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editR1FOPID3 as text
%        str2double(get(hObject,'String')) returns contents of editR1FOPID3 as a double


% --- Executes during object creation, after setting all properties.
function editR1FOPID3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editR1FOPID3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editR2FOPID3_Callback(hObject, eventdata, handles)
% hObject    handle to editR2FOPID3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editR2FOPID3 as text
%        str2double(get(hObject,'String')) returns contents of editR2FOPID3 as a double


% --- Executes during object creation, after setting all properties.
function editR2FOPID3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editR2FOPID3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editMuFOPID3_Callback(hObject, eventdata, handles)
% hObject    handle to editMuFOPID3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMuFOPID3 as text
%        str2double(get(hObject,'String')) returns contents of editMuFOPID3 as a double



% --- Executes during object creation, after setting all properties.
function editMuFOPID3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMuFOPID3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonRunFOPID3.
function pushbuttonRunFOPID3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonRunFOPID3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~(handles.flagPoint3)
    warndlg('\fontsize{10} Please choose the correct fixed-point !', 'Warning', handles.opts);
    return;
end
colorRunFOPID3  = get(handles.pushbuttonRunFOPID3, 'backgroundcolor');
stringRunFOPID3 = get(handles.pushbuttonRunFOPID3, 'string');
set(handles.pushbuttonRunFOPID3, 'enable', 'off');
set(handles.pushbuttonRunFOPID3, 'backgroundcolor', handles.color.run);
set(handles.pushbuttonRunFOPID3, 'string', handles.run);
pause(1e-1);

try
    r1 = str2double(get(handles.editR1FOPID3, 'string'));   % 读取参数
    r2 = str2double(get(handles.editR2FOPID3, 'string'));
    mu = str2double(get(handles.editMuFOPID3, 'string'));
    handles.strFOPID3 = [' and r2 = ',num2str(r2),', \mu = ',num2str(mu)];
    % 控制器表达式 C(s) = Kp(1 + 1/(Ti*s^lambda) + Td*s^mu)
    [Kp,Ti,Td,lambda] = function_FOPID(handles.selectPoint3,r1,r2,mu,handles.Kc,handles.Tc);
catch
    errordlg('\fontsize{10} The input r_1, r_2 or \mu is not suitable !', 'ERROR', handles.opts);
    set(handles.pushbuttonRunFOPID3, 'backgroundcolor', colorRunFOPID3);
    set(handles.pushbuttonRunFOPID3, 'string', stringRunFOPID3);
    set(handles.pushbuttonRunFOPID3, 'enable', 'on');
    return;
end
try
    optionsFOPID3 = simset('SrcWorkspace', 'current');
    % 控制器表达式转换 C(s) = kp + ki/s^lambda + kd*s^mu)
    kpo = Kp;
    kio = Kp/Ti;
    kdo = Kp*Td;
    ifo = ousta_fod(-lambda,10,1e-5,1e+5);               % integral
    dfo = ousta_fod(mu,10,1e-5,1e+5);                    % differential
    Gc  = kpo + kio*ifo + kdo*dfo;
    
    set(handles.textKpFOPID3, 'string', num2str(kpo,'%.4f'));                   % 显示控制器
    set(handles.textKiFOPID3, 'string', num2str(kio,'%.4f'));
    set(handles.textKdFOPID3, 'string', num2str(kdo,'%.4f'));
    set(handles.textLamFOPID3,'string', num2str(lambda,'%.2f'));
    set(handles.textMuFOPID3, 'string', num2str(mu,'%.2f'));
    
    Ls = handles.GpLa * Gc;                                                     % 画 Nyquist 图参数
    if handles.flagW
        [handles.ReNyquistFOPID3,handles.ImNyquistFOPID3, ~]  =  nyquist(Ls, handles.w);
    else
        [handles.ReNyquistFOPID3,handles.ImNyquistFOPID3]  =  nyquist(Ls);
    end
    
    open_system('Model_ZN_FOPID','loadonly');
    Ga = handles.Ga;                                                           % 仿真参数初始化
    Gp = handles.Gp;
    L  = handles.L;
    Gp.iodelay = 0;
    
    step_value = handles.stepValue;
    sim_time   = handles.simTime;
    disturb_step_time  = handles.disTime;
    disturb_step_value = handles.disValue;
    
    warning off;
    sim('Model_ZN_FOPID.mdl',sim_time, optionsFOPID3);
    close_system('Model_ZN_FOPID', 0);
    
    handles.timeFOPID3 = time;                                                  % 仿真结果, 传递全局变量
    handles.outFOPID3  = FOPID_out;
    handles.FOPID3     = Gc;
    
    handles.flagFOPID3    = true;                                               % FOPID3 部分，状态参数更新
    handles.flagRunFOPID3 = true;
    guidata(hObject, handles);
catch
    errordlg('\fontsize{10} Please check the entered simulation parameters or the model "Model\_ZN\_FOPID.mdl" !', 'ERROR', handles.opts);
end
    
set(handles.pushbuttonRunFOPID3, 'backgroundcolor', colorRunFOPID3);
set(handles.pushbuttonRunFOPID3, 'string', stringRunFOPID3);
set(handles.pushbuttonRunFOPID3, 'enable', 'on');





% ......................................................................... %
% ............................... FOPID 4 ................................. %
% ......................................................................... %

% --- Executes on button press in checkboxFOPID4.
function checkboxFOPID4_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxFOPID4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxFOPID4

if get(handles.checkboxFOPID4, 'value')
    if handles.flagRunFOPID4
        handles.flagFOPID4 = true;
    end
    set(handles.popupmenuPoint4,     'enable', 'on');
    set(handles.editR1FOPID4,        'enable', 'on');
    set(handles.editR2FOPID4,        'enable', 'on');
    set(handles.editMuFOPID4,        'enable', 'on');
    set(handles.pushbuttonRunFOPID4, 'enable', 'on');
    set(handles.uipanelFOPID4, 'foregroundcolor',handles.color.FOPID4);
    set(handles.uipanelFOPID4, 'highlightcolor', handles.color.FOPID4);
    set(handles.uipanelFOPID4, 'shadowcolor',    handles.color.FOPID4);
else
    handles.flagFOPID4 = false;
    guidata(hObject,  handles);
    set(handles.popupmenuPoint4,     'enable', 'off');
    set(handles.editR1FOPID4,        'enable', 'off');
    set(handles.editR2FOPID4,        'enable', 'off');
    set(handles.editMuFOPID4,        'enable', 'off');
    set(handles.pushbuttonRunFOPID4, 'enable', 'off');
    set(handles.uipanelFOPID4, 'foregroundcolor', handles.color.defaultForeground);
    set(handles.uipanelFOPID4, 'highlightcolor',  handles.color.defaultHighlight);
    set(handles.uipanelFOPID4, 'shadowcolor',     handles.color.defaultShadow);
end
guidata(hObject, handles);


% --- Executes on selection change in popupmenuPoint4.
function popupmenuPoint4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuPoint4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuPoint4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuPoint4

point4 = get(handles.popupmenuPoint4, 'value');
switch point4
    case 1
        handles.flagPoint4 = false;
        guidata(hObject, handles);
        warndlg('\fontsize{10} Please choose the correct fixed-point !', 'Warning', handles.opts);
        return;
    case 2
        handles.selectPoint4 = true;
        handles.strPoint4 = 'new ZN-point';
    case 3
        handles.selectPoint4 = false;
        handles.strPoint4 = 'ZN-point';
end
if ~(handles.flagPoint4)
    handles.flagPoint4 = true;
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenuPoint4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuPoint4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editR1FOPID4_Callback(hObject, eventdata, handles)
% hObject    handle to editR1FOPID4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editR1FOPID4 as text
%        str2double(get(hObject,'String')) returns contents of editR1FOPID4 as a double


% --- Executes during object creation, after setting all properties.
function editR1FOPID4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editR1FOPID4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editR2FOPID4_Callback(hObject, eventdata, handles)
% hObject    handle to editR2FOPID4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editR2FOPID4 as text
%        str2double(get(hObject,'String')) returns contents of editR2FOPID4 as a double


% --- Executes during object creation, after setting all properties.
function editR2FOPID4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editR2FOPID4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editMuFOPID4_Callback(hObject, eventdata, handles)
% hObject    handle to editMuFOPID4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMuFOPID4 as text
%        str2double(get(hObject,'String')) returns contents of editMuFOPID4 as a double



% --- Executes during object creation, after setting all properties.
function editMuFOPID4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMuFOPID4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonRunFOPID4.
function pushbuttonRunFOPID4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonRunFOPID4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~(handles.flagPoint4)
    warndlg('\fontsize{10} Please choose the correct fixed-point !', 'Warning', handles.opts);
    return;
end
colorRunFOPID4  = get(handles.pushbuttonRunFOPID4, 'backgroundcolor');
stringRunFOPID4 = get(handles.pushbuttonRunFOPID4, 'string');
set(handles.pushbuttonRunFOPID4, 'enable', 'off');
set(handles.pushbuttonRunFOPID4, 'backgroundcolor', handles.color.run);
set(handles.pushbuttonRunFOPID4, 'string', handles.run);
pause(1e-1);

try
    r1 = str2double(get(handles.editR1FOPID4, 'string'));
    r2 = str2double(get(handles.editR2FOPID4, 'string'));
    mu = str2double(get(handles.editMuFOPID4, 'string'));
    handles.strFOPID4 = [' and r2 = ',num2str(r2),', \mu = ',num2str(mu)];
    % 控制器表达式 C(s) = Kp(1 + 1/(Ti*s^lambda) + Td*s^mu)
    [Kp,Ti,Td,lambda] = function_FOPID(handles.selectPoint4,r1,r2,mu,handles.Kc,handles.Tc);
catch
    errordlg('\fontsize{10} The input r_1, r_2 or \mu is not suitable !', 'ERROR', handles.opts);
    set(handles.pushbuttonRunFOPID4, 'backgroundcolor', colorRunFOPID4);
    set(handles.pushbuttonRunFOPID4, 'string', stringRunFOPID4);
    set(handles.pushbuttonRunFOPID4, 'enable', 'on');
    return;
end
try
    optionsFOPID4 = simset('SrcWorkspace', 'current');
    % 控制器表达式转换 C(s) = kp + ki/s^lambda + kd*s^mu)
    kpo = Kp;
    kio = Kp/Ti;
    kdo = Kp*Td;
    ifo = ousta_fod(-lambda,10,1e-5,1e+5);               % integral
    dfo = ousta_fod(mu,10,1e-5,1e+5);                    % differential
    Gc  = kpo + kio*ifo + kdo*dfo;
    
    set(handles.textKpFOPID4, 'string', num2str(kpo,'%.4f'));                   % 显示控制器
    set(handles.textKiFOPID4, 'string', num2str(kio,'%.4f'));
    set(handles.textKdFOPID4, 'string', num2str(kdo,'%.4f'));
    set(handles.textLamFOPID4,'string', num2str(lambda,'%.2f'));
    set(handles.textMuFOPID4, 'string', num2str(mu,'%.2f'));
    
    Ls = handles.GpLa * Gc;                                                     % 画 Nyquist 图参数
    if handles.flagW
        [handles.ReNyquistFOPID4,handles.ImNyquistFOPID4, ~]  =  nyquist(Ls, handles.w);
    else
        [handles.ReNyquistFOPID4,handles.ImNyquistFOPID4]  =  nyquist(Ls);
    end
    
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
    sim('Model_ZN_FOPID.mdl',sim_time, optionsFOPID4);
    close_system('Model_ZN_FOPID', 0);
    
    handles.timeFOPID4 = time;                                                  % 仿真结果, 传递全局变量
    handles.outFOPID4  = FOPID_out;
    handles.FOPID4     = Gc;
    
    handles.flagFOPID4    = true;                                               % FOPID4 部分，状态参数更新
    handles.flagRunFOPID4 = true;
    guidata(hObject, handles);
catch
    errordlg('\fontsize{10} Please check the entered simulation parameters or the model "Model\_ZN\_FOPID.mdl" !', 'ERROR', handles.opts);
end

set(handles.pushbuttonRunFOPID4, 'backgroundcolor', colorRunFOPID4);
set(handles.pushbuttonRunFOPID4, 'string', stringRunFOPID4);
set(handles.pushbuttonRunFOPID4, 'enable', 'on');





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
% axis([-0.7 -0.4 -0.35 -0.15]);      %example 1
axis([-1.2 0.2 -1.5 0.5]);          %example 2
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
flagNewZNPointFOPID3 = false;
flagZNPointFOPID3    = false;
if handles.flagFOPID3
    plot(squeeze(handles.ReNyquistFOPID3), squeeze(handles.ImNyquistFOPID3), ...
        'Color',handles.color.FOPID3, 'LineWidth',2, ...
        'DisplayName',['ZN-PI^{\lambda}D^{\mu}3: ', handles.strPoint3,handles.strFOPID3]);
    if handles.selectPoint3
        flagNewZNPointFOPID3 = true;
    else
        flagZNPointFOPID3    = true;
    end
end
flagNewZNPointFOPID4 = false;
flagZNPointFOPID4   = false;
if handles.flagFOPID4
    plot(squeeze(handles.ReNyquistFOPID4), squeeze(handles.ImNyquistFOPID4), ...
        'Color',handles.color.FOPID4, 'LineWidth',2, ...
        'DisplayName',['ZN-PI^{\lambda}D^{\mu}4: ', handles.strPoint4,handles.strFOPID4]);
    if handles.selectPoint4
        flagNewZNPointFOPID4 = true;
    else
        flagZNPointFOPID4    = true;
    end
end

if flagZNPointFOPID1 || flagZNPointFOPID2 || flagZNPointFOPID3 || flagZNPointFOPID4
    plot(-0.6,-0.6*(-1/(2*pi*0.5)+0.125*2*pi), '.k', 'MarkerSize',25, 'LineWidth',2, 'DisplayName','ZN-point');
end
if flagNewZNPointFOPID1 || flagNewZNPointFOPID2 || flagNewZNPointFOPID3 || flagNewZNPointFOPID4
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

if handles.flagFOPID1
    plot(handles.timeFOPID1, handles.outFOPID1, ...
        'Color',handles.color.FOPID1, 'LineWidth',2, ...
        'DisplayName',['ZN-PI^{\lambda}D^{\mu}1: ', handles.strPoint1,handles.strFOPID1]);
end
if handles.flagFOPID2
    plot(handles.timeFOPID2, handles.outFOPID2, ...
        'Color',handles.color.FOPID2, 'LineWidth',2,...
        'DisplayName',['ZN-PI^{\lambda}D^{\mu}2: ', handles.strPoint2,handles.strFOPID2]);
end
if handles.flagFOPID3
    plot(handles.timeFOPID3, handles.outFOPID3, ...
        'Color',handles.color.FOPID3, 'LineWidth',2,...
        'DisplayName',['ZN-PI^{\lambda}D^{\mu}3: ', handles.strPoint3,handles.strFOPID3]);
end
if handles.flagFOPID4
    plot(handles.timeFOPID4, handles.outFOPID4, ...
        'Color',handles.color.FOPID4, 'LineWidth',2,...
        'DisplayName',['ZN-PI^{\lambda}D^{\mu}4: ', handles.strPoint4,handles.strFOPID4]);
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
% ............................... FOPID 3 ................................. %
set(handles.popupmenuPoint3, 'value', 1);
set(handles.checkboxFOPID3,  'value', 0);
checkboxFOPID3_Callback(hObject, eventdata, handles);
set(handles.checkboxFOPID3,'enable', 'off');
set(handles.editR1FOPID3,  'string', '4');
set(handles.editR2FOPID3,  'string', '1');
set(handles.editMuFOPID3,  'string', '1');
set(handles.textKpFOPID3,  'string', 'kp');
set(handles.textKiFOPID3,  'string', 'ki');
set(handles.textLamFOPID3, 'string', 'λ');
set(handles.textKdFOPID3,  'string', 'kd');
set(handles.textMuFOPID3,  'string', 'μ');
set(handles.pushbuttonRunFOPID3, 'backgroundcolor', handles.color.controller);
set(handles.pushbuttonRunFOPID3, 'string', handles.defaultRun);
% ............................... FOPID 4 ................................. %
set(handles.popupmenuPoint4, 'value', 1);
set(handles.checkboxFOPID4,  'value', 0);
checkboxFOPID4_Callback(hObject, eventdata, handles);
set(handles.checkboxFOPID4,'enable', 'off');
set(handles.editR1FOPID4,  'string', '4');
set(handles.editR2FOPID4,  'string', '1');
set(handles.editMuFOPID4,  'string', '1');
set(handles.textKpFOPID4,  'string', 'kp');
set(handles.textKiFOPID4,  'string', 'ki');
set(handles.textLamFOPID4, 'string', 'λ');
set(handles.textKdFOPID4,  'string', 'kd');
set(handles.textMuFOPID4,  'string', 'μ');
set(handles.pushbuttonRunFOPID4, 'backgroundcolor', handles.color.controller);
set(handles.pushbuttonRunFOPID4, 'string', handles.defaultRun);
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
figSimComparison1 = gcf;
GUI_Main;
close(figSimComparison1);
