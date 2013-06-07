function plotQDStructure(QDOA)
% Plots the structure of Quantum Dots in 3D

    global config;

    for k = 1:length(QDOA)
    
        Layer_Matrix = load([config.simulations, QDOA(k).path, '/Layer_Matrix.dat']);

        NA = size(Layer_Matrix,1);
        numOfElements = max(Layer_Matrix(:,4));
        SizeCode = 30*ones(1,NA)';
        ColCode = Layer_Matrix(:,4)/numOfElements;

        figure;
        scatter3(Layer_Matrix(:,1), Layer_Matrix(:,2), Layer_Matrix(:,3),SizeCode,ColCode,'filled');
        
        stitle = ['Structure of a ', QDOA(k).mat_name, ' Quantum Dot, Radius: ', num2str(QDOA(k).geometry(1).radius)];
        title(stitle, 'Interpreter', 'none');
        xlabel('x-axis');
        ylabel('y-axis');
        zlabel('z-axis');
    end
end