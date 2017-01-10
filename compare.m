%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compare函数，仅用于比较测试的样本图片与原图的相似度，指标为PSNR峰值信噪比
% 
% 参数说明：
% 输入：
% Filename2: 参考图片的路径及名称
% scale: 处理过程中发生的伸缩变换
% Iout: 去除文字后的图片
% RECT: 截取的文字区域 [xmin ymin width, height]
% 输出：
% PSNR: 以文本形式输出峰值信噪比，PSNR的值越大图像相似度越高
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function PSNR = compare(Filename2, scale, Iout, RECT)
In = imread(Filename2);
if(scale ~= 1)                                                             %如果处理过程中用到缩放，则缩小到相应尺寸
    In = imresize(In, scale, 'bicubic');
    Iout = imresize(Iout, scale, 'bicubic');
end
tin = In([RECT(2):(RECT(2) + RECT(4))],[RECT(1):(RECT(1) + RECT(3))],:);   %截图处理过得文字区域进行比较，其它部分相同
tout = Iout([RECT(2):(RECT(2) + RECT(4))],[RECT(1):(RECT(1) + RECT(3))],:);
[ m,n,d ] = size( tin );
mse = sum(( double(tin(:)) - double(tout(:))).^2);                         
mse = mse/(m*n*d);                                                         %计算两幅图像的均方根偏差
out = 10*log10((255*255)/mse);                                             %计算两幅图像的峰值信噪比
PSNR = sprintf('图像的峰值信噪比PSNR为 %d', out);
