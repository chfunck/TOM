function varargout = gui_databaseAll(varargin)
% GUI_DATABASEALL MATLAB code for gui_databaseAll.fig
%      GUI_DATABASEALL, by itself, creates a new GUI_DATABASEALL or raises the existing
%      singleton*.
%
%      H = GUI_DATABASEALL returns the handle to a new GUI_DATABASEALL or the handle to
%      the existing singleton*.
%
%      GUI_DATABASEALL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_DATABASEALL.M with the given input arguments.
%
%      GUI_DATABASEALL('Property','Value',...) creates a new GUI_DATABASEALL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_databaseAll_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_databaseAll_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_databaseAll

% Last Modified by GUIDE v2.5 23-May-2013 21:01:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_databaseAll_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_databaseAll_OutputFcn, ...
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
end


% --- Executes just before gui_databaseAll is made visible.
function gui_databaseAll_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_databaseAll (see VARARGIN)

% Choose default command line output for gui_databaseAll
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_databaseAll wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end


% --- Outputs from this function are returned to the command line.
function varargout = gui_databaseAll_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end



% --- Executes during object creation, after setting all properties.
function uitable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

    QDOA = getQDOA();
    Mpar = QDOA2Matrix(QDOA);
    [n,m] = size(Mpar);
    edit  = cell(n,2);
    edit(:,1) = {false};
    edit(:,2) = {''};
    set(hObject,'data',[edit, Mpar]);
end


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes when entered data in editable cell(s) in uitable.
function uitable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

    if eventdata.Indices(2) == 2 && strcmp(eventdata.NewData,'Simulation set (path)')
        set(handles.t_status,'string','Opening Simulation folder!');
        global config;
        Data = get(handles.uitable, 'data');
        row  = eventdata.Indices(1);
        col  = eventdata.Indices(2);
        path = Data{row,20};
        system(['nautilus ', config.simulations, path]);
        Data{row,col} = eventdata.PreviousData;
        set(handles.uitable, 'data', Data);
    end
end


function [QDOA] = getSelection(hObject, eventdata, handles)
% gives back the selected UI Table entries as an QDOA
    Data = get(handles.uitable,'data');
    if sum(cell2mat(Data(:,1))) == 0
        set(handles.t_status,'string','Please make a selection!');
        QDOA = {};
    else
        [n,m] = size(Data);
        l = 1;
        global config;
        for k=1:n
            if isequal(Data{k,1},true)
                ID = Data{k,20};
                path = [config.simulations, ID, '/QDO.mat'];
                load(path);
                QDOA(l) = QDO;
                l = l+1;
            end
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                          MENU ENTRIES                          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------------------------------------------
function m_edit_Callback(hObject, eventdata, handles)
% hObject    handle to m_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --------------------------------------------------------------------
function m_plotting_Callback(hObject, eventdata, handles)
% hObject    handle to m_plotting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --------------------------------------------------------------------
function m_allBandGaps_Callback(hObject, eventdata, handles)
% hObject    handle to m_allBandGaps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    QDOA = getQDOA();
    plotBandGap(QDOA);
    set(handles.t_status,'string','Band Gaps plotted');
end

% --------------------------------------------------------------------
function m_bandGapsSelection_Callback(hObject, eventdata, handles)
% hObject    handle to m_bandGapsSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    QDOA = getSelection(hObject, eventdata, handles);
    if isempty(QDOA) == 0
        plotBandGap(QDOA);
        set(handles.t_status,'string','Band Gaps plotted');
    end
end

% --------------------------------------------------------------------
function m_3Dstructure_Callback(hObject, eventdata, handles)
% hObject    handle to m_3Dstructure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    QDOA = getSelection(hObject, eventdata, handles);
    if isempty(QDOA) == 0
        plotQDStructure(QDOA);
        set(handles.t_status,'string','3D Structures plotted');
    end
end

% --------------------------------------------------------------------
function m_energyLevels_Callback(hObject, eventdata, handles)
% hObject    handle to m_energyLevels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    QDOA = getSelection(hObject, eventdata, handles);
    if isempty(QDOA) == 0
        plotEnergyLevels(QDOA);
        set(handles.t_status,'string','3D Structures plotted');
    end
end


% --------------------------------------------------------------------
function m_export_Callback(hObject, eventdata, handles)
% hObject    handle to m_export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.t_status,'string','Exporting QDOA...');
    QDOA = getSelection(hObject, eventdata, handles);
    if isempty(QDOA) == 0
        assignin('base','ExportedQDOA',QDOA);
        set(handles.t_status,'string','Export done! QDOA available in workspace as: ExportedQDOA');
    end
end

% --------------------------------------------------------------------
function m_selectAll_Callback(hObject, eventdata, handles)
% hObject    handle to m_selectAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    Data = get(handles.uitable,'data');
    Data(:,1) = {true};
    set(handles.uitable,'data',Data);
    set(handles.t_status,'string','');
end

% --------------------------------------------------------------------
function m_selectNone_Callback(hObject, eventdata, handles)
% hObject    handle to m_selectNone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    Data = get(handles.uitable,'data');
    Data(:,1) = {false};
    set(handles.uitable,'data',Data);
    set(handles.t_status,'string','');
end

% --------------------------------------------------------------------
function m_refresh_Callback(hObject, eventdata, handles)
% hObject    handle to m_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    uitable_CreateFcn(handles.uitable, eventdata, handles);
end


