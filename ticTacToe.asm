INCLUDE Irvine32.inc

;******************** GAME PROCEDURES *************************************
Start_PvC_Game                   PROTO name_:PTR BYTE
Start_PvP_Game                   PROTO name_1:PTR BYTE,name_2:PTR BYTE
Start_CvC_Game			         PROTO
;******************** PRINT PROCEDURES ************************************
Display_games_played             PROTO count1:BYTE,count2:BYTE,count3:BYTE
Display_Game_Menu 	             PROTO
Display_Game_Moves               PROTO gameBoard_2:PTR BYTE
Display_Game_Board			     PROTO
;******************** MENU PROCEDURES *************************************
Main_menu_selection  		     PROTO userInput_2:DWORD
Print_Instructions_PvC_CvC		 PROTO
Print_Instructions_for_to_PvP    PROTO
Update_Game_Board                PROTO player_type_:BYTE, assign_type_:BYTE, location_:DWORD, gameBoard_:PTR BYTE
Set_position		             PROTO pos_num_:BYTE
;******************** VALIDATION PROCEDURES *******************************
validate_input 		     		 PROTO user_input:DWORD, instance_t:BYTE
Check_Winner_for_PvP		     PROTO gameBoard_3:DWORD, num_moves_:BYTE, name_221:PTR BYTE,name_222:PTR BYTE, P1_param:BYTE, instanceType_param2:BYTE
Check_Winner_for_PvC_CvC	     PROTO gameBoard_3:DWORD, num_moves_:BYTE, name_:PTR BYTE, P1_:BYTE, instanceType_2:BYTE
Test_the_winner		             PROTO param1:BYTE, param2:DWORD, param3:BYTE, param4:DWORD, param5:BYTE, param6:DWORD, gameBoard_3:PTR BYTE
;******************** MAIN ************************************************
.code

main proc
	.data
		userInput1     DWORD 0
		select_option  BYTE "                                                Choice: ", 0

	.code
		Menu: invoke Display_Game_Menu

		Menu_choice: 
					   mov edx, OFFSET select_option
					   call WriteString
					   call ReadInt
							mov userInput1, eax
							INVOKE validate_input, userInput1, 1 	; Validates input
							cmp dl, 1
								je Menu_choice						; Start menu
							cmp dl, 2
								je exitProgram						; Jump to exit							

			INVOKE Main_menu_selection, userInput1
			jmp Menu

	exitProgram: exit
main endp

Display_Game_Menu proc
	.data

		Print_Menu BYTE "                                                                      ", 0
				   BYTE "                                          1. Player VS. Computer      ", 0
				   BYTE "                                          2. Computer VS. Computer    ", 0
				   BYTE "                                          3. Player VS. Player        ", 0
				   BYTE "                                          4. exit                     ", 0


	.code

		call Crlf
		call Crlf

		mov ecx, 5		; Counter to print 5 lines of the menu
		mov bl, 0
		printMenu2: mov edx, OFFSET Print_Menu
				    mov eax, 0
				    mov al, LENGTHOF Print_Menu
				    mul bl 						; To move to next line

				    add edx, eax
				    call WriteString
				    call Crlf
				    inc bl
		loop printMenu2		; Loops the whole menu

		call Crlf
		call Crlf

		ret
Display_Game_Menu endp


COMMENT $
	PROCEDURE: In Main Menu compares input, increments counter of each
	gametype for keeping statistics and calls the respective procedure
$
Main_menu_selection PROC x2:DWORD
		.data
			user_input2 EQU [x2 + 4]
			; counters for statistics
			counter_PvC BYTE 0
		    counter_CvC BYTE 0
		    counter_PvP BYTE 0

			filename byte "Stats.txt",0
			filehandle dword ?
			bytesWritten dword 1 dup(0)

			PvC_one BYTE "1"
			PvC_two BYTE "2"
			PvC_three BYTE "3"
			CvC_one BYTE "1"
			CvC_two BYTE "2"
			CvC_three BYTE "3"
			PvP_one BYTE "1"
			PvP_two BYTE "2"
			PvP_three BYTE "3"
		.code
			push ebp
			mov ebp, esp

			cmp user_input2, 1
				je Option1_GO
			cmp user_input2, 2
				je Option2_GO
			cmp user_input2, 3
				je Option3_GO
			cmp user_input2, 4
				je Option4_GO


			Option1_GO: INVOKE Print_Instructions_PvC_CvC	; Calls PvC
						call Clrscr
						inc counter_PvC
						jmp leaveProc2
			Option2_GO: INVOKE Start_CvC_Game	; Calls CvC
						call Clrscr
						inc counter_CvC
						jmp leaveProc2
			Option3_GO: INVOKE Print_Instructions_for_to_PvP	; Calls PvP
						call Clrscr
						inc counter_PvP
						jmp leaveProc2
			; On exit, show statistics of all games played
			Option4_GO:	
						INVOKE createFile,
						ADDR filename,
						GENERIC_WRITE,
						DO_NOT_SHARE,
						NULL,
						OPEN_ALWAYS,
						FILE_ATTRIBUTE_NORMAL,
						0
						mov filehandle, eax
						
						cmp counter_PvC,1
						je pvc1


			pvc1:
					INVOKE WriteFile,filehandle,addr PvC_one,sizeof PvC_one,addr bytesWritten,0	
					
					INVOKE Display_games_played, counter_PvC, counter_CvC, counter_PvP

	leaveProc2:	leave
	ret
Main_menu_selection ENDP

COMMENT $
	PROCEDURE: Displays the stats of games played when user exits the main menu
$
Display_games_played   PROC count1_PvC:BYTE,count2_CvC:BYTE,count3_PvP:BYTE
	.data
		statics_msg_PvC BYTE "                        The number of PvC played is : ",0
		statics_msg_CvC BYTE "                        The number of CvC played is : ",0
		statics_msg_PvP BYTE "                        The number of PvP played is : ",0
	.code
	call Clrscr
	call Crlf
	call Crlf
	call Crlf
	mov edx,offset statics_msg_PvC
	call WriteString
	mov al, count1_PvC
	call WriteDec
	call Crlf
	mov edx,offset statics_msg_CvC
	call WriteString
	mov al, count2_CvC
	call WriteDec
	call Crlf
	mov edx,offset statics_msg_PvP
	call WriteString
	mov al, count3_PvP
	call WriteDec

	call Crlf
	call Crlf
	call WaitMsg		; Waits for exit
	exit
