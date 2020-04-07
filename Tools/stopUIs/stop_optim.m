function varargout = stop_optim(varargin)
% Copyright 2020 The MathWorks, Inc.
% STOP_OPTIM MATLAB code for stop_optim.fig
%      STOP_OPTIM, by itself, creates a new STOP_OPTIM or raises the existing
%      singleton*.
%
%      H = STOP_OPTIM returns the handle to a new STOP_OPTIM or the handle to
%      the existing singleton*.
%
%      STOP_OPTIM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STOP_OPTIM.M with the given input arguments.
%
%      STOP_OPTIM('Property','Value',...) creates a new STOP_OPTIM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stop_optim_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stop_optim_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stop_optim

% Last Modified by GUIDE v2.5 09-Mar-2016 13:57:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stop_optim_OpeningFcn, ...
                   'gui_OutputFcn',  @stop_optim_OutputFcn, ...
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


% --- Executes just before stop_optim is made visible.
function stop_optim_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stop_optim (see VARARGIN)

% Choose default command line output for stop_optim
handles.output = hObject;

handles.qq = 0;

assignin('base','flag',handles.qq);

% fid = fopen('FLAG.txt','w');
% fprintf(fid,'%s',num2str(handles.qq));
% fclose(fid);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes stop_optim wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = stop_optim_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1

handles.qq = get(hObject,'Value');

assignin('base','flag',handles.qq);

% fid = fopen('FLAG.txt','w');
% fprintf(fid,'%s',num2str(handles.qq));
% fclose(fid);

% Get default command line output from handles structure
varargout{1} = handles.output;
