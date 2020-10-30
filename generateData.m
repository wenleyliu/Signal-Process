%%divide the IMU data to traindata(2/3) and testdata(1/3)

clc,clear;
load('4keygentledata.mat');

randArray = randperm(30)%generate rand
trainArray = randArray(1:20)%random traindata index
testArray = randArray(21:30)%random testdata index

train_xAcceData=[];
train_yAcceData=[];
train_zAcceData=[];
train_xGyroData=[];
train_yGyroData=[];
train_zGyroData=[];

test_xAcceData=[];
test_yAcceData=[];
test_zAcceData=[];
test_xGyroData=[];
test_yGyroData=[];
test_zGyroData=[];


for i = 0:112 %volunteer number
    offset = i*120;%sample numble
    for lableNum = 1:3
        offset = offset+30
        for j=1:20
            train_xAcceData=[train_xAcceData;xAcceData(offset+trainArray(j),:)];
            train_yAcceData=[train_yAcceData;yAcceData(offset+trainArray(j),:)];
            train_zAcceData=[train_zAcceData;zAcceData(offset+trainArray(j),:)];
            train_xGyroData=[train_xGyroData;xGyroData(offset+trainArray(j),:)];
            train_yGyroData=[train_yGyroData;yGyroData(offset+trainArray(j),:)];
            train_zGyroData=[train_zGyroData;zGyroData(offset+trainArray(j),:)];
        end
        
        for j=1:10
            test_xAcceData=[test_xAcceData;xAcceData(offset+testArray(j),:)];
            test_yAcceData=[test_yAcceData;yAcceData(offset+testArray(j),:)];
            test_zAcceData=[test_zAcceData;zAcceData(offset+testArray(j),:)];
            test_xGyroData=[test_xGyroData;xGyroData(offset+testArray(j),:)];
            test_yGyroData=[test_yGyroData;yGyroData(offset+testArray(j),:)];
            test_zGyroData=[test_zGyroData;zGyroData(offset+testArray(j),:)];
        end
    end
end

%%
save('train.mat','train_xAcceData','train_yAcceData','train_zAcceData',...
    'train_xGyroData','train_yGyroData','train_zGyroData');
save('test.mat','test_xAcceData','test_yAcceData','test_zAcceData',...
    'test_xGyroData','test_yGyroData','test_zGyroData');
