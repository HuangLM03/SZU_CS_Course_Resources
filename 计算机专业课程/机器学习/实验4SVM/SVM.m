clear;
% 1.人脸数据集的导入与数据处理框架
reshaped_faces=[];
% 声明数据库名
database_name = "AR";

% ORL5646
if (database_name == "ORL")
    for i=1:40
        for j=1:10
            if(i<10)
                face=imread(strcat('C:\Users\hp\Desktop\face\ORL56_46\orl',num2str(i),'_',num2str(j),'.bmp'));
            else
                face=imread(strcat('C:\Users\hp\Desktop\face\ORL56_46\orl',num2str(i),'_',num2str(j),'.bmp'));
            end
            reshaped_face = reshape(face,2576,1);
            reshaped_face=double(reshaped_face);
            reshaped_faces=[reshaped_faces, reshaped_face];
        end
    end
    row = 56;
    column = 46;
    people_num = 40;
    each_pic_num = 10;
    each_train_pic_num = 7; % 每张人脸训练数量
    each_test_pic_num = 3;  % 每张人脸测试数量
end

%AR5040
if (database_name == "AR")
    for i=1:40
        for j=1:10
            if(i<10)
                face=imread(strcat('C:\Users\黄亮铭\Desktop\大学课程\机器学习\实验1PCA\AR_Gray_50by40\AR_Gray_50by40\AR00',num2str(i),'-',num2str(j),'.tif'));
            else
                face=imread(strcat('C:\Users\黄亮铭\Desktop\大学课程\机器学习\实验1PCA\AR_Gray_50by40\AR_Gray_50by40\AR0',num2str(i),'-',num2str(j),'.tif'));
            end
            reshaped_face = reshape(face,2000,1);
            reshaped_face=double(reshaped_face);
            reshaped_faces=[reshaped_faces, reshaped_face];
        end
    end
    row = 50;
    column = 40;
    people_num = 40;
    each_pic_num = 10;
    each_train_pic_num = 7;
    each_test_pic_num = 3;
end

%FERET_80
if (database_name == "FERET")
    for i=1:80
        for j=1:7
            face=imread(strcat('C:\Users\hp\Desktop\face\FERET_80\ff',num2str(i),'_',num2str(j),'.tif'));
            reshaped_face = reshape(face,6400,1);
            reshaped_face=double(reshaped_face);
            reshaped_faces=[reshaped_faces, reshaped_face];
        end
    end
    row = 80;
    column = 80;
    people_num = 80;
    each_pic_num = 7;
    each_train_pic_num = 5;
    each_test_pic_num = 2;
end

% 取出前30%作为测试数据，剩下70%作为训练数据
test_data_index = [];
train_data_index = [];
for i=0:people_num-1
    test_data_index = [test_data_index each_pic_num*i+1:each_pic_num*i+each_test_pic_num];
    train_data_index = [train_data_index each_pic_num*i+each_test_pic_num+1:each_pic_num*(i+1)];
end

train_data = reshaped_faces(:,train_data_index);
test_data = reshaped_faces(:, test_data_index);
dimension = row * column; %一张人脸的维度

% LDA
% 算每个类的平均
k = 1;
class_mean = zeros(dimension, people_num);
for i=1:people_num
    % 求一列（即一个人）的均值
    temp = class_mean(:,i);
    % 遍历每个人的train_pic_num_of_each张用于训练的脸，相加算平均
    for j=1:each_train_pic_num
        temp = temp + train_data(:,k);
        k = k + 1;
    end
    class_mean(:,i) = temp / each_train_pic_num;
end

% 类间散度矩阵Sb
Sb = zeros(dimension, dimension);
all_mean = mean(train_data, 2); % 全部的平均
for i=1:people_num
    % 中心化
    center_data = class_mean(:,i) - all_mean;
    Sb = Sb + center_data * center_data';
end
Sb = Sb / people_num;
% 类内散度矩阵Sw
Sw = zeros(dimension, dimension);
k = 1;
for i=1:people_num
    for j=1:each_train_pic_num
        center_data = train_data(:,k) - class_mean(:,i);
        Sw = Sw + center_data * center_data';
        k = k + 1;
    end
end
Sw = Sw / (people_num * each_train_pic_num);
target = pinv(Sw) * Sb;

% PCA
all_mean = mean(train_data, 2); % 全部的平均
centered_face = (train_data - all_mean);
cov_matrix = centered_face * centered_face';
target = cov_matrix;

% 求特征值、特征向量
[eigen_vectors, dianogol_matrix] = eig(target);
eigen_values = diag(dianogol_matrix);

% 对特征值、特征向量进行排序
[sorted_eigen_values, index] = sort(eigen_values, 'descend');
eigen_vectors = eigen_vectors(:, index);
eigen_vectors = real(eigen_vectors);
rate = []; %用于记录人脸识别率

