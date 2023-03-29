###########################################################
# Assignment #: 11
#  Name: Baozan Yan
#  ASU email: by23@asu.edu
#  Course: CSE/EEE230, your lecture time such as T/Th 1:30pm
#  Description:  reads in numbers and store them in an array, then prints the original content of the array. Then it should ask a user to enter another floating number. 
###########################################################

		.data
arraysize:		.word 12
msg1:		.asciiz "Specify how many numbers should be stored in the array (at most 12):\n"
msg2:		.asciiz "First Array:\n"
msg3:		.asciiz "Enter a number:\n"
msg4:		.asciiz "First Array Content:\n"
msg5:		.asciiz "Please enter a number:\n"
msg6:		.asciiz "Second Array Content:\n"
NewLine:	.asciiz "\n"
array1:		.float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
array2:		.float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0

		.text
############################################################################
# Procedure/Function: printArray
# Description: The printArray prints each element of the parameter array.
# parameters: $a3 = address of the input array , $t5 = element of array, $t0 = i
# registers to be used: $f12 = float num, $t6 =  addr pf save[i]
############################################################################

printArray:

	li	$t0, 0		# i=0
	
  loop1:
	
	sll	$t6, $t0, 2		#$t6=$t0<<2
	add	$t6, $a3, $t6	#$t6= base addr + t6
	l.s	$f12, 0($t6)		#$t5= array[i]
	
	li		$v0, 2		#print float array
	#mov.s	$f12, $t5	#move t5 to f12
	syscall
	li	$v0, 4
	la	$a0, NewLine	#newline
	syscall
	
	addi	$t0, $t0, 1	#i++
	blt	$t0, $s0, loop1		#loop again
	
	jr	$ra

############################################################################
# Procedure/Function: function1
# Description: The function1 goes through each element of the first array.
# parameters: $a1 = address of array1 , $a2 = address of array2, $t0 = i,$s0 = arraysize
# registers to be used: $f12 = float num, $f2 =  num2,$t1 =  addr pf save[i],$s5 =  addr pf save[i]
# $f3 = element of array1, $f7 = element of array2
############################################################################
	
function1:
		
	li	$t0, 0	#i=0
  loop2:
	
	sll	$t1, $t0, 2
	add	$t2, $t1, $a1		#array1
	l.s	$f3, 0($t2)
	
	sll	$s5, $t0, 2
	add	$s6, $s5, $a2		#array2
	l.s	$f7, 0($s6)
	
	c.lt.s $f3, $f2		#array1[i] < num2
	bc1f else
	
	add.s $f7, $f3, $f2		#array2[i] = array1[i]+num2;
	s.s $f7, 0($s6)
	
	j jump1
	
  else:
	mov.s $f7, $f3
	s.s $f7, 0($s6)		#array2[i] = array1[i];
	
  jump1:
	addi	$t0, $t0, 1	# i++
	blt	$t0, $s0, loop2	#loop again
	
	jr $ra
############################################################################
# Procedure/Function: main
# Description: The main will ask a user how many floating numbers will be entered,then read floating point numbers and store them in an array.
# parameters: $a1 = address of array1 , $a2 = address of array2, $t1 = i
# registers to be used: $s0 = howMany, $f0 = input float, $f2 = num2,
############################################################################

main:

	la	$a0, msg1	#print msg1
	li	$v0, 4
	syscall
	li	$v0, 5		#input howMany
	syscall
	move	$s0, $v0		#store the input howMany to $s0
	li	$t0, 0		#i=0
	la	$a1, array1	##addr of array1
	
	li	$v0, 4
	la	$a0, msg2	#print msg2
	syscall
	
  while:
	li	$v0, 4
	la	$a0, msg3	#print msg3
	syscall
	
	sll	$t1, $t0, 2
	add	$t2, $t1, $a1		#array1
	l.s	$f3, 0($t2)
	
	li	$v0, 6		#input float
	syscall
	#mov.s	$f3, $f0		#store the input float to $s1
	
	s.s	$f0, 0($t2)	#array[i]=$s1=$f0
	add	$t0, $t0, 1	# i++
	blt	$t0, $s0, while	#loop again
	
	la	$a0, msg4	#print msg4
	li	$v0, 4
	syscall
	
	addi	$sp, $sp, -4	#make $sp -4
	sw		$ra, 0($sp)		#store $ra
	move 	$a3, $a1		#print array1
	jal	printArray		#jump to printArray
	lw		$ra, 0($sp)		#return here
	addi	$sp, $sp, 4		##make $sp +4
	
	li	$t3, 0	#i =0
  for:
  
	slti	$s3, $t3, 3		#if t0 <3, $s3 = 1
	beq		$s3, $zero, Exit
	
	li	$v0, 4
	la	$a0, msg5	#print msg5
	syscall
	
	li	$v0, 6		#input float num2
	syscall
	mov.s	$f2, $f0		#store the input float to $s2
	
	addi	$sp, $sp, -4	#make $sp -4
	sw		$ra, 0($sp)		#store $ra
	jal	function1		#jump to function1
	lw		$ra, 0($sp)		#return here
	addi	$sp, $sp, 4		##make $sp +4
	
	li	$v0, 4
	la	$a0, msg6	#print msg6
	syscall
	
	addi	$sp, $sp, -4	#make $sp -4
	sw		$ra, 0($sp)		#store $ra
	move 	$a3, $a2		#print array2
	jal	printArray		#jump to printArray
	lw		$ra, 0($sp)		#return here
	addi	$sp, $sp, 4		##make $sp +4
	
	addi		$t3, $t3, 1		#i++
	j	for
	
  Exit:
	
	jr $ra