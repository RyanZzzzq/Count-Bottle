%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @file （Count_Bottle.m） 
% @brief （使用形态学图像处理技术，识别并统计啤酒瓶个数）
% @version 1.0 （版本声明）
% @author （RyanZzzq）
% @date （2023.7.6）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 初始化
clear,clc;
close all;

%% 选择图像文件
[fileName,pathName] = uigetfile('*.*','请选择需要识别的图像文件');%使用文件筐，选择文件
if(fileName)
    fileName = strcat(pathName,fileName);
    fileName = lower(fileName);%一致的小写字母形式
else 
    msgbox('请选择图像文件');
    return; %退出程序
end

%% 读取图像文件
I=imread(fileName);
figure,imshow(I);
title('原始图像','Fontsize',10 ,'FontName','Microsoft YaHei') ;

%% 预处理
imgdata = im2double(I);     %原始图像转为数据
contrast = 1 * (imgdata.^1.4);%增强对比度
figure,imshow(contrast);
title('增强对比度后图像','Fontsize',10 ,'FontName','Microsoft YaHei') ;

%% 中值滤波处理图像
Im=medfilt2(contrast,[3,3]);  %中值滤波
figure,imshow(Im);
title('滤波后图像','Fontsize',10 ,'FontName','Microsoft YaHei') ;

%% 二值化处理图像
It=imbinarize(Im);    %二值化
figure,imshow(It);
title('二值图像','Fontsize',10 ,'FontName','Microsoft YaHei') ;

%% 通过领域判断手动去噪
[m,n] = size(It);
for i = 2:m-1
   for j = 2:n-1
       %同上下元素判断       
       if(It(i,j)~=It(i+1,j) && It(i,j)~=It(i-1,j))
           It(i,j) = 1;
       %同左右元素判断
       elseif(It(i,j)~=It(i,j+1) && It(i,j)~=It(i,j-1))
           It(i,j) = 1;
       %同斜边元素判断
       elseif(It(i,j)~=It(i+1,j+1) && It(i,j)~=It(i-1,j-1))
           It(i,j) = 1;
       %同斜边元素判断
       elseif(It(i,j)~=It(i-1,j+1) && It(i,j)~=It(i+1,j-1))
           It(i,j) = 1;
       end
   end
end
figure,imshow(It);
title('领域降噪后图像','Fontsize',10,'FontName','Microsoft YaHei');

%% 膨胀处理
% 创建结构元素,之后膨胀处理
se1=strel('diamond',50);   %diamond为一个平坦的菱形结构元素，R是从结构元素原点到菱形最远的距离
A1=imdilate(It,se1);
figure,imshow(A1);
title('膨胀处理后图像','Fontsize',10 ,'FontName','Microsoft YaHei') ;

%% 计算数量
% regionprops统计被标记的区域的面积分布，显示区域总数
[L,m] = bwlabel(A1);
img_reg=regionprops(L,'Area','BoundingBox'); %显示最小矩形
areas = cat(1,img_reg.Area); %数组存储像素总数
rects = cat(1,img_reg.BoundingBox); %数组存储矩形情况
centroid = regionprops(L,'Centroid'); %每个区域的质心（重心）

min_px = 10000; %最小像素阈值
counter = 0;%计数器

figure('NumberTitle', 'off', 'Name', '识别结果'),imshow(I);hold on;

for i = 1:m
    if areas(i,:) > min_px
       %areas(i,:) = areas(i+1,:); 消除误差组
       
       rectangle('position',rects(i,:),'edgecolor','r','linewidth',1); %对每个最大连通域画框 img_reg(i).BoundingBox
       text(centroid(i,1).Centroid(1,1)-15,centroid(i,1).Centroid(1,2)-15, num2str(i),'Color', 'r','FontWeight','bold','Fontsize',10 ,'FontName','Microsoft YaHei')
       %在质心位置显示编号
       
       %显示每个矩形中的像素大小
       disp(strcat(num2str(i),'的像素为：',num2str(areas(i,:))));
       counter=counter+1;
    end
end

%% 显示结果
disp(strcat('啤酒瓶的数量：',num2str(counter)));  %命令行窗口显示啤酒瓶数量 i

title(sprintf('总共%d瓶啤酒',counter),'Fontsize',10 ,'FontName','Microsoft YaHei') %图像标题显示总数