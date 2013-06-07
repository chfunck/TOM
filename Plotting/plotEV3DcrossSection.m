function plotEV3DcrossSection(QDOA, NMod)
% plotEV3DcrossSection(QDOA, NMod)
% Plot wavefn of QDOA 
% 2 cross sections for VB and CB modes in one figure
% new figures for new modes

global config;

    for k =1:length(QDOA)

        simPath = [config.simulations, QDOA(k).path];
        %simPath = sprintf('Simulations/ID%s_%s/', dots(k).timestamp, dots(k).mat_name);

        LayerMatrix = load([simPath, '/Layer_Matrix.dat']);
        CB_V = load([simPath, '/CB_V_0_0.dat']);
        VB_V = load([simPath, '/VB_V_0_0.dat']);

        [NAtom,~] = size(LayerMatrix);            
        [n,m]  = size( VB_V );
        NOrb = n/NAtom; %nr of orbitals

        if nargin < 2
            NMod = 1:m/2; %default: nr of modes = all modes
        end

        % convert EV to probability (psi^2) for requested modes
        psiCB2 = EV2psi(CB_V, NOrb, NMod);
        psiVB2 = EV2psi(VB_V, NOrb, NMod);

        for i=NMod,
%             plot3DunitCell( Layer_Matrix, psiCB2(:,i), sprintf('CB mode %i',i), 1000+(i-1))
%             plot3DunitCell( Layer_Matrix, psiVB2(:,i), sprintf('VB mode %i',i), 1000+(i-1))

            h=colormap;
       
        % PLOT CONDUCTION BAND
            figure(100+10*k+i);
            suptitle( strrep(sprintf('plot ID: %i, ID: %s, mat: %s', k, QDOA(k).timestamp, QDOA(k).mat_name ),'_','\_') );
       
            psi = psiCB2(:,i);
            
            psi=psi/max(psi)*length(h);

            %schnitt 1: y,z plane
            subplot(2,2,1);            
            title( sprintf('CB mode %i',i) );
            xlabel('x');
            ylabel('y');
            zlabel('z');
            hold on
            
            IA=1;
            while LayerMatrix(IA,1)<1e-8,
                plot3(LayerMatrix(IA,1),LayerMatrix(IA,2),LayerMatrix(IA,3),'ko','MarkerSize',8,'MarkerFaceColor',h(ceil(psi(IA)),:))
                view([90,0])
                IA=IA+1;
            end

            %schnitt 2: x,y plane
            subplot(2,2,2);
            title( sprintf('CB mode %i',i) );            
            hold on
            xlabel('x');
            ylabel('y');
            zlabel('z');
            
            for IA=1:length(LayerMatrix(:,1)),
                if LayerMatrix(IA,3)<1e-8,
                    plot3(LayerMatrix(IA,1),LayerMatrix(IA,2),LayerMatrix(IA,3),'ko','MarkerSize',8,'MarkerFaceColor',h(ceil(psi(IA)),:))
                end
            end

        % PLOT VALENCE BAND
            figure(100+10*k+i);  
            psi = psiVB2(:,i);
            
            psi=psi/max(psi)*length(h);

            %schnitt 1: y,z plane
            subplot(2,2,3);            
            title( sprintf('VB mode %i',i) );
            xlabel('x');
            ylabel('y');
            zlabel('z');
            hold on
            
            IA=1;
            while LayerMatrix(IA,1)<1e-8,
                plot3(LayerMatrix(IA,1),LayerMatrix(IA,2),LayerMatrix(IA,3),'ko','MarkerSize',8,'MarkerFaceColor',h(ceil(psi(IA)),:))
                view([90,0])
                IA=IA+1;
            end

            %schnitt 2: x,y plane
            subplot(2,2,4);
            title( sprintf('VB mode %i',i) );
            hold on
            xlabel('x');
            ylabel('y');
            zlabel('z');
            
            for IA=1:length(LayerMatrix(:,1)),
                if LayerMatrix(IA,3)<1e-8,
                    plot3(LayerMatrix(IA,1),LayerMatrix(IA,2),LayerMatrix(IA,3),'ko','MarkerSize',8,'MarkerFaceColor',h(ceil(psi(IA)),:))
                end
            end
            
            
            
        end
    end
end


%********************************************************************************
% SUBFUNCTIONS
%********************************************************************************


function plot3DunitCell( LayerMatrix ,EV, plotName, figIndex)

    h=colormap;

    EV=EV/max(EV)*length(h);

    %schnitt 1: y,z plane
    figure(figIndex)    
    suptitle(plotName)
    subplot(2,1,1);
    hold on
    IA=1;
    while LayerMatrix(IA,1)<1e-8,
        plot3(LayerMatrix(IA,1),LayerMatrix(IA,2),LayerMatrix(IA,3),'ko','MarkerSize',8,'MarkerFaceColor',h(ceil(EV(IA)),:))
        view([90,0])
        IA=IA+1;
    end    
    xlabel('x')
    ylabel('y')
    zlabel('z')

    %schnitt 2: x,y plane
    subplot(2,1,1);
    hold on
    for IA=1:length(LayerMatrix(:,1)),
        if LayerMatrix(IA,3)<1e-8,
            plot3(LayerMatrix(IA,1),LayerMatrix(IA,2),LayerMatrix(IA,3),'ko','MarkerSize',8,'MarkerFaceColor',h(ceil(EV(IA)),:))
        end
    end
    xlabel('x')
    ylabel('y')
    zlabel('z')

end