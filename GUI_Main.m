function varargout = GUI_Main(varargin)
% GUI_MAIN MATLAB code for GUI_Main.fig
%      GUI_MAIN, by itself, creates a new GUI_MAIN or raises the existing
%      singleton*.
%
%      H = GUI_MAIN returns the handle to a new GUI_MAIN or the handle to
%      the existing singleton*.
%
%      GUI_MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_MAIN.M with the given input arguments.
%
%      GUI_MAIN('Property','Value',...) creates a new GUI_MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Main

% Last Modified by GUIDE v2.5 06-Jun-2022 20:35:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Main_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Main_OutputFcn, ...
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


% --- Executes just before GUI_Main is made visible.
function GUI_Main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Main (see VARARGIN)

% Choose default command line output for GUI_Main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_Main wait for user response (see UIRESUME)
% uiwait(handles.figStep);

handles.run = 'Runing';                                       % 按钮运行时的显示
handles.defaultRun = 'RUN';                                   % 控制器按钮默认的显示
field1  = 'run';                 value1  = [1.0  0    0   ];  % 按钮运行时的颜色
field2  = 'defaultHighlight';    value2  = [0.5  0.5  0.5 ];  % 默认的原始颜色
field3  = 'defaultForeground';   value3  = [0    0    0   ];
field4  = 'defaultShadow';       value4  = [0.9  0.9  0.9 ];
field5  = 'compensator';         value5  = [0    0    0   ];  % 补偿器的颜色
field6  = 'FOPID1';              value6  = [1.0  0    0   ];  % FOPID1    控制器的颜色
field7  = 'FOPID2';              value7  = [0.58 0    0.83];  % FOPID2    控制器的颜色
field8  = 'ZNPID';               value8  = [0.13 0.55 0.13];  % ZNPID     控制器的颜色
field9  = 'RZNFOPID';            value9  = [1    0.65 0   ];  % RZNFOPID  控制器的颜色
field10 = 'PILamD';              value10 = [0    0    1   ];  % PILamD    控制器的颜色
field11 = 'controller';          value11 = [0.49 0.99  0  ];  % 控制器按钮的默认颜色
field12 = 'function';            value12 = [0.68 0.85 0.90];  % 功能按钮的默认颜色
color = struct(field1,value1, field2,value2, field3,value3, field4,value4, ...
    field5,value5, field6,value6, field7,value7, field8,value8, field9,value9, ...
    field10,value10, field11,value11, field12,value12);       % 保存颜色的结构体
handles.color = color;

handles.w    = 1e-2:1e-2:1e2; 
handles.opts = struct('WindowStyle','modal', 'Interpreter','tex');

handles.flagTa    = false;                                  % 各部分的初始状态设置
handles.falgFOPID = false;

guidata(hObject, handles);                                  % 传递状态的全局变量
global reset;                                               % 保存初始状态的结构体
reset = handles;






% --- Outputs from this function are returned to the command line.
function varargout = GUI_Main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





% ................................ Step 1 ................................. %

function edit_Ns_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Ns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Ns as text
%        str2double(get(hObject,'String')) returns contents of edit_Ns as a double


% --- Executes during object creation, after setting all properties.
function edit_Ns_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Ns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_Ms_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Ms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Ms as text
%        str2double(get(hObject,'String')) returns contents of edit_Ms as a double


% --- Executes during object creation, after setting all properties.
function edit_Ms_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Ms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_n_Callback(hObject, eventdata, handles)
% hObject    handle to edit_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_n as text
%        str2double(get(hObject,'String')) returns contents of edit_n as a double


