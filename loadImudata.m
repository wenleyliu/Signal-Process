function [ SENSOR_RAWDATA_STURCT ] = loadImudata( csv_file_folder_path,DEVICE_NAME,csv_file_index)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   LOADIMUDATA is a MATLAB script for organizing the accelerometer and 
%   gyroscope data of IMU sensor into the same struct according to the tree 
%   structure. The script searches for the name format of the csv_file 
%   corresponding to the accelerometer and gyroscope based on the mobile 
%   device and csv_file_index to determine the path of the csv_file.
%   CSV_FILE_PATH = 'CSV_FILE_FLODER_PATHH\CSV_FILE_NAME_FORMAT' 
%
%   Variables:
%   ----------
%
%   csv_file_folder_path  =  path to the folder where the csv_file is located
%
%   DEVICE_NAME           =  type of mobile device,'jeep,Zen,KC08'
%
%   csv_file_index        =  serial number of csv_file
%
%   Tree organization of IMU data：
%   ----------
%                         | ACCELEROMETER | X,Y,Z
%   SENSORS_RAWDATA_STURCT|
%                         | GYROSCOPE     | X,Y,Z
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Determine the path of the csv_file。   
    CSV_FILE_NAME_FORMAT = struct();
    if strcmp(DEVICE_NAME,'watch_kc08')
        CSV_FILE_NAME_FORMAT.ACCELEROMETER = 'ACCELEROMETER-%04d.csv';
        CSV_FILE_NAME_FORMAT.GYROSCOPE = 'GYROSCOPE-%04d.csv';
    elseif strcmp(DEVICE_NAME,'watch_jeep')
        CSV_FILE_NAME_FORMAT.ACCELEROMETER = 'BMI160accelerometer-%04d.csv';
        CSV_FILE_NAME_FORMAT.GYROSCOPE = 'BMI160gyroscope-%04d.csv';
    elseif strcmp(DEVICE_NAME,'watch_zen')
        CSV_FILE_NAME_FORMAT.ACCELEROMETER = 'Accelerometer-%04d.csv';
        CSV_FILE_NAME_FORMAT.GYROSCOPE = 'Gyroscope-%04d.csv';
    end
    
%   Combine accelerometer and gyroscope data into a struct
    SENSOR_RAWDATA_STURCT = struct();
    SENSOR_NAME = fieldnames(CSV_FILE_NAME_FORMAT);
    SENSOR_ACCOUNT = size(SENSOR_NAME,1);
    AXIS_NAME =['X';'Y';'Z'];
    AXIS_ACCOUNT = size(AXIS_NAME,1);
    for i = 1:SENSOR_ACCOUNT                  
        format_id = SENSOR_NAME{i};
        nameformat=CSV_FILE_NAME_FORMAT.(format_id);
        csvfile = fullfile(csv_file_folder_path, sprintf(nameformat, csv_file_index) );  
        for j=1:AXIS_ACCOUNT 
             SENSOR_RAWDATA_STURCT.SENSOR_NAME{i}.AXIS_NAME(j)=cvsfile(j, :);
        end
    end
end


