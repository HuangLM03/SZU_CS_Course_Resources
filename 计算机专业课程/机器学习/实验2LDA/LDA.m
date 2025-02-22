clear all;
% 1.数据集导入
reshaped_faces=[];
database_name = "AR";
%AR5040
if (database_name == "AR")
    for i=1:40    
      for j=1:10       
        if(i<10)
           pic=imread(strcat('C:\Users\黄亮铭\Desktop\大学课程\机器学习\实验1PCA\AR_Gray_50by40\AR_Gray_50by40\AR00',num2str(i),'-',num2str(j),'.tif'));     
        else
            pic=imread(strcat('C:\Users\黄亮铭\Desktop\大学课程\机器学习\实验1PCA\AR_Gray_50by40\AR_Gray_50by40\AR0',num2str(i),'-',num2str(j),'.tif'));  
        end          
        reshaped_pic = reshape(pic,2000,1);
        reshaped_pic=double(reshaped_pic);        
        reshaped_faces=[reshaped_faces, reshaped_pic];  
      end
    end
row = 50;
col = 40;
people_num = 40;
each_pic_num = 10;
each_train_pic_num = 7;
each_test_pic_num = 3;
end
% ORL5646
if (database_name == "ORL")
  for i=1:40    
    for j=1:10       
        if(i<10)
           pic=imread(strcat('C:\Users\黄亮铭\Desktop\大学课程\机器学习\实验1PCA\ORL56_46\orl',num2str(i),'_',num2str(j),'.bmp'));     
        else
            pic=imread(strcat('C:\Users\黄亮铭\Desktop\大学课程\机器学习\实验1PCA\ORL56_46\orl',num2str(i),'_',num2str(j),'.bmp'));  
        end          
        reshaped_pic = reshape(pic,2576,1);
        reshaped_pic=double(reshaped_pic);        
        reshaped_faces=[reshaped_faces, reshaped_pic];  
    end
  end
row = 56;
col = 46;
people_num = 40;
each_pic_num = 10;
each_train_pic_num = 7;
each_test_pic_num = 3;
end
%FERET_80
if (database_name == "FERET")
    for i=1:80    
      for j=1:7       
        pic=imread(strcat('C:\Users\黄亮铭\Desktop\大学课程\机器学习\实验1PCA\FERET_80\ff',num2str(i),'_',num2str(j),'.tif'));              
        reshaped_pic = reshape(pic,6400,1);
        reshaped_pic=double(reshaped_pic);        
        reshaped_faces=[reshaped_faces, reshaped_pic];  
      end
    end
row = 80;
col = 80;
people_num = 80;
each_pic_num = 7;
each_train_pic_num = 5;
each_test_pic_num = 2;
end

% 取出前30%作为测试数据，剩下70%作为训练数据
test_data_idx = [];
train_data_idx = [];
for i=0:people_num-1
    test_data_idx = [test_data_idx each_pic_num*i+1:each_pic_num*i+each_test_pic_num];
    train_data_idx = [train_data_idx each_pic_num*i+each_test_pic_num+1:each_pic_num*(i+1)];
end

train_data = reshaped_faces(:,train_data_idx);
test_data = reshaped_faces(:, test_data_idx);
dimension = row * col;

% 2.数据预处理
% 求类均值
k = 1; 
class_mean = zeros(dimension, people_num); 
for i=1:people_num
    tmp = class_mean(:,i);
    for j=1:each_train_pic_num
        tmp = tmp + train_data(:,k);
        k = k + 1;
    end
    class_mean(:,i) = tmp / each_train_pic_num;
end

% 求类间散度矩阵Sb
Sb = zeros(dimension, dimension);
all_mean = mean(train_data, 2); % 全部的平均
for i=1:people_num
    % 以每个人的平均脸进行计算，同时中心化
    cen_data = class_mean(:,i) - all_mean;
    Sb = Sb + cen_data * cen_data';
end
Sb = Sb / people_num;

% 求类内散度矩阵Sw
Sw = zeros(dimension, dimension);
k = 1;
for i=1:people_num
    for j=1:each_train_pic_num
        cen_data = train_data(:,k) - class_mean(:,i);
        Sw = Sw + cen_data * cen_data';
        k = k + 1;
    end
end
Sw = Sw / (people_num * each_train_pic_num);

