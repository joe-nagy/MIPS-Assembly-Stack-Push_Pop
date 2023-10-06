# $s0 = UNUSED
# $s1 = UNUSED
# $s2 = UNUSED
# $s3 = UNUSED
# $s4 = UNUSED
# $s5 = UNUSED
# $s6 = UNUSED
# $s7 = Loop counter
# $t0 = UNUSED
# $t1 = store word from array
# $t2 = address of array
# $t3 = value popped from stack
# $t4 = addresses of user messages
# $t5 = UNUSED
# $t6 = UNUSED
# $t7 = UNUSED
# $t8 = UNUSED
# $t9 = UNUSED


.data
a_array: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
a_length: .word 10
msg1: .asciiz "\nWe pushed the following integer to stack: "
msg2: .asciiz "\nWe popped the following integer from stack: "

.macro PUSH(%x)
	addi $sp, $sp, -4
	sw %x, ($sp)
.end_macro

.macro POP(%x)
	lw %x, ($sp)
	sw $zero, ($sp)
	addi $sp, $sp, 4
.end_macro

.macro PRINT_INT(%x)
	li $v0, 1			# Service call 1 = print signed integer
	move $a0, %x			# we move passed register for printing
	syscall
.end_macro 

.macro PRINT_STRING(%x)
	li $v0, 4			# Service call 4 = print string
	move $a0, %x			# we move contents from $t4 to $a0
	syscall
.end_macro

.macro DONE()
	li $v0, 10
	syscall
.end_macro	


.text
	la $t2, a_array			# we load the address of the array
	lw $s7, a_length		# this will serve as loop couter
	
PUSH_LOOP:
	lw $t1, 0($t2)			# we load the word that is contained at the address of t2
	PUSH($t1)			# we push the word onto array
	la $t4, msg1			# we load message address into $t4
	PRINT_STRING($t4)		# we request string print
	PRINT_INT($t1)			# we print integer we just added
	add $t2, $t2, 4			# we increment the adddress where we access the array
	sub $s7, $s7, 1			# we decrement loop counter
	bgtz $s7, PUSH_LOOP
	
	lw $s7, a_length		# this will serve as loop couter
	
POP_LOOP:
   	POP($t3)               		# t3 now has the value we popped from stack
   	la $t4, msg2			# we load message address into $t4
   	PRINT_STRING($t4)		# we request string print
   	PRINT_INT($t3)			# we print #t3 so user gets feedback what was just popped
	sub $s7, $s7, 1        		# Decrement the loop counter
    	bgtz $s7, POP_LOOP    		# Continue the loop if the counter is greater than zero

DONE()