close all;
clear all;

% ͼƬ����
numImages = 12;

% Ԥ�����ڴ�
im_h = cell(numImages, 1);

for i = 1:numImages
    % ��ȡ��ʵͼ��ԭʼ�߷ֱ���ͼ��
    imgName = sprintf('a%d.jpg', i);
    im = imread(imgName);

    % ���ò���
    up_scale = 3;
    model = 'model\9-1-5(ImageNet)\x3.mat';

    % ���������ȷ���������ǲ�ɫͼ��
    if size(im, 3) > 1
        im = rgb2ycbcr(im);
        im = im(:, :, 1);
    end
    
    % ��ͼ����вü���ʹͼ��ߴ��ܱ��Ŵ�������
    im_gnd = modcrop(im, up_scale);
    % ��ͼ������ת��Ϊ���������ͣ�����һ���� [0, 1] ����
    im_gnd = single(im_gnd) / 255;

    % ʹ�� SRCNN ģ�ͽ��г��ֱ����ؽ�
    im_h{i} = SRCNN(model, im_gnd);

    % ʹ��imsharpen���б�Ե��ǿ�����پ�ݸУ�
    im_h{i} = imsharpen(im_h{i}, 'Amount', 0.5, 'Radius', 1);
    
        % ȥ��ͼ��߽�
    im_h{i} = shave(uint8(im_h{i} * 255), [up_scale, up_scale]);
    
    % ���� SRCNN ���ֱ����ؽ����ͼ��
    imwrite(im_h{i}, sprintf('SRCNNsolo%d.jpg', i));
end
    