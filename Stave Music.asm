.data

explain: .asciiz	"Options:\tColours:\n1 - cls\t\t1 - red\n2 - stave\t2 - orange\n3 - note\t3 - yellow\n4 - exit\t4 - green\n\t\t5 - blue\n"
input: .asciiz		"Select an option:"
detail: .asciiz	"Select colour/row/note:"

colour:     .word		0x00000000
staveColour: .word		0x00000000
# 			            black       red	        orange      yellow	    green       blue        white

.text

#MENU
main:


	li $v0, 4 #4 is used to show a write operation
	la $a0 explain #printing menu options
	syscall
	
	li $v0, 4 #4 is used to show a write operation
	la $a0 input #asking the user for option
	syscall

	li $v0, 5 #5 is used to show a read operation (reading user input)
	syscall
	move $s0, $v0 #moves user input from the $v0 register to $s0 to be used in conditionals
	
	

#MENU OPTIONS
beq $s0, 1, cls #Conditional statement to see if user input (1) matches the corresponding menu item
beq $s0, 2, stave #Conditional statement to see if user input (2) matches the corresponding menu item
beq $s0, 3, note #Conditional statement to see if user input (3) matches the corresponding menu item
beq $s0, 4, exit #Conditional statement to see if user input (4) matches the corresponding menu item

cls:
	li $v0, 4
	la $a0, detail  #asking user for colour of cls
	syscall

	li $v0, 5 #5 is used to show a read operation (reading user input)
	syscall
	move $s2, $v0 #moves user input from the $v0 register to $s2 to be used in conditionals
	

	#conditional statemnent to direct user input to correct colour
	beq $s2, 1, red
	beq $s2, 2, orange
	beq $s2, 3, yellow
	beq $s2, 4, green
	beq $s2, 5, blue
	
	
	clsMain: #label for drawing CLS
		lui $s0,0x1004			
		lw $t8, colour
		addi, $t0, $s0, 0	
		lui $s1, 0x100C
		drawCls:
		sw $t8, 0($t0)
		addi $t0, $t0, 4
		bne $t0,$s1,drawCls
		jal main
		
	red:
		li $t0, 0xff0000 #loads the colour red to register $t0
		sw $t0, colour #stores the colour red in the colour word
		jal clsMain #goes back to CLS drawing to draw with colour red
	orange:
		li $t0, 0xffa500 #loads the colour orange to register $t0
		sw $t0, colour #stores the colour red in the colour word
		jal clsMain #goes back to CLS drawing to draw with colour red
	yellow:
		li $t0, 0xffff00 #loads the colour yellow to register $t0
		sw $t0, colour #stores the colour red in the colour word
		jal clsMain #goes back to CLS drawing to draw with colour red
	green:
		li $t0, 0x00ff00 #loads the colour green to register $t0
		sw $t0, colour #stores the colour red in the colour word
		jal clsMain #goes back to CLS drawing to draw with colour red
	blue:
		li $t0, 0x0000ff #loads the colour blue to register $t0
		sw $t0, colour #stores the colour red in the colour word
		jal clsMain #goes back to CLS drawing to draw with colour red
		
#STAVE

stave:

	#reset values
	addi $t9, $zero, 0 #resets $t9 value to 0
	addi $t8, $zero, 0 #resets $t8 value to 0

	li $v0, 4 #4 is used to show a write operation
	la $a0, detail  #asking user for row to print the stave in
	syscall

	li $v0, 5 #5 is used to show a read operation (reading user input)
	syscall
	move $s2, $v0 #moves user input from the $v0 register to $s2 to be used in drawing the stave

	lui $s0, 0x1004 #loading address
	jal staveStart #starts the stave procedure

	staveStart:
		addi $sp, $sp, -4 #decrements the stack pointer by value of 4
		sw $s2, 0($sp) #store the value of $s2 on the stack
	    	
	    	li $t1, 0 # loop counter
	    	li $t2, 10 #used to jump 10 empty spaces between each line
		li $t3, 2048 #the value of display width in bytes to be used in operations
		li $t4 2048 #the value of display width in bytes to be used in operations
		mul $s2, $t3, $s2 #multiplies user input (row) by 2048 (512*4 - which is display width in bytes)
		add $t0, $s0, $s2 #finds the place the user chooses on the display, in bytes
	  	addi $a1, $zero, 0x000000  #Stave (line) Color (black)
	    	li $t9 5 #to be used to limit the stave only drawing 5 lines

		
		drawStave: #starts drawing the stave procedure
			addi $sp, $sp, -4 #decrements the stack pointer by value of 4   
			sw $s2, 0($sp) #store the value of $s2 on the stack  
		
	  		bge $t1, 512, space # exit loop if done (if loop reacches 512 or more)
	   		sw $a1, 0($t0) # set pixel color
	   		addi $t1, $t1, 1 #Adds one to loop counter to show pixel has been drawn
	   		addi $t0, $t0, 4 # move to next pixel
	    		jal drawStave
	    	
		space: #loop for adding 10 lines of space between each line	
	    		mul $t3, $t4, $t2 #multiplies number of lines 2048 to use the value in bytes
	    		add $t0, $t0, $t3 #adds in 2048
	    		addi $t8, $t8, 1 #adds that 1 space jumped to the counter
	    		sub $t1, $t1, $t1 #resets the register back to 0
	    		bne $t8, $t9, drawStave #once the counter reaches 5, so there are 5 spaces drawn, it goes back to drawstave
	    		sub $t8, $t8, $t8 #reseets the count incase user chooses stave again
	    		
			lw $s2, 0($sp)  
			addi $sp, $sp, 4 #increments the stacck pointer by value of 4  
			
	    		jal return #goes to return of procedure
	    		j procedureEnd


	return:
    		jr $ra # return
    	
	
	procedureEnd: 
	nop #used to avoid errors when returning to menu
	jal main


