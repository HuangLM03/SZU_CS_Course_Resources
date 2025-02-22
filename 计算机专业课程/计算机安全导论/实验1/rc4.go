package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"runtime"
	"strings"
	"time"
)

func getSecret(K []byte, dataLen, keyLen int) []byte {
	// 初始化
	S, T := make([]byte, 256), make([]byte, 256)
	for i := 0; i < 256; i++ {
		S[i] = byte(i)
		T[i] = K[i%len(K)]
	}
	// 初始置换
	for i, j := 0, 0; i < 256; i++ {
		j = (j + int(S[i]) + int(T[i])) % 256
		S[i], S[j] = S[j], S[i]
	}
	// 密钥流产生
	key := make([]byte, 0)
	for i, j, k := 0, 0, 0; k < keyLen; k++ {
		i = (i + 1) % 256
		j = (j + int(S[i])) % 256
		S[i], S[j] = S[j], S[i]
		t := byte((int(S[i]) + int(S[i])) % 256)
		key = append(key, t)
	}
	return key
}
func encrypt(key []byte, data []byte, keyLen int) []byte {
	resData := make([]byte, len(data))
	copy(resData, data)
	for i := 0; i < len(data); i++ {
		resData[i] = resData[i] ^ key[i%keyLen]
	}
	return resData
}
func decrypt(key []byte, data []byte, keyLen int) []byte {
	resData := make([]byte, len(data))
	copy(resData, data)
	for i := 0; i < len(data); i++ {
		resData[i] = resData[i] ^ key[i%keyLen]
	}
	return resData
}
func init() {
	// cpu数量设置
	runtime.GOMAXPROCS(1)
}
func main() {
	K := make([]byte, 256)
	K = []byte("计算机安全导论-实验1")
	data := []byte("这是需要加密的内容:XXX")

	keyFile, _ := os.Create("./计算机安全导论/key.txt")
	dataFile, _ := os.Open("/Users/huanglm/Downloads/DownloadFromBrowser/计算机视觉-学号-姓名-实验报告1(1).docx")
	secretFile, _ := os.Create("./计算机安全导论/secret.txt")
	suffix := strings.Split(dataFile.Name(), ".")
	recoverFile, _ := os.Create("./计算机安全导论/recover." + suffix[len(suffix)-1])
	defer keyFile.Close()
	defer dataFile.Close()
	defer secretFile.Close()
	defer recoverFile.Close()

	dataReader := bufio.NewReader(dataFile)
	data, _ = io.ReadAll(dataReader)
	tmpData := make([]byte, 0)
	tmpData = append(tmpData, data...)

	// 计时器
	now := time.Now()
	be_t := now.UnixNano()
	// 密钥流
	key := getSecret(K, len(data), len(K))
	// 加密
	secretData := encrypt(key, data, len(K))
	// 结束计时
	now = time.Now()
	ed_t := now.UnixNano()
	dur_t := ed_t - be_t
	fmt.Println("加密速度为：", float64(len(data))/float64(dur_t), "字节/纳秒")
	// 查询到自己机器的处理器频率约为3.2GHz
	fmt.Println("加密速度为：", float64(len(data))/float64(dur_t)*1e9/float64(3.2*1e9), "字节/周期")
	//解密
	now = time.Now()
	be_t = now.UnixNano()
	data = decrypt(key, secretData, len(K))
	now = time.Now()
	ed_t = now.UnixNano()
	dur_t = ed_t - be_t
	fmt.Println("解密速度为：", float64(len(data))/float64(dur_t), "字节/纳秒")
	// 查询到自己机器的处理器频率约为3.2GHz
	fmt.Println("解密速度为：", float64(len(data))/float64(dur_t)*1e9/float64(3.2*1e9), "字节/周期")
	fmt.Println("密钥流为：", key)
	_, _ = keyFile.Write(key)
	//fmt.Println("加密前数据：", string(tmpData))
	//fmt.Println("对应比特流为：", tmpData)
	//fmt.Println("加密后的数据：", string(secretData))
	//fmt.Println("对应比特流为：", secretData)
	_, _ = secretFile.Write(secretData)
	//fmt.Println("解密前数据：", string(data))
	//fmt.Println("对应比特流为：", data)
	_, _ = recoverFile.Write(data)
}