Display_games_played ENDP

COMMENT $
	Prints instructions for PvC and CvC
$

Print_Instructions_PvC_CvC PROC
	.data
			instructions    BYTE "                                                    TIC-TAC-TOE                                         ", 0
						    BYTE "                To win the game,you have to get three Xs in a row on the board before the computer.   ", 0
						    BYTE "                  When chosing a move, enter a number corresponding to the position on the board      ", 0
						    BYTE "                                                                                                      ", 0
			board_pvc BYTE "                                                                                                        ", 0
						  BYTE "                                                           1 | 2 | 3                                    ", 0
						  BYTE "                                                           4 | 5 | 6                                    ", 0
						  BYTE "                                                           7 | 8 | 9                                    ", 0


			name_prompt   BYTE "                               Enter your name to begin: ", 0

			name_str      BYTE 50 DUP(0)	; For player name
			name_size     BYTE ?			; For player name size
	.code
			push ebp
			mov ebp, esp
			call Clrscr

			mov ecx, 4 		; four lines of instructions
			mov bl, 0
			mov eax, lightGreen
			call SetTextColor
			printMenu: mov edx, OFFSET instructions 	; Loops four lines of instructions
					   mov eax, 0
					   mov al, LENGTHOF instructions
					   mul bl

					   add edx, eax
					   call WriteString

					   mov eax, yellow
			           call SetTextColor
					   call Crlf
					   inc bl
			loop printMenu

			mov ecx, 4
			mov bl, 0
			mov eax, white
			call SetTextColor
			printMenu2: mov edx, OFFSET board_pvc 	; Prints tic-tac board
					    mov eax, 0
					    mov al, LENGTHOF board_pvc
					    mul bl

					    add edx, eax
					    call WriteString

					    call Crlf
					    inc bl
			loop printMenu2

			call Crlf
			call Crlf

			mov edx, OFFSET name_prompt 	; Asks for user name
			call WriteString

			; Takes input of the player name
			mov edx, OFFSET name_str
			mov ecx, SIZEOF name_str
			call ReadString
			mov name_size, al

			INVOKE Start_PvC_Game, ADDR name_str 	; Starts PvC game

			leave
	ret
Print_Instructions_PvC_CvC ENDP


COMMENT &
	Prints the instructions for PvP mode
&
Print_Instructions_for_to_PvP PROC
	.data
			instructions_PvP  BYTE "                                                    TIC-TAC-TOE                                         ", 0
						    BYTE "                To win the game,you have to get three Xs in a row on the board before the computer.     ", 0
						    BYTE "                  When chosing a move, enter a number corresponding to the position on the board        ", 0
						    BYTE "                                                                                                        ", 0
			board_pvp BYTE "                                                                                                        ", 0
						    BYTE "                                                           1 | 2 | 3                                    ", 0
						    BYTE "                                                           4 | 5 | 6                                    ", 0
						    BYTE "                                                           7 | 8 | 9                                    ", 0


			name_prompt1   BYTE "                               Enter player 1 name : ", 0
			name_prompt2   BYTE "                               Enter player 2 name : ", 0

			name_str1      BYTE 50 DUP(0)
			name_size1     BYTE ?

			name_str2      BYTE 50 DUP(0)
			name_size2     BYTE ?
	.code
			push ebp
			mov ebp, esp
			call Clrscr

			mov ecx, 4 		; For printing instructions
			mov bl, 0
			mov eax, lightGreen
			call SetTextColor

			printMenu: mov edx, OFFSET instructions_PvP
					   mov eax, 0
					   mov al, LENGTHOF instructions_PvP
					   mul bl

					   add edx, eax
					   call WriteString

					   mov eax, yellow
			           call SetTextColor
					   call Crlf
					   inc bl
			loop printMenu

			mov ecx, 4 		; For printing game board
			mov bl, 0
			mov eax, white
			call SetTextColor
			printMenu2: mov edx, OFFSET board_pvp
					    mov eax, 0
					    mov al, LENGTHOF board_pvp
					    mul bl

					    add edx, eax
					    call WriteString

					    call Crlf
					    inc bl
			loop printMenu2

			call Crlf
			call Crlf

			mov edx, OFFSET name_prompt1
			call WriteString

			mov edx, OFFSET name_str1
			mov ecx, SIZEOF name_str1
			call ReadString 			; Take name from user
			mov name_size1, al

			mov edx, OFFSET name_prompt2
			call WriteString

			mov edx, OFFSET name_str2
			mov ecx, SIZEOF name_str2
			call ReadString
			mov name_size2, al

			; Start Player VS Player game
			INVOKE Start_PvP_Game, ADDR name_str1, ADDR name_str2

			leave
	ret
Print_Instructions_for_to_PvP ENDP


