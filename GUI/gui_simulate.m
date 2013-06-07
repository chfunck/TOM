function varargout = gui_simulate(varargin)
% GUI_SIMULATE MATLAB code for gui_simulate.fig
%      GUI_SIMULATE, by itself, creates a new GUI_SIMULATE or raises the existing
%      singleton*.
%
%      H = GUI_SIMULATE returns the handle to a new GUI_SIMULATE or the handle to
%      the existing singleton*.
%
%      GUI_SIMULATE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SIMULATE.M with the given input arguments.
%
%      GUI_SIMULATE('Property','Value',...) creates a new GUI_SIMULATE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_simulate_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_simulate_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_simulate

% Last Modified by GUIDE v2.5 23-May-2013 15:25:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_simulate_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_simulate_OutputFcn, ...
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


% --- Executes just before gui_simulate is made visible.
function gui_simulate_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_simulate (see VARARGIN)

% Choose default command line output for gui_simulate
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_simulate wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_simulate_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pb_startsim.
function pb_startsim_Callback(hObject, eventdata, handles)
% hObject    handle to pb_startsim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delProgressInfo(gui_simulate, 't_progress');
setProgressInfo('hline', 0, gui_simulate, 't_progress')
setProgressInfo('Starting Simulation Procedure...', 1, gui_simulate, 't_progress')
Mpar_raw = get(handles.uitable1,'data');
simProcedure(Mpar_raw);



% --- Executes during object creation, after setting all properties.
function uitable1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% --- Executes when entered data in editable cell(s) in uitable1.
A = get(hObject,'data');
A(:) = {''};
% Default values
%  A(:,2) = {'1'};
%  A(:,6) = {'0'};
set(hObject,'data',A);


function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)



function t_progress_Callback(hObject, eventdata, handles)
% hObject    handle to t_progress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of t_progress as text
%        str2double(get(hObject,'String')) returns contents of t_progress as a double


% --- Executes during object creation, after setting all properties.
function t_progress_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t_progress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --------------------------------------------------------------------
function m_clearTable_Callback(hObject, eventdata, handles)
% hObject    handle to m_clearTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uitable1_CreateFcn(handles.uitable1, eventdata, handles)


% --------------------------------------------------------------------
function m_help_Callback(hObject, eventdata, handles)
% hObject    handle to m_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open('TOMmanual.pdf')


% --------------------------------------------------------------------
function m_gui_db_Callback(hObject, eventdata, handles)
% hObject    handle to m_gui_db (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_db();


% --------------------------------------------------------------------
function m_addrows_Callback(hObject, eventdata, handles)
% hObject    handle to m_addrows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
A = get(handles.uitable1,'data');
[n,m] = size(A);
B = cell(n+5,m);
B(:) = {''};
% Default values
%  B(:,2) = {'1'};
%  B(:,6) = {'0'};
B(1:n,:) = A;
set(handles.uitable1,'data',B);
