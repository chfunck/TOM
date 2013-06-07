 function entries = filterQDOA(QDOA, propertyName, value, mode, tol)
% entries = filterQDOA(QDOA, propertyName, value, mode, tol
% returns array of QDO whose properties (specified in propertyName) match value
% suited for properties of type scalar numeric or string
% mode 1: property and value EXACTLY MATCHING 
% mode 2: property matches a RANGE of values = [min, max]
% mode 3: property and value match APPROXIMATELY :
%           numeric properties: specify tolerance tol
%           string properties: objects whose property contains string 'value' are selected
% mode 4+5: compare 2 properties (propertyName = {pN1, pN2}) 
% mode 4: value = constant difference +/-tol = pN1-pN2
% mode 5: value = constant ratio +/-tol = pN1/pN2

    switch mode
        case 1
            indices = find(QDOA, propertyName, value);
        case 2
            indices = findRange(QDOA, propertyName, value(1), value(2));
        case 3
            indices = findSimilar(QDOA, propertyName, value, tol);
        case 4
            indices = findConstDiff(QDOA, propertyName{1}, propertyName{2}, value, tol);
        case 5
            indices = findConstRatio(QDOA, propertyName{1}, propertyName{2}, value, tol);
    end
    entries = getEntries(QDOA, indices);            
end


%********************************************************************
% sub functions for function filter
%********************************************************************

function entries = getEntries(QDOA, indices)
    % returns the objects with the specified indices in an Qdot array

    N=length(indices);
    if N<1
        entries = Qdot.empty;
        return;
    end

    entries(N) = Qdot;
    for i=1:N
        entries(i) = QDOA(indices(i));
    end
end

function [index, path] = find(QDOA, propertyName, value)
    % return indices and paths of DB entries with values of a Qdot property
    % which EXACTLY match argument value

    path = cell(0,0);
    index = [];
    [~,N] = size(QDOA);

    for i=1:N % over all entries
        currentValue = eval(sprintf('QDOA(%i).%s',i,propertyName));
        if isequal(currentValue, value)                       
            index(end+1,1) = i; 
            path{end+1,1} = QDOA(i).path;
        end
    end
end

function [index,path] = findRange(QDOA, propertyName, min, max)
    % return indices and paths of DB entries with values of a Qdot property
    % within a RANGE of values
    % Works only for properties of type double, scalar

    path = cell(0,0);
    index = [];
    [~,N] = size(QDOA);

    for i=1:N % over all entries
        currentValue = eval( sprintf('QDOA(%i).%s',i,propertyName));
        if (currentValue <= max ) && ( currentValue >= min )
            index(end+1,1) = i; 
            path{end+1,1} = QDOA(i).path;
        end
    end

end

function [index,path] = findSimilar(QDOA, propertyName, value, tol)
    % return indices and paths of DB entries with values of a Qdot property
    % which match APPROXIMATELY argument value
    % For scalar doubles specify tol:  tolerance in percent/100
    % for chars: all strings CONTAINING value will be returned 

    firstValue = eval( sprintf('QDOA(%i).%s',1,propertyName)); %read the first value to determine the datatype of the property

    if ischar( firstValue )

        path = cell(0,0);
        index = [];
        [~,N] = size(QDOA);

        for i=1:N % over all entries
            currentValue = eval( sprintf('QDOA(%i).%s',i,propertyName));
            if regexp(currentValue, value, 'once')
                index(end+1,1) = i; 
                path{end+1,1} = QDOA(i).path;
            end
        end                


    elseif isnumeric( firstValue )
        [index, path] = DButils.findRange(QDOA, propertyName, value*(1-tol),  value*(1+tol));
    end
end


function [index, path] = findConstRatio(QDOA, propertyName1, propertyName2, ratio, tol)
    % returns indices and paths of DB entries with const ratio = pN1/pN2.
    % ratio +/- tol

    path = cell(0,0);
    index = [];
    [~,N] = size(QDOA);

    for i=1:N % over all entries
        currentValue1 = eval(sprintf('QDOA(%i).%s',i,propertyName1));
        currentValue2 = eval(sprintf('QDOA(%i).%s',i,propertyName2));
        currentRatio = currentValue1 / currentValue2;

        if ( currentRatio <= ratio*(1+tol) ) && (currentRatio >= ratio*(1-tol) )
            index(end+1,1) = i; 
            path{end+1,1} = QDOA(i).path;
        end
    end            


end


function [index, path] = findConstDiff(QDOA, propertyName1, propertyName2, diff, tol)
    % returns indices and paths of DB entries with constant difference  diff = pN1 - pN2.
    % diff +/- tol

    path = cell(0,0);
    index = [];
    [~,N] = size(QDOA);

    for i=1:N % over all entries
        currentValue1 = eval(sprintf('QDOA(%i).%s',i,propertyName1));
        currentValue2 = eval(sprintf('QDOA(%i).%s',i,propertyName2));
        currentDiff = currentValue1 - currentValue2;

        if ( currentDiff <= diff*(1+tol) ) && (currentDiff >= diff*(1-tol) )
            index(end+1,1) = i; 
            path{end+1,1} = QDOA(i).path;
        end
    end            

end