% --- Executes during object creation, after setting all properties.
function edit_n_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_n (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_L_Callback(hObject, eventdata, handles)
% hObject    handle to edit_L (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_L as text
%        str2double(get(hObject,'String')) returns contents of edit_L as a double


% --- Executes during object creation, after setting all properties.
function edit_L_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_L (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% ................................ Step 2 ................................. %

% --- Executes on selection change in popupmenu_Ta.
function popupmenu_Ta_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Ta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_Ta contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Ta
Ta_num = get(handles.popupmenu_Ta, 'value');
switch Ta_num
    case 1
        handles.flagTa = false;
        guidata(hObject, handles);
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
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu_Ta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_Ta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_Ga.
function pushbutton_Ga_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Ga (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~(handles.flagTa)
    opts = struct('WindowStyle','modal', 'Interpreter','tex');
    warndlg('\fontsize{10} Please choose the correct Ta!', 'Warning', opts);
    return;
end
colorGa  = get(handles.pushbutton_Ga, 'backgroundcolor');
stringGa = get(handles.pushbutton_Ga, 'string');
set(handles.pushbutton_Ga, 'enable', 'off');
set(handles.pushbutton_Ga, 'backgroundcolor', handles.color.run);
set(handles.pushbutton_Ga, 'string', handles.run);
pause(1e-1);



Ns = str2num(get(handles.edit_Ns,  'string'));                   % 读取系统
Ms = str2num(get(handles.edit_Ms,  'string'));
n  = str2double(get(handles.edit_n,'string'));
L  = str2double(get(handles.edit_L,'string'));
try
    handles.falgFOPID = false;

    Ta = handles.Ta;
    [Gp,GpL,Ga,m,falgGa] = function_Compensator(Ns,Ms,n,L,Ta);      % 计算补偿器
    if falgGa                                                       % 显示补偿器
        set(handles.text_Ga, 'string', 'Ga(s) = ');
        if n == 0
            set(handles.text_compensatorNum, 'string', '1 ');
            set(handles.text_compensatorN,   'string', '');
        elseif n == 1
            set(handles.text_compensatorNum, 'string', ['s / ',num2str(Ta),' + 1']);
            set(handles.text_compensatorN,   'string', '');
        else
            set(handles.text_compensatorNum, 'string', ['( s / ',num2str(Ta),' + 1 )']);
            set(handles.text_compensatorN,   'string', num2str(n));
        end
        set(handles.text_frac, 'string', '——————————————————');
        if m == 1
            set(handles.text_compensatorDen, 'string', [num2str(Ta), ' s + 1']);
            set(handles.text_compensatorM,   'string', '');
        else
            set(handles.text_compensatorDen, 'string', ['( ', num2str(Ta), ' s + 1 )']);
            set(handles.text_compensatorM,   'string', num2str(m));
        end
    else
        set(handles.text_compensatorNum, 'string', '');
        set(handles.text_compensatorN,   'string', '');
        set(handles.text_frac,           'string', '');
        set(handles.text_compensatorDen, 'string', '');
        set(handles.text_compensatorM,   'string', '');
        set(handles.text_Ga,    'string', 'Ga(s) = 1');
    end
    
    handles.GpL = GpL;                  % 传递参数
    handles.Gp  = Gp;
    handles.Ga  = Ga;
    handles.L   = L;
    guidata(hObject, handles);
    set(handles.pushbutton_relayTest,  'enable', 'on');
catch
    errordlg('\fontsize{10} Please input the controlled plant in the correct format !', 'ERROR', handles.opts);
end

set(handles.pushbutton_Ga, 'backgroundcolor', colorGa);
set(handles.pushbutton_Ga, 'string', stringGa);
set(handles.pushbutton_Ga, 'enable', 'on');





% ................................ Step 3 ................................. %

function edit_Kc_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Kc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Kc as text
%        str2double(get(hObject,'String')) returns contents of edit_Kc as a double


% --- Executes during object creation, after setting all properties.
function edit_Kc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Kc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_Tc_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Tc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Tc as text
%        str2double(get(hObject,'String')) returns contents of edit_Tc as a double


% --- Executes during object creation, after setting all properties.
function edit_Tc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Tc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_relayTest.
function pushbutton_relayTest_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_relayTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

colorRelayTest  = get(handles.pushbutton_relayTest, 'backgroundcolor');
stringRelayTest = get(handles.pushbutton_relayTest, 'string');
set(handles.pushbutton_relayTest, 'enable', 'off');
set(handles.pushbutton_relayTest, 'backgroundcolor', handles.color.run);
set(handles.pushbutton_relayTest, 'string', handles.run);
pause(1e-1);

handles.falgFOPID = false;

GpLa = handles.GpL * handles.Ga;                % 传递参数
[Gm,~,Wcp,~] = margin(GpLa); 
handles.Kc = Gm;                                % critical gain
handles.Wc = Wcp;                               % critical frequency
handles.Tc = 2*pi / Wcp;                        % critical period
handles.GpLa = GpLa;
guidata(hObject, handles)

set(handles.edit_Kc, 'string', num2str(handles.Kc,'%.4f'));
set(handles.edit_Tc, 'string', num2str(handles.Tc,'%.4f'));

set(handles.pushbutton_relayTest, 'backgroundcolor', colorRelayTest);
set(handles.pushbutton_relayTest, 'string', stringRelayTest);
set(handles.popupmenu_point, 'enable', 'on');





% ................................ Step 4 ................................. %

% --- Executes on selection change in popupmenu_point.
function popupmenu_point_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_point (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_point contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_point
handles.falgFOPID = false;
point = get(handles.popupmenu_point, 'value');
switch point
    case 1
        warndlg('\fontsize{10} Please choose the correct fixed-point !', 'Warning', handles.opts);
        return;
    case 2
        handles.selectPoint = true;
    case 3
        handles.selectPoint = false;
end
guidata(hObject, handles);
set(handles.edit_r1, 'enable', 'on');
set(handles.edit_r2, 'enable', 'on');
set(handles.edit_mu, 'enable', 'on');
set(handles.pushbutton_apply,  'enable', 'on');


% --- Executes during object creation, after setting all properties.
function popupmenu_point_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_point (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% ................................ Step 5 ................................. %

function edit_r1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_r1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_r1 as text
%        str2double(get(hObject,'String')) returns contents of edit_r1 as a double


% --- Executes during object creation, after setting all properties.
function edit_r1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_r1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_r2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_r2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_r2 as text
%        str2double(get(hObject,'String')) returns contents of edit_r2 as a double


% --- Executes during object creation, after setting all properties.
function edit_r2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_r2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_mu_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mu as text
%        str2double(get(hObject,'String')) returns contents of edit_mu as a double


% --- Executes during object creation, after setting all properties.
function edit_mu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_apply.
function pushbutton_apply_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_apply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

colorApply  = get(handles.pushbutton_apply, 'backgroundcolor');
stringApply = get(handles.pushbutton_apply, 'string');
set(handles.pushbutton_apply,  'enable', 'off');
set(handles.pushbutton_apply, 'backgroundcolor', handles.color.run);
set(handles.pushbutton_apply, 'string', handles.run);
pause(1e-1);

handles.falgFOPID = false;

r1 = str2double(get(handles.edit_r1, 'string'));   % 读取参数
r2 = str2double(get(handles.edit_r2, 'string'));
mu = str2double(get(handles.edit_mu, 'string'));
handles.r1 = r1;
handles.r2 = r2;
handles.mu = mu;

Kc = handles.Kc;
if handles.selectPoint
    p = 0.5*Kc;
    q = 0.5*Kc*(-1/(2*pi*0.5)+0.125*2*pi);
else
    p = 0.6*Kc;
    q = 0.6*Kc*(-1/(2*pi*0.5)+0.125*2*pi);
end
lambda = mu * r2;
B  = r1^(lambda);
E  = q / p;
C1 = cos(lambda*pi/2);             S1 = sin(lambda*pi/2);
C2 = cos(mu*pi/2);                 S2 = sin(mu*pi/2);
a  = B*E*C2 - B*S2;
b  = B*E;
c  = E*C1 + S1;
syms x;
equ = a*x^(1+r2) + b*x^r2 + c;                              % 解方程
handles.equ = equ;
handles.a   = a;
handles.b   = b;
handles.c   = c;
guidata(hObject, handles);

set(handles.pushbutton_funImage,  'enable', 'on');
set(handles.pushbutton_FOPID,     'enable', 'on');
set(handles.pushbutton_apply, 'backgroundcolor', colorApply);
set(handles.pushbutton_apply, 'string', stringApply);
set(handles.pushbutton_apply, 'enable', 'on');


% --- Executes on button press in pushbutton_funImage.
function pushbutton_funImage_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_funImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colorfunImage  = get(handles.pushbutton_funImage, 'backgroundcolor');
stringfunImage = get(handles.pushbutton_funImage, 'string');
set(handles.pushbutton_funImage, 'enable', 'off');
set(handles.pushbutton_funImage, 'backgroundcolor', handles.color.run);
set(handles.pushbutton_funImage, 'string', handles.run);
pause(1e-1);

handles.fig_funImage = figure('name', 'Function Image');
fplot(handles.equ,'Color',handles.color.FOPID2, 'LineWidth',2);
grid on;
title(['Function expression:  ',num2str(handles.a,'%.4f'),' x^{',num2str(1+handles.r2,'%.2f'),'} + ', ...
    num2str(handles.b,'%.4f'),' x^{',num2str(handles.r2,'%.2f'),'} + ',num2str(handles.c,'%.4f')]);
guidata(hObject, handles);

set(handles.pushbutton_funImage, 'backgroundcolor', colorfunImage);
set(handles.pushbutton_funImage, 'string', stringfunImage);





% ................................ Step 6 ................................. %


function edit_alpha_Callback(hObject, eventdata, handles)
% hObject    handle to edit_alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_alpha as text
%        str2double(get(hObject,'String')) returns contents of edit_alpha as a double


% --- Executes during object creation, after setting all properties.
function edit_alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_beta_Callback(hObject, eventdata, handles)
% hObject    handle to edit_beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_beta as text
%        str2double(get(hObject,'String')) returns contents of edit_beta as a double


% --- Executes during object creation, after setting all properties.
function edit_beta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_gamma_Callback(hObject, eventdata, handles)
% hObject    handle to edit_gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_gamma as text
%        str2double(get(hObject,'String')) returns contents of edit_gamma as a double


% --- Executes during object creation, after setting all properties.
function edit_gamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_Kp_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Kp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Kp as text
%        str2double(get(hObject,'String')) returns contents of edit_Kp as a double


% --- Executes during object creation, after setting all properties.
function edit_Kp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Kp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_Ti_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Ti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Ti as text
%        str2double(get(hObject,'String')) returns contents of edit_Ti as a double


% --- Executes during object creation, after setting all properties.
function edit_Ti_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Ti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_Td_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Td (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Td as text
%        str2double(get(hObject,'String')) returns contents of edit_Td as a double


% --- Executes during object creation, after setting all properties.
function edit_Td_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Td (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_FOPID.
function pushbutton_FOPID_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_FOPID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colorFOPID  = get(handles.pushbutton_FOPID, 'backgroundcolor');
stringFOPID = get(handles.pushbutton_FOPID, 'string');
set(handles.pushbutton_FOPID, 'enable', 'off');
set(handles.pushbutton_FOPID, 'backgroundcolor', handles.color.run);
set(handles.pushbutton_FOPID, 'string', handles.run);
pause(1e-1);

try
[alpha,beta,gamma] = function_FOPID_para(handles.selectPoint, handles.r1, handles.r2, handles.mu, handles.Kc, handles.Tc);
set(handles.edit_alpha, 'string', num2str(alpha, '%.4f'));   % 显示参数
set(handles.edit_beta,  'string', num2str(beta,  '%.4f'));
set(handles.edit_gamma, 'string', num2str(gamma, '%.4f'));

% 控制器表达式 C(s) = Kp(1 + 1/(Ti*s^lambda) + Td*s^mu)
[Kp,Ti,Td,lambda] = function_FOPID(handles.selectPoint, handles.r1, handles.r2, handles.mu, handles.Kc, handles.Tc);

set(handles.edit_Kp, 'string', num2str(Kp, '%.4f'));   % 显示参数
set(handles.edit_Ti, 'string', num2str(Ti, '%.4f'));
set(handles.edit_Td, 'string', num2str(Td, '%.4f'));

% 控制器表达式转换 C(s) = kp + ki/s^lambda + kd*s^mu)
handles.kpo = Kp;
handles.kio = Kp/Ti;
handles.kdo = Kp*Td;
handles.lambda = lambda;
handles.ifo = ousta_fod(-lambda,10,1e-5,1e+5);               % integral
handles.dfo = ousta_fod(handles.mu,10,1e-5,1e+5);            % differential
handles.falgFOPID = true;
guidata(hObject, handles);

set(handles.text_kp, 'string', num2str(handles.kpo,'%.4f'));                % 显示控制器
set(handles.text_ki, 'string', num2str(handles.kio,'%.4f'));
set(handles.text_kd, 'string', num2str(handles.kdo,'%.4f'));
set(handles.text_lam,'string', num2str(handles.lambda,'%.2f'));
set(handles.text_mu, 'string', num2str(handles.mu,'%.2f'));
catch
    errordlg('\fontsize{10} The input r_1, r_2 or \mu is not suitable !', 'ERROR', handles.opts);
end

set(handles.pushbutton_FOPID, 'backgroundcolor', colorFOPID);
set(handles.pushbutton_FOPID, 'string', stringFOPID);





% ................................ Step 7 ................................. %

function edit_stepValue_Callback(hObject, eventdata, handles)
% hObject    handle to edit_stepValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_stepValue as text
%        str2double(get(hObject,'String')) returns contents of edit_stepValue as a double


% --- Executes during object creation, after setting all properties.
function edit_stepValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_stepValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_simTime_Callback(hObject, eventdata, handles)
% hObject    handle to edit_simTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_simTime as text
%        str2double(get(hObject,'String')) returns contents of edit_simTime as a double


% --- Executes during object creation, after setting all properties.
function edit_simTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_simTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_disTime_Callback(hObject, eventdata, handles)
% hObject    handle to edit_disTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_disTime as text
%        str2double(get(hObject,'String')) returns contents of edit_disTime as a double


% --- Executes during object creation, after setting all properties.
function edit_disTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_disTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_disValue_Callback(hObject, eventdata, handles)
% hObject    handle to edit_disValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_disValue as text
%        str2double(get(hObject,'String')) returns contents of edit_disValue as a double


% --- Executes during object creation, after setting all properties.
function edit_disValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_disValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% ........................... Functional Area ............................. %

% --- Executes on button press in pushbutton_nyquist.
function pushbutton_nyquist_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_nyquist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colorNyquist  = get(handles.pushbutton_nyquist, 'backgroundcolor');
stringNyquist = get(handles.pushbutton_nyquist, 'string');
set(handles.pushbutton_nyquist, 'enable', 'off');
set(handles.pushbutton_nyquist, 'backgroundcolor', handles.color.run);
set(handles.pushbutton_nyquist, 'string', handles.run);
pause(1e-1);

handles.fig_nyquist = figure('Name', 'Nyquist Diagram');                    % Nyquist Diagram
hold on;
grid on;
title('Nyquist diagram of open-loop system for different controllers','FontName','Times New Roman','FontSize',15);
xlabel('Real','FontName','Times New Roman','FontSize',15);
ylabel('Imag','FontName','Times New Roman','FontSize',15);
if handles.falgFOPID
    Gc = handles.kpo + handles.kio*handles.ifo + handles.kdo*handles.dfo;
    Ls = handles.GpLa * Gc;                                                 % 画 Nyquist 图参数
    [ReNyquistFOPID,ImNyquistFOPID, ~] = nyquist(Ls, handles.w);
    plot(squeeze(ReNyquistFOPID), squeeze(ImNyquistFOPID), ...
        'Color',handles.color.PILamD, 'LineWidth',2, 'DisplayName','ZN-PI^{\lambda}D^{\mu}');
end
if isfield(handles, 'selectPoint')
    axis([-1.2 0.2 -1.5 0.5]);
    if handles.selectPoint
        plot(-0.5,-0.5*(-1/(2*pi*0.5)+0.125*2*pi), '.r', 'MarkerSize',25, 'LineWidth',2, 'DisplayName','New ZN-point');
    else
        plot(-0.6,-0.6*(-1/(2*pi*0.5)+0.125*2*pi), '.k', 'MarkerSize',25, 'LineWidth',2, 'DisplayName','ZN-point');
    end
else
    t = 0:0.1:2*pi;
    x = 16*sin(t).^3;
    y = 13*cos(t)-5*cos(2*t)-2*cos(3*t)-cos(4*t);
    plot(x,y,'-r', 'LineWidth',2, 'DisplayName','No controller generated');
    axis equal;
end
legend;
hold off;
guidata(hObject, handles);
set(handles.pushbutton_nyquist, 'backgroundcolor', colorNyquist);
set(handles.pushbutton_nyquist, 'string', stringNyquist);
set(handles.pushbutton_nyquist, 'enable', 'on');


% --- Executes on button press in pushbutton_timeResponse.
function pushbutton_timeResponse_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_timeResponse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colorTime  = get(handles.pushbutton_timeResponse, 'backgroundcolor');
stringTime = get(handles.pushbutton_timeResponse, 'string');
set(handles.pushbutton_timeResponse, 'enable', 'off');
set(handles.pushbutton_timeResponse, 'backgroundcolor', handles.color.run);
set(handles.pushbutton_timeResponse, 'string', handles.run);
pause(1e-1);

try
    step_value = str2double(get(handles.edit_stepValue, 'string'));   % 读取默认仿真参数
    sim_time   = str2double(get(handles.edit_simTime,   'string'));
    disturb_step_value = str2double(get(handles.edit_disValue,  'string'));
    disturb_step_time  = str2double(get(handles.edit_disTime,   'string'));
    
    handles.fig_time = figure('Name', 'Time Response');                                            % Time Response Diagram
    hold on;
    title('Step response of closed-loop system for different controllers','FontName','Times New Roman','FontSize',15);
    xlabel('Time (s)',     'FontName','Times New Roman','FontSize',15);
    ylabel('Step response','FontName','Times New Roman','FontSize',15);
    plot([0, sim_time], [step_value, step_value], '--k', 'LineWidth',2, 'DisplayName','Input');
    if handles.falgFOPID
        optionsFOPID = simset('SrcWorkspace', 'current');
        Ga  = handles.Ga;                                                           % 仿真参数初始化
        Gp  = handles.Gp;
        L   = handles.L;
        Gp.iodelay = 0;
        kpo = handles.kpo;
        kio = handles.kio;
        kdo = handles.kdo;
        ifo = handles.ifo;            % integral
        dfo = handles.dfo;            % differential
        
        warning off;
        open_system('Model_ZN_FOPID','loadonly');
        sim('Model_ZN_FOPID.mdl',sim_time, optionsFOPID);
        close_system('Model_ZN_FOPID', 0);
        
        plot(time, FOPID_out, 'Color',handles.color.PILamD, 'LineWidth',2, 'DisplayName','ZN-PI^{\lambda}D^{\mu}');
    end
    legend;
    hold off;
    guidata(hObject, handles);
catch
    close(handles.fig_time);
    errordlg('\fontsize{10} Please check the entered simulation parameters or the model "Model\_ZN\_FOPID.mdl" !', 'ERROR', handles.opts);
end
set(handles.pushbutton_timeResponse, 'backgroundcolor', colorTime);
set(handles.pushbutton_timeResponse, 'string', stringTime);
set(handles.pushbutton_timeResponse, 'enable', 'on');


% --- Executes on button press in pushbutton_simulink.
function pushbutton_simulink_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_simulink (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colorSimModel  = get(handles.pushbutton_simulink, 'backgroundcolor');
stringSimModel = get(handles.pushbutton_simulink, 'string');
set(handles.pushbutton_simulink, 'enable', 'off');
set(handles.pushbutton_simulink, 'backgroundcolor', handles.color.run);
set(handles.pushbutton_simulink, 'string', handles.run);
pause(1e-1);

Model_ZN_FOPID;

set(handles.pushbutton_simulink, 'backgroundcolor', colorSimModel);
set(handles.pushbutton_simulink, 'string', stringSimModel);
set(handles.pushbutton_simulink, 'enable', 'on');


% --- Executes on button press in pushbutton_comparison1.
function pushbutton_comparison1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_comparison1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton_comparison1, 'enable', 'off');
fig_step = gcf;
GUI_Comparison1;
close(fig_step);


% --- Executes on button press in pushbutton_comparison2.
function pushbutton_comparison2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_comparison2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton_comparison2, 'enable', 'off');
fig_step = gcf;
GUI_Comparison2;
close(fig_step);


% --- Executes on button press in pushbutton_reset.
function pushbutton_reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton_reset, 'enable', 'off');
opts.Interpreter = 'tex';
opts.Default = 'No';
clear_choice = questdlg('\fontsize{10} Clear all records?', 'Warning', 'Yes', 'No', opts);
switch clear_choice
    case 'No'
        set(handles.pushbutton_reset, 'enable', 'on');
        return;
    case 'Yes'
end
% ................................ Step 1 ................................. %
set(handles.edit_Ns, 'string', '[ N(s) ]');
set(handles.edit_Ms, 'string', '[ M(s) ]');
set(handles.edit_n,  'string', 'n');
set(handles.edit_L,  'string', 'L');
% ................................ Step 2 ................................. %
set(handles.popupmenu_Ta,        'value', 1);
set(handles.text_Ga,             'string', 'Ga(s) = ');
set(handles.text_compensatorNum, 'string', '( s / Ta + 1 )');
set(handles.text_compensatorN,   'string', 'n');
set(handles.text_frac,           'string', '——————————————————');
set(handles.text_compensatorDen, 'string', '( Ta s + 1 )');
set(handles.text_compensatorM,   'string', 'm');
set(handles.pushbutton_Ga, 'backgroundcolor', handles.color.controller);
set(handles.pushbutton_Ga, 'string', 'get Ga(s)');
% ................................ Step 3 ................................. %
set(handles.edit_Kc, 'string', 'Kc');
set(handles.edit_Tc, 'string', 'Tc');
set(handles.pushbutton_relayTest, 'backgroundcolor', handles.color.controller);
set(handles.pushbutton_relayTest, 'string', 'Relay Test');
set(handles.pushbutton_relayTest, 'enable', 'off');
% ................................ Step 4 ................................. %
set(handles.popupmenu_point, 'value', 1);
set(handles.popupmenu_point, 'enable', 'off');
% ................................ Step 5 ................................. %
set(handles.edit_r1, 'string',   '4');
set(handles.edit_r2, 'string',   '1');
set(handles.edit_mu, 'string',   '1');
set(handles.pushbutton_apply,    'backgroundcolor', handles.color.controller);
set(handles.pushbutton_apply,    'string', 'Apply');
set(handles.pushbutton_apply,    'enable', 'off');
set(handles.pushbutton_funImage, 'backgroundcolor', handles.color.controller);
set(handles.pushbutton_funImage, 'string', 'Function Image');
set(handles.pushbutton_funImage, 'enable', 'off');
% ................................ Step 6 ................................. %
set(handles.edit_alpha, 'string', '');
set(handles.edit_beta,  'string', '');
set(handles.edit_gamma, 'string', '');
set(handles.edit_Kp,    'string', '');
set(handles.edit_Ti,    'string', '');
set(handles.edit_Td,    'string', '');
set(handles.text_kp,  'string', 'kp');
set(handles.text_ki,  'string', 'ki');
set(handles.text_lam, 'string', 'λ');
set(handles.text_kd,  'string', 'kd');
set(handles.text_mu,  'string', 'μ');
set(handles.pushbutton_FOPID, 'backgroundcolor', handles.color.controller);
set(handles.pushbutton_FOPID, 'string', 'FOPID');
set(handles.pushbutton_FOPID, 'enable', 'off');
% ................................ Step 7 ................................. %
set(handles.edit_stepValue, 'string', '1');
set(handles.edit_disValue,  'string', '0.5');
set(handles.edit_simTime,   'string', '100');
set(handles.edit_disTime,   'string', '50');
% ........................... Functional Area ............................. %
set(handles.pushbutton_nyquist, 'backgroundcolor', handles.color.function);
set(handles.pushbutton_nyquist, 'string', 'Nyquist');
set(handles.pushbutton_timeResponse, 'backgroundcolor', handles.color.function);
set(handles.pushbutton_timeResponse, 'string', 'Time Response');
set(handles.pushbutton_simulink, 'backgroundcolor', handles.color.function);
set(handles.pushbutton_simulink, 'string', 'Simulink Model');
% ..................... Delete Process Variable ........................... %
clear handles;
global reset;
handles = reset;
guidata(hObject, handles);
clc;
set(handles.pushbutton_reset, 'enable', 'on');


% --- Executes on button press in pushbutton_save.
function pushbutton_save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton_save, 'enable', 'off');

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

set(handles.pushbutton_save, 'enable', 'on');