Start_PvP_Game PROC name_pvp_1:PTR BYTE, name_pvp_2:PTR BYTE
		.data
			; Handling parameters
			player_name_1 EQU [name_pvp_1 + 4]
			player_name_2 EQU [name_pvp_2 + 4]

			; Strings
			gameBoard_2	       BYTE 9 DUP(0)
			gameTitle_2	       BYTE "  VS  ", 0

			movNumber_pvp	       BYTE 0
			user_selection_1   DWORD 0
			user_selection_2   DWORD 0

			name_offset_1	   DWORD ?
			name_offset_2	   DWORD ?
			firstGo22		   BYTE ?
			player_user_type2  BYTE ?
			player_user_type3  BYTE ?
			comp_user_type2    BYTE ?
			runOnce22		   BYTE ?

		.code
			push ebp
			mov ebp, esp


			mov ebx, player_name_1
			mov name_offset_1, ebx
			cmp runOnce2, 1
				je clearTable

			mov ebx, player_name_2
			mov name_offset_2, ebx
			cmp runOnce2, 1
				je clearTable

			preGame: mov movNumber_pvp, 1

				mov eax, 0
				mov al, 2
				call RandomRange
				mov firstGo22, al

			jmp Game

			clearTable: mov ecx, 9
						mov al, 0
						mov esi, OFFSET gameBoard_2
						zeroOut: mov [esi], al
								 inc esi
						loop zeroOut
						jmp preGame

			Game: call Clrscr

				  mov edx, 0
				  call Gotoxy

				  mov ecx, 50
				  mov eax, 0
				  Spce: mov al, ' '
				  	    call WriteChar
				  loop Spce

				  mov eax, white
				  call SetTextColor

				  mov edx, player_name_1
				  call WriteString

				  mov edx, offset gameTitle_2
				  call WriteString

				  mov edx, player_name_2
				  call WriteString

				  call Crlf
				  call Crlf

				  INVOKE Display_Game_Board
				  INVOKE Display_Game_Moves, ADDR gameBoard_2

				  cmp movNumber_pvp, 9 		; If 9 moves played, end the game
				  jg leaveProc4

				  INVOKE Check_Winner_for_PvP, ADDR gameBoard_2, movNumber_pvp, name_offset_1,name_offset_2, firstGo22, 0
				  cmp dl, 0
					  je keepPlaying
				  cmp dl, 1
					  je leaveProc4
				  cmp dl, 2
					  je leaveProc4

				  keepPlaying:
				  mov dl, 55
				  mov dh, 23
				  call Gotoxy

				  mov eax, 0
				  mov al, movNumber_pvp
				  mov bl, 2
				  div bl

				  cmp firstGo22, 0
					  je player_first
				  cmp firstGo22, 1
					  je computer_first

				  player_first: cmp ah, 1
								    je player_prompt
							    cmp ah, 0
								  je computer_prompt

				  computer_first: cmp ah, 1
									  je computer_prompt
								  cmp ah, 0
									  je player_prompt

				  player_prompt: cmp firstGo22, 0
									 je U_P1

				                 mov eax, lightMagenta
							     call SetTextColor
								 mov player_user_type2, 1
								 jmp cont1

								 U_P1: mov eax, lightGreen
									   call SetTextColor

									   mov player_user_type2, 0

							     cont1: mov edx, player_name_1
										call WriteString
										mov al, ':'
										call WriteChar
										mov al, ' '
										call WriteChar
										jmp user_selections

				  computer_prompt: cmp firstGo22, 1
									 je C_P1

				                 mov eax, lightMagenta
							     call SetTextColor
								 mov player_user_type3, 1
								 jmp cont2

								 C_P1: mov eax, lightGreen
									   call SetTextColor

									   mov player_user_type3, 0

							     cont2: mov edx, player_name_2
										call WriteString
										mov al, ':'
										call WriteChar
										mov al, ' '
										call WriteChar
										jmp user_selection221

				  user_selections: mov eax, white
								   call SetTextColor

								   mov eax, 0
								   call ReadDec
								   mov user_selection_1, eax
								   INVOKE validate_input, user_selection_1, 3
								   cmp dl, 1
								   je Game

								   INVOKE Update_Game_Board, 0, player_user_type2, user_selection_1, ADDR gameBoard_2
								   cmp dl, 1
								   je user_selections

								   inc movNumber_pvp
								   jmp Game

				  user_selection221 : mov eax, white
								   call SetTextColor

								   mov eax, 0
								   call ReadDec
						           mov user_selection_2, eax
					               INVOKE validate_input, user_selection_2, 3
								   cmp dl, 1
								   je Game

								   INVOKE Update_Game_Board, 2, player_user_type3  , user_selection_2, ADDR gameBoard_2
								   cmp dl, 1
								   je user_selection221

								   inc movNumber_pvp
								   jmp Game

			leaveProc4: cmp movNumber_pvp, 10
							jne justleave
						INVOKE Check_Winner_for_PvP, ADDR gameBoard_2, movNumber_pvp, name_offset_1,name_offset_2, firstGo22, 0
			justleave:	mov runOnce2, 1
			            leave
	ret
Start_PvP_Game ENDP

