/*
对变量的解释：R[]为码率，download_rates[]为历史下载速率(font和rear是其头尾指针)，w[]为权重，cur_grade为当前码率等级（对应R的下标），
				其余变量是为了测试而定义的变量
对函数的解释：init的作用是初始化w，updateDownQueue的作用是更新队列download_rates，；getNextDownloadRate的作用是预测下一时刻的下载速率，
				getNowGrade和getSwitchGrade的作用分别是获取当前码率等级和目标切换码率等级，getSwitchingTime的作用则是计算切换码率所需时间，
				getQmin、getQmax和getQup的作用是获取相应的缓冲阈值，
				getNextBitRate的作用是获取下一时刻的视频分片的码率等级。
*/
#include <math.h>
#define MAX_LEN 4
#define N 100000
#define W 0.4
#define Qmin 2000
#define Bmax 10000
//const int MAX_LEN  = 4, N = 1e5 + 10;
//const double W = 0.6;
const int R[] = { 1000, 2500, 5000, 8000 };
double download_rates[N];
double w[MAX_LEN];
int font = 0, rear = 0;
//const double Qmin = 200;
int cur_grade = 3;
int st = 1;
double predict_rate[N];
int p_idx;
void init(int len)
{
	double beta = 1, alpha = W;
	for (int i = 0; i < len; i++) {
		beta *= (1 - W);
	}
	beta = 1 - beta;
	for (int i = 0; i < len; i++) {
		alpha *= (1 - W);
		w[i] = alpha / beta;
	}
}

void updateDownQueue(int file_size, long download_time)
{
	double alpha = 1;
	if (download_time <= 0) {
		download_time = 1;
		alpha = 0.85;
	}
	double download_rate = (double)file_size / download_time / alpha;
	download_rates[++rear] = download_rate;
	if (rear - font > 4) font++;
}

double getNextDownloadRate()
{
	double next_download_rate_hat = 0;
	long double sum = 0;
	int cnt = 0;
	for (int i = rear - 1; i > font && i > rear - 5; i--) {
		sum += download_rates[i];
		cnt += 1;
	}	

	double mean_download_rate = 0;
	if (cnt == 0) {
		mean_download_rate = 8000;
	}
	else {
		mean_download_rate = sum / cnt;
	}
 	double down_download_rate = mean_download_rate * 0.4;

	if (download_rates[rear] >= mean_download_rate) {
		next_download_rate_hat = (mean_download_rate * cnt + download_rates[rear]) / (cnt + 1) + 0.5;
	}
	else if (download_rates[rear] >= down_download_rate){
		double tmp_download_rate = 0;
		if (st && rear - font <= MAX_LEN) {
			init(rear - font);
			if (rear - font == MAX_LEN)
				st = 0;
		}
		for (int i = 0, j = rear; i < MAX_LEN && j > font; i++, j--) {
			tmp_download_rate += w[i] * download_rates[j];
		}
		next_download_rate_hat = tmp_download_rate + 0.5;
	}
	else {
		next_download_rate_hat = down_download_rate;
	}

	return next_download_rate_hat;
}

int getSwitchGrade()
{
	double max_rate = getNextDownloadRate();
	int tar_grade = 0;
	for (int i = 0; i < 4; i++) {
		if (max_rate > R[i]) {
			tar_grade = i - 1;
		}
	}
	
	return tar_grade;
}
int getNowGrade()
{
	return cur_grade;
}

double getSwitchingTime(double now_bit_rate_idx)
{
	double t = 1 / getNextDownloadRate();
	int tmp = 0;
	for (int i = max(getSwitchGrade(), now_bit_rate_idx); i >= min(getSwitchGrade(), now_bit_rate_idx); i--) {
		tmp += R[i];
	}
	return t * tmp;
}

double getQMin()
{
	return Qmin;
}
double getQDown()
{
	double alpha = R[getNowGrade()] / R[0];
	return Qmin + (1 + alpha) * getSwitchingTime(getNowGrade());
}
double getQUp(int now_bit_rate_idx)
{
	return Bmax * 0.85 * (now_bit_rate_idx + 1) / 4 ;
}

int getNextBitRate(double buffer_time)
{
	int now_grade = getNowGrade();
	int result_grade = now_grade + 1 > 3 ? 3 : now_grade + 1;
	double next_download_rate = getNextDownloadRate();
	//printf("PREDICT RATE: %lf  BUFFER_TIME: %lf\n", next_download_rate, buffer_time);
	//printf("BUFFER_TIME: %lf\n", buffer_time);
	//predict_rate[p_idx++] = next_download_rate;
	if (buffer_time < getQMin()) {
		
		cur_grade = 0;
		return R[0];
	}	
	else if (buffer_time > getQUp(now_grade)) {
		cur_grade += 1;
		if (cur_grade > 3) cur_grade = 3;
		return R[cur_grade];
	}
	else if (next_download_rate > R[result_grade]) {
		cur_grade += 1;
		if (cur_grade > 3) cur_grade = 3;
		return R[cur_grade];
	}
	else if (next_download_rate < R[now_grade]) {
		if (buffer_time > getQDown()) {
			return R[now_grade];
		}
		else {
			cur_grade -= 1;
			if (cur_grade < 0) cur_grade = 0;
			return R[cur_grade];
		}
	}
	else {
		return R[now_grade];
	}
}