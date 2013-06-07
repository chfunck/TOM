function sort_gui_database(selection)
% This gives the gui_database column headers sorting functionality

    warning off;
    switch selection
        case 0
            guiData = guidata(gui_databaseAll);
        case 1
            guiData = guidata(gui_databaseSelection);
    end
    handle  = getfield(guiData,'uitable');

    jscrollpane = findjobj(handle);
    jtable = jscrollpane.getViewport.getView;
 
    % Now turn the JIDE sorting on
    jtable.setSortable(true);
    jtable.setAutoResort(true);
    jtable.setMultiColumnSortable(true);
    jtable.setPreserveSelectionsAfterSorting(true);
end