Start_PvC_Game PROC name_pvc:PTR BYTE
		.data

			player_name EQU [name_pvc + 4]				; Handling parameter
			gameBoard	       BYTE 9 DUP(0)			; Prints game board
			gameTitle	       BYTE " VS. Computer", 0	; 'Name' VS Computer
			computerMove       BYTE "Computer: ", 0
			movNumber	       BYTE 0 					; Number of moves, max=9
			user_selection     DWORD 0 					; Turn of user
			computer_selection DWORD 0 					; Turn of computer
			name_offset		   DWORD ?
			firstGo		       BYTE ?
			player_user_type   BYTE ?
			comp_user_type     BYTE ?
			runOnce			   BYTE ? 					; To store no of games played

		.code
			push ebp
			mov ebp, esp

			mov ebx, player_name
			mov name_offset, ebx
			cmp runOnce, 1
				je clearTable

			preGame:
			mov movNumber, 1
			mov eax, 0
			mov al, 2
			call RandomRange
			mov firstGo, al

			jmp Game

			clearTable: mov ecx, 9
						mov al, 0
						mov esi, OFFSET gameBoard
						zeroOut: mov [esi], al
								 inc esi
						loop zeroOut
						jmp preGame

			Game:
				  call Clrscr
				  mov edx, 0
				  call Gotoxy			; Reposition

				  mov ecx, 50 			; Add spaces
				  mov eax, 0
				  Spce: mov al, ' '
				  	    call WriteChar
				  loop Spce

				  mov eax, white
				  call SetTextColor

				  mov edx, player_name  ; Print player name
				  call WriteString

				  mov edx, OFFSET gameTitle ; Print 'VS Computer'
				  call WriteString
				  call Crlf
				  call Crlf

				  INVOKE Display_Game_Board ; Print game board
				  INVOKE Display_Game_Moves, ADDR gameBoard ; Prints marks

				  cmp movNumber, 9
				  jg leaveProc4

				  INVOKE Check_Winner_for_PvC_CvC, ADDR gameBoard, movNumber, name_offset, firstGo, 0
				  cmp dl, 0
					  je keepPlaying
				  cmp dl, 1
					  je leaveProc4
				  cmp dl, 2
					  je leaveProc4

				  keepPlaying:
				  		mov dl, 55
				 		mov dh, 23
				  		call Gotoxy

				  		mov eax, 0
				  		mov al, movNumber
				  		mov bl, 2
				  		div bl

				  		cmp firstGo, 0
					  	je player_first
				  		cmp firstGo, 1
					  	je computer_first

				  player_first:
				  		cmp ah, 1
						je player_prompt
					    cmp ah, 0
						je computer_prompt

				  computer_first:
				  		cmp ah, 1
						je computer_prompt
						cmp ah, 0
						je player_prompt

				  player_prompt:
				  		cmp firstGo, 0
						je U_P1

				        mov eax, lightMagenta
						call SetTextColor
						mov player_user_type, 1
						jmp cont1

						U_P1: mov eax, lightGreen
							  call SetTextColor
							  mov player_user_type, 0

						cont1: mov edx, player_name
							   call WriteString
							   mov al, ':'
							   call WriteChar
							   mov al, ' '
							   call WriteChar
							   jmp user_selections

				  computer_prompt: cmp firstGo, 1
									   je C_P1

								   mov eax, lightMagenta
								   call SetTextColor
								   mov comp_user_type, 1
								   jmp cont2

								   C_P1: mov eax, lightGreen
									     call SetTextColor

										 mov comp_user_type, 0

								   cont2: mov edx, OFFSET computerMove
									     call WriteString

								   jmp computer_selections

				  user_selections: mov eax, white
								   call SetTextColor

								   mov eax, 0
								   call ReadDec
									  mov user_selection, eax
									  INVOKE validate_input, user_selection, 3
										  cmp dl, 1
											  je Game

								   INVOKE Update_Game_Board, 0, player_user_type, user_selection, ADDR gameBoard
								   cmp dl, 1
									  je user_selections

								   inc movNumber
								   jmp Game

				  computer_selections: mov eax, 0
									   mov al, 10
									   call RandomRange
									   mov ebx, 0
									   mov bl, al
									   mov computer_selection, ebx

									   cmp computer_selection, 0
										   je computer_selections

									   INVOKE Update_Game_Board, 1, comp_user_type, computer_selection, ADDR gameBoard
										  cmp dl, 1
											  je computer_selections

									   mov ebx, 0
									   mov ebx, computer_selection
									   mov al, bl
									   call WriteDec

									   mov eax, 1000
									   call Delay

									   inc movNumber
									   jmp Game

			leaveProc4: cmp movNumber, 10
							jne justleave
						INVOKE Check_Winner_for_PvC_CvC, ADDR gameBoard, movNumber, name_offset, firstGo, 0
			justleave:	mov runOnce, 1
			            leave
	ret
Start_PvC_Game ENDP

COMMENT $
	Prints the game board.
$
Display_Game_Board PROC
		.data
			gameBoardPrint BYTE "                                                                                                        ", 0
						   BYTE "                                                           1 | 2 | 3                                    ", 0
						   BYTE "                                                           4 | 5 | 6                                    ", 0
						   BYTE "                                                           7 | 8 | 9                                    ", 0

		.code
			push ebp
			mov ebp, esp

			mov ecx, 4
				  mov bl, 0
				  mov eax, white
				  call SetTextColor
				  printMenu: mov edx, OFFSET gameBoardPrint
						     mov eax, 0
						     mov al, LENGTHOF gameBoardPrint
						     mul bl
						     add edx, eax
						     call WriteString
						     call Crlf
						     inc bl
				  loop printMenu

			leave
	ret
Display_Game_Board ENDP

COMMENT $
	Prints the moves(X and O) on the game board.
$
Display_Game_Moves PROC g_table:PTR BYTE
		.data
			gameTable EQU [g_table + 4]

			player1Mark  BYTE "X", 0
			player2Mark  BYTE "O", 0
			boardPos     BYTE 1
			player_type2 BYTE 0

		.code
			push ebp
			mov ebp, esp

			mov boardPos, 1
			mov ebx, 0
			mov ebx, gameTable
			mov esi, ebx
			mov ecx, 9
			findMarks: mov al, [esi]		 ; find marks of all 9 entries
					   cmp al, 0
					       jne markFind
					   returnToLoop: inc esi ; traverse through board if not found
								     inc boardPos
			loop findMarks
			jmp leaveProc5

			markFind: cmp al, 1
						   je setPlayer1
					  cmp al, 2
						   je setPlayer2

					  setPlayer1: mov player_type2, 1
								  jmp findBoardPos
					  setPlayer2: mov player_type2, 2
							      jmp findBoardPos

					  findBoardPos: INVOKE Set_position, boardPos 	; Set position
			push ecx
				mov ecx, 1
				mov bl, 0

				printMark:  push edx 	; Print mark according to the position set
								cmp player_type2, 1
									jne getMark

								pMark: mov eax, lightred
									   call SetTextColor

								       mov edx, OFFSET player1Mark
									   mov eax, 0
									   mov al, LENGTHOF player1Mark
									   mul bl
									   jmp continuePrint

								getMark: mov eax, yellow
									     call SetTextColor

										 mov edx, OFFSET player2Mark
										 mov eax, 0
										 mov al, LENGTHOF player2Mark
										 mul bl

								continuePrint: add edx, eax
											   call WriteString
							pop edx

							inc dh
							call Gotoxy
							inc bl
				loop printMark
		   pop ecx

		   mov eax, white
		   call SetTextColor

		    jmp returnToLoop

		    leaveProc5: leave
	ret
