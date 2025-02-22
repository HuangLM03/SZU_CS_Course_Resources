.data
arr: .word 100,6,3,-6,1,-2,9,4,5,1234567890
before: .asciiz "Before:\n"
after: .asciiz "After: \n"
CONTROL: .word 0x10000
DATA: .word 0x10008
SP: .word 0x100  # stack pointer

.text
main:
    # print before
    ld r1, CONTROL(r0)
    ld r2, DATA(r0)
    daddi r3, r0, 4
    daddi r4, r0, before
	sd r4, (r2)
    sd r3, (r1)

    # print the array
    daddi r3, r0, 2
    daddi r5, r0, 10
    daddi r6, r0, 0

printArr1:
    dsll r7, r6, 3
    ld r4, arr(r7)
    sd r4, (r2)
    sd r3, (r1)
	
    daddi r6, r6, 1
    bne r5, r6, printArr1

    # bubbleSort()
    ld r10, SP(r0)
    daddi r11, r0, arr
    daddi r12, r0, 10
    jal sort

    # print after
    daddi r3, r0, 4
    daddi r4, r0, after
    sd r4, (r2)
	sd r3, (r1)
	
    # print the array
    daddi r3, r0, 2
    daddi r5, r0, 10
    daddi r6, r0, 0
printArr2:
    dsll r7, r6, 3
    ld r4, arr(r7)  
    sd r4, (r2) 
    sd r3, (r1)  
	
    daddi r6, r6, 1 
    bne r5, r6, printArr2
    halt

swap:  
    ld r4, 0(r11)
    ld r13, 0(r12)
    sd r13, 0(r11)
    sd r4, 0(r12)
    jr $ra

sort:
    daddi r10, r10, -24
    sd $ra, 16(r10) 
    sd r1, 8(r10) 
    sd r2, 0(r10)
    dadd r14, r11, r0
    daddi r15, r12, 0
    and r16, r16, r0
loop1:
    slt r13, r16, r15
    beq r13, r0, end1
    daddi r17, r16, -1  
loop2:
    slti r13, r17, 0 
    bne r13, r0, end2	
    dsll r18, r17, 3 
    dadd r19, r14, r18
    ld r20, 0(r19)
    ld r21, 8(r19)	
    # if (a[j] > a[j + 1]) swap(a[j], a[j + 1]);
    slt r13, r21, r20
    beq r13, r0, end2	
    #swap
    dadd r11, r0, r19
    daddi r12, r19, 8
    jal swap	
    daddi r17, r17, -1
    j loop2
end2:
    daddi r16, r16, 1
    j loop1
end1:
    # restore
    ld r2, 0(r10)
    ld r1, 8(r10)
    ld $ra, 16(r10)
    daddi r10, r10, 24
    jr $ra