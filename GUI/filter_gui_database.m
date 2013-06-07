function sort_gui_database(selection)
% This gives the gui_database column headers filtering functionality

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

    tableHeader = com.jidesoft.grid.AutoFilterTableHeader(jtable);
    tableHeader.setAutoFilterEnabled(true)
    tableHeader.setShowFilterName(true)
    tableHeader.setShowFilterIcon(true)
    jtable.setTableHeader(tableHeader)
    installer = com.jidesoft.grid.TableHeaderPopupMenuInstaller(jtable);
    pmCustomizer1 = com.jidesoft.grid.AutoResizePopupMenuCustomizer;
    installer.addTableHeaderPopupMenuCustomizer(pmCustomizer1);
    pmCustomizer2 = com.jidesoft.grid.TableColumnChooserPopupMenuCustomizer;
    installer.addTableHeaderPopupMenuCustomizer(pmCustomizer2);
    jscrollpane = javax.swing.JScrollPane(jtable);
    [hjtable,hjcontainer] = javacomponent(jscrollpane, [20 20 1800 950], gcf);
end