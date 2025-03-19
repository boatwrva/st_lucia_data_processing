function [latitude_dd, longitude_dd, utc_time] = parse_nmea_from_hex(file_path)
    % Reads the header of a .hex file and extracts NMEA Latitude, Longitude, and UTC Time.
    % Converts Latitude and Longitude to decimal degrees.

    % Open the file for reading
    fid = fopen(file_path, 'r');
    if fid == -1
        error('Could not open file: %s', file_path);
    end

    % Initialize output variables
    latitude_dd = NaN; 
    longitude_dd = NaN;
    utc_time = '';

    % Read the file line by line
    while ~feof(fid)
        line = fgetl(fid);

        % Stop reading when reaching "*END*"
        if contains(line, '*END*')
            break;
        end

        % Extract relevant NMEA data
        if startsWith(line, '* NMEA Latitude')
            lat_str = extractAfter(line, '= '); % Extract latitude string
            latitude_dd = convert_nmea_to_decimal(lat_str);
        elseif startsWith(line, '* NMEA Longitude')
            lon_str = extractAfter(line, '= '); % Extract longitude string
            longitude_dd = convert_nmea_to_decimal(lon_str);
        elseif startsWith(line, '* NMEA UTC (Time)')
            utc_time = strtrim(extractAfter(line, '= ')); % Extract and trim UTC time
        end
    end

    % Close the file
    fclose(fid);

    % Display the extracted values
    %fprintf('Latitude (decimal degrees): %.6f\n', latitude_dd);
    %fprintf('Longitude (decimal degrees): %.6f\n', longitude_dd);
    %fprintf('UTC Time: %s\n', utc_time);
end

function decimal_degrees = convert_nmea_to_decimal(nmea_str)
    % Converts an NMEA latitude/longitude string to decimal degrees.
    % Example input: '34 43.38 N' or '121 41.41 W'
    
    tokens = split(strtrim(nmea_str), ' '); % Split by spaces
    if numel(tokens) < 3
        error('Invalid NMEA coordinate format: %s', nmea_str);
    end
    
    degrees = str2double(tokens{1}); % Extract degrees
    minutes = str2double(tokens{2}); % Extract minutes
    direction = tokens{3}; % Extract direction (N/S/E/W)
    
    % Convert to decimal degrees
    decimal_degrees = degrees + (minutes / 60);
    
    % Adjust for hemisphere
    if strcmp(direction, 'S') || strcmp(direction, 'W')
        decimal_degrees = -decimal_degrees;
    end
end
