%% continuousWriting segment 5 rounds's 0-9 in same folder
clc; clear;
addpath('./util/');

%% Config
folder = '../rawdata';
load('F:\Project\ViFin\data\20200407-lwl-10key-fake10.mat');
fake10cell=data;
data={}

[date,user,num_key,ofs, watch]=config()
no = 0     %roundNumber
fs = 100;  %required sampling rate

file_i = 0
w_size = int32(0.2 * fs);
min_signal_len = int32(0.1 * fs);
min_interval = int32(0.03 * fs);
threshold = 0.6*2;
data = {};
all_data = [];
seginfo.peaks_b = {};
seginfo.peaks_e = {};


%% Segment

for i=1:10
    
   % path = sprintf('%s/%s/%s/%04d', folder, user, date, 0)
  %$  rawdata = loaddata(path, i, watch)
    rawdata=fake10cell{i}
    if ofs ~= fs
        % resample
        for s='ag'
            for axis='xyz'
                rawdata.(s).(axis) = resample(lowpass(rawdata.(s).(axis), ofs, fs / 2), fs, ofs);
            end
        end
    end

    energy = zeros(1, numel(rawdata.a.x));
    for s='g'
        for axis='xyz'
            energy = energy + (abs(highpass(rawdata.(s).(axis), fs, 1) .^1));
        end
    end
    energy=energy.^2;
    m_energy = zeros(1, numel(energy));
    for j=1:size(energy, 2)
        m_energy(j) = mean(energy(max(1, j - w_size + 1):j));
    end

    pass = false;
    while ~pass
        subplot(2, 1, 1);
        hold off;
        plot(m_energy);
        hold on
        plot([0 numel(m_energy)], [threshold threshold], 'r');
        xlabel('????');ylabel('????');title('6?????');
        subplot(2, 1, 2);
        hold off;
        plot(rawdata.g.x);
        hold on;
        
        peaks_b = [];
        peaks_e = [];
        find_begin = true;
        for j=1:numel(m_energy)
            if find_begin
                if m_energy(j) >= threshold
                    find_begin = false;
                    b = max(1,j - w_size);
                    continue;
                end
            else
                if m_energy(j) < threshold
                    find_begin = true;
                    peaks_b = [peaks_b, b];
                    peaks_e = [peaks_e, j];
                end
            end
        end
        
        % Merge
        j = 2;
        while j <= numel(peaks_b)
            if (peaks_b(j) + w_size) - peaks_e(j - 1) < min_interval
                peaks_b(j) = [];
                peaks_e(j - 1) = [];
            else
                j = j + 1;
            end
        end

        % Filter out noise
        j = 1;
        while j <= numel(peaks_b)
            if peaks_e(j) - peaks_b(j) < min_signal_len
                peaks_b(j) = [];
                peaks_e(j) = [];
            else
                j = j + 1;
            end
        end
        peaks_b = peaks_b +10;
        peaks_e = peaks_e -10;
        for j=1:numel(peaks_b)
            plot([peaks_b(j) peaks_b(j)], [-0.2 0.2], 'b', 'linewidth', 3);
            plot([peaks_e(j) peaks_e(j)], [-0.2 0.2], 'r', 'linewidth', 3);
        end
        i
        peaksize=size(peaks_b,2)
        pass = true;
    end
%% add breakpoint here, refresh the figure 
subplot(2, 1, 1);
hold off;
plot(m_energy);
hold on
plot([0 numel(m_energy)], [threshold threshold], 'r');
subplot(2, 1, 2);
hold off;
plot(rawdata.g.x);
hold on;
 for j=1:numel(peaks_b)
    plot([peaks_b(j) peaks_b(j)], [-0.2 0.2], 'b', 'linewidth', 3);
    plot([peaks_e(j) peaks_e(j)], [-0.2 0.2], 'r', 'linewidth', 3);
end
    seginfo.peaks_b = [seginfo.peaks_b, peaks_b];
    seginfo.peaks_e = [seginfo.peaks_e, peaks_e];
    for j=1:numel(peaks_b)
        for s='ag'
            for axis='xyz'
                sample.(s).(axis) = rawdata.(s).(axis)(peaks_b(j):peaks_e(j));
            end
        end
        data = [data, sample];
    end
    all_data = [all_data, rawdata];
end
%% Save
% labels = {};
% for i=0:(num_key - 1)
%     for j=0:(num_key - 1)
%         label = [i j];
%         labels = [labels, label];
%     end
% end
labels = {};
for i=0:(num_key - 1)
    for j=0:(num_key - 1)
        label = [j]; 
        labels = [labels, label];
    end
       
end
rawdata = all_data;
save(sprintf('../data/%s-%s-%dkey-fake10_cut-%d.mat', date, user, num_key, no + 1), 'labels', 'data', 'num_key' ,'seginfo', 'rawdata');

%% Augmentation

% mat = load(sprintf('../../data/%s-%s-%dkey-%d.mat', date, user, num_key, no + 1), 'num_key', 'seginfo', 'rawdata');
% num_key = mat.num_key;
% seginfo = mat.seginfo;
% rawdata = mat.rawdata;

aug_data = {};
aug_labels = {};

for i=1:num_key
    label = [];
    for j=0:(num_key - 1)
        label = [label, i - 1, j];
    end

    for j=1:num_key
%        for k=j:min((j + 1), num_key)
         for k=j:10
            for include_before=[true, false]
                for include_end=[true, false]
                    if j == 1
                        if include_before
                            b = 1;
                        else
                            b = seginfo.peaks_b{i}(j);
                        end
                    else
                        if include_before
                            b = seginfo.peaks_e{i}(j - 1);
                        else
                            b = seginfo.peaks_b{i}(j);
                        end
                    end
                    if k == num_key
                        if include_end
                            e = numel(rawdata(i).a.x);
                        else
                            e = seginfo.peaks_e{i}(k);
                        end
                    else
                        if include_end
                            e = seginfo.peaks_b{i}(k + 1);
                        else
                            e = seginfo.peaks_e{i}(k);
                        end
                    end
                    range = b:e;

                    for s='ag'
                        for axis='xyz'
                            sample.(s).(axis) = rawdata(i).(s).(axis)(range);
                        end
                    end

                    aug_data = [aug_data, sample];
                    aug_labels = [aug_labels, label(((j - 1) * 2 + 1):(k * 2))];
                end
            end
        end
    end
end

%% Save augment data
data = aug_data;
labels= aug_labels;
save(sprintf('../data/%s-%s-%dkey-augment-%d.mat', date, user, num_key, no + 1), 'labels', 'data', 'num_key' ,'seginfo', 'rawdata');
