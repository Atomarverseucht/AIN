# willkürliche Prozedur G (überschreibt alle "ungesicherten" Register mit dem Wert $a0+200, liefert auch $a0+200 zurück)
G:	addi $a0,$a0,100
	addi $a1,$a0,100
	addi $a2,$a0,100
	addi $a3,$a0,100
	addi $t0,$a0,100
	addi $t1,$a0,100
	addi $t2,$a0,100
	addi $t3,$a0,100
	addi $t4,$a0,100
	addi $t5,$a0,100
	addi $t6,$a0,100
	addi $t7,$a0,100
	addi $t8,$a0,100
	addi $t9,$a0,100
	addi $v0,$a0,100
	addi $v1,$a0,100
	jr $ra

