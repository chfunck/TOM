function removeFailed()
%removeFailed()
% removes directories of failed simulations,
% i.e. QDO.simulationStatus == 0

    QDOA = getQDOA;
    for k=1:length(QDOA)
        if QDOA(k).simulationStatus == 0
            deleteSimData(QDOA(k));
        end
    end
end