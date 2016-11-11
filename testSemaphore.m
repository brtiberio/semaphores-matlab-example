function varargout = testSemaphore(varargin)
% TESTSEMAPHORE MATLAB code for testSemaphore.fig
%      TESTSEMAPHORE, by itself, creates a new TESTSEMAPHORE or raises the existing
%      singleton*.
%
%      H = TESTSEMAPHORE returns the handle to a new TESTSEMAPHORE or the handle to
%      the existing singleton*.
%
%      TESTSEMAPHORE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TESTSEMAPHORE.M with the given input arguments.
%
%      TESTSEMAPHORE('Property','Value',...) creates a new TESTSEMAPHORE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before testSemaphore_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to testSemaphore_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help testSemaphore

% Last Modified by GUIDE v2.5 11-Nov-2016 10:38:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @testSemaphore_OpeningFcn, ...
                   'gui_OutputFcn',  @testSemaphore_OutputFcn, ...
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


% --- Executes just before testSemaphore is made visible.
function testSemaphore_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to testSemaphore (see VARARGIN)

% Choose default command line output for testSemaphore
handles.output = hObject;
%--------------------------------------------------------------------------
% lets add semaphores class load
%--------------------------------------------------------------------------
evalin('base','import java.util.concurrent.Semaphore');
evalin('base', 'mutex = Semaphore(1);');
%--------------------------------------------------------------------------
% lets create our timer
%--------------------------------------------------------------------------
handles.updateTimer = timer('Name', 'updateTimer', 'Period', 0.2, ...
	'ExecutionMode', 'fixedRate', 'BusyMode', 'drop', ...
	'timerfcn', {@update, hObject, eventdata, handles});
%--------------------------------------------------------------------------
handles.holdStatus = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes testSemaphore wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = testSemaphore_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in goButton.
function goButton_Callback(hObject, eventdata, handles)
% hObject    handle to goButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mutex = evalin('base','mutex');
mutex.acquire();
if(handles.goButton.Value ==1)
	start(handles.updateTimer);
	handles.goButton.String = 'Stop';
	handles.holdButton.Enable = 'on';
else
	stop(handles.updateTimer);
	handles.goButton.String = 'Run';
	handles.holdButton.Enable = 'off';
end
mutex.release();

% Hint: get(hObject,'Value') returns toggle state of goButton


% --- Executes on button press in holdButton.
function holdButton_Callback(hObject, eventdata, handles)
% hObject    handle to holdButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mutex = evalin('base','mutex');
mutex.acquire();
if(strcmp(handles.holdButton.Enable,'on'))
	%pause for 3 seconds
	handles.holdButton.Enable = 'off';
	handles.goButton.Enable = 'off';
	pause(3);
	handles.holdButton.Enable = 'on';
	handles.goButton.Enable = 'on';
end
mutex.release();

% Hint: get(hObject,'Value') returns toggle state of holdButton



function update(obj, event, hObject, eventdata, handles)
mutex = evalin('base','mutex');
if(mutex.tryAcquire == 0)
	return;
else
	handles.randomText.String = rand();
end
mutex.release();


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mutex = evalin('base','mutex');
mutex.acquire();
stop(handles.updateTimer);
mutex.release();
% Hint: delete(hObject) closes the figure
delete(hObject);
