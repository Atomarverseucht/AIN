.data
prompt1: .asciiz "enter value:"
prompt2: .asciiz "result is:"
lf:      .asciiz "\n"

.text
.globl main

main:                               
    li  $v0, 4                  # print string service
    la  $a0, prompt1            # write("enter value:")
    syscall
    li  $v0, 5                  # read integer
    syscall

    add $s0, $zero, $v0               # 

    li  $v0, 4                  # print string service
    la  $a0, prompt1            # write("enter value:")
    syscall
    li  $v0, 5                  # read integer
    syscall
    add $a1, $zero, $v0               # 
    add $a0, $zero, $s0

    jal rekmul                  # Jump to Subroutine
                                # Return from Subroutine here! 
    add $s0, $zero, $v0         # Save return value in $s0
    li  $v0, 4                  # print string service
    la  $a0, prompt2            # write("result is:")
    syscall                                
    li   $v0, 1                 # print integer service
    add $a0, $zero, $s0               # write ($s0)
    syscall   
    li  $v0, 4                  # print string service
    la  $a0, lf                 # write line feed
    syscall
    li $v0, 10                  # Exit program
    syscall

#
# calculate: rekmul(a0,0)=0;  rekmul(a0,a1) = rekmul(a0,a1-1) + a0
#$ra 			# return

rekmul:
    addi $sp,$sp, -4
    sw $ra, 0($sp)
    beq $a1, $zero, null       # if a0=0 then goto null
    addi $a1, $a1, -1          # calculate a1-1
    jal rekmul                 # v0=rekmul(a0,a1-1)
    add $v0, $v0, $a0          # v0=rekmul(a0,a1-1) + a0
    j return                   # jump to return           
null:
    add $v0, $zero, $zero      # rekmul(a0,0)=0
return:
    lw $ra, 0($sp)
    addi $sp,$sp, 4
    jr $ra                     # return
