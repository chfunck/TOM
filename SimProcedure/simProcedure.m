function simProcedure(Mpar_raw)
%simProcedure(Mpar_raw)
%   Gets the raw data cell array from the GUI table
%   checks if all entries are valid and reformats the
%   data that can be used to generate OMEN CMD files
    
    %% Delete empty rows from the UI table
    Mpar = delEmptyRows(Mpar_raw);
    [n,m] = size(Mpar);
    TotNerror = 0;
    
    if n==0
        setProgressInfo('No entries to start the simulation', 2, gui_simulate, 't_progress');
    else
        %% Check  data from UI table and write them into Qdot objects
        for k=1:n
            setProgressInfo(['(', int2str(k), '/', int2str(n), ') Creating generic QDOA.'], 1, gui_simulate, 't_progress');
            [QDOG(k), Nerror] = writeQdot(Mpar(k,:),k);
            TotNerror = TotNerror + Nerror;
        end
        
        %% Write Cmd files and start simulation if all data are correct
        if TotNerror == 0
            setProgressInfo('Input parameters okay!', 1, gui_simulate, 't_progress');
            for k=1:n
                setProgressInfo(['(', int2str(k), '/', int2str(n), ') Creating OMEN Cmd file(s).'], 1, gui_simulate, 't_progress');
                simAll(QDOG(k));
            end
            setProgressInfo('hline', 0, gui_simulate, 't_progress');
        else
            setProgressInfo(['At least ', num2str(TotNerror), ' errors to be corrected. Cannot start simulation!'], 2, gui_simulate, 't_progress');
        end
    end
end