note:	
	li $v0, 4 #4 is used to show a write operation
	la $a0, detail  #asking for which note is needed
	syscall

	li $v0, 12 #12 is used to show a read operation of an ASCII character (reading user input)
	syscall
	move $s2, $v0 #moves user input from the $v0 register to $t0 to be used in conditionals
	
	beq $s2, 97, noteA #if ascii 97 (a) go to noteA
	beq $s2, 65, noteA #if ascii 65 (A) go to noteA
	
	beq $s2, 98, noteB #if ascii 98 (b) go to noteB
	beq $s2, 66, noteB #if ascii 66 (B) go to noteB
	
	beq $s2, 99, noteC #if ascii 99 (c) go to noteC
	beq $s2, 67, noteC #if ascii 67 (C) go to noteC
	
	beq $s2, 100, noteD #if ascii 100 (d) go to noteD
	beq $s2, 68, noteD #if ascii 68 (D) go to noteD

	beq $s2, 69, noteE #if ascii 69 (e) go to noteE
	beq $s2, 101, noteE #if ascii 101 (E) go to noteE

	beq $s2, 70, noteF #if ascii 70 (f) go to noteF
	beq $s2, 102, noteF #if ascii 102 (F) go to noteF
	
	beq $s2, 71, noteG #if ascii 71 (g) go to noteA
	beq $s2, 103, noteG #if ascii 103 (G) go to noteA
	
	j drawNote #go to drawNote llabel

		drawNote:
			li $t3, 2048 #loads 2048 (display wdith in bytes)
			sub $t0, $t0, $t5 #subtracts the value of $t5 to place the note in the correct vertical place
		  	li $a0, 0x000000 #note color (black)
		    	li $t1, 0 #loop counter
    			li $t9, 6 #limits the height of note to 6 lines
    			lui $s1, 0x100C #to show the end/limit of bitmap display to avoid going over it
	
		note1:
	    		bge $t1, 8, note2 # exit loop if done
	    		sb $0, 0($t0) # set pixel color
	    		addi $t0, $t0, 4 # draws 1 pixel (4 bytes)	    		
	    		addi $t1, $t1, 1 #adds one to loop counter to show pixel has been drawn
	    		j note1
    
			note2:
				addi $t1, $zero, 0 #resets the value of $t1 so it doesn't affect the loop
				sub $t0, $t0, 32 #removes 32 bytes (8 pixels) so that the new line is drawn right below the first line
    				add $t0, $t0, $t3 
    				addi $t8, $t8, 1 #creats a counter to limit the lines of note to only 6 as required
    				bne $t8, $t9, note1 #if limit has not been reached loop goes back to the first loop
    				j playNote #goes to play the sound of note
    				
		 		add $t0, $t0, $t5
    				sub $t0, $t0, $t3
		 		addi $t8, $zero,0
		 		addi $t1, $zero,0
		 		addi $t5, $zero,0	
		 
		 playNote:
			move $a0, $t6 #moves the pitch of each note to $t6 so that it doesn't affect $a registers
		 	li $a1, 1500 #duration in milliseconds
		 	li $a2, 70 #instrument
		 	li $a3, 130 #volume
		 	
		 	li $v0, 33 #the correct syscall for playing sound
		 	syscall
		 	
		 	j end
		 		
		 end:
		 	#resetting all values back to 0
			addi $a0, $zero, 0
			addi $a1, $zero, 0
			addi $a2, $zero, 0
			addi $a3, $zero, 0
		 	
		 	#resetting the value of $t0 back to original
		 	sub $t0, $t0, 10238
		 	add $t0, $t0, $t5
    			sub $t0, $t0, $t3
    			addi $a0, $zero,0 
		 	addi $t8, $zero,0
		 	addi $t1, $zero,0
		 	addi $t5, $zero,0	
		 	jal main

	noteA:
		li $t5, 61440 #the amount of bytes needed to move the note up to the  correct position on the stave
		li $t6, 69
		j drawNote
		
	noteB:
		li $t5,71680 #the amount of bytes needed to move the note up to the  correct position on the stave
		li $t6, 71
		j drawNote
	noteC:
		li $t5, 83968 #the amount of bytes needed to move the note up to the  correct position on the stave
		li $t6, 72
		j drawNote
	noteD:
		li $t5, 94208 #the amount of bytes needed to move the note up to the  correct position on the stave
		li $t6, 74
		j drawNote
	noteE:
		li $t5 106496 #the amount of bytes needed to move the note up to the  correct position on the stave
		li $t6, 76
		j drawNote
	noteG:
		li $t5, 51200 #the amount of bytes needed to move the note up to the  correct position on the stave
		li $t6, 67
		j drawNote
	noteF:
		li $t5, 40960 #the amount of bytes needed to move the note up to the  correct position on the stave
		li $t6, 65
		j drawNote
	

exit: #exits the code when the user chooses option 4 from the menu
	li $v0, 10
	syscall
