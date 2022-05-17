function [ SENSORS_RAWDATA_STURCT ] = csv2Struct( csv_file_path, SENSOR_TYPE,DEVICE_NAME,csv_file_index)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%根据传感器的类型批量读取数据
%csv文件的路径+ (SENSOR_TYPE,SENSOR_NAME)生成文件名，
%获取信号之后，将信号组织成stuct，signal=（axyz,gxyz）


%确定传感器生成的csv文件的命名方式
CSV_FILE_NAME_FORMAT = struct();
%%传感器类型是imu
if strcmp(SENSOR_TYPE, 'imu')
    if strcmp(DEVICE_NAME,'watch_kc08')
        CSV_FILE_NAME_FORMAT.ACCELEROMER = 'ACCELEROMETER-%04d.csv';
        CSV_FILE_NAME_FORMAT.GYROSCOPE = 'GYROSCOPE-%04d.csv';
    elseif strcmp(DEVICE_NAME,'watch_jeep')
        CSV_FILE_NAME_FORMAT.ACCELEROMER = 'BMI160accelerometer-%04d.csv';
        CSV_FILE_NAME_FORMAT.GYROSCOPE = 'BMI160gyroscope-%04d.csv';
    elseif strcmp(DEVICE_NAME,'watch_zen')
        CSV_FILE_NAME_FORMAT.ACCELEROMER = 'Accelerometer-%04d.csv';
        CSV_FILE_NAME_FORMAT.GYROSCOPE = 'Gyroscope-%04d.csv';
    end     
    SENSORS_RAWDATA_STURCT=struct();
    SENSOR_NAME = fieldnames(CSV_FILE_NAME_FORMAT)%format对应的id
    SENSOR_ACCOUNT = size(SENSOR_NAME,1)
    AXIS_NAME =['x';'y';'z']
    AXIS_ACCOUNT = size(AXIS_NAME,1)
    for i = 1:SENSOR_ACCOUNT
        %先取csv文件
        csvfile = fullfile(csv_file_path, sprintf(CSV_FILE_NAME_FORMAT(SENSOR_NAME{i},csv_file_index))
        for j=1:AXIS_ACCOUNT
             % 取csv的轴数据
            SENSORS_RAWDATA_STURCT.SENSOR_NAME{AXIS_NAME(i)}.(j)=cvsfile(j, :);
        end
    end
    
    SENSORS_RAWDATA_STURCT = aligndata(SENSORS_RAWDATA_STURCT);
end

