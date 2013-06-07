function compareEV(QDOA, band, NMod, tol, propertyName, showGrid)
% compareEV(QDOA, band, Nmod, tol, propertyName, showGrid)
% plot EV along axis for multiple directions (x,y,z) in same window

    directions = [1 0 0;0 1 0;0 0 1];

    [Ndir,~] = size(directions);

    for k =1:Ndir
        for i=1:NMod       
            figure(i);
            subplot(Ndir,1,k);
            title( sprintf('mode %i, dir %s',i, mat2str(directions(k,:)) ) );
        end
        plotEVAlongAxis(QDOA, propertyName,[0 0 0], directions(k,:), showGrid, tol, NMod, band);
    end
end