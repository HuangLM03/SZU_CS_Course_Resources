#include "fluctuation.h"

#include <winsock2.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define INT_SIZE sizeof(unsigned long)
#define REQUEST_SIZE 35
#define PORT 7788
#define BUFFER_SIZE 1024
#define STOP_BYTE 0xFF
#define VIDEO_PATH "./video/"
#define END_REQUEST "END_REQUEST"
#define VIDEO_LEN 60 // 视频总时长为60s

// 定义一个获取文件大小的函数，参数是一个文件指针
long get_file_size(FILE *fp)
{
    long file_size = -1;
    fpos_t cur_pos;
    fgetpos(fp, &cur_pos);
    fseek(fp, 0, SEEK_END);
    file_size = ftell(fp);
    fsetpos(fp, &cur_pos);
    return file_size;
}

int main()
{
    /***初始化阶段***/ 
    WSADATA wsaData;
    WSAStartup(MAKEWORD(2, 2), &wsaData);
	load_fl(); 

    int server_fd, new_socket;
    struct sockaddr_in server_address;
    int opt = 1;
    int addrlen = sizeof(server_address);
    char buffer[BUFFER_SIZE] = {0};

    // 创建套接字
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0)
    {
        perror("socket failed");
        exit(EXIT_FAILURE);
    }
    else
        printf("Create Server Socket Success.\n");

    // 设置套接字选项
    server_address.sin_family = AF_INET;
    server_address.sin_addr.s_addr = INADDR_ANY;
    server_address.sin_port = htons(PORT);

    // 绑定套接字
    if (bind(server_fd, (struct sockaddr *)&server_address, sizeof(server_address)) < 0)
    {
        perror("bind failed");
        exit(EXIT_FAILURE);
    }
    else
        printf("Server Bind Port Success. \n");

    // 监听套接字
    if (listen(server_fd, 3) < 0)
    {
        perror("listen");
        exit(EXIT_FAILURE);
    }
    else
        printf("Server Listening......\n");

    if ((new_socket = accept(server_fd, (struct sockaddr *)&server_address, &addrlen)) < 0)
    {
        perror("accept");
        exit(EXIT_FAILURE);
    }
    else
        printf("Server Accept Success. \n");

    while (1)
    {
        // 接收客户端下载请求
        int bytes_recv = 0;
        char req[REQUEST_SIZE] = "";
        bytes_recv = recv(new_socket, req, REQUEST_SIZE, 0);
        if (bytes_recv <= 0)
            printf("ERROR in recv\n");
        printf("req: %s\n", req);
        unsigned char r_stop_byte;
        if (recv(new_socket, &r_stop_byte, 1, 0) != 1 || r_stop_byte != STOP_BYTE)
            printf("ERROR in receiving stop byte 0x%02X", r_stop_byte);
        r_stop_byte = 'e'; // 重置

        /****************************************************************************/
        /********** 任务2（扩展）：如何根据client信号，终止传输并退出循环？**********/
//        if (!strcmp(req, "END")) {
//        	shutdown(new_socket, SD_BOTH);
//        	break;
//		}
        /****************************************************************************/
        // 找到文件
        char *file_name = req;
        char file_path[35] = VIDEO_PATH;
        strcat(file_path, file_name);
        FILE *fp = fopen(file_path, "rb"); // 以二进制模式打开文件，并返回文件指针
        if (fp == NULL)
        {
            perror("File open failed");
            exit(EXIT_FAILURE);
        }

        unsigned long file_size = (unsigned long)get_file_size(fp);
        printf("%s %d \n", file_path, file_size);

        // 发送文件的大小到客户端
        unsigned long file_size_buf = htonl(file_size);
        int bytes_sent = 0;
        int reqLen = sizeof(req);
        bytes_sent = send_fl(new_socket, (char *)&file_size_buf, INT_SIZE, 0);
        if (bytes_sent < 0)
            printf("ERROR in send\n");
        // 发送视频片段
        int send_count = 0;
        while (send_count < file_size)
        {

            /***************************************************************************************************/
            /**************************  任务1： 发送指定视频文件（按照固定大小buffer方式） ********************/
            //读取视频文件
            unsigned int buf_len = fread(buffer, 1, BUFFER_SIZE, fp);
            if (buf_len <= 0) {
            	perror("ERROR");
            	break;
			}
			//发送视频文件
            int tmp_send_count = send_fl(new_socket, buffer, buf_len, 0);
            if (tmp_send_count < 0) {
            	perror("Error in sending video\n");
            	exit(EXIT_FAILURE);
			}
			//累计总字节数，用于判断是否发送完成
			send_count += tmp_send_count;

            /***************************************************************************************************/
        }
		//sleep(1);
		
        // 发送文件结束符
        unsigned char s_stop_byte = 0xFF;
        bytes_sent = send_fl(new_socket, &s_stop_byte, sizeof(s_stop_byte), 0);
        if (bytes_sent < 0)
            printf("ERROR in send\n");

        // 关闭文件
        fclose(fp);
        printf("close file \n");
    }
    /***结束阶段***/
    closesocket(server_fd);
    closesocket(new_socket);
    WSACleanup();
    release_fl();
    int a;
	scanf("%d", &a);
    return 0;
}