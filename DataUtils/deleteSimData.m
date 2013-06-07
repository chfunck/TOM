function  deleteSimData(QDOA)
% deleteSimData(QDOA)
% WARNING: Deletes the simulation folders and their contents for all
% objects in QDOA

    global config;
    for k = 1:length(QDOA)
        dir = [config.simulations, QDOA(k).path];
        rmdir( dir, 's' );
    end
end