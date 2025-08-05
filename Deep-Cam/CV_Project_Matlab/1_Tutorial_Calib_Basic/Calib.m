% ��������д��ں͹�����
clc;
clear all;

% ����У׼����
load('Omni_Calib_Results_26mm.mat');
ocam_model = calib_data.ocam_model;

% ��ȡTestImages�ļ���������ͼƬ�ļ�����Ϣ
image_folder = 'TestImages';
image_files = dir(fullfile(image_folder, '*.jpg')); % ����ͼƬΪjpg��ʽ���ɰ����޸�Ϊ������ʽ����*.png��

% ֻȡǰ4��ͼƬ�����ͼƬ����4�ţ���ȡʵ������
num_images = min(4, length(image_files));
image_paths = cell(num_images, 1);
for i = 1:num_images
    image_paths{i} = fullfile(image_folder, image_files(i).name);
end

% ��ʼ����������
distances = zeros(num_images, 1);

% ѭ������ÿ��ͼƬ
for i = 1:num_images
    % ����kkӦ����ͼƬ��calib_data.L�е�����������˳��һ��
    kk = i; 
    % Ѱ�����̸���������
    use_corner_find = 1;
    % �޸ĵ��ã�����kk, use_corner_find, calib_data
    [~, Xp_abs_, Yp_abs_] = get_checkerboard_cornersUrban(kk, use_corner_find, calib_data);
    imagePoints = [Xp_abs_', Yp_abs_'];
    
    % ��ͼ�����У׼
    % ������� calibrate �� FindTransformMatrix �����Ѿ���ȷʵ��
    [RRfin_, ~] = calibrate(ocam_model, imagePoints);
    [~, ~, RRfin_] = FindTransformMatrix(ocam_model, imagePoints, RRfin_);
    
    % ��ȡ��������̸�ľ���
    distances(i) = RRfin_(1, 3);
end

% ��ʾÿ��ͼƬ��Ӧ����������̸�ľ���
disp('��������̸�ľ��룺');
for i = 1:num_images
    fprintf('ͼƬ %d: %.2f mm\n', i, distances(i));
end