Display_Game_Moves ENDP
Set_position PROC x6:BYTE
		.data
			pos EQU [x6 + 4]

		.code
			push ebp
			mov ebp, esp

			cmp pos, 1
				je Print_1
			cmp pos, 2
				je Print_2
			cmp pos, 3
				je Print_3
			cmp pos, 4
				je Print_4
			cmp pos, 5
				je Print_5
			cmp pos, 6
				je Print_6
			cmp pos, 7
				je Print_7
			cmp pos, 8
				je Print_8
			cmp pos, 9
				je Print_9

			jmp leaveProc6

			Print_1: mov dl, 59
					 mov dh, 3
					 call Gotoxy
					 jmp leaveProc6

			Print_2: mov dl, 63
					 mov dh, 3
					 call Gotoxy
					 jmp leaveProc6

			Print_3: mov dl, 67
					 mov dh, 3
					 call Gotoxy
					 jmp leaveProc6

			Print_4: mov dl, 59
					 mov dh, 4
					 call Gotoxy
					 jmp leaveProc6

			Print_5: mov dl, 63
					 mov dh, 4
					 call Gotoxy
					 jmp leaveProc6

			Print_6: mov dl, 67
					 mov dh, 4
					 call Gotoxy
					 jmp leaveProc6

			Print_7: mov dl, 59
					 mov dh, 5
					 call Gotoxy
					 jmp leaveProc6

			Print_8: mov dl, 63
					 mov dh, 5
					 call Gotoxy
					 jmp leaveProc6

			Print_9: mov dl, 67
					 mov dh, 5
					 call Gotoxy
					 jmp leaveProc6

			leaveProc6: leave
	ret
Set_position ENDP
Update_Game_Board PROC x4:BYTE, y3:BYTE, w1:DWORD, z1:PTR BYTE
		.data
			player_type EQU [x4 + 4]
			assign_type EQU [y3 + 4]
			location    EQU [w1 + 4]
			game_board  EQU [z1 + 4]

			occupied_error     BYTE "That square is already occupied. Please try again: ", 0
			row_size		   BYTE 3
			row_index		   BYTE ?
			column_index	   DWORD ?

		.code
			push ebp
			mov ebp, esp

			cmp location, 1
				je Fill_1
			cmp location, 2
				je Fill_2
			cmp location, 3
				je Fill_3
			cmp location, 4
				je Fill_4
		    cmp location, 5
				je Fill_5
			cmp location, 6
				je Fill_6
			cmp location, 7
				je Fill_7
			cmp location, 8
				je Fill_8
			cmp location, 9
				je Fill_9

			jmp leaveProc3

			Fill_1: mov row_index, 0
					mov column_index, 0
					jmp Fill_Task

			Fill_2: mov row_index, 0
					mov column_index, 1
					jmp Fill_Task

			Fill_3: mov row_index, 0
					mov column_index, 2
					jmp Fill_Task

			Fill_4: mov row_index, 1
					mov column_index, 0
					jmp Fill_Task

			Fill_5: mov row_index, 1
					mov column_index, 1
					jmp Fill_Task

			Fill_6: mov row_index, 1
					mov column_index, 2
					jmp Fill_Task

			Fill_7: mov row_index, 2
					mov column_index, 0
					jmp Fill_Task

			Fill_8: mov row_index, 2
					mov column_index, 1
					jmp Fill_Task

			Fill_9: mov row_index, 2
					mov column_index, 2
					jmp Fill_Task

			Fill_Task: mov ebx, game_board
					   mov eax, 0
					   mov al, row_index
					   mov dl, row_size
					   mul dl
					   add ebx, eax
					   mov esi, column_index

					   mov cl, [ebx + esi]
					   cmp cl, 0
						   jne occupiedError

					   cmp assign_type, 0
						   je setX_
					   cmp assign_type, 1
						   je setO_

					   setX_: mov al, 1
							  jmp addToBoard
					   setO_: mov al, 2
							  jmp addToBoard

					   addToBoard: mov [ebx + esi], al

					   mov dl, 0
					   jmp leaveProc3
			occupiedError: mov dl, 1

						   cmp player_type, 1
							   je leaveProc3

						   call Crlf
						   call Crlf

						   mov eax, lightRed
						   call SetTextColor

						   push edx
						       mov dl, 38
							   mov dh, 25
							   call Gotoxy
							   mov edx, OFFSET occupied_error
							   call WriteString
						   pop edx

						   mov eax, white
						   call SetTextColor

						   jmp leaveProc3


			leaveProc3: leave
	ret
Update_Game_Board ENDP

