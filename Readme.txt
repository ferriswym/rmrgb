本程序包括start.m，rmrgb.m，compare.m三个文件


start是程序整个程序入口，调用rmrgb和compare
rmrgb是主程序，去除文字和补全背景
compare是用PSNR指标评估图片处理质量，需要原本没有文字的图片，即仅对样本图片调用有效


test_pics文件夹里是用于测试的图片，均是用photoshop往图片里加入文字得到
source_pics文件夹里是对应test_pics里图片的未加文字的源图片


注意事项：
1.调用时需要将matlab的工作路径设在当前目录下，因为程序里有路径调用，如果路径不对将报错
2.启动start后将弹出选择图像的窗口，此时选择待处理的图像，即test_pics里面的图像
3.接着弹出所选择图像的窗口，此时需要用户截取文字区域，在matlab主窗口上有提示
4.最终弹出处理完成的图像，并在主窗口显示PSNR的值


