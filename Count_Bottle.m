%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @file ��Count_Bottle.m�� 
% @brief ��ʹ����̬ѧͼ��������ʶ��ͳ��ơ��ƿ������
% @version 1.0 ���汾������
% @author ��RyanZzzq��
% @date ��2023.7.6��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ��ʼ��
clear,clc;
close all;

%% ѡ��ͼ���ļ�
[fileName,pathName] = uigetfile('*.*','��ѡ����Ҫʶ���ͼ���ļ�');%ʹ���ļ���ѡ���ļ�
if(fileName)
    fileName = strcat(pathName,fileName);
    fileName = lower(fileName);%һ�µ�Сд��ĸ��ʽ
else 
    msgbox('��ѡ��ͼ���ļ�');
    return; %�˳�����
end

%% ��ȡͼ���ļ�
I=imread(fileName);
figure,imshow(I);
title('ԭʼͼ��','Fontsize',10 ,'FontName','Microsoft YaHei') ;

%% Ԥ����
imgdata = im2double(I);     %ԭʼͼ��תΪ����
contrast = 1 * (imgdata.^1.4);%��ǿ�Աȶ�
figure,imshow(contrast);
title('��ǿ�ԱȶȺ�ͼ��','Fontsize',10 ,'FontName','Microsoft YaHei') ;

%% ��ֵ�˲�����ͼ��
Im=medfilt2(contrast,[3,3]);  %��ֵ�˲�
figure,imshow(Im);
title('�˲���ͼ��','Fontsize',10 ,'FontName','Microsoft YaHei') ;

%% ��ֵ������ͼ��
It=imbinarize(Im);    %��ֵ��
figure,imshow(It);
title('��ֵͼ��','Fontsize',10 ,'FontName','Microsoft YaHei') ;

%% ͨ�������ж��ֶ�ȥ��
[m,n] = size(It);
for i = 2:m-1
   for j = 2:n-1
       %ͬ����Ԫ���ж�       
       if(It(i,j)~=It(i+1,j) && It(i,j)~=It(i-1,j))
           It(i,j) = 1;
       %ͬ����Ԫ���ж�
       elseif(It(i,j)~=It(i,j+1) && It(i,j)~=It(i,j-1))
           It(i,j) = 1;
       %ͬб��Ԫ���ж�
       elseif(It(i,j)~=It(i+1,j+1) && It(i,j)~=It(i-1,j-1))
           It(i,j) = 1;
       %ͬб��Ԫ���ж�
       elseif(It(i,j)~=It(i-1,j+1) && It(i,j)~=It(i+1,j-1))
           It(i,j) = 1;
       end
   end
end
figure,imshow(It);
title('�������ͼ��','Fontsize',10,'FontName','Microsoft YaHei');

%% ���ʹ���
% �����ṹԪ��,֮�����ʹ���
se1=strel('diamond',50);   %diamondΪһ��ƽ̹�����νṹԪ�أ�R�ǴӽṹԪ��ԭ�㵽������Զ�ľ���
A1=imdilate(It,se1);
figure,imshow(A1);
title('���ʹ����ͼ��','Fontsize',10 ,'FontName','Microsoft YaHei') ;

%% ��������
% regionpropsͳ�Ʊ���ǵ����������ֲ�����ʾ��������
[L,m] = bwlabel(A1);
img_reg=regionprops(L,'Area','BoundingBox'); %��ʾ��С����
areas = cat(1,img_reg.Area); %����洢��������
rects = cat(1,img_reg.BoundingBox); %����洢�������
centroid = regionprops(L,'Centroid'); %ÿ����������ģ����ģ�

min_px = 10000; %��С������ֵ
counter = 0;%������

figure('NumberTitle', 'off', 'Name', 'ʶ����'),imshow(I);hold on;

for i = 1:m
    if areas(i,:) > min_px
       %areas(i,:) = areas(i+1,:); ���������
       
       rectangle('position',rects(i,:),'edgecolor','r','linewidth',1); %��ÿ�������ͨ�򻭿� img_reg(i).BoundingBox
       text(centroid(i,1).Centroid(1,1)-15,centroid(i,1).Centroid(1,2)-15, num2str(i),'Color', 'r','FontWeight','bold','Fontsize',10 ,'FontName','Microsoft YaHei')
       %������λ����ʾ���
       
       %��ʾÿ�������е����ش�С
       disp(strcat(num2str(i),'������Ϊ��',num2str(areas(i,:))));
       counter=counter+1;
    end
end

%% ��ʾ���
disp(strcat('ơ��ƿ��������',num2str(counter)));  %�����д�����ʾơ��ƿ���� i

title(sprintf('�ܹ�%dƿơ��',counter),'Fontsize',10 ,'FontName','Microsoft YaHei') %ͼ�������ʾ����