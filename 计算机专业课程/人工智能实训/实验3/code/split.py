import os
import shutil
from sklearn.model_selection import KFold

# 设置数据集的路径
dataset_path = 'E:/dataset/randc_dataset/train'
# images_path = os.path.join(dataset_path, 'images')
# labels_path = os.path.join(dataset_path, 'txt')
images_path = dataset_path
labels_path = dataset_path

# 获取所有图像和标签文件的列表
image_files = [f for f in os.listdir(images_path) if f.endswith('.jpg')]
label_files = [f.replace('.jpg', '.txt') for f in image_files]

# 确保图像和标签文件列表是配对的
assert len(image_files) == len(label_files), "Image and label files count do not match"

# 设置交叉验证的折数
n_splits = 4
kf = KFold(n_splits=n_splits, shuffle=True, random_state=42)

# 创建交叉验证的目录结构
for fold, (train_index, test_index) in enumerate(kf.split(image_files), 1):
    train_images_dir = os.path.join(dataset_path, f'fold{fold}/train/')
    train_labels_dir = os.path.join(dataset_path, f'fold{fold}/train/')
    test_images_dir = os.path.join(dataset_path, f'fold{fold}/val/')
    test_labels_dir = os.path.join(dataset_path, f'fold{fold}/val/')

    # 创建目录
    os.makedirs(train_images_dir, exist_ok=True)
    os.makedirs(train_labels_dir, exist_ok=True)
    os.makedirs(test_images_dir, exist_ok=True)
    os.makedirs(test_labels_dir, exist_ok=True)

    # 获取训练和验证的图像和标签文件列表
    train_images = [image_files[i] for i in train_index]
    train_labels = [label_files[i] for i in train_index]
    test_images = [image_files[i] for i in test_index]
    test_labels = [label_files[i] for i in test_index]

    # 复制文件到新的目录
    for img in train_images:
        shutil.copy(os.path.join(images_path, img), os.path.join(train_images_dir, img))
        shutil.copy(os.path.join(labels_path, img.replace('.jpg', '.txt')), os.path.join(train_labels_dir, img.replace('.jpg', '.txt')))
    
    for img in test_images:
        shutil.copy(os.path.join(images_path, img), os.path.join(test_images_dir, img))
        shutil.copy(os.path.join(labels_path, img.replace('.jpg', '.txt')), os.path.join(test_labels_dir, img.replace('.jpg', '.txt')))

    print(f'Fold {fold} created with {len(train_images)} training and {len(test_images)} validation images.')