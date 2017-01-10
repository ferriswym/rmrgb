%程序入口%

clear all;
clc;
FilterSpec = {'*.jpg', 'JPG图像（*.jpg）'; '*.jpeg', 'JPEG图像（*.jpeg）'};
[Filename, path]= uigetfile(FilterSpec, '选择RGB图像文件');    %读取图像文件
[Iout RECT scale]= rmrgb([path, Filename]);                   %调用rmrgb函数去除文字部分
path2 = '.\source_pics\';
switch Filename                                               %如果是测试样本图片，调用compare函数与源图片进行相似度比较
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