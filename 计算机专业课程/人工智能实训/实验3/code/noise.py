import os
import cv2
import numpy as np
import random

def gaussian_noise(img, mean, sigma):
    img = img / 255 # 将图片灰度标准化
    noise = np.random.normal(mean, sigma, img.shape) # 产生高斯噪声 
    gaussian_out = img + noise # 将噪声和图片叠加
    gaussian_out = np.clip(gaussian_out, 0, 1) # 将超过 1 的置 1，低于 0 的置 0 
    gaussian_out = np.uint8(gaussian_out*255) # 将图片灰度范围的恢复为 0-255
    return gaussian_out


def sp_noise(noise_img, proportion):
    height, width = noise_img.shape[0], noise_img.shape[1] # 获取高度宽度像素值
    num = int(height * width * proportion) # 一个准备加入多少噪声小点
    for i in range(num):
        w = random.randint(0, width - 1)
        h = random.randint(0, height - 1)
        if random.randint(0, 1) == 0:
            noise_img[h, w] = 0
        else:
            noise_img[h, w] = 255
    return noise_img


def flip(flip_img):
    op = random.randint(0, 4)
    if op == 0:
        flip_img = cv2.flip(flip_img, 0) # 垂直翻转
    elif op == 1:
        flip_img = cv2.flip(flip_img, -1) # 水平翻转
    return flip_img


def convert(input_dir, output_dir):
    for filename in os.listdir(input_dir):
        path = input_dir + "/" + filename # 获取文件路径
        print("doing... ", path)
        noise_img = cv2.imread(path) # 读取图片
        op = random.randint(0, 4)
        if op == 0:
            img_noise = gaussian_noise(noise_img, 0, 0.24) # 高斯噪声
        elif op == 1:
            img_noise = sp_noise(noise_img,0.1) # 椒盐噪声
        else:
            img_noise = noise_img
        f_and_n_img = flip(img_noise)
        cv2.imwrite(output_dir + '/' + filename, f_and_n_img)

    
if __name__ == '__main__':
    input_dir = "E:/dataset/split_dataset/fold1/train/images" # 输入数据文件夹
    output_dir = "E:/dataset/split_dataset/train" # 输出数据文件夹
    convert(input_dir, output_dir)
    
    input_dir = "E:/dataset/split_dataset/fold1/test/images"    # 输入数据文件夹
    output_dir = "E:/dataset/split_dataset/test" # 输出数据文件夹
    convert(input_dir, output_dir)
    