% 3.构造目标函数，并对目标函数进行特征值分解
% 目标函数一：经典LDA
%target = pinv(Sw) * Sb;
% 目标函数二：不可逆时需要正则项扰动
% Sw = Sw + eye(dimension)*10^-6;
% target = Sw^-1 * Sb;
% 目标函数三：相减形式
% target = Sb - Sw;
% 目标函数四：相除
% target = Sb/Sw;
% 目标函数五：调换位置
% target = Sb * pinv(Sw);
%PCA
cen_face = (train_data - all_mean);
cov_matrix = cen_face * cen_face';
target = cov_matrix;
% 求特征值、特征向量
[eigen_vectors, dianogol_matrix] = eig(target);
eigen_values = diag(dianogol_matrix);
% 对特征值、特征向量进行排序
[sorted_eigen_values, index] = sort(eigen_values, 'descend'); 
eigen_vectors = eigen_vectors(:, index);

% 4人脸识别
index = 1;
X = [];
Y = [];
for i=10:10:160
    project_matrix = eigen_vectors(:,1:i);
    projected_train_data = project_matrix' * (train_data - all_mean);
    projected_test_data = project_matrix' * (test_data - all_mean);

    K=1;
    % 用于保存数据结果
    min_k_values = zeros(K,1);
    min_k_values_label = zeros(K,1);

    test_face_number = size(projected_test_data, 2);
    correct_pre_number = 0;

    for each_test_face_index = 1:test_face_number
        each_test_face = projected_test_data(:,each_test_face_index);
        % 先把k个值填满，避免在迭代中反复判断
        for each_train_face_index = 1:K
            min_k_values(each_train_face_index,1) = norm(each_test_face - projected_train_data(:,each_train_face_index));
            min_k_values_label(each_train_face_index,1) = floor((train_data_idx(1,each_train_face_index) - 1) / each_pic_num) + 1;
        end
        
        [max_value, index_of_max_value] = max(min_k_values);

        % 计算与剩余每一个已知人脸的距离
        for each_train_face_index = K+1:size(projected_train_data,2)
            dis = norm(each_test_face - projected_train_data(:,each_train_face_index));
            % 判断是否更新标签
            if (dis < max_value)
                min_k_values(index_of_max_value,1) = dis;
                min_k_values_label(index_of_max_value,1) = floor((train_data_idx(1,each_train_face_index) - 1) / each_pic_num) + 1;
                [max_value, index_of_max_value] = max(min_k_values);
            end
        end
        
        % 得到结果
        predict_label = mode(min_k_values_label);
        real_label = floor((test_data_idx(1,each_test_face_index) - 1) / each_pic_num)+1;

        if (predict_label == real_label)
            correct_pre_number = correct_pre_number + 1;
        end
    end

    correct_rate = correct_pre_number/test_face_number;
    X = [X i];
    Y = [Y correct_rate];

    if (i == 160)
        waitfor(plot(X,Y));
    end
end

% 二三维可视化
class_num_to_show = 3;
pic_num_in_a_class = each_pic_num;
pic_to_show = class_num_to_show * pic_num_in_a_class;
for i=[2 3]

    % 取出相应数量特征向量
    project_matrix = eigen_vectors(:,1:i);

    % 投影
    projected_test_data = project_matrix' * (reshaped_faces - all_mean);
    projected_test_data = projected_test_data(:,1:pic_to_show);

    color = [];
    for j=1:pic_to_show
        color = [color floor((j-1)/pic_num_in_a_class)*20];
    end

    % 显示
    if (i == 2)
        subplot(1, 7, [1, 2, 3, 4]);
        scatter(projected_test_data(1, :), projected_test_data(2, :), [], color, 'filled');
        for j=1:3
            subplot(1, 7, j+4);
            fig = show_face(test_data(:,floor((j - 1) * pic_num_in_a_class) + 1), row, col);
        end
        waitfor(fig);
    else
        subplot(1, 7, [1, 2, 3, 4]);
        scatter3(projected_test_data(1, :), projected_test_data(2, :), projected_test_data(3, :), [], color, 'filled');
        for j=1:3
            subplot(1, 7, j+4);
            fig = show_face(test_data(:,floor((j - 1) * pic_num_in_a_class) + 1), row, col);
        end
        waitfor(fig);
    end
end

% 输入向量，显示脸
function fig = show_face(vector, row, column)
    fig = imshow(mat2gray(reshape(vector, [row, column])));
end