function timestamp = getTimeDate(option)
% timestamp = getTimeDate(option)
%   Returns a timespamp with date and time, when the
%   function is called
%
%   option=1: for file names  yyyy-mm-dd_hh-mm-ss
%   option=2: for log entries yyyy/mm/dd hh:mm:ss
%   option=3: for DB entries yyyymmddhhmmss
%   option=4: output including milliseconds yyyymmddhhmmssfff
%   option=5: output including milliseconds yyyymmdd-hhmm-ssfff

    switch option
        case 1
            temp = datestr(now,31);
            timestamp = [temp(1:10) ' '];
            timestamp = [timestamp temp(12:19)];
            timestamp(14) = ':';
            timestamp(17) = ':';
        case 2
            temp = datestr(now,31);
            timestamp = [temp(1:10) ' '];
            timestamp = [timestamp temp(12:19)];
            timestamp(5) = '/';
            timestamp(8) = '/';
            timestamp(14) = ':';
            timestamp(17) = ':';
        case 3
            temp = datestr(now,31);
            timestamp = [temp(1:4) temp(6:7) temp(9:10) temp(12:13) temp(15:16) temp(18:19)];
        case 4
            timestamp = datestr(now,'yyyymmddHHMMSSFFF');
        case 5
            timestamp = datestr(clock, 'yyyymmdd-HHMM-SSFFF');
    end
end