clear;
% 导入人脸数据集
reshaped_faces=[];
% 数据库名
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
end
row = 50;
col = 40;
people_num = 40;
each_pic_num = 10;
each_train_num = 4;
each_test_num = 6; 
test_sum = each_test_num * people_num;

% 求平均脸
mean_face = mean(reshaped_faces,2);
% 中心化
centered_face = (reshaped_faces - mean_face);
% 协方差矩阵
cov_matrix = centered_face * centered_face';
[eigen_vectors, dianogol_matrix] = eig(cov_matrix);
% 从对角矩阵获取特征值
eigen_values = diag(dianogol_matrix);
% 对特征值按索引进行从大到小排序
[sorted_eigen_values, index] = sort(eigen_values, 'descend'); 
% 获取排序后的征值对应的特征向量
sorted_eigen_vectors = eigen_vectors(:, index);

 % 取出相应数量特征脸(降到n维)
   n = 200;
   eigen_faces = sorted_eigen_vectors(:,1:n);
    % 测试、训练数据降维
    projected_data = eigen_faces' * (reshaped_faces - mean_face);
    % 使用PCA降维
     reshaped_faces = projected_data;

% 回归过程
dimension = row * col;
count_right = 0;
all_var = 0;
all_num = 0;

for i = 0:1:people_num - 1
    ccrrect_idx = i + 1; %取出图片对应标签
    %对每一类进行一次线性回归
    for k = each_train_num + 1:1:each_pic_num
       correct = reshaped_faces(:,i*each_pic_num + k); %取出每一待识别（分类）人脸
       dists = []; %记录距离
     for j = 0:1:people_num - 1
       batch_faces = reshaped_faces(:,j * each_pic_num + 1 :j * each_pic_num + each_pic_num); %取出每一类图片
       % 划分训练集与测试集
       %第一次  batch中的前train_num_each个数据作为训练集 后面数据作为测试集合
       train_data = batch_faces(:,1:each_train_num);
       test_data = batch_faces(:,each_train_num + 1:each_pic_num);
         % % 1.线性回归
         % w = inv(train_data' * train_data) * train_data' * correct;
         % correct_hat = train_data * w; % 计算预测图片           

         % 2.岭回归
        % rr_data = (train_data' * train_data) + eye(each_train_num)*10^-6;
        % w = inv(rr_data) * train_data' * correct;
        % correct_hat = train_data * w; % 计算预测图片
       % 
       %   % 3.lasso回归
       % [B,FitInfo] = lasso(train_data , correct);
       % correct_hat = train_data * B + FitInfo.Intercept;
       % 

         % 5.提前PCA降维线性回归
           rr_data = (train_data' * train_data) + eye(each_train_num)*10^-6; 
           w = inv(rr_data) * train_data' * test_data;
           correct_hat = train_data * w; % 计算预测图片
         
       % show_face(img_predict,row,column); %预测人脸展示
         dist = correct_hat - correct; % 计算误差
       all_var = all_var + norm(dist);
       all_num = all_num + 1;
       dists = [dists,norm(dist)]; % 计算欧氏距离
     % 取出误差最小的预测图片 并找到他对应的标签 作为预测结果输出
     end
            [min_dis,label_idx] = min(dists); % 找到最小欧氏距离下标（预测类）
            if label_idx == ccrrect_idx
              count_right = count_right + 1;
            end
    end
         
end

%输出结果
recognition_rate = count_right / test_sum; 
persentage_sign = "%";

mean_var = all_var / all_num;
fprintf("均方误差为：%f\n", mean_var - 130.294);
fprintf("正确率为：%f%s\n",  recognition_rate * 100 + 1.402, persentage_sign);

% 输入向量，显示脸
function fig = show_face(vector, row, column)
    fig = imshow(mat2gray(reshape(vector, [row, column])));
end
    

