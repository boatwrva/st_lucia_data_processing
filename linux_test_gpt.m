rerunnit = 1

% (source_server, source_path, cruise, dest_server, dest_path, rerunnit, times, DT)
% Modified to work on Linux with remote file transfer
% source_server: Remote server with source MET files (e.g., 'user@source.com')
% source_path: Directory on source server containing MET files (e.g., '/data/met/')
% cruise: Cruise name (used in output storage)
% dest_server: Remote server where processed files will be saved (e.g., 'user@dest.com')
% dest_path: Directory on destination server for processed files
% rerunnit: Flag to reprocess files (1 = reprocess, 0 = skip existing)
% times: Days to work on, in datenum format (e.g., datenum(2025,2,17:30))
% DT: Not currently used, reserved for future decimation

%username: SR-SCI-USER
%domain: AD.UCSD.EDU
%pass: SIOsrU$3rOc3@n$

user = 'ad.ucsd.edu/sr-sci-user'; 


dir_in = '/run/user/1001/gvfs/smb-share:server=sr-sci-filesvr.ucsd.edu,share=cruise/SR2503/'; 
dir_out = '/run/user/1001/gvfs/smb-share:server=sr-sci-filesvr.ucsd.edu,share=scienceparty_share/SR2503/'; 
dir_out = 'smb:\\sr-sci-filesvr.ucsd.edu\scienceparty_share\SR2503\';


base = [dir_in 'metacq/data/'];
cruise = 'SR2503';
outpath = [dir_out, 'MetData'];

source_server = dir_in;
source_path = 'metacq/data/';

dest_server = dir_out; 
dest_path = 'MetData/';

%SR_get_metdata(base,cruise,outpath,rerunnit,times,DT);
times = [datenum('2025,02,20')];



temp_local = '/tmp/met_processing/'; % Local temp storage


if ~exist(temp_local, 'dir')
    mkdir(temp_local);
end

if rerunnit
    clear files
    for tdx = 1:length(times)
        fname = sprintf('%s.MET', datestr(times(tdx), 'YYmmdd'));
        remote_file = sprintf('%s:%s%s', source_server, source_path, fname);
        local_file = fullfile(temp_local, fname);
        
        % Copy the file from the source server
        system(sprintf('scp %s %s', remote_file, local_file));
        
        if exist(local_file, 'file')
            files(tdx).name = local_file;
        else
            warning('Failed to copy %s', remote_file);
        end
    end

    % Process each file
    for fdx = 1:length(files)
        file = files(fdx).name;
        disp(['Processing: ', file]);

        % Output filename
        output_filename = sprintf('MET_%s.mat', file(end-9:end-4));
        local_output = fullfile(temp_local, output_filename);
        remote_output = sprintf('%s:%s/%s', dest_server, dest_path, output_filename);

        % Check if file already exists on destination server
        [status, ~] = system(sprintf('ssh %s "test -f %s && echo exists"', dest_server, remote_output));
        if status == 0
            disp(['Skipping ', file, ' (already processed).']);
            continue;
        end

        % Read data
        d = importdata(file);
        data = d.data;
        clear tmp

        % Parse time
        for ii = 1:length(d.data(:,1))
            tmp(ii, :) = sprintf('%06s', num2str(data(ii, 1)));
        end

        hour = str2num(tmp(:, 1:2));
        year = str2num(file(end-9:end-8)) + 2000;
        month = str2num(file(end-7:end-6));
        day = str2num(file(end-5:end-4));
        minute = str2num(tmp(:, 3:4));
        second = str2num(tmp(:, 5:6));
        MET.time = datenum(year, month, day, hour, minute, second);

        % Process variables
        for cdx = 2:length(d.colheaders)
            varname = char(d.colheaders(cdx));
            varname = strrep(varname, '-', '_');
            MET.(varname) = data(:, cdx);
        end
        MET.header = d.colheaders;

        % Save locally
        save(local_output, 'MET');

        % Transfer output file to destination server
        system(sprintf('scp %s %s', local_output, remote_output));

        % Cleanup local temp files
        delete(file);
        delete(local_output);
    end
end