.ORIG x3000
;ð������
	AND R1, R1, #0
	ADD R1, R1, #15

bubble_sort	
	BRZ endbubble_sort
	LD R2, st_file	
	ADD R3, R2, R1
	NOT R3, R3
	ADD R3, R3, #1	;R3���-(R2+R1)
	ADD R4, R3, R2	;R4 = -R1
while	
	BRZP endwhile
	LDR R5, R2, #0	;R5<-M[R2]
	LDR R6, R2, #1	;R5<-M[R2+1]
	NOT R4, R6
	ADD R4, R4, #1	;R4 = -R6
	ADD R4, R4, R5	;R4 = R5 - R6
if
	BRZP endswap
	STR R6, R2, #0	;M[R2]<-R6
	STR R5, R2, #1	;M[R2+1]<-R5
endswap
	ADD R2, R2, #1	;R2 = R2 + 1
	ADD R4, R3, R2	;R4 = -R1
	BRNZP while
endwhile
	ADD R1, R1, #-1
	BRNZP bubble_sort
endbubble_sort

;д������������
	LD R1, ld_file
	LD R2, st_file
	AND R0, R0, #0
	ADD R0, R0, #15
write
	BRN endwrite
	LDR R3, R1, #0
	STR R3, R2, #0
	ADD R1, R1, #1
	ADD R2, R2, #1
	ADD R0, R0, #-1
	BRNZP write
endwrite

;ͳ�Ʒ���
	LD R2 st_file
	LD R5 st_A	;�洢A�ɼ�ѧ�������Ľ����ַ
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
ld_file	.FILL x3200
st_file	.FIll x4000
st_A	.FILL x4100
GA	.FILL x0055		;GAΪA�ɼ�ѧ�������Ҫ��֣�85
GB	.FILL x004B		;GBΪB�ɼ�ѧ�������Ҫ��֣�75
.END

