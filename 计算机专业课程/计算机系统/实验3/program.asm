.ORIG x3000
AND R1,R1,#0
ADD R1,R1,#15

;ð������
AND R1, R1, #0
ADD R1, R1, #15
sort	
BRZ endSort
LD R2, stFile	
ADD R3, R2, R1
NOT R3, R3
ADD R3, R3, #1	;R3���-(R2+R1)
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

;��¼�ɼ��ȼ�ΪA��ѧ������
LD R2 stFile
LD R5 stA	;�洢A�ɼ�ѧ�������Ľ����ַ
AND R0, R0, #0	;��¼A�ɼ�ѧ������
LD R4 GA	;�ɼ�A����ͷ�
NOT R4, R4
ADD R4, R4, #1	;��ʱR4 = -85
AND R3, R3, #0	
ADD R3, R3, #4	;ȷ������
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
STR R0, R5, #0	;д��A�ɼ�ѧ������

;��¼�ɼ��ȼ�ΪB��ѧ���ĸ���
AND R0, R0, #0	;��¼B�ɼ�ѧ������
LD R4, GB	;�ɼ�B����ͷ�
NOT R4, R4
ADD R4, R4, #1	;��ʱR4 = -75
AND R3, R3, #0	
ADD R3, R3, #4	;ȷ������
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
STR R0, R5, #1	;д��B�ɼ�ѧ������
HALT

ldFile	.FILL x3200
stFile	.FIll x4000
stA	.FILL x4100
GA	.FILL x0055		;GAΪA�ɼ�ѧ�������Ҫ��֣�85
GB	.FILL x004B		;GBΪB�ɼ�ѧ�������Ҫ��֣�75
.END



