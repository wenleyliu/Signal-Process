%% Fullconnection
clc; clear;
%% Config

data_folder = '../data';
[date,user,num_key]=config();


    mat = load('..\data\20200407-lwl-10key-fake10_cut-1.mat')
    num_key = mat.num_key;
    seginfo = mat.seginfo;
    data = mat.data;
    labels = mat.labels;
%% Augmentation
aug_data = {};
aug_labels = {};
for index_i=1:size(labels,2)
%     fprintf('processing %s...\n');
    label_i=labels{1,index_i};
    for index_j=1:size(labels,2)
         label_j=labels{1,index_j}; 
         label=[label_i,label_j];
         aug_labels = [aug_labels,label];%将切好的数据拼在一起
         %把data{1,index_i} 与data{1,index_j}拼起来
         temp=struct();
         temp.a = struct('x', [], 'y',  [], 'z',  []);        
         temp.g = struct('x',  [], 'y', [], 'z',  []);
        for s='ag'
            for axis='xyz'
                temp.(s).(axis)=[data{1,index_i}.(s).(axis),data{1,index_j}.(s).(axis)];
            end
        end
        aug_data =[aug_data,temp];
    end
end
labels=aug_labels;
data=aug_data;
 save(sprintf('../data/%s-%s-%dkey-10000-connection.mat', date, user, num_key), 'labels', 'data');
 
 for i=1:size(labels,2)
    datacolumns = {'label','ax','ay','az','gx','gy','gz'}
    label = {}
    for j = 1:size(data{i}.a.x,2)
        label = [label,labels{i}]
    end
    for j = 1:size(labels,2)
        ax = data{j}.a.x;
        ay = data{j}.a.y;
        az = data{j}.a.z;
        gx = data{j}.g.x;
        gy = data{j}.g.y;
        gz = data{j}.g.z;
    end
    result_table = table( datacolumns,label,ax,ay,az,gx,gy,gz)     
end
for i=1:size(labels,2)
    datacolumns = {'label','ax','ay','az','gx','gy','gz'}
    label = {}
    for j = 1:size(data{i}.a.x,2)
        label = [label,labels{i}]
    end
    for j = 1:size(labels,2)
        ax = data{j}.a.x;
        ay = data{j}.a.y;
        az = data{j}.a.z;
        gx = data{j}.g.x;
        gy = data{j}.g.y;
        gz = data{j}.g.z;
    end
    result_table = table(datacolumns,label,ax,ay,az,gx,gy,gz);
    writetable(result_table, sprintf('../data/generator_data/%04d.csv',i-1));
end
 
