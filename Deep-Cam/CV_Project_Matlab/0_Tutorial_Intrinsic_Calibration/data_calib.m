% %%% This function lets the user enter the name of the images (base name, numbering scheme,...
% function data_calib(calib_data)
% 
% %clear all;
% set_up_global;
% % Checks that there are some images in the directory:
% 
% l_ras = dir('*ras');
% s_ras = size(l_ras,1);
% l_bmp = dir('*bmp');
% s_bmp = size(l_bmp,1);
% l_tif = dir('*tif');
% s_tif = size(l_tif,1);
% l_pgm = dir('*pgm');
% s_pgm = size(l_pgm,1);
% l_ppm = dir('*ppm');
% s_ppm = size(l_ppm,1);
% l_jpg = dir('*jpg');
% s_jpg = size(l_jpg,1);
% l_gif = dir('*gif');
% s_gif = size(l_gif,1);
% 
% s_tot = s_ras + s_bmp + s_tif + s_pgm + s_jpg + s_ppm + s_gif;
% 
% if s_tot < 1,
%    fprintf(1,'No image in this directory in either ras, bmp, tif, gif, pgm, ppm or jpg format. Change directory and try again.\n');
%    return;
% end;
% 
% 
% % IF yes, display the directory content:
% 
% dir;
% 
% Nima_valid = 0;
% 
% while (Nima_valid==0),
% 
%    fprintf(1,'\n');
%    calib_data.calib_name = input('Basename camera calibration images (without number nor suffix): ','s');
%    
%    calib_data.format_image = '0';
%    
% 	while calib_data.format_image == '0',
%    
%    	calib_data.format_image =  input('Image format: ([]=''r''=''ras'', ''b''=''bmp'', ''t''=''tif'', ''g''=''gif'', ''p''=''pgm'', ''j''=''jpg'', ''m''=''ppm'') ','s');
% 		
% 		if isempty(calib_data.format_image),
%    		calib_data.format_image = 'ras';
% 		end;
%       
%       if lower(calib_data.format_image(1)) == 'm',
%          calib_data.format_image = 'ppm';
%       else
%          if lower(calib_data.format_image(1)) == 'b',
%             calib_data.format_image = 'bmp';
%          else
%             if lower(calib_data.format_image(1)) == 't',
%                calib_data.format_image = 'tif';
%             else
%                if lower(calib_data.format_image(1)) == 'p',
%                   calib_data.format_image = 'pgm';
%                else
%                   if lower(calib_data.format_image(1)) == 'j',
%                      calib_data.format_image = 'jpg';
%                   else
%                      if lower(calib_data.format_image(1)) == 'r',
%                         calib_data.format_image = 'ras';
%                      else
%                          if lower(calib_data.format_image(1)) == 'g',
%                              calib_data.format_image = 'gif';
%                          else  
%                              disp('Invalid image format');
%                              calib_data.format_image = '0'; % Ask for format once again
%                          end;
%                      end;
%                   end;
%                end;
%             end;
%          end;
%       end;
%    end;
% 
%       
%    [Nima_valid] = check_directory(calib_data);
%    
% end;
% 
% if (Nima_valid~=0),
%     % Reading images:
%     
%     ima_read_calib(calib_data); % may be launched from the toolbox itself
%     % Show all the calibration images:
%     
%     if ~isempty(calib_data.ind_read),
%         
%         mosaic(calib_data);
%         
%     end;
%     
% end;
% end
% 
%%% This function lets the user enter the name of the images (base name, numbering scheme,...
function data_calib(calib_data)

%clear all;
set_up_global;
% Checks that there are some images in the directory:

l_ras = dir('*ras');
s_ras = size(l_ras,1);
l_bmp = dir('*bmp');
s_bmp = size(l_bmp,1);
l_tif = dir('*tif');
s_tif = size(l_tif,1);
l_pgm = dir('*pgm');
s_pgm = size(l_pgm,1);
l_ppm = dir('*ppm');
s_ppm = size(l_ppm,1);
l_jpg = dir('*jpg');
s_jpg = size(l_jpg,1);
l_gif = dir('*gif');
s_gif = size(l_gif,1);
l_png = dir('*png');  % ���������PNG�ļ�
s_png = size(l_png,1); % ������PNG�ļ�����

s_tot = s_ras + s_bmp + s_tif + s_pgm + s_jpg + s_ppm + s_gif + s_png;  % ������������

if s_tot < 1,
   fprintf(1,'No image in this directory in either ras, bmp, tif, gif, pgm, ppm, jpg or png format. Change directory and try again.\n');
   return;
end;


% IF yes, display the directory content:

dir;

Nima_valid = 0;

while (Nima_valid==0),

   fprintf(1,'\n');
   calib_data.calib_name = input('Basename camera calibration images (without number nor suffix): ','s');
   
   calib_data.format_image = '0';
   
	while calib_data.format_image == '0',
   
   	calib_data.format_image =  input('Image format: ([]=''r''=''ras'', ''b''=''bmp'', ''t''=''tif'', ''g''=''gif'', ''p''=''pgm'', ''j''=''jpg'', ''m''=''ppm'', ''n''=''png'') ','s');
		
		if isempty(calib_data.format_image),
   		calib_data.format_image = 'ras';
		end;
      
      % ʹ��switch-case���Ƕ��if-else
      first_char = lower(calib_data.format_image(1));
      switch first_char
          case 'm'
              calib_data.format_image = 'ppm';
          case 'b'
              calib_data.format_image = 'bmp';
          case 't'
              calib_data.format_image = 'tif';
          case 'p'
              calib_data.format_image = 'pgm';
          case 'j'
              calib_data.format_image = 'jpg';
          case 'r'
              calib_data.format_image = 'ras';
          case 'g'
              calib_data.format_image = 'gif';
          case 'n'  % ����PNG֧��
              calib_data.format_image = 'png';
          otherwise
              disp('Invalid image format');
              calib_data.format_image = '0'; % ����ѯ�ʸ�ʽ
      end
   end;

      
   [Nima_valid] = check_directory(calib_data);
   
end;

if (Nima_valid~=0),
    % Reading images:
    
    ima_read_calib(calib_data); % may be launched from the toolbox itself
    % Show all the calibration images:
    
    if ~isempty(calib_data.ind_read),
        
        mosaic(calib_data);
        
    end;
    
end;
end