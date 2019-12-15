; AddTwo.asm - adds two 32-bit integers.
; Chapter 3 example
include IRVINE32.inc


.data
playerVsComputerMode                  PROTO name_:PTR BYTE, name_size:BYTE
;Start_PvP_Game                   PROTO name_1:PTR BYTE, name_size1:BYTE,name_2:PTR BYTE, name_size2:BYTE
;Start_CvC_Game			          PROTO

gamesPlayed                PROTO 
gameMenu 						  PROTO
selectMenu		      PROTO 
instructionsForPlayerVsComputer   PROTO
;instructionsForPlayerVsPlayer   PROTO
validateUserInput 		          PROTO userInput_:DWORD, instanceType_:BYTE
;Display_Game_Board			      PROTO
;Update_Game_Board                PROTO player_type_:BYTE, assign_type_:BYTE, location_:DWORD, gameBoard_:PTR BYTE
;Display_Game_Moves               PROTO gameBoard_2:PTR BYTE
;Screen_xy_coordinet		      PROTO pos_num_:BYTE																				              
;Check_Winner_for_PvP		      PROTO gameBoard_3:DWORD, num_moves_:BYTE, name_221:PTR BYTE,name_222:PTR BYTE, P1_param:BYTE, instanceType_param2:BYTE
;Check_Winner_for_PvC_CvC	      PROTO gameBoard_3:DWORD, num_moves_:BYTE, name_:PTR BYTE, P1_:BYTE, instanceType_2:BYTE
;Test_the_winner		          PROTO param1:BYTE, param2:DWORD, param3:BYTE, param4:DWORD, param5:BYTE, param6:DWORD, gameBoard_3:PTR BYTE	  
;Display_winner_Draw			  PROTO l_1:BYTE, h_2:BYTE, l_3:BYTE, h_4:BYTE, l_5:BYTE, h_6:BYTE, path_type_:BYTE

;Variables declaration
userInput dword 0
selectOption byte "                                                Choice: ", 0

;Variables for Game Display Menu
		printMenu  BYTE "                                                                      ", 0
				   BYTE "                                          1. Player vs. Computer      ", 0
				   BYTE "                                          2. Computer vs. Computer    ", 0
				   BYTE "                                          3. Player vs. Player        ", 0
				   BYTE "                                          4. Games Played             ", 0
				   BYTE "                                          5. exit                     ", 0
		
;varibales for validation of input
failCheck			   BYTE ?	
overflowPrompt         BYTE        "that number exceeds 32-bits,Please try agian. ", 0
signedPrompt           BYTE        "Sorry, input must be unsigned. ", 0
rangePrompt			   BYTE        "That is not a valid move. Please enter 1 - 9. "
menuErrorPrompt        BYTE        "Input must be a 1, 2, 3, or 4. ", 0
;variables for selectMenu procedure
counterForPvC byte 0
counterForCvC byte 0
counterForPvP byte 0
numOfGamesInPlayerVSComputer BYTE "                        The number of player vs computer games played is : ",0 
numOfGamesInComputerVsComputer BYTE "                        The number of computer vs computer games played is : ",0 
numOfGamesInPlayerVsPlayer BYTE "                        The number of player vs player games played is : ",0 
instructions    BYTE "                                                    TIC-TAC-TOE                                         ", 0
				BYTE "                To win the game,you have to get three Xs in a row on the board before the computer.   ", 0
				BYTE "                  When chosing a move, enter a number corresponding to the position on the board      ", 0
				BYTE "                                                                                                      ", 0
boardModle      BYTE "                                                                                                        ", 0
				BYTE "                                                           - | - | -                                    ", 0
				BYTE "                                                           - | - | -                                    ", 0
				BYTE "                                                           - | - | -                                    ", 0
