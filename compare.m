%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compare�����������ڱȽϲ��Ե�����ͼƬ��ԭͼ�����ƶȣ�ָ��ΪPSNR��ֵ�����
% 
% ����˵����
% ���룺
% Filename2: �ο�ͼƬ��·��������
% scale: ��������з����������任
% Iout: ȥ�����ֺ��ͼƬ
% RECT: ��ȡ���������� [xmin ymin width, height]
% �����
% PSNR: ���ı���ʽ�����ֵ����ȣ�PSNR��ֵԽ��ͼ�����ƶ�Խ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function PSNR = compare(Filename2, scale, Iout, RECT)
In = imread(Filename2);
if(scale ~= 1)                                                             %�������������õ����ţ�����С����Ӧ�ߴ�
    In = imresize(In, scale, 'bicubic');
    Iout = imresize(Iout, scale, 'bicubic');
end
tin = In([RECT(2):(RECT(2) + RECT(4))],[RECT(1):(RECT(1) + RECT(3))],:);   %��ͼ�����������������бȽϣ�����������ͬ
tout = Iout([RECT(2):(RECT(2) + RECT(4))],[RECT(1):(RECT(1) + RECT(3))],:);
[ m,n,d ] = size( tin );
mse = sum(( double(tin(:)) - double(tout(:))).^2);                         
mse = mse/(m*n*d);                                                         %��������ͼ��ľ�����ƫ��
out = 10*log10((255*255)/mse);                                             %��������ͼ��ķ�ֵ�����
PSNR = sprintf('ͼ��ķ�ֵ�����PSNRΪ %d', out);
