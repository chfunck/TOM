function setProgressInfo(msg, opt, fObject, hObject)
%setProgessInfo(msg, opt, fObject, hObject)
%   msg:        string that should be displayed
%               type 'hline' for a horizontal line
%   opt:        opt = 0     Horizontal line
%               opt = 1     Message with time stamp
%               opt = 2     Warning
%   fObject:    figure, where the information
%               will be displayed (gui_simulate,...)
%   hObject:    Tag (as string) of the object in the figure,
%               where the information will be displayed
%               (t_progess,...)

    guiData = guidata(fObject);
    handle  = getfield(guiData, hObject);
    current = get(handle,'String');

    switch opt
        case 0
            new = repmat('*',1,80);
        case 1
            new = [getTimeDate(2), ': ', msg];
        case 2
            new = ['WARNING: ', msg];
    end

    str = [current;{new}];
    set(handle,'String',str);

end