playerNamePrompt   BYTE "                               Enter your name to begin: ", 0
playerName     BYTE 50 DUP(0)	
sizeOfName      BYTE ?	
gameBoard	       BYTE 9 DUP(0)						
gameTitle	       BYTE  0						
user_selection     BYTE " Computer vs. Computer", 0
computerMove       BYTE 0			
movNumber	       BYTE 0						
computer_selection DWORD 0						
name_offset		   DWORD ?						
firstGo		       BYTE ?						
player_user_type   BYTE ?						
comp_user_type     BYTE ?						
runOnce			   BYTE ?						
			

.code
main proc
	menu: invoke gameMenu
	choice: mov eax,green
			call SetTextColor
			mov edx, offset selectOption
			call WriteString
			call ReadDec
			mov userInput,eax
			invoke validateUserInput,userInput,1
			cmp dl,1							
					
			je choice
			cmp dl, 2							
			je Exit_
MOV eax,0
mov eax,userInput
caLL selectMenu
jmp menu

	
	Exit_: 
		
		exit

	
	main endp

;Procedure to display game menu
gameMenu proc

	call CRLF
	call CRLF

	mov ecx,5		;setting counter
	mov bl,0		
	mov eax, green		;moving color name in eax register
	call SetTextColor	;setting the color of the text

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
				jl rangeCmp			
				
			cmp instanceType, 1				
				je menuCmp
			cmp instanceType, 2			
				je rangeCmp
			cmp instanceType, 3				
				je rangeCmp
			
			menuCmp: cmp userInput1	, 5		 
						jg menuError
					 cmp userInput1, 0
						jle menuError
					 jmp doneChecking	
						 
			rangeCmp: cmp userInput1, 0
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

selectMenu PROC 

			call Randomize
			
			cmp eax, 1
				je option1
			cmp eax, 2
				je option2
			cmp eax, 3
				je option3
			cmp eax, 4
				je option4
			cmp eax, 5
				je option4
				
			
			Option1:    call instructionsForPlayerVsComputer
						call Clrscr
						inc counterForPvC
						jmp exitProcedure



			Option2:    ;call Start_CvC_Game
						call Clrscr
						inc counterForCvC
						jmp exitProcedure


			Option3:    ;call Print_Instructions_for_to_PvP 
						call Clrscr
						inc counterForCvC
						jmp exitProcedure
			Option4:	call gamesPlayed		
	exitProcedure:	leave
	ret
selectMenu ENDP



;Procedure to keep record of number of games played for each module
gamesPlayed   PROC 
	call Clrscr 
	call Crlf
	call Crlf
	call Crlf
	mov edx,offset numOfGamesInPlayervsComputer
	call WriteString
	mov al, counterForPvC
	call WriteInt
	call Crlf
	
	mov edx,offset numOfGamesInComputervsComputer
	call WriteString
	mov al, counterForCvC
	call WriteInt
	call Crlf

	mov edx,offset numOfGamesInPlayerVsPlayer
	call WriteString
	mov al, counterForPvP
	call WriteInt
	
	call Crlf
	call Crlf
	call WaitMsg
	exit	
gamesPlayed ENDP


;procedure to print instructions for palyer vs computer game
instructionsForPlayerVsComputer PROC

call Clrscr
mov ecx,4
mov bl,0

printInstructions: 
			mov edx,offset instructions
			mov eax,0
			mov al,lengthof instructions
			mul bl

			add edx,eax
			call writestring
			call crlf
			add bl,1
			loop printInstructions
		mov ecx,4
		mov bl,0


printBoard:
			mov edx,offset boardModle
			mov eax,0
			mov al,lengthof boardModle
			mul bl

			add edx,eax
			call writestring
			call crlf
			add bl,1
			loop printBoard

		call crlf
		call crlf
		mov edx,offset playerNamePrompt
		call writestring

		mov edx,offset playerName
		mov ecx,sizeOf playerName
		call readstring
		mov sizeOfName,al

	    ;call playerVsComputerMode
		leave
		ret
instructionsForPlayerVsComputer endp




END main


