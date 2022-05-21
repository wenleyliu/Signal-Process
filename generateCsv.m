clc,clear;
%load('mat地址') 
load('20200407-lwl-10key-10000-connection.mat')
for i=1:size(labels,2)
    label = {};
    for j = 1:size(labels,2)
        ax = data{j}.a.x';
        ay = data{j}.a.y';
        az = data{j}.a.z';
        gx = data{j}.g.x';
        gy = data{j}.g.y';
        gz = data{j}.g.z';
    end
   for k = 1:size(data{j}.a.x,2)
        label = [label,labels{i}];
   end
    label=label';
    varNames = {'label','ax','ay','az','gx','gy','gz'};
    result_table = table(label,ax,ay,az,gx,gy,gz,'VariableNames',varNames)
    %文件生成后保存的地址
    writetable(result_table, sprintf('../data/%04d/generator_data.xls',i-1));
end
