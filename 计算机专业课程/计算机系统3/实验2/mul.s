.data
DATA: .word 0x10008
CONTROL: .word 0x10000
NUM1: .word 0
NUM2: .word 0
STACK_SIZE: .space 300
STACK_POINTER: .word 0
INPUT_PROMPT: .asciiz "please enter two numbers:\n"
RESULT_PROMPT: .asciiz "result:\n"
WARNING_PROMPT: .asciiz "warning: result overflow\n"

.text
main:
    lw $a1, DATA($zero)
    lw $a2, CONTROL($zero)
    daddi $sp, $zero, STACK_SIZE

    daddi $a0, $zero, INPUT_PROMPT
    jal writeString

    daddi $a0, $zero, NUM1
    jal readInt
    daddi $a0, $zero, NUM2
    jal readInt

    daddi $t0, $zero, 32
    lw $t1, NUM1($zero)
    lw $t2, NUM2($zero)
loop:
    beq $t0, $zero, end
    andi $t3, $t1, 1
    beq $t3, $zero, noAdd 
    dadd $t4, $t4, $t2
noAdd:
    dsrl $t1, $t1, 1
    dsll $t2, $t2, 1
    daddi $t0, $t0, -1
    j loop
end:

    daddi $a0, $zero, RESULT_PROMPT
    jal writeString
    daddi $a0, $t4, 0
    jal writeInt

    halt 
    
writeString:
	daddi $sp, $sp, -4
	sw $ra, ($sp)
	
	sw $a0, ($a1)
	daddi $t0, $zero, 4
	sw $t0, ($a2)
	
	lw $ra, ($sp)
	daddi $sp, $sp, 4
	jr $ra  # return

writeInt:
	daddi $sp, $sp, -4
	sw $ra, ($sp)
	
	sw $a0, ($a1)
	daddi $t0, $zero, 2
	sw $t0, ($a2)
	
	lw $ra, ($sp)
	daddi $sp, $sp, 4
	jr $ra  # return

readInt:
	daddi $sp, $sp, -4
	sw $ra, ($sp)
	
	daddi $t0, $zero, 8
	sw $t0, ($a2)
	
	lw $t1, ($a1)
	sw $t1, ($a0)
	
	lw $ra, ($sp)
	daddi $sp, $sp, 4
	jr $ra  # return