% --------------------------------------------------------------------
function m_wavefunctios_Callback(hObject, eventdata, handles)
% hObject    handle to m_wavefunctios (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --------------------------------------------------------------------
function m_3D_Callback(hObject, eventdata, handles)
% hObject    handle to m_3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --------------------------------------------------------------------
function m_crossSection_Callback(hObject, eventdata, handles)
% hObject    handle to m_crossSection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    QDOA = getSelection(hObject, eventdata, handles);
    if isempty(QDOA) == 0
        defaultNMod = 4;
        plotEV3DcrossSection(QDOA, defaultNMod)
        set(handles.t_status,'string','3D Cross Section Wavefunction plotted');
    end
end


% --------------------------------------------------------------------
function m_3Dhigh_Callback(hObject, eventdata, handles)
% hObject    handle to m_3Dhigh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --------------------------------------------------------------------
function m_help_Callback(hObject, eventdata, handles)
% hObject    handle to m_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    open('TOMmanual.pdf')
end


% --------------------------------------------------------------------
function m_gui_simulate_Callback(hObject, eventdata, handles)
% hObject    handle to m_gui_simulate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    gui_simulate;
end


% --------------------------------------------------------------------
function m_sort_Callback(hObject, eventdata, handles)
% hObject    handle to m_sort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    sort_gui_database(0);
end

% --------------------------------------------------------------------
function m_filter_Callback(hObject, eventdata, handles)
% hObject    handle to m_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    filter_gui_database(0);
end

% --------------------------------------------------------------------
function m_removeDuplicates_Callback(hObject, eventdata, handles)
% hObject    handle to m_removeDuplicates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    QDOA = getSelection(hObject, eventdata, handles);
        if isempty(QDOA) == 0
            [cleanedQDOA, duplicatesQDOA] = removeDuplicates(QDOA);
            deleteSimData(duplicatesQDOA);
            uitable_CreateFcn(handles.uitable, eventdata, handles);
            set(handles.t_status,'string','Duplicates removed - Table reloaded.');
        end
end

% --------------------------------------------------------------------
function m_delete_Callback(hObject, eventdata, handles)
% hObject    handle to m_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    QDOA = getSelection(hObject, eventdata, handles);
        if isempty(QDOA) == 0
            deleteSimData(QDOA);
            uitable_CreateFcn(handles.uitable, eventdata, handles);
            set(handles.t_status,'string','Selected simulation data deleted - Table reloaded.');
        end
end


% --------------------------------------------------------------------
function m_EvsField_Callback(hObject, eventdata, handles)
% hObject    handle to m_EvsField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    QDOA = getSelection(hObject, eventdata, handles);
    if isempty(QDOA) == 0
        figure;
        plotEvsField(QDOA)
        set(handles.t_status,'string','Energy vs E-Field');
    end
end

% --------------------------------------------------------------------
function m_VvsBGap_Callback(hObject, eventdata, handles)
% hObject    handle to m_VvsBGap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    QDOA = getSelection(hObject, eventdata, handles);
    if isempty(QDOA) == 0
        plotVoltBandGap(QDOA);
        set(handles.t_status,'string','Voltage vs Band Gap plotted');
    end
end

% --------------------------------------------------------------------
function m_3Dhigh_CB_Callback(hObject, eventdata, handles)
% hObject    handle to m_3Dhigh_CB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    QDOA = getSelection(hObject, eventdata, handles);
    if isempty(QDOA) == 0
        defaultNMod = 4;
        probLim = [0.2,0.5];
        plotEV3Dmax(QDOA, 'CB', probLim, (1:defaultNMod));
        set(handles.t_status,'string','High probability 3D Wavefunction plotted');
    end
end

% --------------------------------------------------------------------
function m_3Dhigh_VB_Callback(hObject, eventdata, handles)
% hObject    handle to m_3Dhigh_VB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    QDOA = getSelection(hObject, eventdata, handles);
    if isempty(QDOA) == 0
        defaultNMod = 4;
        probLim = [0.2,0.5];
        plotEV3Dmax(QDOA, 'VB', probLim, (1:defaultNMod));
        set(handles.t_status,'string','High probability 3D Wavefunction plotted');
    end
end

% --------------------------------------------------------------------
function m_3D_CB_Callback(hObject, eventdata, handles)
% hObject    handle to m_3D_CB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    QDOA = getSelection(hObject, eventdata, handles);
    if isempty(QDOA) == 0
        defaultNMod = 4;
        plotEV3D(QDOA, 'CB', 1:defaultNMod);
        set(handles.t_status,'string','3D Wavefunction plotted');
    end
end

% --------------------------------------------------------------------
function m_3D_VB_Callback(hObject, eventdata, handles)
% hObject    handle to m_3D_VB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    QDOA = getSelection(hObject, eventdata, handles);
    if isempty(QDOA) == 0
        defaultNMod = 4;
        plotEV3D(QDOA, 'VB', 1:defaultNMod);
        set(handles.t_status,'string','3D Wavefunction plotted');
    end
end


% --------------------------------------------------------------------
function m_allVvsBGap_Callback(hObject, eventdata, handles)
% hObject    handle to m_allVvsBGap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    plotVoltBandGap;
    set(handles.t_status,'string','Voltage vs Band Gap plotted');
end


% --------------------------------------------------------------------
function m_removeFailed_Callback(hObject, eventdata, handles)
% hObject    handle to m_removeFailed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    removeFailed();
    uitable_CreateFcn(handles.uitable, eventdata, handles);
    set(handles.t_status,'string','Failed simulations deleted - Table reloaded.');
end
