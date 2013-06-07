function plotEV3Dmax(QDOA, band, probLim, Mod)
% plotEV3Dmax(QDOA, band, probLim, Mod)
% Plot wavefn of QDOA:
% red appear atoms where probability density is largest:
% sum( psi( all red atoms ) )< probLim(1)
% yellow appear atoms where probability density is large:
% probLim(1) < sum( psi( all yellow and red atoms ) ) < probLim(2)
% band = 'CB' or 'VB'
% for Modes specified in vector 


global config;

    for k =1:length(QDOA)

        simPath = [config.simulations, QDOA(k).path];
        %simPath = sprintf('Simulations/ID%s_%s/', dots(k).timestamp, dots(k).mat_name);

        LayerMatrix = load([simPath, '/Layer_Matrix.dat']);
        if isequal(band, 'CB')
            EV = load([simPath, '/CB_V_0_0.dat']);
            E = load([simPath, '/CB_E_0_0.dat']);
%             plotid = 1;
        elseif isequal(band, 'VB')
            EV = load([simPath, '/VB_V_0_0.dat']);
            E = load([simPath, '/VB_E_0_0.dat']);
%             plotid = 2;
        end
        
        [NAtom,~] = size(LayerMatrix);            
        [n,m]  = size( EV );
        NOrb = n/NAtom; %nr of orbitals
        AllMod = m/2;

        if nargin < 4
            Mod = 1:m/2; %default: nr of modes = all modes
        end

    % convert EV to probability (psi^2) for requested modes
        psi2 = EV2psi(EV, NOrb, AllMod);
        
    % PLOT
        for i=Mod,
           
%             figure(1000*plotid+100*k+i);
            figure
            suptitle( strrep(sprintf('plotID: %i, mat: %s, Efield: %g, ModNr: %i, E-Level: %g eV', k, QDOA(k).mat_name, QDOA(k).Efield, i, E(i)),'_','\_') );
            title( sprintf('VB mode %i',i) );            

            psi = psi2(:,i);
            [~,sInd] = sort(psi,'descend');
            
            %plot grid
            scatter3(LayerMatrix(:,1), LayerMatrix(:,2), LayerMatrix(:,3), 50,'b');
            hold on

            %plot atoms where psi2 largest
            probSum = 0;
            IA=1;
            while probSum < probLim(1)                
                ind = sInd(IA);
                probSum = probSum + psi( ind );
                plot3(LayerMatrix(ind,1),LayerMatrix(ind,2),LayerMatrix(ind,3),'ko','MarkerSize',8,'MarkerFaceColor','r');       

                IA=IA+1;
            end
            while probSum < probLim(2)                
                ind = sInd(IA);
                probSum = probSum + psi( ind );
                plot3(LayerMatrix(ind,1),LayerMatrix(ind,2),LayerMatrix(ind,3),'ko','MarkerSize',8,'MarkerFaceColor','y');       

                IA=IA+1;
            end

            xlabel('x');
            ylabel('y');
            zlabel('z');
     
            
        end
    end
end
