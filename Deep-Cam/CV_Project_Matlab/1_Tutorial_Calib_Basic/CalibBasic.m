clc
clear all
load('Ocam_deep_SRCNN.mat'); % Calib parameters
ocam_model = calib_data.ocam_model; % Calib parameters

% 定义要处理的图像文件名
imageFiles = {'TestImages/b_1.jpg', 'TestImages/b_2.jpg'};

for k = 1:length(imageFiles)
    i = calib_data.n_ima;
    % 使用花括号确保以单元格形式赋值
    calib_data.L{i+1} = imageFiles{k}; 
    use_corner_find = 1;
    
    % 调用角点检测函数
    try
        [callBack, Xp_abs_, Yp_abs_] = get_checkerboard_cornersUrban(i+1, use_corner_find, calib_data);
    catch ME
        fprintf('Corner detection error while processing image %s: %s\n', imageFiles{k}, ME.message);
        continue; % 跳过当前图像的处理
    end
    
    % 检查角点检测结果是否为空
    if isempty(Xp_abs_) || isempty(Yp_abs_)
        fprintf('No corner detected while processing image %s, skip the image\n', imageFiles{k});
        continue;
    end
    
    Xt = calib_data.Xt;
    Yt = calib_data.Yt;
    
    % 检查维度是否匹配
    if length(Xp_abs_) ~= length(Xt) || length(Yp_abs_) ~= length(Yt)
        fprintf('When processing image %s, the corner detection result does not match the dimension of the calibration data, skip the image \n', imageFiles{k});
        continue;
    end
    
    imagePoints = [Yp_abs_, Xp_abs_];
    
    % 计算外参
    [RRfin, ss] = calibrate(Xt, Yt, Xp_abs_, Yp_abs_, ocam_model);
    RRfin_ = FindTransformMatrix(Xp_abs_, Yp_abs_, Xt, Yt, ocam_model, RRfin);
    
    % 计算距离
    Y = RRfin_(k, 3);
    fprintf('The distance of image %s is:%f\n', imageFiles{k}, Y);
end
