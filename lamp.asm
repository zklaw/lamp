org 0000h
ljmp start
org 0100h

delay:
	loop_delay:
		push 7
		mov R7,#114
		del_1ms:
			nop
			nop
			nop
			nop
			nop
			nop				
			djnz R7,del_1ms
			nop
			pop 7
		ret

chooseDisplay:
		CLR A		
		mov DPTR,#0F030h
		mov A,#01111111b ;choose a display
		movx @DPTR,A		
		mov DPTR,#0F038h 
		ret
bitESC: 
		mov DPTR,#0F030h
		mov A,#00000010b ;bit for ESC
		movx @DPTR,A
		ret

turnOn: 
		movx @DPTR,A		
		clr P1.6 ;turn on a segment
		ret

start:
	mov R1,#00000001b	
	program1:		
		lcall bitESC		
		JB P3.5, program2
		lcall chooseDisplay
		mov A,R1	;choose a segment on a display
		lcall turnOn
		loop1:
			lcall bitESC			
			JB P3.5,program2
			lcall chooseDisplay 
			mov A,R1	;choose a segment on a display
			movx @DPTR,A
			mov R2,#200
			insideLoop:
				lcall delay			
				djnz R2,insideLoop
				mov A,R1
				RL A
				mov R1,A
				lcall turnOn
				ljmp loop1			
				ljmp program1
	turnOff:
		lcall bitESC		
		JB P3.5, start
		CLR A
		mov DPTR,#0
		lcall chooseDisplay
		mov A,#00111111b
		setb P1.6		
		ljmp turnOff
	
	program2:		
		mov R2,#200
		lcall bitESC		
		JB P3.5, turnOff
		lcall chooseDisplay
		mov A,11111111b	;choose a segment
		lcall turnOn		
		loop2:			
			lcall bitESC			
			JB P3.5,turnOff			
			lcall chooseDisplay 
			mov A,11111111b	;choose a segment
			lcall turnOn			
			mov R2,#200
			insideLoop2:
				lcall delay			
				djnz R2,insideLoop2
				setb P1.6 ;turn off a segment			
				mov R2,#200
				insideLoop3:
					lcall delay			
					djnz R2,insideLoop3			
					ljmp loop2
	
	stop:
		ljmp stop
		end
