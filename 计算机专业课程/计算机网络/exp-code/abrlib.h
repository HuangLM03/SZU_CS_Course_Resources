#pragma once
#include <stdlib.h>
#include <string.h>

// 不同分辨率视频对应的码率(kbps)
#define BITRATE_360P 1000
#define BITRATE_480P 2500
#define BITRATE_720P 5000
#define BITRATE_1080P 8000
#define request_size 35
// 视频质量相关参数
double QoE_count = 0; // 用户体验质量统计 (Quality of experience)
double alpha = 0.001;
double beta = 0.0005;
double gama = 0.01;

//const int request_size = 35;

// 队列的节点
typedef struct QListNode
{
	struct QListNode *_next;
	char _data[request_size];
} QueueNode;

// 队列的结构
typedef struct Queue
{
	QueueNode *_front;
	QueueNode *_rear;
} Queue;

void QueueInit(Queue *q)
{ // 初始化队列结构
	q->_front = NULL;
	q->_rear = NULL;
}

void QueuePush(Queue *q, char *x)
{ // 在队列尾部插入数据
	QueueNode *cur = (QueueNode *)malloc(sizeof(QueueNode));
	strncpy(cur->_data, x, request_size);
	cur->_next = NULL;
	if (q->_front == NULL)
	{ // 若是队列本身为空，队列里就只有这一个节点，又为队列头又为队列尾
		q->_front = q->_rear = cur;
	}
	else
	{
		q->_rear->_next = cur; // 否则，链表尾插操作
		q->_rear = cur;
	}
}

void QueuePop(Queue *q)
{ // 队列头部出数据
	if (q->_front == NULL)
		return;						   // 本身队列为空，不做操作
	QueueNode *tmp = q->_front->_next; // 先保留下一个节点，防止断链
	free(q->_front);
	q->_front = tmp; // 更新对列头部
}

char *QueueFront(Queue *q)
{ // 获取队列首部元素
	return q->_front->_data;
}

int QueueEmpty(Queue *q)
{							  // 判断队列是否为空
	return q->_front == NULL; // 为空，返回1
}

int QueueSize(Queue *q)
{ // 获取队列中的元素个数
	QueueNode *cur;
	int count = 0;
	for (cur = q->_front; cur; cur = cur->_next)
		count++; // 循环遍历，计数即可
	return count;
}

void QueueDestory(Queue *q)
{ // 销毁队列
	if (q->_front == NULL)
		return;
	while (q->_front)
		QueuePop(q); // 对每一个元素迭代出队即可
}

// 获取请求的比特率
int getBitrate(char *req)
{
	// char input[] = "ocean-1080p-8000k0.ts";
	char input[25]; // 假设输入字符串不会超过255字符
	strncpy(input, req, request_size);
	char *token;
	char *delimiter = "-";
	int segment = 0;			// 用于跟踪当前处理的段号
	char thirdSegmentFirst4[5]; // 存储第三段的前4个字符，加上终止符

	// 使用strtok分隔字符串
	token = strtok(input, delimiter);
	while (token != NULL)
	{
		segment++;
		if (segment == 3)
		{
			strncpy(thirdSegmentFirst4, token, 4); // 复制前4个字符
			thirdSegmentFirst4[4] = '\0';		   // 添加字符串终止符
			break;								   // 找到第三段后退出循环
		}
		token = strtok(NULL, delimiter); // 继续分隔字符串
	}

	int number = strtol(thirdSegmentFirst4, NULL, 10); // 将字符串转换为长整型数字
	// printf("转换后的数字是: %ld\n", number);
	return number;
}

// 记录当前下载的QoE
void QoERecord(int current_bitrate, int last_bitrate, int rebuffering_time)
{
	double QoE = alpha * current_bitrate - beta * abs(last_bitrate - current_bitrate) - gama * rebuffering_time;
	QoE_count += QoE;
}

// 打印最终QoE评分
void QoECount()
{
	printf("The QoE count is: %f \n", QoE_count);
}