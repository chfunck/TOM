function writeCmdFile(QDO, filename)
% writeCmdFile(QDO, filename)
% writes the cmdfile for qdot object into the current directory
%********************************************************************

    file = fopen(filename,'w');
        
    fprintf(file,'// Command file for OMEN. \n \n');
            
    printVar(file, 'mat_name',QDO.mat_name, 'material_model');
    printVar(file, 'lattice_type',QDO.lattice_type, 'lattice');
    
    printVar(file, 'a0',QDO.a0, 'lattice constant');
    printVar(file, 'first_atom',QDO.first_atom, 'atom situated at [0 0 0]');
    
    
    printVar(file, 'open_system',QDO.open_system, ' ');
    printVar(file, 'tb',QDO.tb, 'tight-binding order');
    printVar(file, 'dsp3',QDO.dsp3, 'passivation energy [eV]');
    
    
    printVar(file, 'n_of_modes',QDO.n_of_modes, 'number of modes');
    printVar(file, 'max_bond_def',QDO.max_bond_def, 'maximum relative bond deformation (should only be changed if very large strain)');
    
    
    printVar(file, 'x',QDO.x, 'transport direction');
    printVar(file, 'y',QDO.y, 'direction of confinement');
    printVar(file, 'z',QDO.z, 'direction of confinement');
    
    %printVar(file, 'CPU_per_vd_point',qdot.CPU_per_vd_point, '');
    
    printVar(file, 'NVD',QDO.NVD, 'nr of drain voltages Vd=Vdmin:(Vdmax-Vdmin)/(NVD-1):Vdmax');
    printVar(file, 'Vdmin',QDO.Vdmin, 'absolute minimum drain potential');
    printVar(file, 'Vdmax',QDO.Vdmax, 'absolute maximum drain potential');
    
    if QDO.update_bs_target==1;
        printVar(file, 'update_bs_target', QDO.update_bs_target, ' ');
        printVar(file, 'bs_target', QDO.bs_target, ' ');
    end
    
%     printVar(file, 'default_directory',qdot.default_directory, '');

    printVar(file, 'no_mat',QDO.no_mat, 'nr of pieces that form the nanowire (channel+oxide0');
    printVar(file, 'no_channel_mat',QDO.no_channel_mat, 'nr of pieces that form the nanowire channel');
    printVar(file, 'no_oxide_mat',QDO.no_oxide_mat, 'nr of pieces that form the oxide around the wire');
    
    
    printGeometry(file,QDO);
    
    if QDO.update_bs_target==1                        
        cmds = sprintf(['/* Commands */ \n\n'...
                        'command(1) = Write_Layer_Matrix;\n'...
                        'command(2) = Write_Hamiltonian_Matrix;\n'...
                        'command(3) = CB_Closed;\n']);
    else
        cmds = sprintf(['/* Commands */ \n\n'...
                    'command(1) = Write_Layer_Matrix;\n'...
                    'command(2) = Write_Hamiltonian_Matrix;\n'...
                    'command(3) = CB_Closed;\n'...
                    'command(4) = VB_Closed;\n'...
                    '//command(1) = Optial_Matrix_Element;\n']);
    end

    fprintf(file, '%s', cmds);

    fclose(file);
end

function printVar(file, varname, value, comment)

    if ischar(value) %value is a string
    fprintf(file,'%s   =   %s;     // %s \n\n',varname, value, comment);
    
    elseif (isfloat(value) == 1) && (length(value) == 1)
            fprintf(file,'%s   =   %g;     // %s \n\n',varname, value, comment);

    else %value is a float vector or matrix  
        fprintf(file,'%s   =   %s;     // %s \n\n',varname, mat2str(value), comment);

    end
end

function printGeometry(file, qdot)
    fprintf(file,'\n \n // Geometry \n \n');
        
    for i = 1:length(qdot.geometry);
        
        nr = int2str(i);
        nrbrack = ['(',nr,')'];
        
        
        printVar(file,['mat_type',nrbrack],qdot.geometry(i).type, 'type of material: square or circle');
        
        printVar(file,['mat_cs',nrbrack],qdot.geometry(i).cs, 'does the material determine the nanowire cross section');
        
        printVar(file,['mat_id',nrbrack],qdot.geometry(i).id, '');
        
        printVar(file,['mat_radius',nrbrack],qdot.geometry(i).radius, 'radius of circle');
        
        printVar(file,['mat_coord(',nr,',1)'],qdot.geometry(i).coord, 'type of material: square or circle');
        
    end
end