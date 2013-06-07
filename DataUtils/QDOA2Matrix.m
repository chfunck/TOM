function matrix = QDOA2Matrix(QDOA)
% matrix = QDOA2Matrix(QDOA)
% creates cell matrix from QDOA, containing selected properties

    N = length(QDOA);
    M = 2; % number of properties displayed

    matrix = cell(N,M);

    for i = 1:N
        matrix{i,1} = QDOA(i).mat_name;
        matrix{i,2} = QDOA(i).geometry(1).id;
        matrix{i,3} = QDOA(i).geometry(1).type;
        matrix{i,4} = QDOA(i).geometry(1).radius;
        matrix{i,5} = mat2str(QDOA(i).geometry(1).coord);

        if length(QDOA(i).geometry) == 2
        matrix{i,6} = QDOA(i).geometry(2).id;
        matrix{i,7} = QDOA(i).geometry(2).type;
        matrix{i,8} = QDOA(i).geometry(2).radius;
        matrix{i,9} = mat2str(QDOA(i).geometry(2).coord);
        end

        matrix{i,10} = QDOA(i).n_of_modes;
        matrix{i,11} = QDOA(i).Vdmax;            
        matrix{i,12} = QDOA(i).a0;                
        matrix{i,13} = QDOA(i).tb;
        matrix{i,14} = QDOA(i).dsp3;

        matrix{i,15} = QDOA(i).timestamp(1:8);
        matrix{i,16} = QDOA(i).timestamp(10:13);                

        matrix{i,17} = QDOA(i).OMENversion;
        matrix{i,18} = QDOA(i).path;
        matrix{i,19} = QDOA(i).user;
        matrix{i,20} = QDOA(i).machine;
    end
end