% 清除命令行窗口和工作区
clc;
clear all;

% 加载校准参数
load('Omni_Calib_Results_26mm.mat');
ocam_model = calib_data.ocam_model;

% 获取TestImages文件夹下所有图片文件的信息
image_folder = 'TestImages';
image_files = dir(fullfile(image_folder, '*.jpg')); % 假设图片为jpg格式，可按需修改为其他格式，如*.png等

% 只取前4张图片，如果图片不足4张，则取实际数量
num_images = min(4, length(image_files));
image_paths = cell(num_images, 1);
for i = 1:num_images
    image_paths{i} = fullfile(image_folder, image_files(i).name);
end

% 初始化距离数组
distances = zeros(num_images, 1);

% 循环处理每张图片
for i = 1:num_images
    % 这里kk应该是图片在calib_data.L中的索引，假设顺序一致
    kk = i; 
    % 寻找棋盘格像素坐标
    use_corner_find = 1;
    % 修改调用，传入kk, use_corner_find, calib_data
    [~, Xp_abs_, Yp_abs_] = get_checkerboard_cornersUrban(kk, use_corner_find, calib_data);
    imagePoints = [Xp_abs_', Yp_abs_'];
    
    % 对图像进行校准
    % 这里假设 calibrate 和 FindTransformMatrix 函数已经正确实现
    [RRfin_, ~] = calibrate(ocam_model, imagePoints);
    [~, ~, RRfin_] = FindTransformMatrix(ocam_model, imagePoints, RRfin_);
    
    % 获取相机到棋盘格的距离
    distances(i) = RRfin_(1, 3);
end

% 显示每张图片对应的相机到棋盘格的距离
disp('相机到棋盘格的距离：');
for i = 1:num_images
    fprintf('图片 %d: %.2f mm\n', i, distances(i));
end