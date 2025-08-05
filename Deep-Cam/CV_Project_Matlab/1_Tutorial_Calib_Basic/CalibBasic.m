clc
clear all
load('Ocam_deep_SRCNN.mat'); % Calib parameters
ocam_model = calib_data.ocam_model; % Calib parameters

% ����Ҫ�����ͼ���ļ���
imageFiles = {'TestImages/b_1.jpg', 'TestImages/b_2.jpg'};

for k = 1:length(imageFiles)
    i = calib_data.n_ima;
    % ʹ�û�����ȷ���Ե�Ԫ����ʽ��ֵ
    calib_data.L{i+1} = imageFiles{k}; 
    use_corner_find = 1;
    
    % ���ýǵ��⺯��
    try
        [callBack, Xp_abs_, Yp_abs_] = get_checkerboard_cornersUrban(i+1, use_corner_find, calib_data);
    catch ME
        fprintf('Corner detection error while processing image %s: %s\n', imageFiles{k}, ME.message);
        continue; % ������ǰͼ��Ĵ���
    end
    
    % ���ǵ������Ƿ�Ϊ��
    if isempty(Xp_abs_) || isempty(Yp_abs_)
        fprintf('No corner detected while processing image %s, skip the image\n', imageFiles{k});
        continue;
    end
    
    Xt = calib_data.Xt;
    Yt = calib_data.Yt;
    
    % ���ά���Ƿ�ƥ��
    if length(Xp_abs_) ~= length(Xt) || length(Yp_abs_) ~= length(Yt)
        fprintf('When processing image %s, the corner detection result does not match the dimension of the calibration data, skip the image \n', imageFiles{k});
        continue;
    end
    
    imagePoints = [Yp_abs_, Xp_abs_];
    
    % �������
    [RRfin, ss] = calibrate(Xt, Yt, Xp_abs_, Yp_abs_, ocam_model);
    RRfin_ = FindTransformMatrix(Xp_abs_, Yp_abs_, Xt, Yt, ocam_model, RRfin);
    
    % �������
    Y = RRfin_(k, 3);
    fprintf('The distance of image %s is:%f\n', imageFiles{k}, Y);
end
