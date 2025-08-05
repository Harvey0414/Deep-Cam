close all;
clear all;

% 图片数量
numImages = 12;

% 预分配内存
im_h = cell(numImages, 1);

for i = 1:numImages
    % 读取真实图像（原始高分辨率图像）
    imgName = sprintf('a%d.jpg', i);
    im = imread(imgName);

    % 设置参数
    up_scale = 3;
    model = 'model\9-1-5(ImageNet)\x3.mat';

    % 仅处理亮度分量（如果是彩色图像）
    if size(im, 3) > 1
        im = rgb2ycbcr(im);
        im = im(:, :, 1);
    end
    
    % 对图像进行裁剪，使图像尺寸能被放大倍数整除
    im_gnd = modcrop(im, up_scale);
    % 将图像数据转换为单精度类型，并归一化到 [0, 1] 区间
    im_gnd = single(im_gnd) / 255;

    % 使用 SRCNN 模型进行超分辨率重建
    im_h{i} = SRCNN(model, im_gnd);

    % 使用imsharpen进行边缘增强（减少锯齿感）
    im_h{i} = imsharpen(im_h{i}, 'Amount', 0.5, 'Radius', 1);
    
        % 去除图像边界
    im_h{i} = shave(uint8(im_h{i} * 255), [up_scale, up_scale]);
    
    % 保存 SRCNN 超分辨率重建后的图像
    imwrite(im_h{i}, sprintf('SRCNNsolo%d.jpg', i));
end
    