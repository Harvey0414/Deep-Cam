clear all;

% ��ȡ��������
basename = input('Basename camera calibration images (without number nor suffix): ', 's');

% ��ȡͼ���ʽ
valid_formats = {'r', 'ras', 'b', 'bmp', 't', 'tif', 'g', 'gif', 'p', 'pgm', 'j', 'jpg', 'm', 'ppm'};
format_extensions = {'ras', 'ras', 'bmp', 'bmp', 'tif', 'tif', 'gif', 'gif', 'pgm', 'pgm', 'jpg', 'jpg', 'ppm', 'ppm'};

format_input = input('Image format: ([]=''r''=''ras'', ''b''=''bmp'', ''t''=''tif'', ''g''=''gif'', ''p''=''pgm'', ''j''=''jpg'', ''m''=''ppm''): ', 's');

format_idx = find(strcmpi(valid_formats, format_input), 1);
if isempty(format_idx)
    fprintf('Invalid format, use default format jpg\n');
    format_idx = 11; % 'j'������
end
file_ext = format_extensions{format_idx};

% ��ȡͼ������
num_images = input('The number of images to be processed: ');

% ��ȡ��ʼ���
start_num = input('Start number: ');
img_numbers = start_num:(start_num + num_images - 1);

% Ԥ�����ڴ�
im_h = cell(num_images, 1);

% ����ͼ��
for i = 1:num_images
    img_number = img_numbers(i);
    img_name = sprintf('%s%d.%s', basename, img_number, file_ext);
    
    try
        % ��ȡͼ��
        im = imread(img_name);
        fprintf('Processing image: %s\n', img_name);
    catch
        fprintf('Error: Unable to read image% s, please check if the file exists. \n', img_name);
        continue; % ������ǰͼ�񣬼���������һ��
    end
    
    
    % ���ò���
    up_scale = 3;
    model = 'model\9-5-5(ImageNet)\x3.mat';


    % ���������ȷ���������ǲ�ɫͼ��
    if size(im, 3) > 1
        im = rgb2ycbcr(im);
        im = im(:, :, 1);
    end 
    
    
    % ��ͼ����вü���ʹͼ��ߴ��ܱ��Ŵ�������
    im_gnd = modcrop(im, up_scale);
    % ��ͼ������ת��Ϊ���������ͣ�����һ���� [0, 1] ����
    im_gnd = single(im_gnd) / 255;

    % ����˫���β�ֵ
    im_l = imresize(im_gnd, 1 / up_scale, 'bicubic');
    im_b = imresize(im_l, up_scale, 'bicubic');

    % ʹ�� SRCNN ģ�ͽ��г��ֱ����ؽ�
    im_h{i} = SRCNN(model, im_b);

    % ����ͼ��
    output_name = sprintf('%s_%d.jpg', basename, img_number);
    imwrite(im_h{i}, output_name);
end

fprintf('\nAll image processing completed!\n');