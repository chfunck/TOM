function delProgressInfo(fObject, hObject)
%delProgressInfo(fObject, hObject)
%   fObject:    figure, where the information
%               will be displayed (gui_simulate,...)
%   hObject:    Tag (as string) of the object in the figure,
%               where the information will be displayed
%               (t_progess,...)

guiData = guidata(fObject);
handle  = getfield(guiData, hObject);
set(handle,'String','');

end

