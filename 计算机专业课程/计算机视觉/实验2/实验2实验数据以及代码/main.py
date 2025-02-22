import sys
import math
import cv2
import numpy as np
from numpy.ma.core import masked


def video_read(file_name):
    return cv2.VideoCapture(file_name)


def video_split(file_name):
    cap = video_read(file_name)
    width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
    size = (width, height)
    fps = cap.get(cv2.CAP_PROP_FPS)

    video_writer = video_write(file_name, fps, size)
    while True:
        ok, frame = cap.read()
        if not ok:
            break
        frame = detect(frame)
        video_writer.write(frame)
    cap.release()
    video_writer.release()


def video_write(file_name, fps, size):
    arr = file_name.split('.')
    file_name = arr[0] + '_after.mp4'
    fourcc = cv2.VideoWriter_fourcc(*'mp4v')
    return cv2.VideoWriter(file_name, fourcc, fps, size)


def grayscale(image):
    return cv2.cvtColor(image, cv2.COLOR_RGB2GRAY)


def gaussian_blur(image, kernel_size):
    return cv2.GaussianBlur(image, (kernel_size, kernel_size), 0)


def canny(image, low, high):
    return cv2.Canny(image, low, high)

def region_of_interest(image, vertices):
    mask = np.zeros_like(image)
    ignore_mask_color = [255,]

    cv2.fillPoly(mask, vertices, ignore_mask_color)
    masked_image = cv2.bitwise_and(image, mask)
    return masked_image


def hough_lines(img, rho, theta, threshold, min_line_len, max_line_gap):
    lines = cv2.HoughLinesP(img, rho, theta, threshold, np.array([]), minLineLength=min_line_len,
                           maxLineGap=max_line_gap)
    return lines


def draw_lines(frame, masked_edges):
    rho = 1
    theta = np.pi / 180
    hof_threshold = 150
    min_line_len = 50
    max_line_gap = 2
    lines = hough_lines(masked_edges, rho, theta, hof_threshold,
                        min_line_len, max_line_gap)

    line_x_set, line_y_set, slope_set = [], [], []
    if lines is not None:
        for line in lines:
            x1, y1, x2, y2 = line[0]
            fit = np.polyfit((x1, x2), (y1, y2), 1)
            k = fit[0]
            if 2 <= k <= 3:
                line_x_set.append(x1)
                line_y_set.append(y1)
                line_x_set.append(x2)
                line_y_set.append(y2)
                slope_set.append(k)

    global x_top, y_top, slope, x_bot, times
    if line_x_set and line_y_set:
        times = 0
        idx = line_y_set.index(min(line_y_set))
        x_top = line_x_set[idx]
        y_top = line_y_set[idx]
        slope = np.median(slope_set)
        x_bot = int(x_top + (frame.shape[0] - y_top) / slope)

    if times <= 12:
        times += 1
        cv2.line(frame, (x_bot, frame.shape[0]), (x_top, y_top),
                 (0, 255, 0), 5)

    return frame


def detect(frame):
    shape = frame.shape
    gray_img = grayscale(frame)
    gray_img = cv2.equalizeHist(gray_img)
    blur_img = gaussian_blur(gray_img, 5)
    test1_img = cv2.blur(blur_img, (5, 5))
    test2_img = cv2.medianBlur(test1_img, 5)
    # cv2.imshow('Gaussian', blur_img)
    # cv2.imshow('Mean', test1_img)
    # cv2.imshow('Median', test2_img)
    # cv2.waitKey(0)
    edge_img = canny(blur_img, 50, 160)
    vertices = np.array([[(shape[1] / 2, shape[0]), (shape[1] / 2, 0),
                          (shape[1], 0), (shape[1], shape[0])]], dtype=np.int32)
    masked_edges = region_of_interest(edge_img, vertices)
    # cv2.imshow('edges', masked_edges)
    # cv2.waitKey(0)
    frame = draw_lines(frame, masked_edges)

    return frame


if __name__ == '__main__':
    video_split('/Users/huanglm/Downloads/计算机视觉/实验2/实验2实验数据/01.avi')
