clear all;

% 预处理
% 1.读取图片数据并将每一张图片拉成一个一维向量
load train_images.mat;
load train_labels.mat;
data = reshape(train_images, 28 * 28, 60000);
% 2.设置聚类的类别数量K
K = 10;
% 3.设置读取的样本数量，用作训练数据sampleNum
sampleNum = 10000;
trainData = data(:, 1:sampleNum);

y1 = zeros(1, 50);
y2 = zeros(1, 50);
tic
for l = 1 : 50
% K-means
eps = 1e-6;
stopTimes = 100;
% 1.随机选取K个向量作为初始的聚类中心，聚类中心使用矩阵center（n，K）存储
[n, m] = size(trainData);
% figure();
center = zeros(n, K);
center(:, 1) = trainData(:, randperm(sampleNum, 1));
for i = 2 : K
    distance = 0;
    index = 0;
    % 要找的样本是距离所有聚类中心最远，因此该问题可以看成最小值最大问题，
    for j = 1 : sampleNum
        tmpDist = 1e9;
        for k = 1 : i
            tmp = norm(center(:, k) - trainData(:, j));
            % 距离所有聚类中心最小
            if tmp < tmpDist
                tmpDist = tmp;
            end
        end
        % 最大的最小值
        if tmpDist > distance
            distance = tmpDist;
            index = j;
        end
    end
    center(:, i) = trainData(:, index);    
    % subplot(1, 10, i);
    % imshow(reshape(trainData(:, index), 28, 28),[ ]); 
end

times = 0;
newCluster = zeros(1, m);
dist = zeros(1, K);
while true
    stop = 1;
    % 2.初始化零矩阵。
    %   dist（1，K）：记录当前向量距离每个聚类中心的距离
    %   newCenter（n，K）：记录新的聚类中心
    %   newCluster（1，m）：记录每个样本属于哪个聚类中心
    
    newCenter = zeros(n, K);
    
    % 3.循环所有样本：计算当前样本到每个聚类中心的距离，找到最近的聚类中心，打上标签。
    for i = 1 : m
        for j  = 1 : K
            dist(j) = norm(trainData(:, i) - center(:, j));
        end
        [minVal, index] = min(dist);
        newCluster(i) = index;
    end
    % 4.计算新的聚类中心的坐标。
    for i = 1 : K
        num = 0;
        for j = 1 : m
            if newCluster(j) == i
                num = num + 1;
                newCenter(:, i) = newCenter(:, i) + trainData(:, j);
            end
        end
        newCenter(:, i) = newCenter(:, i) / num;
        if norm(newCenter(:, i) - center(:, i)) > eps
            stop = 0;
        end
    end
    % 5.判断新的聚类中心的坐标与原聚类中心的坐标的变化数值是否小于阈值以及
    % 判断迭代次数是否超过预设值来决定是否继续进行迭代。
    if stop || times > stopTimes
        break;
    else
        center = newCenter;
    end
    times = times + 1;
end
% display(times);
% 统计正确率：每一类出现最多的标签作为该类的预测标签，计算正确率
rightRate = 0;
for i = 1 : K
    labels = zeros(1, sampleNum);
    num = 0;
    for j = 1 : sampleNum
        if newCluster(j) == i
            num = num + 1;
            labels(num) = train_labels(j);
        end
    end
    [val, appearNum] = mode(labels(1:num), 2);
    rightRate = rightRate + appearNum;
end
rightRate = rightRate / sampleNum;
% display(rightRate);
y1(1, l) = rightRate;
y2(1, l) = times;
end
display("迭代次数均值："+mean(y2(1:50)));
display("正确率均值："+mean(y1(1:50)));
display("运行时间："+num2str(toc/50));