clc; 
clear;
%addpath('./util' );

%set the data path
filepath='./data/';

%loading agrs
[args] = config_loading(filepath);
user_name = args.user_name;
sampling_rate = args.sampling_rate;
sampling_date = args.sampling_date;
watch_type = args.watch_type;

%loading data 
[file_format] = format_loading(watch_type);
[data] = data_loading(filepath, file_format)

%filtering(filtering must before resampling)


%resampling(if you wish) 


%segmentation


%align

%%
function [value] = config_loading(filepath)
    value = [];
    filename = [filepath, 'data_declaration.txt'];
    fid = fopen(filename); % 打开文件    
    while ~feof(fid)  % 循环直至文件末
        line = fgetl(fid);   % 读取某一行
        dict = strsplit(line, '=');   % = 作为分隔符
    
        if length(dict) == 2
            key = char(strtrim(string(dict(1))));
            word = char(strtrim(string(dict(2))));
            
            if strcmp(key, 'user_name')
                value.user_name = (word);
            elseif strcmp(key, 'sampling_rate')
                value.sampling_rate = str2num(word);
            elseif strcmp(key, 'sampling_date')
                value.sampling_date = str2num(word);
            elseif strcmp(key, 'watch_type')
                value.watch_type  = (word);
            end
        end
    end
    fclose(fid); 
end
%%
function [data_nameformat] = format_loading(watch_type)

    SENSORS = struct();
    if strcmp(watch_type, 'kc08')
        SENSORS.a = 'ACCELEROMETER-%04d.csv';
        SENSORS.g = 'GYROSCOPE-%04d.csv';
    elseif strcmp(watch_type, 'jeep')
        SENSORS.a = 'BMI160accelerometer-%04d.csv';
        SENSORS.g = 'BMI160gyroscope-%04d.csv';
    elseif strcmp(watch_type, 'zen')
        SENSORS.a = 'Accelerometer-%04d.csv';
        SENSORS.g = 'Gyroscope-%04d.csv';
    end
    data_nameformat = SENSORS;
end
%%
function [data] = data_loading(filepath, data_nameformat)
    files = dir(fullfile([filepath, '*.csv']));
    files_account = length(files);

    data = {};
    for k = 1 : files_account/2;
        a_filepath = [filepath, sprintf(data_nameformat.a, k-1)];
        g_filepath = [filepath, sprintf(data_nameformat.g, k-1)];
        a_csvfile = csvread(a_filepath, 0, 1);  
        g_csvfile = csvread(g_filepath, 0, 1);
       
        data{k}.a.x = a_csvfile(1,:);
        data{k}.a.y = a_csvfile(2,:);       
        data{k}.a.z = a_csvfile(3,:);
        data{k}.g.x = g_csvfile(1,:);
        data{k}.g.y = g_csvfile(2,:);       
        data{k}.g.z = g_csvfile(3,:);        
    end
end  
        
        
        