;To check winner for Player vs Player game mode
Check_Winner_for_PvP PROC x7:DWORD, y4:BYTE, w2:PTR BYTE,w3:PTR BYTE, z2:BYTE, in1:BYTE
		.data
			game_board2 EQU [x7 + 4]
			move_number EQU [y4 + 4]
			user_name_1   EQU [w2 + 4]
			user_name_2   EQU [w3 + 4]
			player1     EQU [z2 + 4]
			inst_type   EQU [in1 + 4]

			gameBoard_offset2 DWORD ?
			P1_Win_prompt2    BYTE " WINS!", 0
			P2_Win_prompt2    BYTE " WINS!", 0
			draw_prompt2		 BYTE "IT'S A DRAW!", 0
			test_counter2	 BYTE ?
			path_type2		 BYTE ?

		.code
			push ebp
			mov ebp, esp

			mov ebx, game_board2
			mov gameBoard_offset2, ebx

			cmp move_number, 6
				jl win_false

			mov test_counter, 0


		    Test1: INVOKE Test_the_winner, 0, 0, 0, 1, 0, 2, gameBoard_offset2
				   inc test_counter2
				   cmp dl, 0
					   je Test2
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			Test2: INVOKE Test_the_winner, 0, 0, 1, 1, 2, 2, gameBoard_offset2
				   inc test_counter2
				   cmp dl, 0
					   je Test3
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			Test3: INVOKE Test_the_winner, 1, 0, 1, 1, 1, 2, gameBoard_offset2
			       inc test_counter2
				   cmp dl, 0
					   je Test4
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			Test4: INVOKE Test_the_winner, 2, 0, 2, 1, 2, 2, gameBoard_offset2
				   inc test_counter2
				   cmp dl, 0
					   je Test5
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			Test5: INVOKE Test_the_winner, 0, 0, 1, 0, 2, 0, gameBoard_offset2
				   inc test_counter2
				   cmp dl, 0
					   je Test6
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			Test6: INVOKE Test_the_winner, 0, 1, 1, 1, 2, 1, gameBoard_offset2
			       inc test_counter2
				   cmp dl, 0
					   je Test7
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			Test7: INVOKE Test_the_winner, 0, 2, 1, 2, 2, 2, gameBoard_offset2
			       inc test_counter2
				   cmp dl, 0
					   je Test8
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			Test8: INVOKE Test_the_winner, 2, 0, 1, 1, 0, 2, gameBoard_offset2
			       inc test_counter2
				   cmp dl, 0
					   je win_false
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			jmp win_false


			P1_Win: push edx
					mov dl, 55
					mov dh, 23
				    call Gotoxy

			        cmp player1, 0
						je user_1
					cmp player1, 1
						je comp_1

					user_1: mov eax, lightGreen
							call SetTextColor

							mov edx, user_name_1
					        call WriteString
							cmp inst_type, 1
								je suffix_add4
							resume4:
							mov edx, OFFSET P1_Win_prompt2
							call WriteString
							call Crlf

							pop edx

							mov path_type2, 0
							jmp fillPath

							suffix_add4: mov al, '1'
										call WriteChar
										jmp resume4

					comp_1: mov eax, lightGreen
							call SetTextColor

							mov edx, user_name_2
					        call WriteString
							cmp inst_type, 1
								je suffix_add3
							resume3:
							mov edx, OFFSET P2_Win_prompt2
							call WriteString
							call Crlf

							pop edx

							mov path_type2, 0
							jmp fillPath

							suffix_add3: mov al, '1'
										call WriteChar
										jmp resume3

			P2_Win: push edx
					mov dl, 55
					mov dh, 23
				    call Gotoxy

			        cmp player1, 1
						je user_2
					cmp player1, 0
						je comp_2

					user_2: mov eax, lightMagenta
							call SetTextColor

							mov edx, user_name_1
					        call WriteString
							cmp inst_type, 1
								je suffix_add2
							resume2:
							mov edx, OFFSET P1_Win_prompt2
							call WriteString
							call Crlf

							pop edx

							mov path_type2, 1
							jmp fillPath

							suffix_add2: mov al, '1'
										 call WriteChar
										 jmp resume2

					comp_2: mov eax, lightGreen
							call SetTextColor

							mov edx, user_name_2
					        call WriteString
							cmp inst_type, 1
								je suffix_add1
							resume1:
							mov edx, OFFSET P2_Win_prompt2
							call WriteString
							call Crlf

							pop edx

							mov path_type2, 0
							jmp fillPath

							suffix_add1: mov al, '1'
										call WriteChar
										jmp resume1

			win_false: cmp move_number, 10
						   je draw
					    jmp leaveskip

			draw: push edx
			      mov dl, 55
				  mov dh, 23
				  call Gotoxy

			      mov eax, yellow
				  call SetTextColor

			      mov edx, OFFSET draw_prompt2
				  call WriteString
				  pop edx
				  call Crlf

				  jmp fillPath


			fillPath: mov eax, white
						call SetTextColor

						push edx
							mov dl, 50
							mov dh, 25
							call Gotoxy
						pop edx

						call WaitMsg
			leaveskip:	leave

	ret
Check_Winner_for_PvP ENDP








Check_Winner_for_PvC_CvC PROC x7:DWORD, y4:BYTE, w2:PTR BYTE, z2:BYTE, in1:BYTE
		.data
			game_board2 EQU [x7 + 4]
			move_number EQU [y4 + 4]
			user_name   EQU [w2 + 4]
			player1     EQU [z2 + 4]
			inst_type   EQU [in1 + 4]

			gameBoard_offset DWORD ?
			P1_Win_prompt    BYTE " WINS!", 0
			P2_Win_prompt    BYTE "COMPUTER WINS", 0
			draw_prompt		 BYTE "IT'S A DRAW!", 0
			test_counter	 BYTE ?
			path_type		 BYTE ?

		.code
			push ebp
			mov ebp, esp

			mov ebx, game_board2
			mov gameBoard_offset, ebx

			cmp move_number, 6
				jl win_false

			mov test_counter, 0


		    Test1: INVOKE Test_the_winner, 0, 0, 0, 1, 0, 2, gameBoard_offset
				   inc test_counter
				   cmp dl, 0
					   je Test2
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			Test2: INVOKE Test_the_winner, 0, 0, 1, 1, 2, 2, gameBoard_offset
				   inc test_counter
				   cmp dl, 0
					   je Test3
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			Test3: INVOKE Test_the_winner, 1, 0, 1, 1, 1, 2, gameBoard_offset
			       inc test_counter
				   cmp dl, 0
					   je Test4
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			Test4: INVOKE Test_the_winner, 2, 0, 2, 1, 2, 2, gameBoard_offset
				   inc test_counter
				   cmp dl, 0
					   je Test5
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			Test5: INVOKE Test_the_winner, 0, 0, 1, 0, 2, 0, gameBoard_offset
				   inc test_counter
				   cmp dl, 0
					   je Test6
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			Test6: INVOKE Test_the_winner, 0, 1, 1, 1, 2, 1, gameBoard_offset
			       inc test_counter
				   cmp dl, 0
					   je Test7
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			Test7: INVOKE Test_the_winner, 0, 2, 1, 2, 2, 2, gameBoard_offset
			       inc test_counter
				   cmp dl, 0
					   je Test8
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			Test8: INVOKE Test_the_winner, 2, 0, 1, 1, 0, 2, gameBoard_offset
			       inc test_counter
				   cmp dl, 0
					   je win_false
				   cmp dl, 1
					   je P1_Win
				   cmp dl, 2
					   je P2_Win
			jmp win_false


			P1_Win: push edx
					mov dl, 55
					mov dh, 23
				    call Gotoxy

			        cmp player1, 0
						je user_1
					cmp player1, 1
						je comp_1

					user_1: mov eax, lightGreen
							call SetTextColor

							mov edx, user_name
					        call WriteString
							cmp inst_type, 1
								je suffix_add1
							resume1:
							mov edx, OFFSET P1_Win_prompt
							call WriteString
							call Crlf

							pop edx

							mov path_type, 0
							jmp fillPath

							suffix_add1: mov al, '1'
										call WriteChar
										jmp resume1

					comp_1: mov eax, lightGreen
							call SetTextColor

							cmp inst_type, 1
								je suffix_add2
							mov edx, OFFSET P2_Win_prompt
							call WriteString

							resume2:
							call Crlf

							pop edx

							mov path_type, 0
							jmp fillPath

							suffix_add2: mov edx, user_name
										 call WriteString
							             mov al, '2'
										 call WriteChar
										 mov edx, OFFSET P1_Win_prompt
										 call WriteString
										 jmp resume2

			P2_Win: push edx
					mov dl, 55
					mov dh, 23
				    call Gotoxy

			        cmp player1, 1
						je user_2
					cmp player1, 0
						je comp_2

					user_2: mov eax, lightMagenta
							call SetTextColor

							mov edx, user_name
					        call WriteString
							cmp inst_type, 1
								je suffix_add3
							resume3:
							mov edx, OFFSET P1_Win_prompt
							call WriteString
							call Crlf

							pop edx

							mov path_type, 1
							jmp fillPath

							suffix_add3: mov al, '1'
										 call WriteChar
										 jmp resume3

					comp_2: mov eax, lightMagenta
							call SetTextColor

							cmp inst_type, 1
								je suffix_add4
							mov edx, OFFSET P2_Win_prompt
							call WriteString

							resume4:
							call Crlf

							pop edx

							mov path_type, 1
							jmp fillPath

							suffix_add4: mov edx, user_name
										 call WriteString
							             mov al, '2'
										 call WriteChar
										 mov edx, OFFSET P1_Win_prompt
										 call WriteString
										 jmp resume4

			win_false: cmp move_number, 10
						   je draw
					    jmp leaveskip

			draw: push edx
			      mov dl, 55
				  mov dh, 23
				  call Gotoxy

			      mov eax, yellow
				  call SetTextColor

			      mov edx, OFFSET draw_prompt
				  call WriteString
				  pop edx
				  call Crlf

				  jmp fillPath


			fillPath:  mov eax, white
						call SetTextColor

						push edx
							mov dl, 50
							mov dh, 25
							call Gotoxy
						pop edx

						call WaitMsg
			leaveskip:	leave

	ret
