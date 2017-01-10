%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%主要函数，利用两次一维插值去除图片中的小标注文字
%用户输入需处理的图片，并截取文字区域，程序输出去除文字的图片

% 参数说明：
% 输入：
% Filename: 图像文件名
% 输出：
% It: 返回修改后的最终图像
% RECT: 截取的文字区域[xmin ymin width, height]
% scale: 处理过程中的伸缩变换尺度，用于后续相似评估
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [It RECT scale] = rmrgb(Filename)        
Is = imread(Filename);
scalex = 1; scaley = 1; cusizex = 800; cusizey = 1500; %根据屏幕分辨率设定，使截取图片时能在屏幕上显示完整图片，此时效果最好
if(size(Is,1) > cusizex)
    scalex = cusizex/size(Is,1);
end
if(size(Is,2) > cusizey)
    scaley = cusizey/size(Is,2);
end
scale = min(scalex, scaley);
if(scale ~= 1)
    Is = imresize(Is, scale, 'bicubic');             %根据屏幕分辨率缩放图片，使截取图片时矩形框为原始尺寸，得到准确坐标
end
disp('请框选标注文字，双击确定');
disp('注意不要改动图片尺寸，且方框在包含所有文字条件下尽可能小');
[text RECT] = imcrop(Is);                            %截取文字区域图像text，以下均是对文字区域部分处理
RECT = round(RECT);
xmin = RECT(1);ymin = RECT(2); width = RECT(3); height = RECT(4);
w1 = [0 -1 0; -1 4 -1; 0 -1 0];
L = imfilter(text, w1, 'corr', 'replicate');         %以拉普拉斯算子滤波锐化
h3_75 = fspecial('gaussian', 3, 0.75);
L1 = imfilter(L, h3_75, 'corr', 'replicate');        %高斯滤波去除噪声
thresh = graythresh(L1);
bw1 = im2bw(L1,thresh);                              %二值化，取文字区域
bw2 = imdilate(bw1, ones(3,3));                      %图像膨胀处理
for c = 1:3
    bw(:,:,c) = bw2;
end
b=0;w=0;x=[];y=[];xi=[];yi=[];m=0;n=0;
nrow = size(bw2,1); ncol = size(bw2,2);
rowin=zeros(nrow,ncol,3);colin=zeros(nrow,ncol,3);
for a = 1:nrow                                       %按行遍历图像，每行对文字区域点作插值记入矩阵
    x = find(bw2(a,:) == 0);
    m = size(x,2);
    y = text(a,x,:);
    xi = find(bw2(a,:));
    n = size(xi,2);
    if(n ~= 0)
        y = double(y);
        y = reshape(y,m,3);
        yi = interp1(x,y,xi,'cubic');
        for b = 1:n
            if(yi(b)>255)
                yi(b) = 255;
            elseif(yi(b)<0)
                yi(b) = 0;
            end
            rowin(a,xi(b),:) = yi(b,:);
        end
    end
    xi=[];yi=[];x=[];y=[];n=0;m=0;
end
text(bw) = rowin(bw);
for b = 1:ncol                                       %按列遍历图像，每列对文字区域点作插值记入矩阵
    x = find(bw2(:,b) == 0);
    m = size(x,1);
    y = text(x,b,:);
    xi = find(bw2(:,b));
    n = size(xi,1);
    y = double(y);
    y = reshape(y,m,3);
    if(n ~= 0)
        yi = interp1(x,y,xi,'cubic');
        for a = 1:n
            if(yi(a) > 255)
                yi(a) = 255;
            elseif(yi(a) < 0)
                yi(a) = 0;
            end
            colin(xi(a),b,:) = yi(a,:);
        end
    end
    xi=[];yi=[];x=[];y=[];n=0;m=0;
end
kcol = 0; krow = 1;
text(bw) = colin(bw)*kcol + rowin(bw)*krow;          %以双向插值的加权平均值替换原图
t1 = imfilter(text, h3_75, 'corr', 'replicate');     %对替换得到的图像进行一次高斯滤波，平滑图像
text(bw) = t1(bw);                                   %把平滑后得到的文字部分的点带入回text
t2 = imfilter(text, h3_75, 'corr', 'replicate');     %对text再进行一次高斯滤波，得到最终处理矩阵
text(bw) = t2(bw); 
It = Is;
It([ymin:ymin + height - 1],[xmin:xmin + width - 1], :) = text;  %把text放回原来完整图像矩阵
if(scale ~= 1)
    It = imresize(It, 1/scale, 'bicubic');           %如果原来因图像过大而进行了缩小，则用插值法放大成原来大小
end
imshow(Is);
figure;
imshow(It);