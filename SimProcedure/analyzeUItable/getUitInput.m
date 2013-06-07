function [CHK, M] = getUitInput(cellstr)
%[CHK, M] = getUitInput(cellstr)
%
%   Converts a string into a double matrix
%
%   '[a,b,c][d,e,f]...[g,h,j]'     or 
%   '[a,b,c;d,e,f;...;g,h,j]'       becomes a MATLAB matrix
%
%       M = [ a b c
%             d e f
%             . . .
%             g h j ]
%
%   where a,b,...,j are doubles as strings.
%
%   Spaces are deleted!
%
%   cellstr     A cell element containing a string
%   X           the string as a double matrix
%   CHK         Boolean containing 1 if conversion was successful, 0 if
%               input has not allowed characters,...



    CHK = 1;    
    if isempty(cellstr);
        [CHK, M] = warning(4);
    else
        str = char(cellstr);

        % Delete all spaces in string and check if string is empty
        str = str(str ~= ' ');
        if isempty(str)
            [CHK, M] = warning(4);
            return;
        end

        [n,m] = size(str);
        M = [];
        row = 1;
        col = 1;
        tmp = '';
        bracket = 0;    % 0 for brackets fit, # of brackets opened

        % Check dimensions, if values are missing
        chkdim = 1;
        for i=1:m
            if strcmp(str(i),'.') || strcmp(str(i),'-')
                if i > 1
                    if strcmp(str(i-1:i),'..') || strcmp(str(i-1:i),'--')
                        [CHK, M] = warning(5);
                        return;
                    end
                    if strcmp(str(i-1:i),'.-')
                        [CHK, M] = warning(6);
                        return;
                    end
                end
            elseif strcmp(str(i),',')
                if i > 1
                    if strcmp(str(i-1),',') || strcmp(str(i-1),';')
                        [CHK, M] = warning(3);
                        return;
                    end
                end
                chkdim(row) = chkdim(row) + 1;
            elseif strcmp(str(i),';')
                if i > 1
                    if strcmp(str(i-1),',') || strcmp(str(i-1),';')
                        [CHK, M] = warning(3);
                        return;
                    end
                end
                row = row + 1;
                chkdim(row) = 1;
            elseif strcmp(str(i),']')
                if i > 1
                    if strcmp(str(i-1),',') || strcmp(str(i-1),';')
                        [CHK, M] = warning(3);
                        return;
                    end
                end
                if i ~= m
                    row = row + 1;
                    chkdim(row) = 1;
                end
            end
        end
        if sum(chkdim)/chkdim(1) ~= length(chkdim)
            [CHK, M] = warning(3);
            return;
        end
        row = 1;
        col = 1;

        % Check for inconsistencies and not allowed characters
        for i=1:m
            dstr = str2double(str(i));
            if dstr >= 0 || dstr <= 9 || strcmp(str(i),'.') || strcmp(str(i),'-')
                tmp = [tmp, str(i)];
                if i == m
                    M(row,col) = str2double(tmp);
                end
            elseif strcmp(str(i),',')
                M(row,col) = str2double(tmp);
                tmp = '';
                col = col + 1;

            elseif strcmp(str(i),';')
                M(row,col) = str2double(tmp);
                tmp = '';
                col = 1;
                row = row + 1;
            elseif strcmp(str(i),'[')
                bracket = bracket + 1;
            elseif strcmp(str(i),']')
                bracket = bracket - 1;
                if bracket < 0
                    [CHK, M] = warning(2);
                    return;
                end
                M(row,col) = str2double(tmp);
                tmp = '';
                col = 1;
                row = row + 1;
                bracket = 0;
            else
                [CHK, M] = warning(1);
                return;
            end
        end
        if bracket ~= 0
            [CHK, M] = warning(2);
            return;
        end
    end
end

function [CHK, msg] = warning(option)
    switch option
        case 1
            msg = 'Input has not the right format!';
        case 2
            msg = 'Brackets missing or set wrong!';
        case 3
            msg = 'Dimensions do not fit or values between commas and semicolons are missing!';
        case 4
            msg = 'Input empty!';
        case 5
            msg = 'Decimal points or minus signs following each other!';
        case 6
            msg = 'Input .- not allowed!';
    end
    CHK = 0;
end