Check_Winner_for_PvC_CvC ENDP


Test_the_winner PROC p1:BYTE, p2:DWORD, p3:BYTE, p4:DWORD, p5:BYTE, p6:DWORD, x8:PTR BYTE
		.data
			r1 			EQU [p1 + 4]
			c1 			EQU [p2 + 4]
			r2 			EQU [p3 + 4]
			c2 			EQU [p4 + 4]
			r3 			EQU [p5 + 4]
			c3 			EQU [p6 + 4]
			game_board3 EQU [x8 + 4]

			test_num1    BYTE ?
			test_num2    BYTE ?
			test_num3    BYTE ?
			instance	 BYTE ?

			row_size2    BYTE 3

	    .code
			push ebp
			mov ebp, esp

			mov ebx, game_board3
			mov dl, row_size2

			T1: mov eax, 0
				mov al, r1
				mov esi, c1
				jmp get_test_num1

			T2: mov eax, 0
				mov al, r2
				mov esi, c2
				jmp get_test_num2

			T3: mov eax, 0
				mov al, r3
				mov esi, c3
				jmp get_test_num3

			getTest: mov edi, ebx
					 mul dl
					 add edi, eax

					cmp instance, 1
						je set_test_num1
					cmp instance, 2
						je set_test_num2
					cmp instance, 3
						je set_test_num3

				   set_test_num1: mov cl, [edi + esi]
								  mov test_num1, cl
								  jmp T2
				   set_test_num2: mov cl, [edi + esi]
								  mov test_num2, cl
								  jmp T3
				   set_test_num3: mov cl, [edi + esi]
								  mov test_num3, cl
								  jmp computeResult

					get_test_num1: mov instance, 1
								   jmp getTest
					get_test_num2: mov instance, 2
								   jmp getTest
					get_test_num3: mov instance, 3
								   jmp getTest

					computeResult: mov al, test_num1
								   cmp al, test_num2
										jne no_win
								   cmp al, test_num3
										jne no_win
								   mov al, test_num2
								   cmp al, test_num3
										jne no_win	; There is no win
								   ; The game is a win
								   mov al, test_num1
								   add al, test_num2
								   add al, test_num3
								   ; Decide which player has won
								   cmp al, 3	; Because p1 sets 1
									   je P1Win
								   cmp al, 6	; Because p2 sets 2
									   je P2Win
								   jmp no_win

			P1Win: mov dl, 1
				   jmp leaveProc8
			P2Win: mov dl, 2
				   jmp leaveProc8

			no_win: mov dl, 0
					jmp leaveProc8

			leaveProc8: leave
	ret
Test_the_winner ENDP



