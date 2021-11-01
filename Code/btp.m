function varargout = btp(varargin)
% BTP MATLAB code for btp.fig
%      BTP, by itself, creates a new BTP or raises the existing
%      singleton*.
%
%      H = BTP returns the handle to a new BTP or the handle to
%      the existing singleton*.
%
%      BTP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BTP.M with the given input arguments.
%
%      BTP('Property','Value',...) creates a new BTP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before btp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to btp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help btp

% Last Modified by GUIDE v2.5 28-Feb-2021 20:57:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @btp_OpeningFcn, ...
                   'gui_OutputFcn',  @btp_OutputFcn, ...
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


% --- Executes just before btp is made visible.
function btp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to btp (see VARARGIN)

% Choose default command line output for btp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(handles.axes1,'visible', 'off');
% UIWAIT makes btp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = btp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load.
function load_Callback(~, ~, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img

[path , nofile] = imgetfile();
if nofile
    errordlg('No image Loaded','Error');
end
[~,name,~] = fileparts(path);
assignin('base','name',name);
img=imread(path);
img=im2double(img);

axes(handles.axes1);
imshow(img)
set( handles.img,'String', evalin('base','name') )
title ('\fontsize{20}\color[rgb]{0.996,0.592,0.0} Brain MRI ')


% --- Executes on button press in predict.
function predict_Callback(hObject, eventdata, handles)
% hObject    handle to predict (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img
THR =5;
BaseV=22.005;
bwimg=im2gray(img);
bwimg=imresize(bwimg,[100 100]);
[~, S , ~]=svd(bwimg);
Singular_Value=diag(S);
NewV=norm(Singular_Value);
diff = abs(BaseV-NewV);
if diff<=THR
    prediction='Normal';
else
    prediction='Abnormal';   
end
set( handles.newv,'String', num2str(NewV,3) )
set( handles.diff,'String', num2str(diff,3) )
set( handles.pre,'String', prediction )
if prediction == "Abnormal"
   set( handles.pre,'ForegroundColor', [1,0,0] )
else
    set( handles.pre,'ForegroundColor', [0,1,0] )
end