%使用SVM人脸识别
for i=10:10:160
    right_num = 0;
    % 降维得到投影矩阵
    project_matrix = eigen_vectors(:,1:i);
    projected_train_data = project_matrix' * (train_data - all_mean);
    projected_test_data = project_matrix' * (test_data - all_mean);
    % SVM训练过程
    model_num = 1;
    for j = 0:1:people_num - 2
        % 取出每次SVM需要的训练集
        train_img1 = projected_train_data(:,j * each_train_pic_num + 1 : j * each_train_pic_num + each_train_pic_num);
        train_label1 = ones(1,each_train_pic_num)*(j + 1); 
        % 取出每次SVM需要的测试集
        test_img1 = projected_test_data(:,j * each_test_pic_num + 1 : j * each_test_pic_num + each_test_pic_num); 
        for z = j + 1:1:people_num - 1
            % 取出每次SVM需要的训练集
            train_img2 = projected_train_data(:,z * each_train_pic_num + 1 : z * each_train_pic_num + each_train_pic_num); 
            train_label2 = ones(1,each_train_pic_num)*(z + 1);
            train_imgs = [train_img1,train_img2];
            train_label = [train_label1,train_label2];
            % 取出每次SVM需要的测试集
            test_img2 = projected_test_data(:,z * each_test_pic_num + 1 : z * each_test_pic_num + each_test_pic_num); 
            test_imgs = [test_img1,test_img2];
            % 数据预处理（归一化）
            [mtrain,ntrain] = size(train_imgs);
            [mtest,ntest] = size(test_imgs);
            test_dataset = [train_imgs,test_imgs];
            [dataset_scale,ps] = mapminmax(test_dataset,0,1);
            train_imgs = dataset_scale(:,1:ntrain);
            test_imgs = dataset_scale( :,(ntrain+1):(ntrain+ntest) );
            % SVM训练
            train_imgs = train_imgs';
            train_label = train_label';
            % fitcsvm默认读取数据为按行，一张一脸为一列，需要转置
            expr = ['model_' num2str(model_num) ' = fitcsvm(train_imgs,train_label);']; 
            eval(expr);
            model_num = model_num + 1;
        end
    end
    model_num = model_num - 1;

    % 人脸识别
    for k = 1:1:each_test_pic_num * people_num
        test_img = projected_test_data(:,k); % 取出待识别图像
        test_real_label = fix((k - 1) / each_test_pic_num) + 1; % 给定待测试真实标签
        predict_labels = zeros(1,people_num); %用于OVO投票
        % SVM预测
        for t = 1:1:model_num
            predict_label = predict(eval(['model_' num2str(t)]),test_img');
            predict_labels(1,predict_label) = predict_labels(1,predict_label) + 1;
        end
        [max_value,index] = max(predict_labels);
        if(index == test_real_label)
            right_num = right_num + 1;
        end
    end
    recognition_rate = right_num / (each_test_pic_num * people_num);
    rate = [rate,recognition_rate];
end

%            % SVM(OVR)
% for i = 10:10:160
%         right_num = 0;
%     % 降维得到投影矩阵
%     project_matrix = eigen_vectors(:,1:i);
%     projected_train_data = project_matrix' * (train_data - all_mean);
%     projected_test_data = project_matrix' * (test_data - all_mean);
%          model_num = 1;
%              % SVM训练过程（每次训练都要使用整个数据集）
%          for j = 0:1:people_num - 1
%
%          train_imgs = circshift(projected_train_data,-j * train_pic_num_of_each ,2); %使训练集始终在前几行
%          train_label1 = ones(1,train_pic_num_of_each) * (j + 1);
%          train_label2 = zeros(1,train_pic_num_of_each * (people_num - 1));
%          train_label = [train_label1,train_label2];
%
%          test_imgs = circshift(projected_test_data,-j * test_pic_num_of_each ,2); %使测试集始终在前几行
%
%         % 数据预处理,将训练集和测试集归一化到[0,1]区间
%         [mtrain,ntrain] = size(train_imgs); %m为行数，n为列数
%         [mtest,ntest] = size(test_imgs);
%
%         test_dataset = [train_imgs,test_imgs];
%         % mapminmax为MATLAB自带的归一化函数
%         [dataset_scale,ps] = mapminmax(test_dataset,0,1);
%
%         train_imgs = dataset_scale(:,1:ntrain);
%         test_imgs = dataset_scale( :,(ntrain+1):(ntrain+ntest) );
%
%         % SVM网络训练
%         train_imgs = train_imgs';
%         train_label = train_label';
%         expr = ['model_' num2str(model_num) ' = fitcsvm(train_imgs,train_label);']; % fitcsvm默认读取数据为按行，一张一脸为一列，需要转置
%         eval(expr);
%         model_num = model_num + 1;
%          end
%         model_num = model_num - 1;
%          % 人脸识别
%        for k = 1:1:test_pic_num_of_each * people_num
%         test_img = projected_test_data(:,k); % 取出待识别图像
%         test_real_label = fix((k - 1) / test_pic_num_of_each) + 1; % 给定待测试真实标签
%         predict_labels = zeros(1,people_num); %用于OVR预测
%
%        % SVM网络预测
%        for t = 1:1:model_num
%        [predict_label,possibility] = predict(eval(['model_' num2str(t)]),test_img');
%        if predict_label ~= 0
%        predict_labels(1,predict_label) = predict_labels(1,predict_label) + possibility(1,1);
%        end
%        end
%          [min_value,index] = min(predict_labels); % 若一张图片被预测为多类，选择离超平面最远的作为最终预测类
%        if(index == test_real_label)
%            right_num = right_num + 1;
%        end
%        end
%        recognition_rate = right_num / (test_pic_num_of_each * people_num);
%        rate = [rate,recognition_rate];
%
% end


% 划分训练集和测试集
% 训练集
train_set = [dataset(1:5,:);dataset(11:15,:)];
train_set_labels = [lableset(1:5);lableset(11:15)];
% 测试集
test_set = [dataset(6:10,:);dataset(16:20,:)];
test_set_labels = [lableset(6:10);lableset(16:20)];
 
% 数据预处理（归一化）
[mtrain,ntrain] = size(train_set);
[mtest,ntest] = size(test_set);
test_dataset = [train_set;test_set];
[dataset_scale,ps] = mapminmax(test_dataset',0,1);
dataset_scale = dataset_scale';
train_set = dataset_scale(1:mtrain,:);
test_set = dataset_scale( (mtrain+1):(mtrain+mtest),: );

% SVM训练
model = fitcsvm(train_set,train_set_labels);

% SVM预测
[predict_label] = predict(model,test_set);

