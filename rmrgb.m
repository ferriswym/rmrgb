%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��Ҫ��������������һά��ֵȥ��ͼƬ�е�С��ע����
%�û������账���ͼƬ������ȡ�������򣬳������ȥ�����ֵ�ͼƬ

% ����˵����
% ���룺
% Filename: ͼ���ļ���
% �����
% It: �����޸ĺ������ͼ��
% RECT: ��ȡ����������[xmin ymin width, height]
% scale: ��������е������任�߶ȣ����ں�����������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [It RECT scale] = rmrgb(Filename)        
Is = imread(Filename);
scalex = 1; scaley = 1; cusizex = 800; cusizey = 1500; %������Ļ�ֱ����趨��ʹ��ȡͼƬʱ������Ļ����ʾ����ͼƬ����ʱЧ�����
if(size(Is,1) > cusizex)
    scalex = cusizex/size(Is,1);
end
if(size(Is,2) > cusizey)
    scaley = cusizey/size(Is,2);
end
scale = min(scalex, scaley);
if(scale ~= 1)
    Is = imresize(Is, scale, 'bicubic');             %������Ļ�ֱ�������ͼƬ��ʹ��ȡͼƬʱ���ο�Ϊԭʼ�ߴ磬�õ�׼ȷ����
end
disp('���ѡ��ע���֣�˫��ȷ��');
disp('ע�ⲻҪ�Ķ�ͼƬ�ߴ磬�ҷ����ڰ����������������¾�����С');
[text RECT] = imcrop(Is);                            %��ȡ��������ͼ��text�����¾��Ƕ��������򲿷ִ���
RECT = round(RECT);
xmin = RECT(1);ymin = RECT(2); width = RECT(3); height = RECT(4);
w1 = [0 -1 0; -1 4 -1; 0 -1 0];
L = imfilter(text, w1, 'corr', 'replicate');         %��������˹�����˲���
h3_75 = fspecial('gaussian', 3, 0.75);
L1 = imfilter(L, h3_75, 'corr', 'replicate');        %��˹�˲�ȥ������
thresh = graythresh(L1);
bw1 = im2bw(L1,thresh);                              %��ֵ����ȡ��������
bw2 = imdilate(bw1, ones(3,3));                      %ͼ�����ʹ���
for c = 1:3
    bw(:,:,c) = bw2;
end
b=0;w=0;x=[];y=[];xi=[];yi=[];m=0;n=0;
nrow = size(bw2,1); ncol = size(bw2,2);
rowin=zeros(nrow,ncol,3);colin=zeros(nrow,ncol,3);
for a = 1:nrow                                       %���б���ͼ��ÿ�ж��������������ֵ�������
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
for b = 1:ncol                                       %���б���ͼ��ÿ�ж��������������ֵ�������
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
text(bw) = colin(bw)*kcol + rowin(bw)*krow;          %��˫���ֵ�ļ�Ȩƽ��ֵ�滻ԭͼ
t1 = imfilter(text, h3_75, 'corr', 'replicate');     %���滻�õ���ͼ�����һ�θ�˹�˲���ƽ��ͼ��
text(bw) = t1(bw);                                   %��ƽ����õ������ֲ��ֵĵ�����text
t2 = imfilter(text, h3_75, 'corr', 'replicate');     %��text�ٽ���һ�θ�˹�˲����õ����մ������
text(bw) = t2(bw); 
It = Is;
It([ymin:ymin + height - 1],[xmin:xmin + width - 1], :) = text;  %��text�Ż�ԭ������ͼ�����
if(scale ~= 1)
    It = imresize(It, 1/scale, 'bicubic');           %���ԭ����ͼ��������������С�����ò�ֵ���Ŵ��ԭ����С
end
imshow(Is);
figure;
imshow(It);