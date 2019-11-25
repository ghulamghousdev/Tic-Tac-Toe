; AddTwo.asm - adds two 32-bit integers.
; Chapter 3 example
include IRVINE32.inc


.data
;Start_PvC_Game                   PROTO name_:PTR BYTE, name_size:BYTE
;Start_PvP_Game                   PROTO name_1:PTR BYTE, name_size1:BYTE,name_2:PTR BYTE, name_size2:BYTE
;Start_CvC_Game			         PROTO

;Display_Game_statics             PROTO count1:BYTE,count2:BYTE,count3:BYTE
gameMenu 					     PROTO
;Main_menu_selection  		     PROTO userInput_2:DWORD
;Print_Instructions_for_PvC_CvC   PROTO
;Print_Instructions_for_to_PvP    PROTO
validateUserInput 		     PROTO userInput_:DWORD, instanceType_:BYTE
;Display_Game_Board			     PROTO
;Update_Game_Board                PROTO player_type_:BYTE, assign_type_:BYTE, location_:DWORD, gameBoard_:PTR BYTE
;Display_Game_Moves               PROTO gameBoard_2:PTR BYTE
;Screen_xy_coordinet		         PROTO pos_num_:BYTE																				              
;Check_Winner_for_PvP		     PROTO gameBoard_3:DWORD, num_moves_:BYTE, name_221:PTR BYTE,name_222:PTR BYTE, P1_param:BYTE, instanceType_param2:BYTE
;Check_Winner_for_PvC_CvC	     PROTO gameBoard_3:DWORD, num_moves_:BYTE, name_:PTR BYTE, P1_:BYTE, instanceType_2:BYTE
;Test_the_winner		             PROTO param1:BYTE, param2:DWORD, param3:BYTE, param4:DWORD, param5:BYTE, param6:DWORD, gameBoard_3:PTR BYTE	  
;Display_winner_Draw			     PROTO l_1:BYTE, h_2:BYTE, l_3:BYTE, h_4:BYTE, l_5:BYTE, h_6:BYTE, path_type_:BYTE

;Variables declaration
userInput dword 0
selectOption byte "                                                Choice: ", 0

;Variables for Game Display Menu
		printMenu  BYTE "                                                                      ", 0
				   BYTE "                                          1. Player vs. Computer      ", 0
				   BYTE "                                          2. Computer vs. Computer    ", 0
				   BYTE "                                          3. Player vs. Player        ", 0
				   BYTE "                                          4. exit                     ", 0
		
;varibales for validation of input
failCheck			   BYTE ?	
overflowPrompt         BYTE        "that number exceeds 32-bits,Please try agian. ", 0
signedPrompt           BYTE        "Sorry, input must be unsigned. ", 0
rangePrompt		   BYTE        "That is not a valid move. Please enter 1 - 9. "
menuErrorPrompt       BYTE        "Input must be a 1, 2, 3, or 4. ", 0

.code
main proc
	invoke gameMenu
	choice: mov eax,white
			call SetTextColor
			mov edx, offset selectOption
			call WriteString
			call ReadDec
			mov userInput,eax
			INVOKE validateUserInput, userInput, 1	
			cmp dl, 1							
					
			je choice
			cmp dl, 2							
			je Exit_

	
	Exit_: 
		
		exit

	
	main endp

;Procedure to display game menu
gameMenu proc

	call CRLF
	call CRLF

	mov ecx,5		;setting counter
	mov bl,0		
	mov eax, white		;moving color name in eax register
	call SetTextColor		;setting the color of the text

	printMenuLabel: mov edx, offset printMenu		;moving address of printMenu string into edx
					mov eax,0		
					mov al, lengthof printMenu
					mul bl

					add edx,eax
					call writeString
					call CRLF
					inc bl
					loop printMenuLabel

	call CRLF
	call CRLF

	ret		;returning to main proc

gameMenu endp


;Procedure to validate user input 

validateUserInput PROC x1:DWORD, y1:BYTE	
		.data
			userInput1    EQU [x1 + 4]
			instanceType  EQU [y1 + 4]
			
		.code
			push ebp							
			mov ebp, esp
			
			jo overflowError					
			cmp userInput1, 0					
				jl rangeCompare		
				
			cmp instanceType, 1				
				je menuCompare
			cmp instanceType, 2			
				je rangeCompare
			cmp instanceType, 3				
				je rangeCompare
			
			menuCompare: cmp userInput1, 4		 
						jg menuError
					 cmp userInput1, 0
						jle menuError
					 jmp doneChecking	
						 
			rangeCompare: cmp userInput1, 0
						jl RangeSignedError
						je RangeError
					  cmp userInput1, 9
						jg RangeError
					jmp doneChecking
					  
			overflowError: mov edx, OFFSET overflowPrompt
						   jmp displayError
								   
			MenuError: mov edx, OFFSET menuErrorPrompt
					   jmp displayError
					   
			RangeSignedError: mov edx, OFFSET signedPrompt
							  jmp displayError
			RangeError: mov edx, OFFSET rangePrompt
						jmp displayError
			
			displayError: call Crlf				
						  mov eax, lightRed		
						  call SetTextColor
						   
						  mov ecx, 38
						  Spce: mov al, ' '
						        call WriteChar
						  loop Spce
						  call WriteString
						  call Crlf
						  
						  mov ecx, 38
						  Spce2: mov al, ' '
						         call WriteChar
						  loop Spce2
						  call WaitMsg
						   
						  mov eax, white
						  call SetTextColor
						   
						  jo clrOF				 
						  jmp skipClrOF
						   
						  clrOF: mov cl, 1
								 neg cl
						   
						  skipClrOF:
						  call Crlf
						  call Crlf
						   
						  mov failCheck, 1		
						  jmp leaveProc1
		
			doneChecking: cmp userInput1, 5	
							je setExitCode
						mov failCheck, 0
						jmp leaveProc1
				  
			setExitCode: mov failCheck, 2		
	
			leaveProc1: mov dl, failCheck
						leave
			   
	ret
validateUserInput ENDP
END main
