function QDOA = sweep(QDOG)
% QDOA = sweep(QDOG)
% Takes a generic qdot object 
% with scalar sweep parameters entered in the form [min,max,steps].
% returns array of qdots with all parameter combinations
% supportes sweep parameters: radius(1), radius(2), Voltage
%********************************************************************
   
    nMat = QDOG.no_mat;

    if QDOG.permutateRadii == 1
    % PERMUTATE RADII
        
        p1 = paramSweep( QDOG.geometry(1).radius);
        p2 = paramSweep( QDOG.geometry(2).radius);
        p3 = paramSweep( QDOG.Efield );
            

    % CREATE PERMUTATION MATRIX with all parameter combinations
    % collumn i of permMatrix contains parameters for qdot(i)

        permMatrix = zeros( rows(p1)+rows(p2)+rows(p3), cols(p1)*cols(p2)*cols(p3) );

        % Assign values to the permutation matrix 
        Ind = 1;
        for IA = 1:cols(p1)
            for IB = 1:cols(p2)
                for IC = 1:cols(p3)
                    permMatrix(:,Ind) = [ p1(:,IA); p2(:,IB); p3(:,IC)];
                    Ind = Ind+1;
                end
            end
        end
        
    else
    % DO NOT PERMUTATE RADII
    
        p1 = sweepAndLockRadii(QDOG);
        p3 = paramSweep( QDOG.Efield );
            
%     voltage = [def_dot.Vdmin, def_dot.Vdmax, def_dot.NVD];
%     p2 = paramSweep( voltage );

    % CREATE PERMUTATION MATRIX with all parameter combinations
    % collumn i of permMatrix contains parameters for qdot(i)

        permMatrix = zeros( rows(p1)+rows(p3), cols(p1)*cols(p3) );

        % Assign values to the permutation matrix 
        Ind = 1;
        for IA = 1:cols(p1)
            for IB = 1:cols(p3)
            permMatrix(:,Ind) = [ p1(:,IA); p3(:,IB)];
            Ind=Ind+1;
            end
        end
    end

    N = cols(permMatrix); %Number of permutations

    QDOA( N ) = Qdot; %initialize N qdots


% ASSIGN VALUES TO NEW QDOTS

    for i = 1:N
        QDOA(i) = QDOG;
        j = 1;

        % fill in the radii
        for k = 1:nMat
            QDOA(i).geometry(k).radius = permMatrix(k,i);
            j=k+1;
        end

        %fill in the voltages
%         dots(i).NVD = 1;
%         dots(i).Vdmax = permMatrix(j,i);
%         dots(i).Vdmin = permMatrix(j,i);

        %set voltages
        QDOA(i).Efield = permMatrix(j,i);
        QDOA(i).NVD=1;
        QDOA(i).Vdmax = permMatrix(j,i)*2*QDOA(i).geometry(nMat).radius;
        QDOA(i).Vdmin = permMatrix(j,i)*2*QDOA(i).geometry(nMat).radius;

    end
    
end


% SUBFUNCTIONS
%********************************************************************

function p = paramSweep(a)
% create all parameter values using linspace

    if(cols(a) == 3)
        p = linspace(a(1),a(2),a(3));
    elseif(cols(a) ==1)
% do not use linspace if only single value
        p=a;
    else
% only acceptable input: scalar or vector of length 3
        warning('radius1: incorrect values');
        p=a(1);
    end
end


function p12 = lock(a1,a2)
% lock two parameters: they will not be permutated later

    if cols(a1) ~= cols(a2)
        if cols(a1) == 1
            a1 = a1 * ones(1,cols(a2));
        elseif cols(a2) ==1
            a2 = a2 * ones(1,cols(a1));
        else
            warning(['dimensions of lock parameters do not match. \n' ...
                            'they will be reset to their first value']);
            a1 = a1(1);
            a2 = a2(1);
        end
    end
    p12 = [a1;a2];
end


function radiiMatrix = sweepAndLockRadii(QDOG)
%sweep each radius and lock it with the radii from the qdot. 

    nMat = QDOG.no_mat;
    
    radiiMatrix = paramSweep( QDOG.geometry(1).radius );
    
    for i = 2:nMat
        r = paramSweep( QDOG.geometry(i).radius );     
        radiiMatrix = lock( radiiMatrix , r);
    end
end


function n = cols(mat)
% returns number of collums in a 2x2 matrix
    [~,n] = size(mat);
end


function m = rows(mat)
% returns number of rows in a 2x2 matrix
    [m,~] = size(mat);
end