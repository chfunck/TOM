function gui_db(varargin)
%gui_db(varargin)
%   Function with no argument loads whole database
%   gui_db(QDOA) only loads the quantum dot objects of the QDO array

    if nargin == 0
        gui_databaseAll;
        sort_gui_database(0);
    elseif nargin == 1
        setappdata(0,'USER_QDOA',varargin{1})
        gui_databaseSelection;
        sort_gui_database(1);
    else
        disp('Please only call with one Qdot Array!');
    end
end