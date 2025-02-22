#include <winsock2.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <malloc.h>
#include "player.h"

#define DOWNLOAD_PATH "./download/"

#define INT_SIZE sizeof(int)
#define REQUEST_SIZE 35
#define PORT 7788
#define BUFFER_SIZE 1024
#define STOP_BYTE 0xFF
#define VIDEO_LEN 60 // 视频总时长为60s
/************1. 添加abr相关参数的头文件******************************/
#include "abrlib.h"
#include "upgradeABR.h"
/*******************************************************************/
int main() {	
	/************2. 在初始化阶段添加下载队列相关初始代码*******************/
	Queue download_queue;
	QueueInit(&download_queue);
	
	//在下载队列中，初始化下载chunk0和chunk1
	QueuePush(&download_queue,"ocean-1080p-8000k-0.ts");
	//QueuePush(&download_queue,"ocean-1080p-8000k-1.ts");
	
	int video_id=0; //当前下载视频的chunk id
	int current_bitrate=0;  //当前下载的码率 (kbps)
	int last_bitrate=0;  //上一轮下载视频的码率 (kbps)
	/*******************************************************************/
	//初始化播放器库
	StartStreamingServer();
	
    int sock = 0;
    struct sockaddr_in serv_addr;
    char buffer[BUFFER_SIZE] = {0};

    if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0)
    {
        perror("Socket creation error");
        return -1;
    }
    else
        printf("Client Create Socket Success. \n");

    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT);
    serv_addr.sin_addr.S_un.S_addr = inet_addr("172.30.206.78");
    if (connect(sock, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0)
    {
        perror("Connection Failed");
        return -1;
    }
    else
        printf("Client Connect Server Success. \n");

    /*****************************************************************/
    /********** 任务1： 如何向server循环请求连续的视频文件？**********/
    /*****************************************************************/
    //int p = 360, k = 1000;
	//for (int index = 0; index < VIDEO_LEN; index++) {
		/***3. 修改客户端请求逻辑，不断循环将下载队列中的请求出队，并发送请求***/
		while(!QueueEmpty(&download_queue)){
		        
		    //发送下载请求
		    int bytes_sent=0;
		    unsigned char s_stop_byte =0xFF;
		    char* req=QueueFront(&download_queue);
		    current_bitrate=getBitrate(req);    //获取当前下载视频的码率大小
		    printf("send req: %s\n",req);
		    bytes_sent=send(sock, req, REQUEST_SIZE, 0);
		    if (bytes_sent < 0) printf("ERROR in send\n");
		    bytes_sent=send(sock, &s_stop_byte, sizeof(s_stop_byte), 0);
		    if (bytes_sent < 0) printf("ERROR in send\n");
		/*******************************************************************/
	//	    // 视频文件名
	//	    char req[REQUEST_SIZE];
	//	    
	//	    /***************** 任务2：如何按顺序选择视频文件？*****************/\
	//		if (sprintf(req, "ocean-%dp-%dk-%d.ts", p, k, index) < 0) {
	//	    	perror("Error");
	//	    	return -1;
	//		}	    
	//	    /******************************************************************/
	//		
	//	    bytes_sent = send(sock, req, REQUEST_SIZE, 0);
	//	    if (bytes_sent < 0)
	//	        printf("ERROR in send\n");
	//	    bytes_sent = send(sock, &s_stop_byte, sizeof(s_stop_byte), 0);
	//	    if (bytes_sent < 0)
	//	        printf("ERROR in send\n");
	//	    printf("send req: %s\n", req);
		
			/*******4. 对视频下载的耗时进行统计，用于码率自适应决策****************/
			//开始计时
			long start = GetTickCount();
			
			//接收视频片段...
			int file_size, my_file_size;
		    unsigned long file_size_buf;
		    int bytes_recv = 0;
		    bytes_recv = recv(sock, (char *)&file_size_buf, INT_SIZE, 0);
		    file_size = ntohl(file_size_buf);my_file_size = file_size;
		    printf("file_size %d \n", file_size);
		
		    // 接收视频片段
		    char *video_segement = malloc(file_size);
		    if (video_segement == NULL)
		    {
		        perror("malloc failed");
		        // 处理内存分配失败的情况，可能需要退出程序
		        return -1;
		    }
		    int recv_count = 0;
		    while (recv_count < file_size)
		    {
		
		        /************************************************************************/
		        /***************** 任务3 ： 如何使用buffer接收视频文件？*****************/
		        //接受视频文件
		        int tmp_recv_count = recv(sock, buffer, BUFFER_SIZE, 0);
		        if(tmp_recv_count<=0){
		        	printf("Error receiving video file\n");
		        	break;
				}		        
				if (tmp_recv_count + recv_count > file_size) {
					memcpy(video_segement + recv_count, buffer, file_size - recv_count);
					printf("GOTO OUT!!!\n");
					goto out;
				}
				else {
					//拼接视频文件
					memcpy(video_segement + recv_count, buffer, tmp_recv_count);					
				}
				//累计总字节数，用于判断是否接收完成
				recv_count += tmp_recv_count;
		        /************************************************************************/
		    }
		    unsigned char r_stop_byte;
		    if (recv(sock, &r_stop_byte, 1, 0) != 1 || r_stop_byte != STOP_BYTE)
		        printf("ERROR in receiving stop byte 0x%02X \n", r_stop_byte); // 检查文件结束符
		    out:r_stop_byte = 'e';                                                 // 重置
			
			//结束计时        
			long end = GetTickCount();
			long download_time=end-start;   //单位ms
			/*******************************************************************/
			long // 将完整的视频段交付给播放器，并获取卡顿时间 (请勿对rebuffering_time进行修改)
			// 播放器收到交付的视频段会结束缓冲状态
			rebuffering_time = ReceiveSegment(video_segement, req, file_size);
			
			/*****5. 在下载结束后，统计QoE，并为之后的下载进行简单的ABR自适应决策**/
			double buffer_occupancy=GetBufferSize();    //获取播放器缓冲区长度ms
			
			//统计用户体验质量
			QoERecord(current_bitrate,last_bitrate,rebuffering_time);
			last_bitrate=current_bitrate;
			
//			//改进ABR算法v2
//			updateDownQueue(my_file_size, download_time); //单位为kb/s
//			int next_bit_rate = getNextBitRate(buffer_occupancy);
//			int next_id=video_id+1; //间隔一个chunk进行下载
//			if(next_id<=VIDEO_LEN-1){
//			    if(next_bit_rate == 8000){
//			        char temp[REQUEST_SIZE]="ocean-1080p-8000k";
//			        char suffix[6]="";
//			        sprintf(suffix, "-%d.ts", next_id);  
//			        strcat( temp, suffix);
//			        QueuePush(&download_queue,temp);    //将决策结果入队
//			    }else if (next_bit_rate == 5000){
//			        char temp[REQUEST_SIZE]="ocean-720p-5000k";
//			        char suffix[6]="";
//			        sprintf(suffix, "-%d.ts", next_id);  
//			        strcat( temp, suffix);
//			        QueuePush(&download_queue,temp);    //将决策结果入队			    	
//				}else if(next_bit_rate == 2500){
//			        char temp[REQUEST_SIZE]="ocean-480p-2500k";
//			        char suffix[6]="";
//			        sprintf(suffix, "-%d.ts", next_id);  
//			        strcat( temp, suffix);
//			        QueuePush(&download_queue,temp);    //将决策结果入队
//			    }else{
//			        char temp[REQUEST_SIZE]="ocean-360p-1000k";
//			        char suffix[6]="";
//			        sprintf(suffix, "-%d.ts", next_id);  
//			        strcat( temp, suffix);
//			        QueuePush(&download_queue,temp);    //将决策结果入队
//			    }
//			}
	//简单的码率自适应决策
			int next_id=video_id+2; //间隔一个chunk进行下载
			if(next_id<=VIDEO_LEN-1){
			    if(download_time<200){
			        char temp[REQUEST_SIZE]="ocean-1080p-8000k";
			        char suffix[6]="";
			        sprintf(suffix, "-%d.ts", next_id);  
			        strcat( temp, suffix);
			        QueuePush(&download_queue,temp);    //将决策结果入队
			    }else if (download_time<400){
			        char temp[REQUEST_SIZE]="ocean-720p-5000k";
			        char suffix[6]="";
			        sprintf(suffix, "-%d.ts", next_id);  
			        strcat( temp, suffix);
			        QueuePush(&download_queue,temp);    //将决策结果入队			    	
				}else if(download_time<600){
			        char temp[REQUEST_SIZE]="ocean-480p-2500k";
			        char suffix[6]="";
			        sprintf(suffix, "-%d.ts", next_id);  
			        strcat( temp, suffix);
			        QueuePush(&download_queue,temp);    //将决策结果入队
			    }else{
			        char temp[REQUEST_SIZE]="ocean-360p-1000k";
			        char suffix[6]="";
			        sprintf(suffix, "-%d.ts", next_id);  
			        strcat( temp, suffix);
			        QueuePush(&download_queue,temp);    //将决策结果入队
			    }
			}		
//		    // 写入文件
//		    char file_path[40] = DOWNLOAD_PATH;
//		    strcat(file_path, req);
//		    printf("file_path %s \n", file_path);
//		    FILE *fp = fopen(file_path, "wb"); // 以二进制模式打开文件，并返回文件指针
//		    if (fp == NULL)
//		    {
//		        perror("fopen");
//		        exit(EXIT_FAILURE);
//		    }
//		    fwrite(video_segement, 1, file_size, fp);
		    
//			//播放器缓存并在未来播放该分段
//			ReceiveSegment(video_segement, req, file_size);
		    /***数据接收完成阶段***/
	
	//	    // 释放内存
	//	    free(video_segement);
	//	    video_segement = NULL;
					
			//释放内存
			free(video_segement);   
			video_segement=NULL;
			video_id++; //更新下载id
			QueuePop(&download_queue);
			/*******************************************************************/
	}

	QoECount();
    /*************************************************************************************/
    /*********任务2（扩展）：如何在视频流传输完成后，通知server结束视频传输？*************/
    strcpy(buffer, "END");
    if (send(sock, buffer, strlen(buffer), 0) <= 0) {
    	perror("Error in end");
    	return -1;
	}
	shutdown(sock, SD_BOTH);
    /*************************************************************************************/

    /***结束阶段***/
    closesocket(sock);
    WSACleanup();
	//等待播放器播放完视频并释放资源
	WaitEnd();		
	for (int i = 1; i <= rear; i++) {
		//printf("%02d TIMES: %10.2lf %10.2lf\n", i, download_rates[i], predict_rate[i]);
	}
	return 0;
}
 
	                                                       
             