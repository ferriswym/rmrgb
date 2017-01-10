%�������%

clear all;
clc;
FilterSpec = {'*.jpg', 'JPGͼ��*.jpg��'; '*.jpeg', 'JPEGͼ��*.jpeg��'};
[Filename, path]= uigetfile(FilterSpec, 'ѡ��RGBͼ���ļ�');    %��ȡͼ���ļ�
[Iout RECT scale]= rmrgb([path, Filename]);                   %����rmrgb����ȥ�����ֲ���
path2 = '.\source_pics\';
switch Filename                                               %����ǲ�������ͼƬ������compare������ԴͼƬ�������ƶȱȽ�
    case 'bluesky1.jpg'
        Filename2 = [path2, 'bluesky.jpg'];
        PSNR = compare(Filename2, scale, Iout, RECT);
    case 'cloud1.jpg'
        Filename2 = [path2, 'cloud.jpg'];
        PSNR = compare(Filename2, scale, Iout, RECT);
    case 'dawn1.jpg'
        Filename2 = [path2, 'dawn.jpg'];
        PSNR = compare(Filename2, scale, Iout, RECT);
    case 'lake1.jpg'
        Filename2 = [path2, 'lake.jpg'];
        PSNR = compare(Filename2, scale, Iout, RECT);
    case 'mountain1.jpg'
        Filename2 = [path2, 'mountain.jpg'];
        PSNR = compare(Filename2, scale, Iout, RECT);
    case 'sanxia1.jpg'
        Filename2 = [path2, 'sanxia.jpg'];
        PSNR = compare(Filename2, scale, Iout, RECT);
    case 'sea1.jpg'
        Filename2 = [path2, 'sea.jpg'];
        PSNR = compare(Filename2, scale, Iout, RECT);
    case 'sky1.jpg'
        Filename2 = [path2, 'sky.jpg'];
        PSNR = compare(Filename2, scale, Iout, RECT);
end
disp(PSNR);