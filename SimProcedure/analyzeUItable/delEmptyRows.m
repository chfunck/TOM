function [Mpar] = delEmptyRows(Mpar_raw)
%[Mpar] = delEmptyRows(Mpar_raw)
%   Gets a cell array and deletes empty rows

    e = cellfun('isempty', Mpar_raw);
    e = sum(e,2);
    [idx,e] = find(e);
    Mpar_raw(idx,:) = [];
    Mpar = Mpar_raw;
end