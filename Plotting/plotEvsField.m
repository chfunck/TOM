function plotEvsField(QDOA)
% plotEvsField(QDOA)
% Plot Energylevels againts applied electric field
% Degeneracy (precision 0.005) is shown

global config;
N= length(QDOA);

xAxis = cell2mat( {QDOA(:).Efield} );
xspace = max(xAxis) - min(xAxis);
DegSpaceing = 0.005*xspace;
if DegSpaceing < 0.001
    DegSpaceing = 0.001;
end

for k =1:N
    
    VBpath = [config.simulations QDOA(k).path '/VB_E_0_0.dat'];
    CBpath = [config.simulations QDOA(k).path '/CB_E_0_0.dat'];
    if exist( CBpath ) > 0
        CBE = load(CBpath);
        plotDegEnergy(CBE, xAxis(k), DegSpaceing);
    end
    if exist( VBpath ) > 0
        VBE = load(VBpath);
        plotDegEnergy(VBE, xAxis(k), DegSpaceing);
    end
    xlabel('e-field in V/nm');
%     xlabel('Degeneracy');
    ylabel('Energy in eV');
     
end

end

function plotDegEnergy(E,x,DegSpaceing)
    L = length(E);
    precision = 0.001;
    roundedE = round(E/precision)*precision;
    x = ones(L,1).*x;
    
    for i=2:L            
        if roundedE(i)==roundedE(i-1)
            x(i) = x(i-1)+DegSpaceing;
        end
    end
    hold on;
    plot(x, E, '.b');
    title(sprintf('precision %g',precision));
end
