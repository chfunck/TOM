function [QDOA, simSuccess] = simAll(QDOG)
% [QDOA, simSuccess] = simAll(QDOG)
% CREATE OMEN CMD FILE FOR EVERY PARAMETER COMBINATION
% PERFORMS OMEN SIMULATION FOR ALL CMD FILES
%
% returns:
% QDOA: array of qdot objs
% simSuccess(Ind)= true/false, concerning simulation of QDOA(Ind)
%
% creates a folder for each simulation, containing:
% Simulation Data created by OMEN
% Cmd File
% Logfile with console output of OMEN simulation
% qdot object containing the parameters
%********************************************************************
        
% PERFORM SWEEP
%********************************************************************
		    
    QDOA = sweep(QDOG); %create array of qdots with all parameters
    N = length(QDOA);

    
% DEFINITIONS
%********************************************************************
	global config;
    
    returnDir = pwd;
    
    cd(config.simulations);
    
    simSuccess = zeros(N,1); %each element changed to 1 if corresponding simulation is successfull
    
    mat = QDOG.mat_name; %matrial
    
    status = (-1)*ones(N,1); %status of each simulation. returned zero if sucessful
    
    consoleOut = cell(N,1); %console output for each sim will be saved here
    
    simTimestamp = cell(N,1); %Timestamp for each simulation
    logTimestamp = getTimeDate(5); %Timestamp for all simulations
    

% WRITE CMD FILE AND SIMULATE 
%********************************************************************

    t1 = tic; %measure time of all simulations

    for i = 1:N
		
        %print message
        fprintf(1, '\nSTART SIMULATION %i \n',i);
        message = sprintf('Start simulation %i',i);
        setProgressInfo(message, 1, gui_simulate, 't_progress');
        
        %timestamp for this simulation
        simTimestamp{i} = getTimeDate(5);
	
    % CREATE AND CHANGE DIR
		
        SIMDIR = sprintf('ID%s_%s', simTimestamp{i}, mat);
        mkdir(SIMDIR);
        cd(SIMDIR);
        
	% WRITE CMD FILE
            
        CMDFILENAME = 'qdot_cmd'; 
        
        writeCmdFile(QDOA(i), CMDFILENAME); %write the cmdfiles
			
	% SIMULATE WITH OMEN
        
        t2 = tic;   %measure time of single simulation
        
        UNIXCOMMAND = [config.OMEN, ' ', CMDFILENAME]; %create command string
        [status(i), consoleOut{i}] = unix( UNIXCOMMAND, '-echo') ; %execute

        singleTime = toc(t2);
		
        
	% SET DATA
        
        QDOA(i).timestamp = simTimestamp{i};
        QDOA(i).user        = config.user;
        QDOA(i).OMENversion = config.vOMEN;
        QDOA(i).machine     = config.machine;
        QDOA(i).path        = SIMDIR;
    
    % CHECK SUCCESS
    
        simSuccess(i) = checkSuccess( status(i), QDOA(i));
        QDOA(i).simulationStatus = simSuccess(i);

    % SAVE QDO

        QDONAME = 'QDO';  %name of mat-file in which the current qdot is saved
        QDO = QDOA(i);        
        save(QDONAME, 'QDO');        
		
	% WRITE LOGFILE OF THIS SIMULATIONS

        simlogFile = ['simlog_' simTimestamp{i} '.txt'];
        simlogfid = fopen(simlogFile, 'w');

        if  simSuccess(i) == 1  %simulation successful 
            fprintf(simlogfid, 'Simulation SUCCESSFUL.\n');
            fprintf(1, '\nEND OF SIMULATION %i: SUCCESSFUL.\n', i);
            setProgressInfo('SUCCESSFUL', 1, gui_simulate, 't_progress');
        else
            fprintf(simlogfid, 'Simulation FAILED.\n');
            fprintf(1, '\nEND OF SIMULATION %i: FAILED.\n',i);
            setProgressInfo('FAILED', 2, gui_simulate, 't_progress');
        end

        fprintf(simlogfid, 'elapsed time %f \n\nConsole output for simulation: %s \n\n' , singleTime, simTimestamp{i});
        fwrite(simlogfid, consoleOut{i});
        fclose(simlogfid);
        
		cd ..;
        
    end
    
    totalTime = toc(t1);
    

    
% WRITE LOGFILE OF ALL SIMULATIONS
%********************************************************************
    
    LOGDIR = ['log'];
    
    if exist( [config.simulations LOGDIR] , 'dir' ) ==0
        mkdir(LOGDIR);
    end
    
    cd(LOGDIR);

    LOGNAME = ['log_' logTimestamp '_' mat '.txt'];
    logfid = fopen(LOGNAME,'w');

    fprintf(logfid, 'Simulation %s %s \nTotal time: %f sec.\n\n',logTimestamp, mat, totalTime);

    %Check for failed simulations
    
    if( sum( simSuccess == 0 ) )
        failed = find( simSuccess == 0 );
        fprintf(logfid, 'Attempt to simulate %i qdots. \n', N);
        fprintf(logfid, 'Simulation failed for indices %s \n\n', sprintf('%d, ',failed));
        setProgressInfo('Some simulations FAILED!', 2, gui_simulate, 't_progress');
    else %all sim successful
        fprintf(logfid, 'All %i simulations terminated normally! \n\n', N);
        setProgressInfo('All simulations SUCCESSFUL!', 1, gui_simulate, 't_progress');
    end
    
    fprintf(logfid, 'CONSOLE OUTPUT OF EVERY SIMULATION: \n\n');
    for i =1:N
        fprintf(logfid, 'SIMULATION %s :\n\n%s \n\n-------------------- \n\n', simTimestamp{i}, consoleOut{i});
    end
    
    fclose(logfid);
    
    cd(returnDir);


end


function check = checkSuccess(status, QDO)

% check if the OMEN simulation was successful, returns 1 or 0
% status: status returned by unix function
% check status and if VB and/or CB files are created.

check = 0;

	if (status == 0) % terminated normally
        VB = exist( [QDO.path '/VB_V_0_0.dat'], 'file') ~= 0 ;
        CB = exist( [QDO.path '/CB_V_0_0.dat'], 'file') ~= 0 ;
        if (QDO.update_bs_target == 0) && CB && VB
            check = 1;
        elseif (QDO.update_bs_target == 1) && (CB || VB)
            check = 1;
        end
    end
end