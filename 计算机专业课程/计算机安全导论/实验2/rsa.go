package main

import (
	"bufio"
	"fmt"
	"io"
	"math/rand/v2"
	"os"
	"strings"
	"time"
)

const (
	N = int64(1e4)
)

var (
	p, q, n, phi_n, e, d int64
	primes               [N]int64
	cnt                  int64
	st                   [N]bool
)

func getPrimes() {
	for i := int64(2); i < N; i++ {
		if st[i] == false {
			primes[cnt] = i
			cnt++
		}
		for j := int64(0); primes[j]*i < N; j++ {
			st[primes[j]*i] = true
			if i%primes[j] == 0 {
				break
			}
		}
	}
}

func quickPow(a, b, mod int64) int64 {
	var res int64 = 1
	for b != 0 {
		if b&1 == 1 {
			res = (res * a) % mod
		}
		a = (a * a) % mod
		b = b >> 1
	}
	return res
}
func gcd(a, b int64) int64 {
	if b == 0 {
		return a
	}
	return gcd(b, a%b)
}
func exgcd(a, b int64, x, y *int64) int64 {
	if b == 0 {
		(*x), (*y) = 1, 0
		return a
	}
	d := exgcd(b, a%b, y, x)
	(*y) = (*y) - a/b*(*x)
	return d
}
func inv(a, mod int64) int64 {
	var x, y int64
	exgcd(a, mod, &x, &y)
	return (x%mod + mod) % mod
}
func init() {
	beT := time.Now().UnixNano()
	getPrimes()
	idx1, idx2 := rand.Int64N(cnt), rand.Int64N(cnt)
	p, q = primes[idx1], primes[idx2]
	n = p * q
	phi_n = (p - 1) * (q - 1)
	for {
		idx := rand.Int64N(cnt)
		if primes[idx] < phi_n && gcd(primes[idx], phi_n) == 1 {
			e = primes[idx]
			break
		}
	}
	d = inv(e, phi_n)
	edT := time.Now().UnixNano()
	t1 = edT - beT
}

var (
	inputBuffer, outputBuffer = make([]byte, 8000000), make([]byte, 8000000)
	len1                      int64
	C                         = make([]int64, 8000000)
	t1, t2, t3                int64
)

var fileName string

func intputText() {
	file, _ := os.Open("/Users/huanglm/Downloads/计算机安全导论/第7讲 公钥密码.pptx")
	defer file.Close()

	fileName = file.Name()

	reader := bufio.NewReader(file)
	buffer, _ := io.ReadAll(reader)
	copy(inputBuffer, buffer)
	len1 = int64(len(buffer))
}
func outputText(uri string) {
	file, _ := os.Create(uri)
	defer file.Close()
	writer := bufio.NewWriter(file)
	_, _ = writer.Write(outputBuffer[:len1])
	writer.Flush()
}
func main() {
	fmt.Printf("参数：\n大素数：%v %v\n模数：%v\n公钥：%v\n私钥：%v\n", p, q, n, e, d)
	intputText()
	now := time.Now()
	beT := now.UnixNano()
	for i := int64(0); i < len1; i++ {
		C[i] = quickPow(int64(inputBuffer[i]), e, n)
	}
	now = time.Now()
	edT := now.UnixNano()
	t2 = edT - beT

	for i := int64(0); i < len1; i++ {
		outputBuffer[i] = byte(C[i])
	}
	outputText("/Users/huanglm/Downloads/Goland/go_study/计算机安全导论/实验2/密文." + strings.Split(fileName, ".")[1])

	now = time.Now()
	beT = now.UnixNano()
	for i := int64(0); i < len1; i++ {
		outputBuffer[i] = byte(quickPow(C[i], d, n))
	}
	now = time.Now()
	edT = time.Now().UnixNano()
	t3 = edT - beT
	//fmt.Println("密文")
	//fmt.Println(C[:len1])
	outputText("/Users/huanglm/Downloads/Goland/go_study/计算机安全导论/实验2/解密后." + strings.Split(fileName, ".")[1])

	fmt.Println("数据的总大小为", len1, "字节")
	fmt.Println("生成密钥对的时间为：", float64(t1)/1e6, "ms")
	fmt.Println("加密时间为：", float64(t2)/1e6, "ms")
	fmt.Println("解密时间为：", float64(t3)/1e6, "ms")
	fmt.Printf("生成密钥对的时间为：%f 毫秒 加密速度：%.2f 字节/毫秒 解密速度：%.2f 字节/毫秒", float64(t1)/1e6,
		float64(len1)/(float64(t2)/1e6), float64(len1)/(float64(t3)/1e6))
}