Start_CvC_Game PROC
		.data
			gameBoard2	       BYTE 9 DUP(0)

			gameTitle2	       BYTE "Computer 1 VS Computer 2", 0
			computer1Move      BYTE "Computer 1", 0
			computer2Move      BYTE "Computer 2", 0
			computer_name      BYTE "Computer ", 0

			movNumber2	        BYTE 0
			computer1_selection DWORD 0
			computer2_selection DWORD 0
			comp1_assign_type   BYTE ?
			comp2_assign_type   BYTE ?
			comp_name_offset    DWORD ?
			firstGo2	        BYTE ?
			runOnce2			BYTE ?

		.code
			push ebp
			mov ebp, esp

			mov ebx, OFFSET computer_name
			mov comp_name_offset, ebx
			cmp runOnce2, 1
				je clearTable_

			preGame_: mov movNumber2, 1
			          mov firstGo2, 0

			jmp Game2

			clearTable_: mov ecx, 9
						mov al, 0
						mov esi, OFFSET gameBoard2
						zeroOut_: mov [esi], al
								 inc esi
						loop zeroOut_
						jmp preGame_

			Game2:call Clrscr

				  mov edx, 0
				  call Gotoxy

				  mov ecx, 50
				  mov eax, 0
				  Spce_: mov al, ' '
				  	    call WriteChar
				  loop Spce_

				  mov eax, white
				  call SetTextColor

				  mov edx, OFFSET gameTitle2
				  call WriteString

				  call Crlf
				  call Crlf

				  INVOKE Display_Game_Board
				  INVOKE Display_Game_Moves, ADDR gameBoard2

				  cmp movNumber2, 9
					  jg leaveProc9

				  INVOKE Check_Winner_for_PvC_CvC, ADDR gameBoard2, movNumber2, comp_name_offset, firstGo2, 1
				  cmp dl, 0
					  je keepPlaying_
				  cmp dl, 1
					  je leaveProc9
				  cmp dl, 2
					  je leaveProc9

				  keepPlaying_:
				  mov dl, 55
				  mov dh, 23
				  call Gotoxy

				  mov eax, 0
				  mov al, movNumber2
				  mov bl, 2
				  div bl

				 mov firstGo2, 0
				 jmp computer1_first

				  computer1_first: cmp ah, 1
								       je computer1_prompt
							       cmp ah, 0
								       je computer2_prompt

				  computer1_prompt: cmp firstGo2, 0
									    je C1e

									mov eax, lightMagenta
									call SetTextColor
									mov comp1_assign_type, 1
									jmp cont1_

								    C1e: mov eax, lightGreen
									     call SetTextColor

										 mov comp1_assign_type, 0

							        cont1_: mov edx, OFFSET computer1Move
										    call WriteString
										    mov al, ':'
										    call WriteChar
										    mov al, ' '
										    call WriteChar
										    jmp compouter1_selection

				  computer2_prompt: cmp firstGo2, 1
									    je C2e

								    mov eax, lightMagenta
								    call SetTextColor
									mov comp2_assign_type, 1
								    jmp cont2_

								    C2e: mov eax, lightGreen
									     call SetTextColor

										mov comp1_assign_type, 0

								    cont2_: mov edx, OFFSET computer2Move
									        call WriteString
										    mov al, ':'
										    call WriteChar
										    mov al, ' '
										    call WriteChar
										    jmp compouter2_selection

				  compouter1_selection: mov eax, 0
									mov al, 10
									call RandomRange
									mov ebx, 0
									mov bl, al
									mov computer1_selection, ebx

								    cmp computer1_selection, 0
									    je compouter1_selection

								    INVOKE Update_Game_Board, 1, comp1_assign_type, computer1_selection, ADDR gameBoard2
									   cmp dl, 1
										   je compouter1_selection

								    mov ebx, 0
								    mov ebx, computer1_selection
								    mov al, bl
								    call WriteDec

								    mov eax, 2000
								    call Delay

								    inc movNumber2
								    jmp Game2

				  compouter2_selection: mov eax, 0
									mov al, 10
									call RandomRange
									mov ebx, 0
									mov bl, al
									mov computer2_selection, ebx

								    cmp computer2_selection, 0
									    je compouter2_selection

								    INVOKE Update_Game_Board, 1, comp2_assign_type, computer2_selection, ADDR gameBoard2
									    cmp dl, 1
										    je compouter2_selection

								    mov ebx, 0
								    mov ebx, computer2_selection
								    mov al, bl
								    call WriteDec

								    mov eax, 2000
								    call Delay

								    inc movNumber2
								    jmp Game2

			leaveProc9: cmp movNumber2, 10
							jne justleave_
						INVOKE Check_Winner_for_PvC_CvC, ADDR gameBoard2, movNumber2, comp_name_offset, firstGo2, 1
			justleave_:	mov runOnce2, 1
			            leave
	ret
Start_CvC_Game ENDP

COMMENT $
	PROCEDURE: Validates user input in:
	- menu
	- in gameplay
$
validate_input PROC user_input:DWORD, instance_t:BYTE
		.data

			input_1    		EQU [user_input + 4]
			instance_type	EQU [instance_t + 4]

			failCheck			   BYTE ?	;

			overflow_prompt        BYTE        "The number exceeds 32-bits, please try agian. ", 0
			range_prompt		   BYTE        "Out of range. Please enter 1 - 9. "
			menuError_prompt       BYTE        "Input must be a 1, 2, 3, or 4. ", 0
			signed_prompt          BYTE        "Sorry, input must be unsigned. ", 0

		.code
			push ebp
			mov ebp, esp

			jo overflowError
			cmp input_1, 0
				jl rangeCmp

			cmp instance_type, 1
				je menuCmp
			cmp instance_type, 2
				je rangeCmp
			cmp instance_type, 3
				je rangeCmp

			menuCmp: cmp input_1, 4		 ; Checks the range of menu 1-4
						jg menuError
					 cmp input_1, 0
						jle menuError
					 jmp doneChecking

			rangeCmp: cmp input_1, 0	 ; Checks the range of moves in game, 1-9
						jl RangeSignedError
						je RangeError

					  cmp input_1, 9
						jg RangeError
					jmp doneChecking

			overflowError: mov edx, OFFSET overflow_prompt
						   jmp displayError

			MenuError: mov edx, OFFSET menuError_prompt
					   jmp displayError

			RangeSignedError: mov edx, OFFSET signed_prompt
						jmp displayError

			RangeError: mov edx, OFFSET range_prompt
						jmp displayError

			displayError: call Crlf
						  mov eax, lightRed
						  call SetTextColor

						  mov ecx, 38			; Centers the error prompt
						  Spce: mov al, ' '
						        call WriteChar
						  loop Spce
						  call WriteString		; Displays the prompt
						  call Crlf

						  mov ecx, 38			; Centers the prompt
						  Spce2: mov al, ' '
						         call WriteChar
						  loop Spce2
						  call WaitMsg

						  mov eax, white
						  call SetTextColor

						  jo clrOF
						  jmp skip_clrOF		; Adds two \n before prompt

						  clrOF: mov cl, 1
								 neg cl

						  skip_clrOF:			; Adds two \n before prompt
						  call Crlf
						  call Crlf

						  mov failCheck, 1
						  jmp leaveProc1

			doneChecking: cmp input_1, 5
							je setExitCode
						mov failCheck, 0
						jmp leaveProc1

			setExitCode: mov failCheck, 2		; Helps in looping main menu

			leaveProc1: mov dl, failCheck
						leave
	ret
validate_input ENDP
END main
