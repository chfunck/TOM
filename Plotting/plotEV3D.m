function plotEV3D(QDOA, band, Mod)
% plotEV3D(QDOA, band, Mod)
% Plot wavefn of QDOA. 
% Color code: red = high probability density, blue = low.
% for Modes specified in vector 
% for band = 'CB' or 'VB'

global config;

    for k =1:length(QDOA)
        
        % load Layer_Matrix and EVs
        simPath = [config.simulations, QDOA(k).path];
        LayerMatrix = load([simPath, '/Layer_Matrix.dat']);
        if isequal(band, 'CB')
            EV = load([simPath, '/CB_V_0_0.dat']);
            E = load([simPath, '/CB_E_0_0.dat']);
        elseif isequal(band, 'VB')
            EV = load([simPath, '/VB_V_0_0.dat']);
            E = load([simPath, '/VB_E_0_0.dat']);
        end
        
        [NAtom,~] = size(LayerMatrix);            
        [n,m]  = size( EV );
        NOrb = n/NAtom; %nr of orbitals
        AllMod = m/2;

        if nargin < 3
            Mod = 1:m/2; %default: nr of modes = all modes
        end

        % convert EV to probability (psi^2) for requested modes
        psi2 = EV2psi(EV, NOrb, AllMod);
   
    % PLOT 
        for i=Mod,
            h=colormap;
       
%             figure(100+10*k+i);
            figure
            suptitle( strrep(sprintf('plot ID: %i, mat: %s, mode-Id: %i, E-level: %g \n color code: probability density high - low: red - blue', k, QDOA(k).mat_name, i, E(i) ),'_','\_') );
       
            psi = psi2(:,i);
            psi=psi/max(psi)*length(h);
            
            title( sprintf('%s mode %i',band,i) );            
            hold on
            
            for IA=1:length(LayerMatrix(:,1)),
                plot3(LayerMatrix(IA,1),LayerMatrix(IA,2),LayerMatrix(IA,3),'ko','MarkerSize',8,'MarkerFaceColor',h(ceil(psi(IA)),:))
            end

            xlabel('x');
            ylabel('y');
            zlabel('z');     
        end
    end
end
