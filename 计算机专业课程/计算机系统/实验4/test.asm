.ORIG x3000

; 游戏初始化
    AND R1, R1, #0      ; R1 用于存储当前玩家的符号
    ADD R1, R1, #1      ; 玩家1使用符号1，初始化为1
    AND R2, R2, #0      ; R2 用于计算每个玩家的分数
    AND R3, R3, #0      ; R3 用于计算游戏结束的条件

; 游戏主循环
LOOP:
    ; 显示当前棋盘状态
    LEA R4, BOARD
    JSR DISPLAY_BOARD

    ; 提示当前玩家的回合
    LEA R0, PROMPT
    PUTS

    ; 读取玩家输入的坐标
    LEA R0, INPUT
    GETS

    ; 解析玩家输入的坐标
    LDR R5, INPUT
    ADD R5, R5, #-48    ; 转换ASCII码为数字
    LDR R6, INPUT+1
    ADD R6, R6, #-48

    ; 计算输入坐标对应的棋盘位置
    ADD R7, R5, R5      ; R7 = R5 * 2
    ADD R7, R7, R6      ; R7 = (R5 * 2) + R6
    ADD R7, R7, R7      ; R7 = ((R5 * 2) + R6) * 2
    ADD R7, R7, #BOARD ; R7 = ((R5 * 2) + R6) * 2 + BOARD

    ; 检查输入是否有效
    LDR R4, R7
    BRZ INVALID_INPUT

    ; 检查是否已经有线连接
    ADD R8, R7, #1
    LDR R8, R8
    BRZ INVALID_INPUT

    ; 在棋盘上绘制线
    ST R1, R7

    ; 检查是否完成了一个方框
    AND R8, R7, R7
    ADD R8, R8, #2
    ADD R8, R8, R7
    ADD R8, R8, #BOARD
    LDR R8, R8
    ADD R8, R8, #4
    ADD R9, R7, #4
    ADD R9, R9, R9
    ADD R9, R9, R7
    ADD R9, R9, #BOARD
    LDR R9, R9
    ADD R10, R7, #8
    ADD R10, R10, #8
    ADD R10, R10, R7
    ADD R10, R10, #BOARD
    LDR R10, R10
    ADD R11, R7, #12
    ADD R11, R11, #12
    ADD R11, R11, R7
    ADD R11, R11, #BOARD
    LDR R11, R11
    ADD R12, R7, #16
   
    ADD R12, R12, R7
    ADD R12, R12, #BOARD
    LDR R12, R12

    ; 检查是否完成了一个方框
    ADD R13, R7, #1
    ADD R13, R13, R13
    ADD R13, R13, R7
    ADD R13, R13, #BOARD
    LDR R13, R13
    ADD R14, R7, #2
    ADD R14, R14, #2
    ADD R14, R14, R7
    ADD R14, R14, #BOARD
    LDR R14, R14
    ADD R15, R7, #3
    ADD R15, R15, #3
    ADD R15, R15, R7
    ADD R15, R15, #BOARD
    LDR R15, R15

    ADD R4, R8, R9
    ADD R4, R4, R10
    ADD R4, R4, R11
    ADD R4, R4, R12
    ADD R4, R4, R13
    ADD R4, R4, R14
    ADD R4, R4, R15
    BRz DRAW_LINE

    ; 完成了一个方框，记录分数
    ADD R2, R2, R1

    ; 检查游戏是否结束
    ADD R3, R8, R9
    ADD R3, R3, R10
    ADD R3, R3, R11
    ADD R3, R3, R12
    ADD R3, R3, R13
    ADD R3, R3, R14
    ADD R3, R3, R15
    ADD R3, R3, #16
    ADD R3, R3, #16
    ADD R3, R3, #16
    ADD R3, R3, #16
    ADD R3, R3, #16
    ADD R3, R3, #16
    ADD R3, R3, #16
    ADD R3, R3, #16
    ADD R3, R3, #16
    ADD R3, R3, #16
    ADD R3, R3, #16
    ADD R3, R3, #16
    ADD R3, R3, #16
    ADD R3, R3, #16
    ADD R3, R3, #16
    ADD R3, R3, #16

    BRnzp LOOP

; 无效输入处理
INVALID_INPUT:
    LEA R0, INVALID_PROMPT
    PUTS
    BRnzp LOOP

; 绘制线的处理
DRAW_LINE:
    ; 在棋盘上绘制线
    ST R1, R7

    ; 切换玩家
    NOT R1, R1

    BRnzp LOOP

; 显示当前棋盘状态的子程序
DISPLAY_BOARD:
    ; 打印第一行
    LD R5, R4, #0
    LD R6, R4, #1
    ADD R5, R5, R6
    ADD R5, R5, R5
    ADD R5, R5, R6
    ADD R5, R5, #BOARD
    LDR R5, R5
    LD R6, R4, #1
    ADD R6, R6, R6
    ADD R6, R6, R6
    ADD R6, R6, #BOARD
    LDR R6, R6
    ADD R7, R4, #1
    ADD R7, R7, R7
    ADD R7, R7, #BOARD
    LDR R7, R7
    LD R8, R4, #2
    ADD R8, R8, R8
    ADD R8, R8, R8
    ADD R8, R8, #BOARD
    LDR R8, R8

    LEA R0, BOARD_FORMAT
    LEA R1, BOARD_CHARS
    ADD R2, R2, #16
    ADD R2, R2, #16
    ADD R2, R2, #16
    ADD R2, R2, #16
    ADD R2, R2, #16
    ADD R2, R2, #16
    ADD R2, R2, #16
    ADD R2, R2, #16
    ADD R2, R2, #16
    ADD R2, R2, #16
    ADD R2, R2, #16
    ADD R2, R2, #16
    ADD R2, R2, #16
    ADD R2, R2, #16
    ADD R2, R2, #16
    ADD R2, R2, #16
    JSR sprintf

    LEA R0, BOARD_CHARS
    PUTS
    RET

BOARD:
.FILL x0000
.FILL x0000
.FILL x0000
.FILL x0000

BOARD_FORMAT:
.STRINGZ " %c  |  %c  |  %c  |  %c \n"
.STRINGZ "---|-----|-----|----\n"
.STRINGZ " %c  |  %c  |  %c  |  %c \n"
.STRINGZ "---|-----|-----|----\n"
.STRINGZ " %c  |  %c  |  %c  |  %c \n"
.STRINGZ "---|-----|-----|----\n"
.STRINGZ " %c  |  %c  |  %c  |  %c \n"

BOARD_CHARS:
.FILL x0000
.FILL x0000
.FILL x0000
.FILL x0000
.FILL x0000
.FILL x0000
.FILL x0000
.FILL x0000
.FILL x0000
.FILL x0000
.FILL x0000
.FILL x0000
.FILL x0000
.FILL x0000
.FILL x0000
.FILL x0000
