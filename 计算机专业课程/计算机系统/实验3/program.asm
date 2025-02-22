.ORIG x3000
AND R1,R1,#0
ADD R1,R1,#15

;冒泡排序
AND R1, R1, #0
ADD R1, R1, #15
sort	
BRZ endSort
LD R2, stFile	
ADD R3, R2, R1
NOT R3, R3
ADD R3, R3, #1	;R3存放-(R2+R1)
ADD R4, R3, R2	;R4 = -R1
while	
BRZP endWhile
LDR R5, R2, #0	;R5<-M[R2]
LDR R6, R2, #1	;R5<-M[R2+1]
NOT R4, R6
ADD R4, R4, #1	;R4 = -R6
ADD R4, R4, R5	;R4 = R5 - R6
if
BRZP endSwap
STR R6, R2, #0	;M[R2]<-R6
STR R5, R2, #1	;M[R2+1]<-R5
endSwap
ADD R2, R2, #1	;R2 = R2 + 1
ADD R4, R3, R2	;R4 = -R1
BRNZP while
endWhile
ADD R1, R1, #-1
BRNZP sort
endSort

;记录成绩等级为A的学生个数
LD R2 stFile
LD R5 stA	;存储A成绩学生个数的结果地址
AND R0, R0, #0	;记录A成绩学生个数
LD R4 GA	;成绩A的最低分
NOT R4, R4
ADD R4, R4, #1	;此时R4 = -85
AND R3, R3, #0	
ADD R3, R3, #4	;确认排名
gradeA	
BRZ endA
LDR R1, R2, #0
ADD R1, R1, R4
isA	
BRN endisA
ADD R0, R0, #1
endisA
ADD R2, R2, #1
ADD R3, R3, #-1
BRNZP gradeA
endA
STR R0, R5, #0	;写入A成绩学生个数

;记录成绩等级为B的学生的个数
AND R0, R0, #0	;记录B成绩学生个数
LD R4, GB	;成绩B的最低分
NOT R4, R4
ADD R4, R4, #1	;此时R4 = -75
AND R3, R3, #0	
ADD R3, R3, #4	;确认排名
gradeB
BRZ endB
LDR R1, R2, #0
ADD R1, R1, R4
isB	
BRN endisB
ADD R0, R0, #1
endisB
ADD R2, R2, #1
ADD R3, R3, #-1
BRNZP gradeB
endB
STR R0, R5, #1	;写入B成绩学生个数
HALT

ldFile	.FILL x3200
stFile	.FIll x4000
stA	.FILL x4100
GA	.FILL x0055		;GA为A成绩学生的最低要求分：85
GB	.FILL x004B		;GB为B成绩学生的最低要求分：75
.END



