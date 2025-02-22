/************1. 添加abr相关参数的头文件******************************/
#include "abrlib.h"
/*******************************************************************/


/************2. 在初始化阶段添加下载队列相关初始代码*******************/
Queue download_queue;
QueueInit(&download_queue);

//在下载队列中，初始化下载chunk0和chunk1
QueuePush(&download_queue,"ocean-1080p-8000k-0.ts");
QueuePush(&download_queue,"ocean-1080p-8000k-1.ts");

int video_id=0; //当前下载视频的chunk id
int current_bitrate=0;  //当前下载的码率 (kbps)
int last_bitrate=0;  //上一轮下载视频的码率 (kbps)
/*******************************************************************/



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


/*******4. 对视频下载的耗时进行统计，用于码率自适应决策****************/
//开始计时
long start = GetTickCount();

//接收视频片段...

//结束计时        
long end = GetTickCount();
long download_time=end-start;   //单位ms
/*******************************************************************/


/*****5. 在下载结束后，统计QoE，并为之后的下载进行简单的ABR自适应决策**/
double rebuffering_time=GetRebufferingTime();   //获取播放器卡顿时间ms
double buffer_occupancy=GetBufferSize();    //获取播放器缓冲区长度ms

//统计用户体验质量
QoERecord(current_bitrate,last_bitrate,rebuffering_time);
last_bitrate=current_bitrate;

//简单的码率自适应决策
int next_id=video_id+2; //间隔一个chunk进行下载
if(next_id<=VIDEO_LEN-1){
    if(download_time<200){
        char temp[REQUEST_SIZE]="ocean-1080p-8000k";
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

//释放内存
free(video_segement);   
video_segement=NULL;
video_id++; //更新下载id
/*******************************************************************/
