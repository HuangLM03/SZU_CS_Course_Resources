import cv2
import numpy as np
import os
import random

def rotate_image(image_path, angle, save_path):
    image = cv2.imread(image_path)
    (h, w) = image.shape[:2]
    
    center = (w // 2, h // 2)
    M = cv2.getRotationMatrix2D(center, angle, 1.0)
    
    rotated = cv2.warpAffine(image, M, (w, h))
    
    cv2.imwrite(save_path, rotated)

def contort_image(image_path, save_path):
    image = cv2.imread(image_path)
    (h, w) = image.shape[:2]
    
    src_pts = np.float32([[10, 10], [200, 50], [500, 500]])
    dst_pts = np.float32([[110, 10], [200, 50], [400, 500]])
    
    M = cv2.getAffineTransform(src_pts, dst_pts)
    warped = cv2.warpAffine(image, M, (w, h))
    
    cv2.imwrite(save_path, warped)

# 图片路径和保存路径
image_dir = 'E:\\dataset\\randc_dataset\\fold1\\train\\images'
save_dir = 'E:\\dataset\\randc_dataset\\train\\'

for filename in os.listdir(image_dir):
    if filename.endswith(".jpg"):
        # print("Doing …{}".format(filename))
        image_path = os.path.join(image_dir, filename)
        op = random.randint(0, 3)
        save_path = os.path.join(save_dir, f"{filename}")
        if op == 0:            
            # 旋转图片
            rotate_image(image_path, random.randint(-180, 180), save_path)
        elif op == 1:
            save_path_twist = os.path.join(save_dir, f"{filename}")
            # 扭曲图片
            contort_image(image_path, save_path)
        else:
            image = cv2.imread(image_path)
            cv2.imwrite(save_path, image)

image_dir = 'E:\\dataset\\randc_dataset\\fold1\\test\\images'
save_dir = 'E:\\dataset\\randc_dataset\\test\\'

for filename in os.listdir(image_dir):
    if filename.endswith(".jpg"):
        # print("Doing … {}".format(filename))
        image_path = os.path.join(image_dir, filename)
        op = random.randint(0, 3)
        save_path = os.path.join(save_dir, f"{filename}")
        if op == 0:            
            # 旋转图片
            rotate_image(image_path, random.randint(-180, 180), save_path)
        elif op == 1:
            print("Doing … {}".format(filename))
            save_path_twist = os.path.join(save_dir, f"{filename}")
            # 扭曲图片
            contort_image(image_path, save_path)
        else:
            image = cv2.imread(image_path)
            cv2.imwrite(save_path, image)